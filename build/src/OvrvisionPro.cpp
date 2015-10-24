//
//
//

#include <sys/stat.h>

#include "OvrvisionPro.h"

using namespace std;

namespace OVR
{
#define SAMPLE_CHECK_ERRORS(ERR)

	OvrvisionPro::OvrvisionPro(int width, int height)
	{
		this->_size = Size(width, height);
		// TODO: check GPU memory size
		_format16UC1.image_channel_data_type = CL_UNSIGNED_INT16;
		_format16UC1.image_channel_order = CL_R;
		_format8UC4.image_channel_data_type = CL_UNSIGNED_INT8;
		_format8UC4.image_channel_order = CL_RGBA;
		_formatMap.image_channel_data_type = CL_FLOAT;
		_formatMap.image_channel_order = CL_R;

		if (SelectGPU("", "OpenCL C 1.2") == NULL) // Find OpenCL(version 1.2 and above) device 
		{
			throw std::runtime_error("Insufficient OpenCL version");
		}
		
		_commandQueue = clCreateCommandQueue(_context, _deviceId, 0, &_errorCode);

		// UMatを使うとパフォーマンスが落ちるので、ocl::Image2Dは使わない
		_src = clCreateImage2D(_context, CL_MEM_READ_ONLY, &_format16UC1, width, height, 0, 0, &_errorCode);
		SAMPLE_CHECK_ERRORS(_errorCode);

		_remapAvailable = false;

		_mapX[0] = new Mat();
		_mapY[0] = new Mat();
		_mapX[1] = new Mat();
		_mapY[1] = new Mat();
		_l = clCreateImage2D(_context, CL_MEM_READ_WRITE, &_format8UC4, width, height, 0, 0, &_errorCode);
		_r = clCreateImage2D(_context, CL_MEM_READ_WRITE, &_format8UC4, width, height, 0, 0, &_errorCode);
		_L = clCreateImage2D(_context, CL_MEM_READ_WRITE, &_format8UC4, width, height, 0, 0, &_errorCode);
		_R = clCreateImage2D(_context, CL_MEM_READ_WRITE, &_format8UC4, width, height, 0, 0, &_errorCode);
		_mx[0] = clCreateImage2D(_context, CL_MEM_READ_ONLY, &_formatMap, width, height, 0, 0, &_errorCode);
		_my[0] = clCreateImage2D(_context, CL_MEM_READ_ONLY, &_formatMap, width, height, 0, 0, &_errorCode);
		_mx[1] = clCreateImage2D(_context, CL_MEM_READ_ONLY, &_formatMap, width, height, 0, 0, &_errorCode);
		_my[1] = clCreateImage2D(_context, CL_MEM_READ_ONLY, &_formatMap, width, height, 0, 0, &_errorCode);
	}


	OvrvisionPro::~OvrvisionPro()
	{
		delete _mapX[0];
		delete _mapY[0];
		delete _mapX[1];
		delete _mapY[1];
		clReleaseKernel(_demosaic);
		clReleaseKernel(_remap);
		clReleaseProgram(_program);
		clReleaseMemObject(_src);
		clReleaseMemObject(_l);
		clReleaseMemObject(_r);
		clReleaseMemObject(_L);
		clReleaseMemObject(_R);
		if (_remapAvailable)
		{
		clReleaseMemObject(_mx[0]);
		clReleaseMemObject(_my[0]);
		clReleaseMemObject(_mx[1]);
		clReleaseMemObject(_my[1]);
		}
	}

