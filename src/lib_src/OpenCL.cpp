//
//
//


#include <stdio.h>
#include <sys/stat.h>
#include <opencv2/opencv.hpp>
//#include <opencv2/core/ocl.hpp>

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

#define INITPFN(x) \
    x = (x ## _fn)clGetExtensionFunctionAddress(#x);
//if(!x) { shrLog("failed getting " #x); Cleanup(EXIT_FAILURE); }

namespace OVR
{
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
			_format8UC1.image_channel_data_type = CL_UNSIGNED_INT8;
			_format8UC1.image_channel_order = CL_R;
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
			_grayL = clCreateImage2D(_context, CL_MEM_READ_WRITE, &_format8UC1, _width, _height, 0, 0, &_errorCode);
			_grayR = clCreateImage2D(_context, CL_MEM_READ_WRITE, &_format8UC1, _width, _height, 0, 0, &_errorCode);
			_mx[0] = clCreateImage2D(_context, CL_MEM_READ_ONLY, &_formatMap, _width, _height, 0, 0, &_errorCode);
			_my[0] = clCreateImage2D(_context, CL_MEM_READ_ONLY, &_formatMap, _width, _height, 0, 0, &_errorCode);
			_mx[1] = clCreateImage2D(_context, CL_MEM_READ_ONLY, &_formatMap, _width, _height, 0, 0, &_errorCode);
			_my[1] = clCreateImage2D(_context, CL_MEM_READ_ONLY, &_formatMap, _width, _height, 0, 0, &_errorCode);

			_deviceExtensions = NULL;
			CreateProgram();
			Prepare4Sharing();
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
			clReleaseKernel(_grayscale);
			clReleaseKernel(_skincolor);
			clReleaseProgram(_program);
			clReleaseMemObject(_src);
			clReleaseMemObject(_l);
			clReleaseMemObject(_r);
			clReleaseMemObject(_L);
			clReleaseMemObject(_R);
			clReleaseMemObject(_grayL);
			clReleaseMemObject(_grayR);
			if (_remapAvailable)
			{
				clReleaseMemObject(_mx[0]);
				clReleaseMemObject(_my[0]);
				clReleaseMemObject(_mx[1]);
				clReleaseMemObject(_my[1]);
			}
			if (_deviceExtensions != NULL)
			{
				delete[] _deviceExtensions;
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

		cl_uint maxFreq = 0;
		cl_uint maxUnits = 0;
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
						char devicename[80];
						cl_uint freq, units;
						clGetDeviceInfo(id[j], CL_DEVICE_MAX_CLOCK_FREQUENCY, sizeof(cl_uint), &freq, &length);
						clGetDeviceInfo(id[j], CL_DEVICE_MAX_COMPUTE_UNITS, sizeof(cl_uint), &units, &length);
						clGetDeviceInfo(id[j], CL_DEVICE_NAME, sizeof(devicename), devicename, NULL);
						printf("%s %d Compute units %dMHz : %s\n", devicename, units, freq, buffer);
						if (_strcmpi(buffer, version) >= 0)
						{
							if ((maxFreq * maxUnits) < (freq * units))
							{
								_platformId = platforms[i];
								_deviceId = id[j];
								maxFreq = freq;
								maxUnits = units;
							}
						}
						else
						{
							//clGetDeviceInfo(_deviceId, CL_DEVICE_NAME, sizeof(buffer), buffer, NULL);
							printf("%d Compute units %dMHz : %s\n", units, freq, buffer);
						}
					}
				}
				delete[] id;
			}
		}
#ifdef _WIN32
		cl_context_properties opengl_props[] = {
			CL_GL_CONTEXT_KHR, (cl_context_properties)wglGetCurrentContext(),
			CL_WGL_HDC_KHR, (cl_context_properties)wglGetCurrentDC(),
			CL_CONTEXT_PLATFORM, (cl_context_properties)_platformId,
			0
		};

		cl_context_properties d3d11_props[] =
		{
			//CL_CONTEXT_D3D11_DEVICE_KHR, (cl_context_properties)g_pD3DDevice,
			CL_CONTEXT_PLATFORM, (cl_context_properties)_platformId,
			0
		};
