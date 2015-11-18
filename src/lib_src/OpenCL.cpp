//
//
//


#include <stdio.h>
#include <sys/stat.h>
#include <opencv2/opencv.hpp>
#include <opencv2/core/ocl.hpp>

#include "OvrvisionProCL.h"

#include "OpenCL_kernel.h" // kernel code declared here const char *kernel;


using namespace std;
using namespace cv;

#if 0
// Report about an OpenCL problem.
// Macro is used instead of a function here
// to report source file name and line number.
#define SAMPLE_CHECK_ERRORS(ERR)                        \
    if(ERR != CL_SUCCESS)                               \
		    {                                                   \
        throw Error(                                    \
            "OpenCL error " +                           \
            opencl_error_to_str(ERR) +                  \
            " happened in file " + to_str(__FILE__) +   \
            " at line " + to_str(__LINE__) + "."        \
        );                                              \
		    }
#else
string opencl_error_to_str(cl_int error)
{
#define CASE_CL_CONSTANT(NAME) case NAME: return #NAME;

	// Suppose that no combinations are possible.
	// TODO: Test whether all error codes are listed here
	switch (error)
	{
		CASE_CL_CONSTANT(CL_SUCCESS)
			CASE_CL_CONSTANT(CL_DEVICE_NOT_FOUND)
			CASE_CL_CONSTANT(CL_DEVICE_NOT_AVAILABLE)
			CASE_CL_CONSTANT(CL_COMPILER_NOT_AVAILABLE)
			CASE_CL_CONSTANT(CL_MEM_OBJECT_ALLOCATION_FAILURE)
			CASE_CL_CONSTANT(CL_OUT_OF_RESOURCES)
			CASE_CL_CONSTANT(CL_OUT_OF_HOST_MEMORY)
			CASE_CL_CONSTANT(CL_PROFILING_INFO_NOT_AVAILABLE)
			CASE_CL_CONSTANT(CL_MEM_COPY_OVERLAP)
			CASE_CL_CONSTANT(CL_IMAGE_FORMAT_MISMATCH)
			CASE_CL_CONSTANT(CL_IMAGE_FORMAT_NOT_SUPPORTED)
			CASE_CL_CONSTANT(CL_BUILD_PROGRAM_FAILURE)
			CASE_CL_CONSTANT(CL_MAP_FAILURE)
			CASE_CL_CONSTANT(CL_MISALIGNED_SUB_BUFFER_OFFSET)
			CASE_CL_CONSTANT(CL_EXEC_STATUS_ERROR_FOR_EVENTS_IN_WAIT_LIST)
			CASE_CL_CONSTANT(CL_INVALID_VALUE)
			CASE_CL_CONSTANT(CL_INVALID_DEVICE_TYPE)
			CASE_CL_CONSTANT(CL_INVALID_PLATFORM)
			CASE_CL_CONSTANT(CL_INVALID_DEVICE)
			CASE_CL_CONSTANT(CL_INVALID_CONTEXT)
			CASE_CL_CONSTANT(CL_INVALID_QUEUE_PROPERTIES)
			CASE_CL_CONSTANT(CL_INVALID_COMMAND_QUEUE)
			CASE_CL_CONSTANT(CL_INVALID_HOST_PTR)
			CASE_CL_CONSTANT(CL_INVALID_MEM_OBJECT)
			CASE_CL_CONSTANT(CL_INVALID_IMAGE_FORMAT_DESCRIPTOR)
			CASE_CL_CONSTANT(CL_INVALID_IMAGE_SIZE)
			CASE_CL_CONSTANT(CL_INVALID_SAMPLER)
			CASE_CL_CONSTANT(CL_INVALID_BINARY)
			CASE_CL_CONSTANT(CL_INVALID_BUILD_OPTIONS)
			CASE_CL_CONSTANT(CL_INVALID_PROGRAM)
			CASE_CL_CONSTANT(CL_INVALID_PROGRAM_EXECUTABLE)
			CASE_CL_CONSTANT(CL_INVALID_KERNEL_NAME)
			CASE_CL_CONSTANT(CL_INVALID_KERNEL_DEFINITION)
			CASE_CL_CONSTANT(CL_INVALID_KERNEL)
			CASE_CL_CONSTANT(CL_INVALID_ARG_INDEX)
			CASE_CL_CONSTANT(CL_INVALID_ARG_VALUE)
			CASE_CL_CONSTANT(CL_INVALID_ARG_SIZE)
			CASE_CL_CONSTANT(CL_INVALID_KERNEL_ARGS)
			CASE_CL_CONSTANT(CL_INVALID_WORK_DIMENSION)
			CASE_CL_CONSTANT(CL_INVALID_WORK_GROUP_SIZE)
			CASE_CL_CONSTANT(CL_INVALID_WORK_ITEM_SIZE)
			CASE_CL_CONSTANT(CL_INVALID_GLOBAL_OFFSET)
			CASE_CL_CONSTANT(CL_INVALID_EVENT_WAIT_LIST)
			CASE_CL_CONSTANT(CL_INVALID_EVENT)
			CASE_CL_CONSTANT(CL_INVALID_OPERATION)
			CASE_CL_CONSTANT(CL_INVALID_GL_OBJECT)
			CASE_CL_CONSTANT(CL_INVALID_BUFFER_SIZE)
			CASE_CL_CONSTANT(CL_INVALID_MIP_LEVEL)
			CASE_CL_CONSTANT(CL_INVALID_GLOBAL_WORK_SIZE)
			CASE_CL_CONSTANT(CL_INVALID_PROPERTY)
			CASE_CL_CONSTANT(CL_INVALID_GL_SHAREGROUP_REFERENCE_KHR)
	default:
		return "UNKNOWN ERROR CODE ";// +to_str(error);
	}

#undef CASE_CL_CONSTANT
}