	// Select GPU device
	cl_device_id OvrvisionPro::SelectGPU(const char *platform, const char *version)
	{
		cl_uint num_of_platforms = 0;
		// get total number of available platforms:
		cl_int err = clGetPlatformIDs(0, 0, &num_of_platforms);
		SAMPLE_CHECK_ERRORS(err);

		vector<cl_platform_id> platforms(num_of_platforms);
		// get IDs for all platforms:
		err = clGetPlatformIDs(num_of_platforms, &platforms[0], 0);
		SAMPLE_CHECK_ERRORS(err);

		vector<cl_device_id> devices;
		for (cl_uint i = 0; i < num_of_platforms; i++)
		{
			cl_uint num_of_devices = 0;
			if (CL_SUCCESS == clGetDeviceIDs(
				platforms[i],
				CL_DEVICE_TYPE_GPU,
				0,
				0,
				&num_of_devices
				))
			{
				cl_device_id *id = new cl_device_id[num_of_devices];
				err = clGetDeviceIDs(
					platforms[i],
					CL_DEVICE_TYPE_GPU,
					num_of_devices,
					id,
					0
					);
				SAMPLE_CHECK_ERRORS(err);
				for (cl_uint j = 0; j < num_of_devices; j++)
				{
					devices.push_back(id[j]);
					size_t length;
					char buffer[32];
					if (clGetDeviceInfo(id[j], CL_DEVICE_OPENCL_C_VERSION, sizeof(buffer), buffer, &length) == CL_SUCCESS)
					{
						//printf("%s\n", buffer);
						if (_strcmpi(buffer, version) >= 0)
						{
							_platformId = platforms[i];
							_deviceId = id[j];
							_context = clCreateContext(NULL, 1, &_deviceId, NULL, NULL, &_errorCode);
							SAMPLE_CHECK_ERRORS(_errorCode);
							break;
						}
					}
				}
				delete[] id;
			}
		}
		return _deviceId;
	}

	// Load camera parameters 
	bool OvrvisionPro::LoadCameraParams(const char *filename)
	{
		size_t origin[3] = { 0, 0, 0 };
		size_t region[3] = { _size.width, _size.height, 1 };

		if (_settings.Read(filename))
		{
			// Left camera
			_settings.GetUndistortionMatrix(OV_CAMEYE_LEFT, *_mapX[0], *_mapY[0], _size.width, _size.height);
			_errorCode = clEnqueueWriteImage(_commandQueue, _mx[0], CL_TRUE, origin, region, _size.width * sizeof(float), 0, _mapX[0]->ptr(0), 0, NULL, NULL);
			_errorCode = clEnqueueWriteImage(_commandQueue, _my[0], CL_TRUE, origin, region, _size.width * sizeof(float), 0, _mapY[0]->ptr(0), 0, NULL, NULL);
			SAMPLE_CHECK_ERRORS(_errorCode);

			// Right camera
			_settings.GetUndistortionMatrix(OV_CAMEYE_RIGHT, *_mapX[1], *_mapY[1], _size.width, _size.height);
			_errorCode = clEnqueueWriteImage(_commandQueue, _mx[1], CL_TRUE, origin, region, _size.width * sizeof(float), 0, _mapX[1]->ptr(0), 0, NULL, NULL);
			_errorCode = clEnqueueWriteImage(_commandQueue, _my[1], CL_TRUE, origin, region, _size.width * sizeof(float), 0, _mapY[1]->ptr(0), 0, NULL, NULL);
			SAMPLE_CHECK_ERRORS(_errorCode);

			_remapAvailable = true;
			return true;
		}
		else
		{
			return false;
		}
	}

	// CreateProgram from file
	void OvrvisionPro::CreateProgram(const char *filename, bool binary)
	{
		FILE *file;
		struct _stat st;
		_stat(filename, &st);
		size_t size = st.st_size;
		char *buffer = new char[size];
		if (binary)
		{
			if (fopen_s(&file, filename, "rb") == 0)
			{
				cl_int status;
				fread(buffer, st.st_size, 1, file);
				fclose(file);
				_program = clCreateProgramWithBinary(_context, 1, &_deviceId, &size, (const unsigned char **)&buffer, &status, &_errorCode);
				SAMPLE_CHECK_ERRORS(_errorCode);
				delete[] buffer;
			}
		}
		else
		{
			if (fopen_s(&file, filename, "r") == 0)
			{
				fread(buffer, st.st_size, 1, file);
				fclose(file);
				_program = clCreateProgramWithSource(_context, 1, (const char **)&buffer, &size, &_errorCode);
				SAMPLE_CHECK_ERRORS(_errorCode);
				_errorCode = clBuildProgram(_program, 1, &_deviceId, "", NULL, NULL);
				if (_errorCode == CL_BUILD_PROGRAM_FAILURE)
				{
					// Determine the size of the log
					size_t log_size;
					clGetProgramBuildInfo(_program, _deviceId, CL_PROGRAM_BUILD_LOG, 0, NULL, &log_size);

					// Allocate memory for the log
					char *log = (char *)malloc(log_size);

					// Get the log
					clGetProgramBuildInfo(_program, _deviceId, CL_PROGRAM_BUILD_LOG, log_size, log, NULL);

					// Print the log
					printf("%s\n", log);
				}
				SAMPLE_CHECK_ERRORS(_errorCode);
				delete[] buffer;
			}
		}
		_demosaic = clCreateKernel(_program, "demosaic", &_errorCode);
		SAMPLE_CHECK_ERRORS(_errorCode);
		_remap = clCreateKernel(_program, "remap", &_errorCode);
		SAMPLE_CHECK_ERRORS(_errorCode);
	}