#endif
		// ここで連携するOpenGL/D3Dのプロパティを設定してコンテキストを取得する
		switch (_sharing)
		{
#ifdef _WIN32
		case OPENGL:
			_context = clCreateContext(opengl_props, 1, &_deviceId, NULL, NULL, &_errorCode);
			break;

		case D3D11:
			_context = clCreateContext(d3d11_props, 1, &_deviceId, NULL, NULL, &_errorCode);
			break;
#endif
		default:
			_context = clCreateContext(NULL, 1, &_deviceId, NULL, NULL, &_errorCode);
			break;
		}
		SAMPLE_CHECK_ERRORS(_errorCode);
#ifdef _DEBUG
		char buffer[80];
		clGetDeviceInfo(_deviceId, CL_DEVICE_NAME, sizeof(buffer), buffer, NULL);
		printf("DEVICE: %s\n", buffer);
#endif
		return _deviceId;
	}

	// Enumerate OpenCL extensions
	int OvrvisionProOpenCL::DeviceExtensions(EXTENSION_CALLBACK callback, void *item)
	{
		size_t size;
		clGetDeviceInfo(_deviceId, CL_DEVICE_EXTENSIONS, 0, NULL, &size); // get entension size
		if (_deviceExtensions == NULL)
		{
			_deviceExtensions = new char[size];
		}
		clGetDeviceInfo(_deviceId, CL_DEVICE_EXTENSIONS, size, _deviceExtensions, NULL);
		if (callback != NULL)
		{
			callback(item, _deviceExtensions);
		}
		else
		{
			//puts(_deviceExtensions);
		}
		return (int)size;
	}

	// OpenGL/D3D連携準備
	bool OvrvisionProOpenCL::Prepare4Sharing()
	{
		DeviceExtensions();
#ifdef _WIN32
		if (strstr(_deviceExtensions, "cl_nv_d3d11_sharing"))
		{
			_vendorD3D11 = NVIDIA;
			INITPFN(clGetDeviceIDsFromD3D11NV);
			INITPFN(clCreateFromD3D11BufferNV);
			INITPFN(clCreateFromD3D11Texture2DNV);
			INITPFN(clCreateFromD3D11Texture3DNV);
			INITPFN(clEnqueueAcquireD3D11ObjectsNV);
			INITPFN(clEnqueueReleaseD3D11ObjectsNV);
			if (clCreateFromD3D11Texture2DNV != NULL)
				return true;
		}
		else if (strstr(_deviceExtensions, "cl_khr_d3d11_sharing"))
		{
			_vendorD3D11 = KHRONOS;
			INITPFN(clGetDeviceIDsFromD3D11KHR);
			INITPFN(clCreateFromD3D11BufferKHR);
			INITPFN(clCreateFromD3D11Texture2DKHR);
			INITPFN(clCreateFromD3D11Texture3DKHR);
			INITPFN(clEnqueueAcquireD3D11ObjectsKHR);
			INITPFN(clEnqueueReleaseD3D11ObjectsKHR);
			if (clCreateFromD3D11Texture2DKHR != NULL)
				return true;
		}
		return false;
#else
		return true;
#endif
	}

	// OpenGL連携テクスチャー
	cl_mem OvrvisionProOpenCL::CreateGLTexture2D(GLuint textureId, int width, int height)
	{
		/*
		glBindTexture(GL_TEXTURE_2D, textureId);
		glTexImage2D(GL_TEXTURE_2D, 0, pixelFormat, width, height, 0, pixelFormat, dataType, NULL);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
		glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_DECAL);
		glBindTexture(GL_TEXTURE_2D, 0);
		glEnable(GL_TEXTURE_2D);
		*/
		return clCreateFromGLTexture2D(_context, CL_MEM_READ_WRITE, GL_TEXTURE_2D, 0, textureId, &_errorCode);
	}

#ifdef _WIN32
	// TODO: Direct3D連携用のテクスチャーを生成
	cl_mem OvrvisionProOpenCL::CreateD3DTexture2D(ID3D11Texture2D *texture, int width, int height)
	{
		if (_vendorD3D11 == NVIDIA)
		{
			return clCreateFromD3D11Texture2DNV(_context, CL_MEM_READ_WRITE, texture, 0, &_errorCode);
		}
		else
		{
			return clCreateFromD3D11Texture2DKHR(_context, CL_MEM_READ_WRITE, texture, 0, &_errorCode);
		}
	}