#define SAMPLE_CHECK_ERRORS(ERR) if (ERR != CL_SUCCESS) throw runtime_error(opencl_error_to_str(ERR));
#endif

namespace OVR
{
	int EnumerateGPU(PENUMDEVICE callback, void *pItem)
	{
		if (!ocl::haveOpenCL())
		{
			//cout << "OpenCL is not avaiable..." << endl;
			return 0;
		}
		ocl::Context context;
		if (!context.create(ocl::Device::TYPE_GPU))
		{
			//cout << "Failed creating the context..." << endl;
			return 0;
		}

		// In OpenCV 3.0.0 beta, only a single device is detected.
		//cout << context.ndevices() << " GPU devices are detected." << endl;
		for (size_t i = 0; i < context.ndevices(); i++)
		{
			cv::ocl::Device device = context.device(i);
			string name, version, capability;
			if (device.available() && device.imageSupport())
			{
				//printf("%s:\t%s\n", device.name(), device.OpenCLVersion());
				name = device.name();
				version = device.OpenCL_C_Version();
				capability = device.OpenCLVersion();
				version = device.version();
				if (callback != NULL)
				{
					callback(pItem, name.c_str(), version.c_str(), device.extensions().c_str(), device.deviceVersionMajor(), device.deviceVersionMinor());
				}
			}
		}
		return context.ndevices();
	}

	//namespace OPENCL
	//{
		// Constructor
	OvrvisionProOpenCL::OvrvisionProOpenCL(int width, int height, enum SHARING_MODE mode)
		{
			_width = width;
			_height = height;
			_sharing = mode;
			// TODO: check GPU memory size
			_format16UC1.image_channel_data_type = CL_UNSIGNED_INT16;
			_format16UC1.image_channel_order = CL_R;
			_format8UC4.image_channel_data_type = CL_UNSIGNED_INT8;
			_format8UC4.image_channel_order = CL_RGBA;
			_formatMap.image_channel_data_type = CL_FLOAT;
			_formatMap.image_channel_order = CL_R;

			if (SelectGPU("", "OpenCL C 1.2") == NULL) // Find OpenCL(version 1.2 and above) device 
			{
				throw runtime_error("Insufficient OpenCL version");
			}
			_commandQueue = clCreateCommandQueue(_context, _deviceId, 0, &_errorCode);

			// UMatを使うとパフォーマンスが落ちるので、ocl::Image2Dは使わない
			_src = clCreateImage2D(_context, CL_MEM_READ_ONLY, &_format16UC1, _width, _height, 0, 0, &_errorCode);
			SAMPLE_CHECK_ERRORS(_errorCode);

			_remapAvailable = false;

			mapX[0] = new Mat();
			mapY[0] = new Mat();
			mapX[1] = new Mat();
			mapY[1] = new Mat();
			_l = clCreateImage2D(_context, CL_MEM_READ_WRITE, &_format8UC4, _width, _height, 0, 0, &_errorCode);
			_r = clCreateImage2D(_context, CL_MEM_READ_WRITE, &_format8UC4, _width, _height, 0, 0, &_errorCode);
			_L = clCreateImage2D(_context, CL_MEM_READ_WRITE, &_format8UC4, _width, _height, 0, 0, &_errorCode);
			_R = clCreateImage2D(_context, CL_MEM_READ_WRITE, &_format8UC4, _width, _height, 0, 0, &_errorCode);
			_mx[0] = clCreateImage2D(_context, CL_MEM_READ_ONLY, &_formatMap, _width, _height, 0, 0, &_errorCode);
			_my[0] = clCreateImage2D(_context, CL_MEM_READ_ONLY, &_formatMap, _width, _height, 0, 0, &_errorCode);
			_mx[1] = clCreateImage2D(_context, CL_MEM_READ_ONLY, &_formatMap, _width, _height, 0, 0, &_errorCode);
			_my[1] = clCreateImage2D(_context, CL_MEM_READ_ONLY, &_formatMap, _width, _height, 0, 0, &_errorCode);

			CreateProgram();
		}