	// Demosaicing
	void OvrvisionPro::Demosaic(const ushort *src, Mat &left, Mat &right)
	{
		size_t origin[3] = { 0, 0, 0 };
		size_t region[3] = { _size.width, _size.height, 1 };
		size_t demosaicSize[] = { _size.width / 2, _size.height / 2 };
		cl_event writeEvent, executeEvent;
		_errorCode = clEnqueueWriteImage(_commandQueue, _src, CL_TRUE, origin, region, _size.width * sizeof(ushort), 0, src, 0, NULL, &writeEvent);
		SAMPLE_CHECK_ERRORS(_errorCode);

		//__kernel void demosaic(
		//	__read_only image2d_t src,	// CL_UNSIGNED_INT16
		//	__write_only image2d_t left,	// CL_UNSIGNED_INT8 x 3
		//	__write_only image2d_t right)	// CL_UNSIGNED_INT8 x 3
		//cl_kernel _demosaic = clCreateKernel(_program, "demosaic", &_errorCode);
		//SAMPLE_CHECK_ERRORS(_errorCode);

		clSetKernelArg(_demosaic, 0, sizeof(cl_mem), &_src);
		clSetKernelArg(_demosaic, 1, sizeof(cl_mem), &_l);
		clSetKernelArg(_demosaic, 2, sizeof(cl_mem), &_r);
		_errorCode = clEnqueueNDRangeKernel(_commandQueue, _demosaic, 2, NULL, demosaicSize, 0, 1, &writeEvent, &executeEvent);
		SAMPLE_CHECK_ERRORS(_errorCode);

		// Read result
		_errorCode = clEnqueueReadImage(_commandQueue, _l, CL_TRUE, origin, region, left.cols * sizeof(uchar) * 4, 0, left.ptr(0), 1, &executeEvent, NULL);
		_errorCode = clEnqueueReadImage(_commandQueue, _r, CL_TRUE, origin, region, right.cols * sizeof(uchar) * 4, 0, right.ptr(0), 1, &executeEvent, NULL);
		//clFinish(_commandQueue);
		//clReleaseKernel(_demosaic);
		//SAMPLE_CHECK_ERRORS(_errorCode);
	}

	void OvrvisionPro::Demosaic(const Mat src, Mat &left, Mat &right)
	{
		const uchar *ptr = src.ptr(0);
		Demosaic((const ushort *)ptr, left, right);
	}