#endif

	// TODO:　縮小グレースケール画像を取得
	void OvrvisionProOpenCL::Grayscale(uchar *left, uchar *right, enum SCALING scaling)
	{
		// _l, _rから縮小グレースケール画像を生成して返す
		int scale = 2;
		switch (scaling)
		{
		case HALF:
			scale = 2;
			break;

		case FOURTH:
			scale = 4;
			break;

		case EIGHTH:
			scale = 8;
			break;

		default:
			return;
		}
		size_t reSize[] = { _width / scale, _height / scale };
		size_t region[3] = { _width / scale, _height / scale, 1 };
		size_t origin[3] = { 0, 0, 0 };
		cl_event writeEvent, execute;

		clSetKernelArg(_remap, 0, sizeof(cl_mem), &_l);
		clSetKernelArg(_remap, 1, sizeof(cl_mem), &_grayL);
		clSetKernelArg(_remap, 2, sizeof(int), &scale);
		_errorCode = clEnqueueNDRangeKernel(_commandQueue, _grayscale, 2, NULL, reSize, 0, 1, &writeEvent, &execute);
		SAMPLE_CHECK_ERRORS(_errorCode);
		clSetKernelArg(_remap, 0, sizeof(cl_mem), &_r);
		clSetKernelArg(_remap, 1, sizeof(cl_mem), &_grayR);
		clSetKernelArg(_remap, 2, sizeof(int), &scale);
		_errorCode = clEnqueueNDRangeKernel(_commandQueue, _grayscale, 2, NULL, reSize, 0, 1, &writeEvent, &execute);
		SAMPLE_CHECK_ERRORS(_errorCode);
		// Read result
		_errorCode = clEnqueueReadImage(_commandQueue, _grayL, CL_TRUE, origin, region, _width * sizeof(uchar), 0, left, 1, &execute, NULL);
		_errorCode = clEnqueueReadImage(_commandQueue, _grayR, CL_TRUE, origin, region, _width * sizeof(uchar), 0, right, 1, &execute, NULL);
		SAMPLE_CHECK_ERRORS(_errorCode);
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
		void OvrvisionProOpenCL::Demosaic(const ushort* src, cl_mem left, cl_mem right, cl_event *execute)
		{
			size_t origin[3] = { 0, 0, 0 };
			size_t region[3] = { _width, _height, 1 };
			size_t demosaicSize[] = { _width / 2, _height / 2 };
			cl_event writeEvent;
			_errorCode = clEnqueueWriteImage(_commandQueue, _src, CL_TRUE, origin, region, _width * sizeof(ushort), 0, src, 0, NULL, &writeEvent);
			SAMPLE_CHECK_ERRORS(_errorCode);

			//__kernel void demosaic(
			//	__read_only image2d_t src,	// CL_UNSIGNED_INT16
			//	__write_only image2d_t left,	// CL_UNSIGNED_INT8 x 3
			//	__write_only image2d_t right)	// CL_UNSIGNED_INT8 x 3
			//cl_kernel _demosaic = clCreateKernel(_program, "demosaic", &_errorCode);
			//SAMPLE_CHECK_ERRORS(_errorCode);

			clSetKernelArg(_demosaic, 0, sizeof(cl_mem), &_src);
			clSetKernelArg(_demosaic, 1, sizeof(cl_mem), &left);
			clSetKernelArg(_demosaic, 2, sizeof(cl_mem), &right);
			_errorCode = clEnqueueNDRangeKernel(_commandQueue, _demosaic, 2, NULL, demosaicSize, 0, 1, &writeEvent, execute);
			SAMPLE_CHECK_ERRORS(_errorCode);
		}

		void OvrvisionProOpenCL::Demosaic(const ushort* src, cl_event *execute)
		{
			Demosaic(src, _l, _r, execute);
		}

		// Read images region of interest
		void OvrvisionProOpenCL::Read(uchar *left, uchar *right, int offsetX, int offsetY, uint width, uint height)
		{
			size_t origin[3] = { offsetX, offsetY, 0 };
			size_t region[3] = { width, height, 1 };
			cl_event execute;
			if (left != NULL)
			{
				_errorCode = clEnqueueReadImage(_commandQueue, _l, CL_TRUE, origin, region, width * sizeof(uchar) * 4, 0, left, 0, NULL, NULL);
			}
			if (right != NULL)
			{
				_errorCode = clEnqueueReadImage(_commandQueue, _r, CL_TRUE, origin, region, width * sizeof(uchar) * 4, 0, right, 0, NULL, NULL);
			}
		}


		void OvrvisionProOpenCL::Demosaic(const ushort* src, uchar *left, uchar *right)
		{
			size_t origin[3] = { 0, 0, 0 };
			size_t region[3] = { _width, _height, 1 };
			cl_event execute;

			Demosaic(src, &execute);

			// Read result
			_errorCode = clEnqueueReadImage(_commandQueue, _l, CL_TRUE, origin, region, _width * sizeof(uchar) * 4, 0, left, 1, &execute, NULL);
			_errorCode = clEnqueueReadImage(_commandQueue, _r, CL_TRUE, origin, region, _width * sizeof(uchar) * 4, 0, right, 1, &execute, NULL);
		}

		void OvrvisionProOpenCL::Demosaic(const ushort *src, Mat &left, Mat &right)
		{
			size_t origin[3] = { 0, 0, 0 };
			size_t region[3] = { _width, _height, 1 };
			cl_event execute;

			Demosaic(src, &execute);

			// Read result
			_errorCode = clEnqueueReadImage(_commandQueue, _l, CL_TRUE, origin, region, _width * sizeof(uchar) * 4, 0, left.ptr(0), 1, &execute, NULL);
			_errorCode = clEnqueueReadImage(_commandQueue, _r, CL_TRUE, origin, region, _width * sizeof(uchar) * 4, 0, right.ptr(0), 1, &execute, NULL);
			//clFinish(_commandQueue);
			//clReleaseKernel(_demosaic);
			//SAMPLE_CHECK_ERRORS(_errorCode);
		}

		void OvrvisionProOpenCL::Demosaic(const Mat src, Mat &left, Mat &right)
		{
			const uchar *ptr = src.ptr(0);
			Demosaic((const ushort *)ptr, left, right);
		}

		// Remap
		void OvrvisionProOpenCL::Remap(const cl_mem src, uint width, uint height, const cl_mem mapX, const cl_mem mapY, cl_mem dst, cl_event *execute)
		{
			size_t remapSize[] = { width, height };

			//__kernel void remap(
			//	__read_only image2d_t src,		// CL_UNSIGNED_INT8 x 4
			//	__read_only image2d_t mapX,		// CL_FLOAT
			//	__read_only image2d_t mapY,		// CL_FLOAT
			//	__write_only image2d_t	dst)	// CL_UNSIGNED_INT8 x 4
			//cl_kernel _remap = clCreateKernel(_program, "remap", &_errorCode);
			//SAMPLE_CHECK_ERRORS(_errorCode);

			clSetKernelArg(_remap, 0, sizeof(cl_mem), &src);
			clSetKernelArg(_remap, 1, sizeof(cl_mem), &mapX);
			clSetKernelArg(_remap, 2, sizeof(cl_mem), &mapY);
			clSetKernelArg(_remap, 3, sizeof(cl_mem), &dst);
			_errorCode = clEnqueueNDRangeKernel(_commandQueue, _remap, 2, NULL, remapSize, 0, 1, execute, NULL);
			SAMPLE_CHECK_ERRORS(_errorCode);
		}

		// Demosaic and Remap
		void OvrvisionProOpenCL::DemosaicRemap(const ushort* src, cl_mem left, cl_mem right, cl_event *execute)
		{
			size_t origin[3] = { 0, 0, 0 };
			size_t region[3] = { _width, _height, 1 };
			size_t demosaicSize[] = { _width / 2, _height / 2 };
			cl_event writeEvent;
			_errorCode = clEnqueueWriteImage(_commandQueue, _src, CL_TRUE, origin, region, _width * sizeof(ushort), 0, src, 0, NULL, &writeEvent);
			SAMPLE_CHECK_ERRORS(_errorCode);

			//__kernel void demosaic(
			//	__read_only image2d_t src,	// CL_UNSIGNED_INT16
			//	__write_only image2d_t left,	// CL_UNSIGNED_INT8 x 3
			//	__write_only image2d_t right)	// CL_UNSIGNED_INT8 x 3
			//cl_kernel _demosaic = clCreateKernel(_program, "demosaic", &_errorCode);
			//SAMPLE_CHECK_ERRORS(_errorCode);

			clSetKernelArg(_demosaic, 0, sizeof(cl_mem), &_src);
			clSetKernelArg(_demosaic, 1, sizeof(cl_mem), &_L);
			clSetKernelArg(_demosaic, 2, sizeof(cl_mem), &_R);
			_errorCode = clEnqueueNDRangeKernel(_commandQueue, _demosaic, 2, NULL, demosaicSize, 0, 1, &writeEvent, execute);
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

				clSetKernelArg(_remap, 0, sizeof(cl_mem), &_L);
				clSetKernelArg(_remap, 1, sizeof(cl_mem), &_mx[0]);
				clSetKernelArg(_remap, 2, sizeof(cl_mem), &_my[0]);
				clSetKernelArg(_remap, 3, sizeof(cl_mem), &left);
				_errorCode = clEnqueueNDRangeKernel(_commandQueue, _remap, 2, NULL, remapSize, 0, 1, &writeEvent, execute);
				SAMPLE_CHECK_ERRORS(_errorCode);
				clSetKernelArg(_remap, 0, sizeof(cl_mem), &_R);
				clSetKernelArg(_remap, 1, sizeof(cl_mem), &_mx[1]);
				clSetKernelArg(_remap, 2, sizeof(cl_mem), &_my[1]);
				clSetKernelArg(_remap, 3, sizeof(cl_mem), &right);
				_errorCode = clEnqueueNDRangeKernel(_commandQueue, _remap, 2, NULL, remapSize, 0, 1, &writeEvent, execute);
				SAMPLE_CHECK_ERRORS(_errorCode);
			}
		}

		void OvrvisionProOpenCL::DemosaicRemap(const ushort* src, cl_event *execute)
		{
			DemosaicRemap(src, _l, _r, execute);
		}

		void OvrvisionProOpenCL::DemosaicRemap(const ushort* src, uchar *left, uchar *right)
		{
			size_t origin[3] = { 0, 0, 0 };
			size_t region[3] = { _width, _height, 1 };
			cl_event execute;

			DemosaicRemap(src, &execute);
			// Read result
			_errorCode = clEnqueueReadImage(_commandQueue, _l, CL_TRUE, origin, region, _width * sizeof(uchar) * 4, 0, left, 1, &execute, NULL);
			_errorCode = clEnqueueReadImage(_commandQueue, _r, CL_TRUE, origin, region, _width * sizeof(uchar) * 4, 0, right, 1, &execute, NULL);
			SAMPLE_CHECK_ERRORS(_errorCode);

		}

		void OvrvisionProOpenCL::DemosaicRemap(const ushort *src, Mat &left, Mat &right)
		{
			size_t origin[3] = { 0, 0, 0 };
			size_t region[3] = { _width, _height, 1 };
			cl_event execute;

			DemosaicRemap(src, &execute);
			// Read result
			_errorCode = clEnqueueReadImage(_commandQueue, _l, CL_TRUE, origin, region, _width * sizeof(uchar) * 4, 0, left.ptr(0), 1, &execute, NULL);
			_errorCode = clEnqueueReadImage(_commandQueue, _r, CL_TRUE, origin, region, _width * sizeof(uchar) * 4, 0, right.ptr(0), 1, &execute, NULL);
			SAMPLE_CHECK_ERRORS(_errorCode);

		}

		void OvrvisionProOpenCL::DemosaicRemap(const Mat src, Mat &left, Mat &right)
		{
			//size_t origin[3] = { 0, 0, 0 };
			//size_t region[3] = { src.cols, src.rows, 1 };
			//size_t demosaicSize[] = { src.cols / 2, src.rows / 2 };
			const uchar *ptr = src.ptr(0);
			DemosaicRemap((const ushort *)ptr, left, right);
		}

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
				_grayscale = clCreateKernel(_program, "grayscale", &_errorCode);
				SAMPLE_CHECK_ERRORS(_errorCode);
				_skincolor = clCreateKernel(_program, "skincolor", &_errorCode);
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
}