		// Destructor
	OvrvisionProOpenCL::~OvrvisionProOpenCL()
		{
			//intrinsic.release();
			//distortion.release();
			//mapX[0]->release();
			//mapY[0]->release();
			//mapX[1]->release();
			//mapY[1]->release();
			delete mapX[0];
			delete mapY[0];
			delete mapX[1];
			delete mapY[1];
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


		// Load camera parameters 
		bool OvrvisionProOpenCL::LoadCameraParams(const char *filename)
		{
			size_t origin[3] = { 0, 0, 0 };
			size_t region[3] = { _width, _height, 1 };
			OvrvisionSetting _settings(NULL);

			if (_settings.ReadEEPROM())
			{
				// Left camera
				_settings.GetUndistortionMatrix(OV_CAMEYE_LEFT, *mapX[0], *mapY[0], _width, _height);
				_errorCode = clEnqueueWriteImage(_commandQueue, _mx[0], CL_TRUE, origin, region, _width * sizeof(float), 0, mapX[0]->ptr(0), 0, NULL, NULL);
				_errorCode = clEnqueueWriteImage(_commandQueue, _my[0], CL_TRUE, origin, region, _width * sizeof(float), 0, mapY[0]->ptr(0), 0, NULL, NULL);
				SAMPLE_CHECK_ERRORS(_errorCode);

				// Right camera
				_settings.GetUndistortionMatrix(OV_CAMEYE_RIGHT, *mapX[1], *mapY[1], _width, _height);
				_errorCode = clEnqueueWriteImage(_commandQueue, _mx[1], CL_TRUE, origin, region, _width * sizeof(float), 0, mapX[1]->ptr(0), 0, NULL, NULL);
				_errorCode = clEnqueueWriteImage(_commandQueue, _my[1], CL_TRUE, origin, region, _width * sizeof(float), 0, mapY[1]->ptr(0), 0, NULL, NULL);
				SAMPLE_CHECK_ERRORS(_errorCode);

				_remapAvailable = true;
				return true;
			}
			else
			{
				return false;
			}
		}

		// Load camera parameters 
		bool OvrvisionProOpenCL::LoadCameraParams(OvrvisionSetting* ovrset)
		{
			size_t origin[3] = { 0, 0, 0 };
			size_t region[3] = { _width, _height, 1 };

			// Left camera
			ovrset->GetUndistortionMatrix(OV_CAMEYE_LEFT, *mapX[0], *mapY[0], _width, _height);
			_errorCode = clEnqueueWriteImage(_commandQueue, _mx[0], CL_TRUE, origin, region, _width * sizeof(float), 0, mapX[0]->ptr(0), 0, NULL, NULL);
			_errorCode = clEnqueueWriteImage(_commandQueue, _my[0], CL_TRUE, origin, region, _width * sizeof(float), 0, mapY[0]->ptr(0), 0, NULL, NULL);
			SAMPLE_CHECK_ERRORS(_errorCode);

			// Right camera
			ovrset->GetUndistortionMatrix(OV_CAMEYE_RIGHT, *mapX[1], *mapY[1], _width, _height);
			_errorCode = clEnqueueWriteImage(_commandQueue, _mx[1], CL_TRUE, origin, region, _width * sizeof(float), 0, mapX[1]->ptr(0), 0, NULL, NULL);
			_errorCode = clEnqueueWriteImage(_commandQueue, _my[1], CL_TRUE, origin, region, _width * sizeof(float), 0, mapY[1]->ptr(0), 0, NULL, NULL);
			SAMPLE_CHECK_ERRORS(_errorCode);

			_remapAvailable = true;
			return true;
		}

		// Demosaicing
		void OvrvisionProOpenCL::Demosaic(const ushort *src, Mat &left, Mat &right)
		{
			size_t origin[3] = { 0, 0, 0 };
			size_t region[3] = { _width, _height, 1 };
			size_t demosaicSize[] = { _width / 2, _height / 2 };
			cl_event writeEvent, executeEvent;
			_errorCode = clEnqueueWriteImage(_commandQueue, _src, CL_TRUE, origin, region, _width * sizeof(ushort), 0, src, 0, NULL, &writeEvent);
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

		void OvrvisionProOpenCL::Demosaic(const Mat src, Mat &left, Mat &right)
		{
			const uchar *ptr = src.ptr(0);
			Demosaic((const ushort *)ptr, left, right);
		}

		// Demosaic and Remap
		void OvrvisionProOpenCL::DemosaicRemap(const ushort *src, Mat &left, Mat &right)
		{
			size_t origin[3] = { 0, 0, 0 };
			size_t region[3] = { _width, _height, 1 };
			size_t demosaicSize[] = { _width / 2, _height / 2 };
			cl_event writeEvent, executeEvent;
			_errorCode = clEnqueueWriteImage(_commandQueue, _src, CL_TRUE, origin, region, _width * sizeof(ushort), 0, src, 0, NULL, &writeEvent);
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
				size_t remapSize[] = { _width, _height };

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

		void OvrvisionProOpenCL::DemosaicRemap(const Mat src, Mat &left, Mat &right)
		{
			size_t origin[3] = { 0, 0, 0 };
			size_t region[3] = { src.cols, src.rows, 1 };
			size_t demosaicSize[] = { src.cols / 2, src.rows / 2 };
			const uchar *ptr = src.ptr(0);
			DemosaicRemap((const ushort *)ptr, left, right);
		}

		// Remap with CPU
		//void OvrvisionPro::Remap(Cameye eye, const Mat src, Mat &dst)
		//{
		//	if (eye == OV_CAMEYE_LEFT)
		//		cv::remap(src, dst, *mapX[0], *mapY[0], INTER_LINEAR);
		//	else if (eye == OV_CAMEYE_RIGHT)
		//		cv::remap(src, dst, *mapX[1], *mapY[1], INTER_LINEAR);
		//}

		//bool OvrvisionPro::SaveSettings(const char *filename)
		//{
		//	return _settings.Write(filename);
		//}

		bool OvrvisionProOpenCL::CreateProgram()
		{
			size_t size = strlen(kernel);
			_program = clCreateProgramWithSource(_context, 1, (const char **)&kernel, &size, &_errorCode);
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
				return false;
			}
			else
			{
				_demosaic = clCreateKernel(_program, "demosaic", &_errorCode);
				SAMPLE_CHECK_ERRORS(_errorCode);
				_remap = clCreateKernel(_program, "remap", &_errorCode);
				SAMPLE_CHECK_ERRORS(_errorCode);
				return true;
			}
		}

		// CreateProgram from file
		void OvrvisionProOpenCL::createProgram(const char *filename, bool binary)
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
				}
			}
			delete[] buffer;
			_demosaic = clCreateKernel(_program, "demosaic", &_errorCode);
			SAMPLE_CHECK_ERRORS(_errorCode);
			_remap = clCreateKernel(_program, "remap", &_errorCode);
			SAMPLE_CHECK_ERRORS(_errorCode);
		}

		// Save binary program
		int OvrvisionProOpenCL::saveBinary(const char *filename)
		{
			FILE *file;
			if (fopen_s(&file, filename, "w") == 0)
			{
				size_t kernel_bin_size;
				clGetProgramInfo(_program, CL_PROGRAM_BINARY_SIZES, sizeof(size_t), &kernel_bin_size, NULL);
				cerr << "Kernel Binary Size:\t" << kernel_bin_size << endl;
				unsigned char *buffer = new unsigned char[kernel_bin_size];
				clGetProgramInfo(_program, CL_PROGRAM_BINARIES, kernel_bin_size, &buffer, NULL);
				fwrite(buffer, kernel_bin_size, 1, file);
				delete[] buffer;
				fclose(file);
				return 0;
			}
			else
			{
				return 1;
			}
		}

		// Select GPU device
		cl_device_id OvrvisionProOpenCL::SelectGPU(const char *platform, const char *version)
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
								cl_context_properties opengl_props[] = {
									CL_GL_CONTEXT_KHR, (cl_context_properties)wglGetCurrentContext(),
									CL_WGL_HDC_KHR, (cl_context_properties)wglGetCurrentDC(),
									CL_CONTEXT_PLATFORM, (cl_context_properties)_platformId,
									0
								};
								switch (_sharing)
								{
								case OPENGL:
									_context = clCreateContext(opengl_props, 1, &_deviceId, NULL, NULL, &_errorCode);
									break;

								case D3D11:
								default:
									_context = clCreateContext(NULL, 1, &_deviceId, NULL, NULL, &_errorCode);
									break;
								}
								SAMPLE_CHECK_ERRORS(_errorCode);
#ifdef _DEBUG
								clGetDeviceInfo(_deviceId, CL_DEVICE_NAME, sizeof(buffer), buffer, NULL);
								printf("DEVICE: %s\n", buffer);
#endif
								break;
							}
						}
					}
					delete[] id;
				}
			}
			return _deviceId;
		}

	//}
}