	// Demosaic and Remap
	void OvrvisionPro::DemosaicRemap(const ushort *src, Mat &left, Mat &right)
	{
		size_t origin[3] = { 0, 0, 0 };
		size_t region[3] = { _size.width, _size.height, 1 };
		size_t demosaicSize[] = { _size.width / 2, _size.height / 2 };
		cl_event writeEvent, executeEvent;
		_errorCode = clEnqueueWriteImage(_commandQueue, _src, CL_TRUE, origin, region, _size.width * sizeof(ushort), 0, src, 0, NULL, &writeEvent);
		SAMPLE_CHECK_ERRORS(_errorCode);

		//__kernel void demosaic(
		//	__read_only image2d_t src,	// CL_UNSIGNED_INT16
		//	__write_only image2d_t left,	// CL_UNSIGNED_INT8 x 3
		//	__write_only image2d_t right)	// CL_UNSIGNED_INT8 x 3
		//cl_kernel _demosaic = clCreateKernel(_program, "demosaic", &_errorCode);
		//SAMPLE_CHECK_ERRORS(_errorCode);

		clSetKernelArg(_demosaic, 0, sizeof(cl_mem), &_src);
		clSetKernelArg(_demosaic, 1, sizeof(cl_mem), &_l);
		clSetKernelArg(_demosaic, 2, sizeof(cl_mem), &_r);
		_errorCode = clEnqueueNDRangeKernel(_commandQueue, _demosaic, 2, NULL, demosaicSize, 0, 1, &writeEvent, &executeEvent);
		SAMPLE_CHECK_ERRORS(_errorCode);

		if (_remapAvailable)
		{
			size_t remapSize[] = { _size.width, _size.height };

			//__kernel void remap(
			//	__read_only image2d_t src,		// CL_UNSIGNED_INT8 x 4
			//	__read_only image2d_t mapX,		// CL_FLOAT
			//	__read_only image2d_t mapY,		// CL_FLOAT
			//	__write_only image2d_t	dst)	// CL_UNSIGNED_INT8 x 4
			//cl_kernel _remap = clCreateKernel(_program, "remap", &_errorCode);
			//SAMPLE_CHECK_ERRORS(_errorCode);

			clSetKernelArg(_remap, 0, sizeof(cl_mem), &_l);
			clSetKernelArg(_remap, 1, sizeof(cl_mem), &_mx[0]);
			clSetKernelArg(_remap, 2, sizeof(cl_mem), &_my[0]);
			clSetKernelArg(_remap, 3, sizeof(cl_mem), &_L);
			_errorCode = clEnqueueNDRangeKernel(_commandQueue, _remap, 2, NULL, remapSize, 0, 1, &writeEvent, &executeEvent);
			SAMPLE_CHECK_ERRORS(_errorCode);
			clSetKernelArg(_remap, 0, sizeof(cl_mem), &_r);
			clSetKernelArg(_remap, 1, sizeof(cl_mem), &_mx[1]);
			clSetKernelArg(_remap, 2, sizeof(cl_mem), &_my[1]);
			clSetKernelArg(_remap, 3, sizeof(cl_mem), &_R);
			_errorCode = clEnqueueNDRangeKernel(_commandQueue, _remap, 2, NULL, remapSize, 0, 1, &writeEvent, &executeEvent);
			SAMPLE_CHECK_ERRORS(_errorCode);

			// Read result
			_errorCode = clEnqueueReadImage(_commandQueue, _L, CL_TRUE, origin, region, left.cols * sizeof(uchar) * 4, 0, left.ptr(0), 1, &executeEvent, NULL);
			_errorCode = clEnqueueReadImage(_commandQueue, _R, CL_TRUE, origin, region, right.cols * sizeof(uchar) * 4, 0, right.ptr(0), 1, &executeEvent, NULL);
			SAMPLE_CHECK_ERRORS(_errorCode);
#ifdef _DEBUG
			printf("Remapped\n");
#endif
		}
		else
		{
			// Read result
			_errorCode = clEnqueueReadImage(_commandQueue, _l, CL_TRUE, origin, region, left.cols * sizeof(uchar) * 4, 0, left.ptr(0), 1, &executeEvent, NULL);
			_errorCode = clEnqueueReadImage(_commandQueue, _r, CL_TRUE, origin, region, right.cols * sizeof(uchar) * 4, 0, right.ptr(0), 1, &executeEvent, NULL);
			SAMPLE_CHECK_ERRORS(_errorCode);
		}
	}

	void OvrvisionPro::DemosaicRemap(const Mat src, Mat &left, Mat &right)
	{
		size_t origin[3] = { 0, 0, 0 };
		size_t region[3] = { src.cols, src.rows, 1 };
		size_t demosaicSize[] = { src.cols / 2, src.rows / 2 };
		const uchar *ptr = src.ptr(0);
		DemosaicRemap((const ushort *)ptr, left, right);
	}


}