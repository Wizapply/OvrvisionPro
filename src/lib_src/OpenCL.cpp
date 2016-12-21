// OpenCL.cpp
//
//MIT License
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//THE SOFTWAR
//
// Oculus Rift : TM & Copyright Oculus VR, Inc. All Rights Reserved
// Unity : TM & Copyright Unity Technologies. All Rights Reserved

#include <stdio.h>
#include <sys/stat.h>
#include <opencv2/opencv.hpp>
#include <stdexcept>

#include "OvrvisionProCL.h"

#include "OpenCL_kernel.h" // kernel code declared here const char *kernel;

#define TONE_CORRECTION	// Tone correction for improve skin color estimation
#define MEDIAN_3x3	// Use Median 3x3 filter to denoise
//#define GAUSSIAN	// Use Gaussian filter to denoise

using namespace std;
using namespace cv;

#pragma region MACROS

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
#ifdef WIN32
			CASE_CL_CONSTANT(CL_INVALID_GL_SHAREGROUP_REFERENCE_KHR)
#endif
	default:
		return "UNKNOWN ERROR CODE ";// +to_str(error);
	}

#undef CASE_CL_CONSTANT
}

#if 0
// Report about an OpenCL problem.
// Macro is used instead of a function here
// to report source file name and line number.
#define SAMPLE_CHECK_ERRORS(ERR)						\
    if(ERR != CL_SUCCESS)								\
		{													\
        throw std::runtime_error(							\
            "OpenCL error " +							\
            opencl_error_to_str(ERR) +					\
            " happened in file " + std::to_str(__FILE__) +	\
            " at line " + std::to_str(__LINE__) + "."		\
        );												\
		}
#else

#define SAMPLE_CHECK_ERRORS(ERR)  \
	if (ERR != CL_SUCCESS) { \
		printf("%s %d\n", __FILE__, __LINE__); \
		throw std::runtime_error(opencl_error_to_str(ERR).c_str()); \
	}
#endif

#define GETFUNCTION(platform, x) \
    (x ## _fn)clGetExtensionFunctionAddressForPlatform(platform, #x);
#pragma endregion

namespace OVR
{

#pragma region CONSTANTS
	static const cl_image_format _format16UC1 = { CL_R, CL_UNSIGNED_INT16 };
	static const cl_image_format _format8UC4 = { CL_RGBA, CL_UNSIGNED_INT8 };
	static const cl_image_format _format8UC1 = { CL_R, CL_UNSIGNED_INT8 };
	static const cl_image_format _formatMap = { CL_R, CL_FLOAT };
	static const cl_image_format _formatGL = { CL_RGBA, CL_UNORM_INT8 };
	static const char ESTIMATION_INSTRUCTION[] = "Please wave hand(s) to estimate skin color.";
	static const char COUNTDOWN_MESSAGE[] = "Estimating.. %d";
	static const char ESTIMATED_MESSAGE[] = "Estimation complete.";
	static const uchar toneBeutify[3][256] = {
		{ 0, 1, 3, 4, 6, 7, 9, 10,
		11, 13, 14, 16, 17, 19, 20, 21,
		23, 24, 26, 27, 29, 30, 31, 33,
		34,  36,  37,  38,  40,  41,  43,  44,
		46,  47,  48,  50,  51,  52,  54,  55,
		57, 58, 59, 61, 62, 64, 65, 66,
		68, 69, 70, 72, 73, 74, 76, 77,
		78, 80, 81, 82, 84, 85, 86, 88,
		89, 90, 92, 93, 94, 96, 97, 98,
		99, 101, 102, 103, 104, 106, 107, 108,
		109, 111, 112, 113, 114, 116, 117, 118,
		119, 120, 122, 123, 124, 125, 126, 127,
		129, 130, 131, 132, 133, 134, 135, 137,
		138, 139, 140, 141, 142, 143, 144, 145,
		146, 147, 148, 150, 151, 152, 153, 154,
		155, 156, 157, 158, 159, 160, 161, 162,
		162, 163, 164, 165, 166, 167, 168, 169,
		170, 171, 172, 173, 174, 175, 175, 176,
		177, 178, 179, 180, 181, 182, 182, 183,
		184, 185, 186, 187, 187, 188, 189, 190,
		191, 192, 192, 193, 194, 195, 195, 196,
		197, 198, 199, 199, 200, 201, 202, 202,
		203, 204, 205, 205, 206, 207, 208, 208,
		209, 210, 210, 211, 212, 213, 213, 214,
		215, 215, 216, 217, 217, 218, 219, 219,
		220, 221, 222, 222, 223, 224, 224, 225,
		226, 226, 227, 227, 228, 229, 229, 230,
		231, 231, 232, 233, 233, 234, 235, 235,
		236, 236, 237, 238, 238, 239, 240, 240,
		241, 241, 242, 243, 243, 244, 245, 245,
		246, 246, 247, 248, 248, 249, 249, 250,
		251, 251, 252, 253, 253, 254, 254, 255 },
		{ 0, 1, 3, 4, 6, 7, 9, 10,
		11, 13, 14, 16, 17, 19, 20, 21,
		23, 24, 26, 27, 29, 30, 31, 33,
		34, 36, 37, 38, 40, 41, 43, 44,
		46, 47, 48, 50, 51, 52, 54, 55,
		57, 58, 59, 61, 62, 64, 65, 66,
		68, 69, 70, 72, 73, 74, 76, 77,
		78, 80, 81, 82, 84, 85, 86, 88,
		89, 90, 92, 93, 94, 96, 97, 98,
		99, 101, 102, 103, 104, 106, 107, 108,
		109, 111, 112, 113, 114, 116, 117, 118,
		119, 120, 122, 123, 124, 125, 126, 127,
		129, 130, 131, 132, 133, 134, 135, 137,
		138, 139, 140, 141, 142, 143, 144, 145,
		146, 147, 148, 150, 151, 152, 153, 154,
		155, 156, 157, 158, 159, 160, 161, 162,
		162, 163, 164, 165, 166, 167, 168, 169,
		170, 171, 172, 173, 174, 175, 175, 176,
		177, 178, 179, 180, 181, 182, 182, 183,
		184, 185, 186, 187, 187, 188, 189, 190,
		191, 192, 192, 193, 194, 195, 195, 196,
		197, 198, 199, 199, 200, 201, 202, 202,
		203, 204, 205, 205, 206, 207, 208, 208,
		209, 210, 210, 211, 212, 213, 213, 214,
		215, 215, 216, 217, 217, 218, 219, 219,
		220, 221, 222, 222, 223, 224, 224, 225,
		226, 226, 227, 227, 228, 229, 229, 230,
		231, 231, 232, 233, 233, 234, 235, 235,
		236, 236, 237, 238, 238, 239, 240, 240,
		241, 241, 242, 243, 243, 244, 245, 245,
		246, 246, 247, 248, 248, 249, 249, 250,
		251, 251, 252, 253, 253, 254, 254, 255 },
		{ 0, 1, 3, 4, 6, 7, 9, 10,
		11, 13, 14, 16, 17, 19, 20, 21,
		23, 24, 26, 27, 29, 30, 31, 33,
		34, 36, 37, 38, 40, 41, 43, 44,
		46, 47, 48, 50, 51, 52, 54, 55,
		57, 58, 59, 61, 62, 64, 65, 66,
		68, 69, 70, 72, 73, 74, 76, 77,
		78, 80, 81, 82, 84, 85, 86, 88,
		89, 90, 92, 93, 94, 96, 97, 98,
		99, 101, 102, 103, 104, 106, 107, 108,
		109, 111, 112, 113, 114, 116, 117, 118,
		119, 120, 122, 123, 124, 125, 126, 127,
		129, 130, 131, 132, 133, 134, 135, 137,
		138, 139, 140, 141, 142, 143, 144, 145,
		146, 147, 148, 150, 151, 152, 153, 154,
		155, 156, 157, 158, 159, 160, 161, 162,
		162, 163, 164, 165, 166, 167, 168, 169,
		170, 171, 172, 173, 174, 175, 175, 176,
		177, 178, 179, 180, 181, 182, 182, 183,
		184, 185, 186, 187, 187, 188, 189, 190,
		191, 192, 192, 193, 194, 195, 195, 196,
		197, 198, 199, 199, 200, 201, 202, 202,
		203, 204, 205, 205, 206, 207, 208, 208,
		209, 210, 210, 211, 212, 213, 213, 214,
		215, 215, 216, 217, 217, 218, 219, 219,
		220, 221, 222, 222, 223, 224, 224, 225,
		226, 226, 227, 227, 228, 229, 229, 230,
		231, 231, 232, 233, 233, 234, 235, 235,
		236, 236, 237, 238, 238, 239, 240, 240,
		241, 241, 242, 243, 243, 244, 245, 245,
		246, 246, 247, 248, 248, 249, 249, 250,
		251, 251, 252, 253, 253, 254, 254, 255 }, 
	};
	static const uchar toneMap[3][256] =
	{
		{ 0, 0, 1, 1, 2, 2, 3, 3,
		4, 4, 5, 5, 6, 6, 7, 7,
		8, 8, 9, 9, 10, 11, 11, 12,
		12, 13, 13, 14, 14, 15, 15, 16,
		16, 17, 17, 18, 18, 19, 19, 20,
		20, 21, 21, 22, 23, 23, 24, 24,
		25, 25, 26, 26, 27, 28, 28, 29,
		29, 30, 30, 31, 32, 32, 33, 33,
		34, 34, 35, 36, 36, 37, 38, 38,
		39, 39, 40, 41, 41, 42, 43, 43,
		44, 45, 45, 46, 46, 47, 48, 49,
		49, 50, 51, 51, 52, 53, 53, 54,
		55, 56, 56, 57, 58, 58, 59, 60,
		61, 61, 62, 63, 64, 65, 65, 66,
		67, 68, 69, 69, 70, 71, 72, 73,
		73, 74, 75, 76, 77, 78, 79, 80,
		80, 81, 82, 83, 84, 85, 86, 87,
		88, 89, 90, 91, 92, 93, 94, 95,
		95, 96, 98, 99, 100, 101, 102, 103,
		104, 105, 106, 107, 108, 109, 110, 111,
		112, 113, 115, 116, 117, 118, 119, 120,
		122, 123, 124, 125, 126, 127, 129, 130,
		131, 132, 134, 135, 136, 137, 139, 140,
		141, 143, 144, 145, 147, 148, 149, 151,
		152, 154, 155, 156, 158, 159, 161, 162,
		164, 165, 166, 168, 169, 171, 172, 174,
		176, 177, 179, 180, 182, 183, 185, 187,
		188, 190, 191, 193, 195, 196, 198, 200,
		201, 203, 205, 206, 208, 210, 211, 213,
		215, 216, 218, 220, 222, 223, 225, 227,
		229, 230, 232, 234, 236, 237, 239, 241,
		243, 244, 246, 248, 250, 251, 253, 255},
		{ 0, 0, 1, 1, 2, 2, 3, 3,
		4, 4, 5, 5, 6, 6, 7, 7,
		8, 8, 9, 9, 10, 11, 11, 12,
		12, 13, 13, 14, 14, 15, 15, 16,
		16, 17, 17, 18, 18, 19, 19, 20,
		20, 21, 21, 22, 23, 23, 24, 24,
		25, 25, 26, 26, 27, 28, 28, 29,
		29, 30, 30, 31, 32, 32, 33, 33,
		34, 34, 35, 36, 36, 37, 38, 38,
		39, 39, 40, 41, 41, 42, 43, 43,
		44, 45, 45, 46, 46, 47, 48, 49,
		49, 50, 51, 51, 52, 53, 53, 54,
		55, 56, 56, 57, 58, 58, 59, 60,
		61, 61, 62, 63, 64, 65, 65, 66,
		67, 68, 69, 69, 70, 71, 72, 73,
		73, 74, 75, 76, 77, 78, 79, 80,
		80, 81, 82, 83, 84, 85, 86, 87,
		88, 89, 90, 91, 92, 93, 94, 95,
		95, 96, 98, 99, 100, 101, 102, 103,
		104, 105, 106, 107, 108, 109, 110, 111,
		112, 113, 115, 116, 117, 118, 119, 120,
		122, 123, 124, 125, 126, 127, 129, 130,
		131, 132, 134, 135, 136, 137, 139, 140,
		141, 143, 144, 145, 147, 148, 149, 151,
		152, 154, 155, 156, 158, 159, 161, 162,
		164, 165, 166, 168, 169, 171, 172, 174,
		176, 177, 179, 180, 182, 183, 185, 187,
		188, 190, 191, 193, 195, 196, 198, 200,
		201, 203, 205, 206, 208, 210, 211, 213,
		215, 216, 218, 220, 222, 223, 225, 227,
		229, 230, 232, 234, 236, 237, 239, 241,
		243, 244, 246, 248, 250, 251, 253, 255},
		{ 0, 0, 1, 1, 2, 2, 3, 3,
		4, 4, 5, 5, 6, 6, 7, 7,
		8, 8, 9, 9, 10, 11, 11, 12,
		12, 13, 13, 14, 14, 15, 15, 16,
		16, 17, 17, 18, 18, 19, 19, 20,
		20, 21, 21, 22, 23, 23, 24, 24,
		25, 25, 26, 26, 27, 28, 28, 29,
		29, 30, 30, 31, 32, 32, 33, 33,
		34, 34, 35, 36, 36, 37, 38, 38,
		39, 39, 40, 41, 41, 42, 43, 43,
		44, 45, 45, 46, 46, 47, 48, 49,
		49, 50, 51, 51, 52, 53, 53, 54,
		55, 56, 56, 57, 58, 58, 59, 60,
		61, 61, 62, 63, 64, 65, 65, 66,
		67, 68, 69, 69, 70, 71, 72, 73,
		73, 74, 75, 76, 77, 78, 79, 80,
		80, 81, 82, 83, 84, 85, 86, 87,
		88, 89, 90, 91, 92, 93, 94, 95,
		95, 96, 98, 99, 100, 101, 102, 103,
		104, 105, 106, 107, 108, 109, 110, 111,
		112, 113, 115, 116, 117, 118, 119, 120,
		122, 123, 124, 125, 126, 127, 129, 130,
		131, 132, 134, 135, 136, 137, 139, 140,
		141, 143, 144, 145, 147, 148, 149, 151,
		152, 154, 155, 156, 158, 159, 161, 162,
		164, 165, 166, 168, 169, 171, 172, 174,
		176, 177, 179, 180, 182, 183, 185, 187,
		188, 190, 191, 193, 195, 196, 198, 200,
		201, 203, 205, 206, 208, 210, 211, 213,
		215, 216, 218, 220, 222, 223, 225, 227,
		229, 230, 232, 234, 236, 237, 239, 241,
		243, 244, 246, 248, 250, 251, 253, 255},
	};
#pragma endregion

	//namespace OPENCL
	//{
#pragma region CONSTRUCTOR_DESTRUCTOR
		// Constructor
	OvrvisionProOpenCL::OvrvisionProOpenCL(int width, int height, enum SHARING_MODE mode, void *pDevice)
		{
			_width = width;
			_height = height;
			_sharing = mode;

			if (SelectGPU("", "OpenCL C 1.2") == NULL) // Find OpenCL(version 1.2 and above) device 
			{
                throw std::runtime_error("Insufficient OpenCL version");
			}
#ifdef MACOSX
			//pclGetGLContextInfoKHR = GETFUNCTION(_platformId, clGetGLContextInfoKHR);
#else
			//pclGetGLContextInfoKHR = GETFUNCTION(_platformId, clGetGLContextInfoKHR);
#endif
			CreateContext(mode, pDevice);
			_commandQueue = clCreateCommandQueue(_context, _deviceId, 0, &_errorCode);
			SAMPLE_CHECK_ERRORS(_errorCode);
			// UMat seems to have extra overhead of data transfer, so WE USE NATIVE OPENCL IMAGE2D
			memset(&_desc_scaled, 0, sizeof(_desc_scaled));
			_desc_scaled.image_type = CL_MEM_OBJECT_IMAGE2D;
			cl_image_desc desc = { CL_MEM_OBJECT_IMAGE2D, _width, _height, 0, 0, 0, 0, 0, 0, NULL };
			cl_image_desc desc_half = { CL_MEM_OBJECT_IMAGE2D, _width / 2, _height / 2, 0, 0, 0, 0, 0, 0, NULL };
			cl_image_desc desc_tone = { CL_MEM_OBJECT_IMAGE2D, 256, 3, 0, 0, 0, 0, 0, 0, NULL };

			_src = clCreateImage(_context, CL_MEM_READ_ONLY, &_format16UC1, &desc, 0, &_errorCode);
			SAMPLE_CHECK_ERRORS(_errorCode);

			_remapAvailable = false;

			_mapX[0] = new Mat();
			_mapY[0] = new Mat();
			_mapX[1] = new Mat();
			_mapY[1] = new Mat();
			_skinmask[0] = new Mat(_height / 2, _width / 2, CV_8UC1);
			_skinmask[1] = new Mat(_height / 2, _width / 2, CV_8UC1);

			_l = clCreateImage(_context, CL_MEM_READ_WRITE, &_format8UC4, &desc, 0, &_errorCode);
			_r = clCreateImage(_context, CL_MEM_READ_WRITE, &_format8UC4, &desc, 0, &_errorCode);
			_L = clCreateImage(_context, CL_MEM_READ_WRITE, &_format8UC4, &desc, 0, &_errorCode);
			_R = clCreateImage(_context, CL_MEM_READ_WRITE, &_format8UC4, &desc, 0, &_errorCode);
			_mx[0] = clCreateImage(_context, CL_MEM_READ_ONLY, &_formatMap, &desc, 0, &_errorCode);
			_my[0] = clCreateImage(_context, CL_MEM_READ_ONLY, &_formatMap, &desc, 0, &_errorCode);
			_mx[1] = clCreateImage(_context, CL_MEM_READ_ONLY, &_formatMap, &desc, 0, &_errorCode);
			_my[1] = clCreateImage(_context, CL_MEM_READ_ONLY, &_formatMap, &desc, 0, &_errorCode);
			_reducedL = clCreateImage(_context, CL_MEM_READ_WRITE, &_format8UC4, &desc_half, 0, &_errorCode);
			_reducedR = clCreateImage(_context, CL_MEM_READ_WRITE, &_format8UC4, &desc_half, 0, &_errorCode);
			_toneMap = clCreateImage(_context, CL_MEM_READ_ONLY | CL_MEM_COPY_HOST_PTR, &_format8UC1, &desc_tone, (void *)toneMap, &_errorCode);
			_texture[0] = NULL;
			_texture[1] = NULL;

			_deviceExtensions = NULL;
			CreateProgram();
			Prepare4Sharing();
			SetScale(HALF);
			_released = false;
			_calibration = false;
			_frameCounter = 0;

			// Skin default values
			_h_low = 13;
			_h_high = 21;
			_s_low = 88;
			_s_high = 136;
			_skinThreshold = 0;
			_histgram[0] = new Mat(256, 256, CV_32SC1);
			_histgram[1] = new Mat(256, 256, CV_32SC1);

			// Inter frame object tracking 
			//_kalman[0] = KalmanFilter(4, 2);
			//_kalman[1] = KalmanFilter(4, 2);
			//setIdentity(_kalman[0].measurementMatrix, cvRealScalar(1.0));
			//setIdentity(_kalman[0].processNoiseCov, cvRealScalar(1e-5));
			//setIdentity(_kalman[0].measurementNoiseCov, cvRealScalar(0.1));
			//setIdentity(_kalman[0].errorCovPost, cvRealScalar(1.0));
			
			//kalman->DynamMatr[0] = 1.0; kalman->DynamMatr[1] = 0.0; kalman->DynamMatr[2] = 1.0; kalman->DynamMatr[3] = 0.0;
			//kalman->DynamMatr[4] = 0.0; kalman->DynamMatr[5] = 1.0; kalman->DynamMatr[6] = 0.0; kalman->DynamMatr[7] = 1.0;
			//kalman->DynamMatr[8] = 0.0; kalman->DynamMatr[9] = 0.0; kalman->DynamMatr[10] = 1.0; kalman->DynamMatr[11] = 0.0;
			//kalman->DynamMatr[12] = 0.0; kalman->DynamMatr[13] = 0.0; kalman->DynamMatr[14] = 0.0; kalman->DynamMatr[15] = 1.0;
	}

		// Destructor
	OvrvisionProOpenCL::~OvrvisionProOpenCL()
	{
		if (!_released)
			Close();
	}

	void OvrvisionProOpenCL::Close()
	{
		if (!_released)
		{
			_mapX[0]->release();
			_mapY[0]->release();
			_mapX[1]->release();
			_mapY[1]->release();
			_skinmask[0]->release();
			_skinmask[1]->release();
			_histgram[0]->release();
			_histgram[1]->release();
			delete _mapX[0];
			delete _mapY[0];
			delete _mapX[1];
			delete _mapY[1];
			delete _skinmask[0];
			delete _skinmask[1];
			delete _histgram[0];
			delete _histgram[1];

			clReleaseCommandQueue(_commandQueue);
			clReleaseContext(_context);
			clReleaseProgram(_program);

			clReleaseKernel(_demosaic);
			clReleaseKernel(_remap);
			clReleaseKernel(_resize);
			clReleaseKernel(_convertGrayscale);
			clReleaseKernel(_convertHSV);
			clReleaseKernel(_skincolor);
			clReleaseKernel(_gaussianBlur3x3);
			clReleaseKernel(_medianBlur3x3);
			clReleaseKernel(_medianBlur5x5);
			clReleaseKernel(_mask);
			clReleaseKernel(_maskOpengl);
			clReleaseKernel(_maskD3D11);
			clReleaseKernel(_invertMask);
			clReleaseKernel(_toneCorrection);
			clReleaseKernel(_resizeTone);
			clReleaseKernel(_convertHSVTone);
			clReleaseKernel(_maskTone);
			clReleaseKernel(_maskOpenglTone);
			clReleaseKernel(_copyOpengl);

			clReleaseMemObject(_src);
			clReleaseMemObject(_l);
			clReleaseMemObject(_r);
			clReleaseMemObject(_L);
			clReleaseMemObject(_R);
			clReleaseMemObject(_mx[0]);
			clReleaseMemObject(_my[0]);
			clReleaseMemObject(_mx[1]);
			clReleaseMemObject(_my[1]);
			clReleaseMemObject(_reducedL);
			clReleaseMemObject(_reducedR);
			clReleaseMemObject(_toneMap);
			if (_texture[0] != NULL)
			{
				clReleaseMemObject(_texture[0]);
			}
			if (_texture[1] != NULL)
			{
				clReleaseMemObject(_texture[1]);
			}
			if (_deviceExtensions != NULL)
			{
				delete[] _deviceExtensions;
			}
			//cvReleaseKalman(&_kalman[0]);
			//cvReleaseKalman(&_kalman[1]);
			_released = true;
		}
	}
#pragma endregion

#pragma region FUNDAMENTAL_FUNCTIONS
	/*! @brief Create OpenCL kernels */
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
			free(log);
			return false;
		}
		else
		{
			_demosaic = clCreateKernel(_program, "demosaic", &_errorCode);
			SAMPLE_CHECK_ERRORS(_errorCode);
			_remap = clCreateKernel(_program, "remap", &_errorCode);
			SAMPLE_CHECK_ERRORS(_errorCode);
			_resize = clCreateKernel(_program, "resize", &_errorCode);
			SAMPLE_CHECK_ERRORS(_errorCode);
			_convertHSV = clCreateKernel(_program, "convertHSV", &_errorCode);
			SAMPLE_CHECK_ERRORS(_errorCode);
			_convertGrayscale = clCreateKernel(_program, "convertGrayscale", &_errorCode);
			SAMPLE_CHECK_ERRORS(_errorCode);
			_skincolor = clCreateKernel(_program, "skincolor", &_errorCode);
			SAMPLE_CHECK_ERRORS(_errorCode);
			_gaussianBlur3x3 = clCreateKernel(_program, "gaussian3x3", &_errorCode);
			SAMPLE_CHECK_ERRORS(_errorCode);
			_medianBlur3x3 = clCreateKernel(_program, "median3x3_H", &_errorCode);
			SAMPLE_CHECK_ERRORS(_errorCode);
			_medianBlur5x5 = clCreateKernel(_program, "median5x5_H", &_errorCode);
			SAMPLE_CHECK_ERRORS(_errorCode);
			_mask = clCreateKernel(_program, "mask", &_errorCode);
			SAMPLE_CHECK_ERRORS(_errorCode);
			_maskOpengl = clCreateKernel(_program, "mask_opengl", &_errorCode);
			SAMPLE_CHECK_ERRORS(_errorCode);
			_maskD3D11 = clCreateKernel(_program, "mask_d3d11", &_errorCode);
			SAMPLE_CHECK_ERRORS(_errorCode);
			_invertMask = clCreateKernel(_program, "invert_mask", &_errorCode);
			SAMPLE_CHECK_ERRORS(_errorCode);
			_toneCorrection = clCreateKernel(_program, "tone", &_errorCode);
			SAMPLE_CHECK_ERRORS(_errorCode);
			_resizeTone = clCreateKernel(_program, "resize_tone", &_errorCode);
			SAMPLE_CHECK_ERRORS(_errorCode);
			_convertHSVTone = clCreateKernel(_program, "convertHSVTone", &_errorCode);
			SAMPLE_CHECK_ERRORS(_errorCode);
			_maskTone = clCreateKernel(_program, "maskTone", &_errorCode);
			SAMPLE_CHECK_ERRORS(_errorCode);
			_maskOpenglTone = clCreateKernel(_program, "mask_openglTone", &_errorCode);
			SAMPLE_CHECK_ERRORS(_errorCode);
			_copyOpengl = clCreateKernel(_program, "copy_opengl", &_errorCode);
			SAMPLE_CHECK_ERRORS(_errorCode);
			return true;
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
		bool device_found = false;
		vector<cl_device_id> devices;

		// Search GPU
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
				//SAMPLE_CHECK_ERRORS(err);
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
						if (strcmp(buffer, version) >= 0)
						{
							if ((maxFreq * maxUnits) < (freq * units))
							{
								_platformId = platforms[i];
								_deviceId = id[j];
								maxFreq = freq;
								maxUnits = units;
								device_found = true;
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
		if (!device_found)
		{
            throw std::runtime_error("GPU NOT FOUND.\nRequired OpenCL 1.2 or above.\n");
		}
		return _deviceId;
	}

	// Check saticefy OvrvisionPro
	bool OvrvisionProOpenCL::CheckGPU()
	{
		bool result = false;
		cl_uint num_of_platforms = 0;
		// get total number of available platforms:
		cl_int err = clGetPlatformIDs(0, 0, &num_of_platforms);
		SAMPLE_CHECK_ERRORS(err);

		vector<cl_platform_id> platforms(num_of_platforms);
		// get IDs for all platforms:
		err = clGetPlatformIDs(num_of_platforms, &platforms[0], 0);
		SAMPLE_CHECK_ERRORS(err);

		for (cl_uint i = 0; i < num_of_platforms; i++)
		{
			char devicename[80];
			clGetPlatformInfo(platforms[i], CL_PLATFORM_NAME, sizeof(devicename), devicename, NULL);
			printf("PLATFORM: %s\n", devicename);
#ifdef MACOSX
			// Reference https://developer.apple.com/library/mac/documentation/Performance/Conceptual/OpenCL_MacProgGuide/shareGroups/shareGroups.html#//apple_ref/doc/uid/TP40008312-CH20-SW1
			CGLContextObj kCGLContext = CGLGetCurrentContext();
			CGLShareGroupObj kCGLShareGroup = CGLGetShareGroup(kCGLContext);

			cl_context_properties opengl_props[] = {
				CL_CONTEXT_PROPERTY_USE_CGL_SHAREGROUP_APPLE, (cl_context_properties)kCGLShareGroup,
				0
			};
			size_t devSizeInBytes = 0;
			clGetGLContextInfoAPPLE(NULL, &kCGLContext, CL_CGL_DEVICE_FOR_CURRENT_VIRTUAL_SCREEN_APPLE, 0, NULL, &devSizeInBytes);
			const size_t devNum = devSizeInBytes / sizeof(kCGLContext);
			if (devNum)
			{
				std::vector<cl_device_id> devices(devNum);
				clGetGLContextInfoAPPLE(NULL, &kCGLContext, CL_CGL_DEVICE_FOR_CURRENT_VIRTUAL_SCREEN_APPLE, devSizeInBytes, &devices[0], NULL);
				for (size_t k = 0; k < devNum; k++)
				{
					cl_device_type t;
					clGetDeviceInfo(devices[k], CL_DEVICE_TYPE, sizeof(t), &t, NULL);
					//if (t == CL_DEVICE_TYPE_GPU)
					{
						clGetDeviceInfo(devices[k], CL_DEVICE_NAME, sizeof(devicename), devicename, NULL);
						char buffer[32];
						clGetDeviceInfo(devices[k], CL_DEVICE_OPENCL_C_VERSION, sizeof(buffer), buffer, NULL);
						printf("\t%s %s\n", devicename, buffer);
					}
				}
			}
#else
			clGetGLContextInfoKHR_fn pclGetGLContextInfoKHR = NULL;
			pclGetGLContextInfoKHR = GETFUNCTION(platforms[i], clGetGLContextInfoKHR);
#ifdef WIN32
			// Reference https://software.intel.com/en-us/articles/sharing-surfaces-between-opencl-and-opengl-43-on-intel-processor-graphics-using-implicit
			cl_context_properties opengl_props[] = {
				CL_CONTEXT_PLATFORM, (cl_context_properties)platforms[i],
				CL_GL_CONTEXT_KHR, (cl_context_properties)wglGetCurrentContext(),
				CL_WGL_HDC_KHR, (cl_context_properties)wglGetCurrentDC(),
				0
			};
#elif defined(LINUX)
			cl_context_properties opengl_props[] = {
				CL_CONTEXT_PLATFORM, (cl_context_properties)platforms[i],
				CL_GL_CONTEXT_KHR, (cl_context_properties)glXGetCurrentContext(),
				CL_GLX_DISPLAY_KHR, (cl_context_properties)glXGetCurrentDisplay(),
				0
			};
#endif
			size_t devSizeInBytes = 0;
			pclGetGLContextInfoKHR(opengl_props, CL_DEVICES_FOR_GL_CONTEXT_KHR, 0, NULL, &devSizeInBytes);
			const size_t devNum = devSizeInBytes / sizeof(cl_device_id);
			if (devNum)
			{
				std::vector<cl_device_id> devices(devNum);
				pclGetGLContextInfoKHR(opengl_props, CL_DEVICES_FOR_GL_CONTEXT_KHR, devSizeInBytes, &devices[0], NULL);
				for (size_t k = 0; k < devNum; k++)
				{
					cl_device_type t;
					clGetDeviceInfo(devices[k], CL_DEVICE_TYPE, sizeof(t), &t, NULL);
					//if (t == CL_DEVICE_TYPE_GPU)
					{
						clGetDeviceInfo(devices[k], CL_DEVICE_NAME, sizeof(devicename), devicename, NULL);
						char buffer[32];
						clGetDeviceInfo(devices[k], CL_DEVICE_OPENCL_C_VERSION, sizeof(buffer), buffer, NULL);
						printf("\t%s %s\n", devicename, buffer);
					}
				}
			}
#endif
			// Check Memory capacity and extensions
			bool gl_sharing = false, version = false, d3d11_sharing = false, memory = false;
			cl_ulong mem_size;
			cl_uint num_of_devices = 0;
			if (CL_SUCCESS == clGetDeviceIDs(platforms[i], CL_DEVICE_TYPE_GPU, 0, 0, &num_of_devices))
			{
				cl_device_id *id = new cl_device_id[num_of_devices];
				err = clGetDeviceIDs(platforms[i], CL_DEVICE_TYPE_GPU, num_of_devices, id, 0);
				SAMPLE_CHECK_ERRORS(err);
				for (cl_uint j = 0; j < num_of_devices; j++)
				{
					clGetDeviceInfo(id[j], CL_DEVICE_NAME, sizeof(devicename), devicename, NULL);
					printf("\tGPU: %s\n", devicename);

					// Check version
					char buffer[32];
					if (clGetDeviceInfo(id[j], CL_DEVICE_OPENCL_C_VERSION, sizeof(buffer), buffer, NULL) == CL_SUCCESS)
					{
						if (strcmp(buffer, "OpenCL C 1.2") >= 0)
						{
							version = true;
						}
						printf("\tOpenCL: %s\n", buffer);
					}

					// Check memory capacity
					clGetDeviceInfo(id[j], CL_DEVICE_GLOBAL_MEM_SIZE, sizeof(mem_size), &mem_size, NULL);
					printf("\tGLOBAL_MEM_SIZE: %ld MBytes\n", mem_size / (1024 * 1024));
					clGetDeviceInfo(id[j], CL_DEVICE_MAX_MEM_ALLOC_SIZE, sizeof(mem_size), &mem_size, NULL);
					printf("\tMAX_MEM_ALLOC_SIZE: %ld MBytes\n", mem_size / (1024 * 1024));
					// TODO: Determine which is dominant
					if (256 <= mem_size / (1024 * 1024))
					{
						memory = true;
					}

					// Check extensions
					size_t size;
					char *extensions;
					clGetDeviceInfo(id[j], CL_DEVICE_EXTENSIONS, 0, NULL, &size); // get entension size
					extensions = new char[size];

					clGetDeviceInfo(id[j], CL_DEVICE_EXTENSIONS, size, extensions, NULL);
					if (strstr(extensions, "cl_khr_gl_sharing") != NULL)
					{
						gl_sharing = true;
						printf("\tcl_khr_gl_sharing\n");
					}
#ifdef MACOSX
					else if (strstr(extensions, "cl_APPLE_gl_sharing") != NULL)
					{
						gl_sharing = true;
						printf("\tcl_APPLE_gl_sharing\n");
					}
#endif // MACOSX
#ifdef WIN32
					if (strstr(extensions, "cl_nv_d3d11_sharing") != NULL)
					{
						d3d11_sharing = true;
						printf("\tcl_nv_d3d11_sharing\n");
					}
					else if (strstr(extensions, "cl_khr_d3d11_sharing") != NULL)
					{
						d3d11_sharing = true;
						printf("\tcl_khr_d3d11_sharing\n");
					}
#endif
#ifdef _DEBUG
					puts(extensions);
#endif		

				}
#ifdef WIN32
				if (gl_sharing && memory && version && d3d11_sharing)
				{
					result = true;
					printf("\tOvrvisionPro: Positive\n\n");
				}
#else
				if (gl_sharing && memory && version)
				{
					result = true;
					printf("\tOvrvisionPro: Positive\n\n");
				}
#endif
				else if (256 <= mem_size / (1024 * 1024))
				{
					printf("\tOvrvisionPro: Depend on resolution\n\n");
				}
				else
				{
					printf("\tOvrvisionPro: Negative\n\n");
				}
			}
		}
		return result;
	}

#ifdef WIN32
	void __stdcall createContextCallback(const char *message, const void *data, size_t size, void *userdata)
	{
		printf("clCreateContext: %d %s\n", size, message);
		OutputDebugStringA(message);
	}
#endif

	// Create device context
	void OvrvisionProOpenCL::CreateContext(SHARING_MODE mode, void *pDevice)
	{
#ifdef WIN32
		// Reference: http://www.isus.jp/article/idz/vc/sharing-surfaces-between-opencl-and-opengl43/
		cl_context_properties opengl_props[] = {
			CL_CONTEXT_PLATFORM, (cl_context_properties)_platformId,
			CL_GL_CONTEXT_KHR, (cl_context_properties)wglGetCurrentContext(),
			CL_WGL_HDC_KHR, (cl_context_properties)wglGetCurrentDC(),
			0
		};

		cl_context_properties d3d11_props[] =
		{
			CL_CONTEXT_PLATFORM, (cl_context_properties)_platformId,
			CL_CONTEXT_D3D11_DEVICE_KHR, (cl_context_properties)pDevice,
			0
		};
#elif defined(MACOSX)
		// Reference https://developer.apple.com/library/mac/documentation/Performance/Conceptual/OpenCL_MacProgGuide/shareGroups/shareGroups.html#//apple_ref/doc/uid/TP40008312-CH20-SW1
		CGLContextObj kCGLContext = CGLGetCurrentContext();
		CGLShareGroupObj kCGLShareGroup = CGLGetShareGroup(kCGLContext);

		cl_context_properties opengl_props[] = {
			CL_CONTEXT_PROPERTY_USE_CGL_SHAREGROUP_APPLE, (cl_context_properties)kCGLShareGroup,
			0
		};
#elif defined(LINUX)
		cl_context_properties opengl_props[] = {
			CL_CONTEXT_PLATFORM, (cl_context_properties)_platformId,
			CL_GL_CONTEXT_KHR, (cl_context_properties)glXGetCurrentContext(),
			CL_GLX_DISPLAY_KHR, (cl_context_properties)glXGetCurrentDisplay(),
			0
		};
#endif
		// Prepare for sharing texture
		switch (mode)
		{
#ifdef WIN32
		case OPENGL:
 			if (opengl_props[3] != NULL && opengl_props[5] != NULL)
			{
				_context = clCreateContext(opengl_props, 1, &_deviceId, createContextCallback, NULL, &_errorCode);
			}
			else
			{
				_sharing = mode = NONE;
				_context = clCreateContext(NULL, 1, &_deviceId, createContextCallback, NULL, &_errorCode);
			}
			break;

		case D3D11:
			_context = clCreateContext(d3d11_props, 1, &_deviceId, createContextCallback, NULL, &_errorCode);
			break;
#elif defined(MACOSX)
		case OPENGL:
			_context = clCreateContext(opengl_props, 1, &_deviceId, NULL, NULL, &_errorCode);
			break;
#elif defined(LINUX)
		case OPENGL:
			_context = clCreateContext(opengl_props, 1, &_deviceId, NULL, NULL, &_errorCode);
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

	// Load camera parameters 
	bool OvrvisionProOpenCL::LoadCameraParams(const char *filename)
	{
		size_t origin[3] = { 0, 0, 0 };
		size_t region[3] = { _width, _height, 1 };
		OvrvisionSetting _settings(NULL);

		if (_settings.ReadEEPROM())
		{
			// Left camera
			_settings.GetUndistortionMatrix(OV_CAMEYE_LEFT, *_mapX[0], *_mapY[0], _width, _height);
			_errorCode = clEnqueueWriteImage(_commandQueue, _mx[0], CL_TRUE, origin, region, _width * sizeof(float), 0, _mapX[0]->ptr(0), 0, NULL, NULL);
			_errorCode = clEnqueueWriteImage(_commandQueue, _my[0], CL_TRUE, origin, region, _width * sizeof(float), 0, _mapY[0]->ptr(0), 0, NULL, NULL);
			SAMPLE_CHECK_ERRORS(_errorCode);

			// Right camera
			_settings.GetUndistortionMatrix(OV_CAMEYE_RIGHT, *_mapX[1], *_mapY[1], _width, _height);
			_errorCode = clEnqueueWriteImage(_commandQueue, _mx[1], CL_TRUE, origin, region, _width * sizeof(float), 0, _mapX[1]->ptr(0), 0, NULL, NULL);
			_errorCode = clEnqueueWriteImage(_commandQueue, _my[1], CL_TRUE, origin, region, _width * sizeof(float), 0, _mapY[1]->ptr(0), 0, NULL, NULL);
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
		ovrset->GetUndistortionMatrix(OV_CAMEYE_LEFT, *_mapX[0], *_mapY[0], _width, _height);
		_errorCode = clEnqueueWriteImage(_commandQueue, _mx[0], CL_TRUE, origin, region, _width * sizeof(float), 0, _mapX[0]->ptr(0), 0, NULL, NULL);
		_errorCode = clEnqueueWriteImage(_commandQueue, _my[0], CL_TRUE, origin, region, _width * sizeof(float), 0, _mapY[0]->ptr(0), 0, NULL, NULL);
		SAMPLE_CHECK_ERRORS(_errorCode);

		// Right camera
		ovrset->GetUndistortionMatrix(OV_CAMEYE_RIGHT, *_mapX[1], *_mapY[1], _width, _height);
		_errorCode = clEnqueueWriteImage(_commandQueue, _mx[1], CL_TRUE, origin, region, _width * sizeof(float), 0, _mapX[1]->ptr(0), 0, NULL, NULL);
		_errorCode = clEnqueueWriteImage(_commandQueue, _my[1], CL_TRUE, origin, region, _width * sizeof(float), 0, _mapY[1]->ptr(0), 0, NULL, NULL);
		SAMPLE_CHECK_ERRORS(_errorCode);

		_remapAvailable = true;
		return true;
	}
#pragma endregion

#pragma region TEXTURE_SHARING
	// Prepare for OpenGL/D3D texture sharing
	bool OvrvisionProOpenCL::Prepare4Sharing()
	{
		DeviceExtensions();
#ifdef WIN32
		if (strstr(_deviceExtensions, "cl_nv_d3d11_sharing"))
		{
			_vendorD3D11 = NVIDIA;
			pclGetDeviceIDsFromD3D11NV = GETFUNCTION(_platformId, clGetDeviceIDsFromD3D11NV);
			pclCreateFromD3D11BufferNV = GETFUNCTION(_platformId, clCreateFromD3D11BufferNV);
			pclCreateFromD3D11Texture2DNV = GETFUNCTION(_platformId, clCreateFromD3D11Texture2DNV);
			pclCreateFromD3D11Texture3DNV = GETFUNCTION(_platformId, clCreateFromD3D11Texture3DNV);
			pclEnqueueAcquireD3D11ObjectsNV = GETFUNCTION(_platformId, clEnqueueAcquireD3D11ObjectsNV);
			pclEnqueueReleaseD3D11ObjectsNV = GETFUNCTION(_platformId, clEnqueueReleaseD3D11ObjectsNV);
			if (pclCreateFromD3D11Texture2DNV != NULL)
				return true;
		}
		else if (strstr(_deviceExtensions, "cl_khr_d3d11_sharing"))
		{
			_vendorD3D11 = KHRONOS;
			pclGetDeviceIDsFromD3D11KHR = GETFUNCTION(_platformId, clGetDeviceIDsFromD3D11KHR);
			pclCreateFromD3D11BufferKHR = GETFUNCTION(_platformId, clCreateFromD3D11BufferKHR);
			pclCreateFromD3D11Texture2DKHR = GETFUNCTION(_platformId, clCreateFromD3D11Texture2DKHR);
			pclCreateFromD3D11Texture3DKHR = GETFUNCTION(_platformId, clCreateFromD3D11Texture3DKHR);
			pclEnqueueAcquireD3D11ObjectsKHR = GETFUNCTION(_platformId, clEnqueueAcquireD3D11ObjectsKHR);
			pclEnqueueReleaseD3D11ObjectsKHR = GETFUNCTION(_platformId, clEnqueueReleaseD3D11ObjectsKHR);
			if (pclCreateFromD3D11Texture2DKHR != NULL)
				return true;
		}
		return false;
#else
        return false;
#endif
	}

	// Create textures
	void OvrvisionProOpenCL::CreateSkinTextures(int width, int height, TEXTURE left, TEXTURE right)
	{
		switch (_sharing)
		{
		case OPENGL:
			_texture[0] = CreateGLTexture2D((GLuint)left, width, height);
			_texture[1] = CreateGLTexture2D((GLuint)right, width, height);
			break;
#if	defined(WIN32)
		case D3D11:
			_texture[0] = CreateD3DTexture2D((ID3D11Texture2D *)left, width, height);
			_texture[1] = CreateD3DTexture2D((ID3D11Texture2D *)right, width, height);
			break;
#endif
		}
	}

	// Update textures
	void OvrvisionProOpenCL::UpdateSkinTextures(TEXTURE left, TEXTURE right)
	{
		cl_event event[2];

#if defined(WIN32)
		if (_sharing == OPENGL)
		{	//	glFinish(); // depend on mode
			_errorCode = clEnqueueAcquireGLObjects(_commandQueue, 2, _texture, 0, NULL, NULL);
			SAMPLE_CHECK_ERRORS(_errorCode);
			SkinImages(_texture[0], _texture[1], &event[0], &event[1]);
			_errorCode = clEnqueueReleaseGLObjects(_commandQueue, 2, _texture, 2, event, NULL);
			SAMPLE_CHECK_ERRORS(_errorCode);
			_errorCode = clFinish(_commandQueue);	// NVIDIA has not cl_khr_gl_event
			SAMPLE_CHECK_ERRORS(_errorCode);
		}
		else if (_sharing == D3D11)
		{
			if (_vendorD3D11 == NVIDIA)
			{
				_errorCode = pclEnqueueAcquireD3D11ObjectsNV(_commandQueue, 2, _texture, 0, NULL, NULL);
				SAMPLE_CHECK_ERRORS(_errorCode);
				SkinImages(_texture[0], _texture[1], &event[0], &event[1]);
				_errorCode = pclEnqueueReleaseD3D11ObjectsNV(_commandQueue, 2, _texture, 2, event, NULL);
				SAMPLE_CHECK_ERRORS(_errorCode);
				_errorCode = clFinish(_commandQueue);	// NVIDIA has not cl_khr_gl_event
				SAMPLE_CHECK_ERRORS(_errorCode);
			}
			else
			{
				_errorCode = pclEnqueueAcquireD3D11ObjectsKHR(_commandQueue, 2, _texture, 0, NULL, NULL);
				SAMPLE_CHECK_ERRORS(_errorCode);
				SkinImages(_texture[0], _texture[1], &event[0], &event[1]);
				_errorCode = pclEnqueueReleaseD3D11ObjectsKHR(_commandQueue, 2, _texture, 2, event, NULL);
				SAMPLE_CHECK_ERRORS(_errorCode);
				_errorCode = clFinish(_commandQueue);	// NVIDIA has not cl_khr_gl_event
				SAMPLE_CHECK_ERRORS(_errorCode)
			}
		}
#elif defined(LINUX)
		if (_sharing == OPENGL)
		{	//	glFinish(); // depend on mode
			_errorCode = clEnqueueAcquireGLObjects(_commandQueue, 2, _texture, 0, NULL, NULL);
			SAMPLE_CHECK_ERRORS(_errorCode);
			SkinImages(_texture[0], _texture[1], &event[0], &event[1]);
			_errorCode = clEnqueueReleaseGLObjects(_commandQueue, 2, _texture, 2, event, NULL);
			SAMPLE_CHECK_ERRORS(_errorCode);
			_errorCode = clFinish(_commandQueue);	// NVIDIA has not cl_khr_gl_event
			SAMPLE_CHECK_ERRORS(_errorCode);
		}
#elif defined(MACOSX)
		if (_sharing == OPENGL)
		{
			glFlushRenderAPPLE();// depend on mode
			SkinImages(_texture[0], _texture[1], &event[0], &event[1]);
			_errorCode = clFinish(_commandQueue);
			SAMPLE_CHECK_ERRORS(_errorCode);
		}
#endif
		// Release temporaries
		clReleaseEvent(event[0]);
		clReleaseEvent(event[1]);
	}

	// Update textures
	void OvrvisionProOpenCL::UpdateImageTextures(TEXTURE left, TEXTURE right)
	{
		cl_event event[2];
#ifdef WIN32
		if (_sharing == OPENGL)
		{	//	glFinish(); // depend on mode
			_errorCode = clEnqueueAcquireGLObjects(_commandQueue, 2, _texture, 0, NULL, NULL);
			SAMPLE_CHECK_ERRORS(_errorCode);

			// Copy to texture
			CopyImage(_texture[0], _texture[1], &event[0], &event[1]);

			_errorCode = clEnqueueReleaseGLObjects(_commandQueue, 2, _texture, 2, event, NULL);
			SAMPLE_CHECK_ERRORS(_errorCode);
			_errorCode = clFinish(_commandQueue);	// NVIDIA has not cl_khr_gl_event
			SAMPLE_CHECK_ERRORS(_errorCode);
		}
		else if (_sharing == D3D11)
		{
			if (_vendorD3D11 == NVIDIA)
			{
				_errorCode = pclEnqueueAcquireD3D11ObjectsNV(_commandQueue, 2, _texture, 0, NULL, NULL);
				SAMPLE_CHECK_ERRORS(_errorCode);

				// Copy to texture
				CopyImage(_texture[0], _texture[1], &event[0], &event[1]);

				_errorCode = pclEnqueueReleaseD3D11ObjectsNV(_commandQueue, 2, _texture, 2, event, NULL);
				SAMPLE_CHECK_ERRORS(_errorCode);
				_errorCode = clFinish(_commandQueue);	// NVIDIA has not cl_khr_gl_event
				SAMPLE_CHECK_ERRORS(_errorCode);
			}
			else
			{
				_errorCode = pclEnqueueAcquireD3D11ObjectsKHR(_commandQueue, 2, _texture, 0, NULL, NULL);
				SAMPLE_CHECK_ERRORS(_errorCode);

				CopyImage(_texture[0], _texture[1], &event[0], &event[1]);

				_errorCode = pclEnqueueReleaseD3D11ObjectsKHR(_commandQueue, 2, _texture, 2, event, NULL);
				SAMPLE_CHECK_ERRORS(_errorCode);
				_errorCode = clFinish(_commandQueue);	// NVIDIA has not cl_khr_gl_event
				SAMPLE_CHECK_ERRORS(_errorCode)
			}
		}
#elif defined(LINUX)
		if (_sharing == OPENGL)
		{	//	glFinish(); // depend on mode
			_errorCode = clEnqueueAcquireGLObjects(_commandQueue, 2, _texture, 0, NULL, NULL);
			SAMPLE_CHECK_ERRORS(_errorCode);

			// Copy to texture
			CopyImage(_texture[0], _texture[1], &event[0], &event[1]);

			_errorCode = clEnqueueReleaseGLObjects(_commandQueue, 2, _texture, 2, event, NULL);
			SAMPLE_CHECK_ERRORS(_errorCode);
			_errorCode = clFinish(_commandQueue);	// NVIDIA has not cl_khr_gl_event
			SAMPLE_CHECK_ERRORS(_errorCode);
		}
#elif defined(MACOSX)
		if (_sharing == OPENGL)
		{	//	glFinish(); // depend on mode
			_errorCode = clEnqueueAcquireGLObjects(_commandQueue, 2, _texture, 0, NULL, NULL);
			SAMPLE_CHECK_ERRORS(_errorCode);

			// Copy to texture
			CopyImage(_texture[0], _texture[1], &event[0], &event[1]);

			_errorCode = clEnqueueReleaseGLObjects(_commandQueue, 2, _texture, 2, event, NULL);
			SAMPLE_CHECK_ERRORS(_errorCode);
			_errorCode = clFinish(_commandQueue);	// cl_APPLE_gl_event
			SAMPLE_CHECK_ERRORS(_errorCode);
		}
#endif
		// Release temporaries
		clReleaseEvent(event[0]);
		clReleaseEvent(event[1]);
	}

	// Inspact textures
	void OvrvisionProOpenCL::InspectTextures(uchar* left, uchar *right, uint type)
	{
		uint width = _scaledRegion[0];
		uint height = _scaledRegion[1];
		cl_int status;
		cl_event event[2];
		size_t origin[3] = { 0, 0, 0 };
		if (type == 2)
		{
			// Read result
			_errorCode = clEnqueueReadImage(_commandQueue, _L, CL_TRUE, origin, _scaledRegion, width * sizeof(uchar) * 4, 0, left, 0, NULL, NULL);
			_errorCode = clEnqueueReadImage(_commandQueue, _R, CL_TRUE, origin, _scaledRegion, width * sizeof(uchar) * 4, 0, right, 0, NULL, NULL);
		}
		else if (type == 1)
		{
			// Read result
			_errorCode = clEnqueueReadImage(_commandQueue, _reducedL, CL_TRUE, origin, _scaledRegion, width * sizeof(uchar) * 4, 0, left, 0, NULL, NULL);
			_errorCode = clEnqueueReadImage(_commandQueue, _reducedR, CL_TRUE, origin, _scaledRegion, width * sizeof(uchar) * 4, 0, right, 0, NULL, NULL);
		}
		else if (type == 3)
		{
#ifdef WIN32
			if (_sharing == D3D11)
			{
				if (_vendorD3D11 == NVIDIA)
				{
					_errorCode = pclEnqueueAcquireD3D11ObjectsNV(_commandQueue, 2, _texture, 0, NULL, NULL);
					SAMPLE_CHECK_ERRORS(_errorCode);
					_errorCode = clEnqueueReadImage(_commandQueue, _texture[0], CL_TRUE, origin, _scaledRegion, width * sizeof(uchar) * 4, 0, left, 0, NULL, &event[0]);
					clGetEventInfo(event[0], CL_EVENT_COMMAND_EXECUTION_STATUS, sizeof(status), &status, NULL);
					_errorCode = clEnqueueReadImage(_commandQueue, _texture[1], CL_TRUE, origin, _scaledRegion, width * sizeof(uchar) * 4, 0, right, 0, NULL, &event[1]);
					clGetEventInfo(event[0], CL_EVENT_COMMAND_EXECUTION_STATUS, sizeof(status), &status, NULL);
					_errorCode = pclEnqueueReleaseD3D11ObjectsNV(_commandQueue, 2, _texture, 2, event, NULL);
					SAMPLE_CHECK_ERRORS(_errorCode);
				}
				else
				{
					_errorCode = pclEnqueueAcquireD3D11ObjectsKHR(_commandQueue, 2, _texture, 0, NULL, NULL);
					SAMPLE_CHECK_ERRORS(_errorCode);
					_errorCode = clEnqueueReadImage(_commandQueue, _texture[0], CL_TRUE, origin, _scaledRegion, width * sizeof(uchar) * 4, 0, left, 0, NULL, &event[0]);
					clGetEventInfo(event[0], CL_EVENT_COMMAND_EXECUTION_STATUS, sizeof(status), &status, NULL);
					_errorCode = clEnqueueReadImage(_commandQueue, _texture[1], CL_TRUE, origin, _scaledRegion, width * sizeof(uchar) * 4, 0, right, 0, NULL, &event[1]);
					clGetEventInfo(event[0], CL_EVENT_COMMAND_EXECUTION_STATUS, sizeof(status), &status, NULL);
					_errorCode = pclEnqueueReleaseD3D11ObjectsKHR(_commandQueue, 2, _texture, 2, event, NULL);
					SAMPLE_CHECK_ERRORS(_errorCode);
				}
			}
			else
			{
				_errorCode = clEnqueueAcquireGLObjects(_commandQueue, 2, _texture, 0, NULL, NULL);
				SAMPLE_CHECK_ERRORS(_errorCode);
				_errorCode = clEnqueueReadImage(_commandQueue, _texture[0], CL_TRUE, origin, _scaledRegion, width * sizeof(uchar) * 4, 0, left, 0, NULL, &event[0]);
				clGetEventInfo(event[0], CL_EVENT_COMMAND_EXECUTION_STATUS, sizeof(status), &status, NULL);
				_errorCode = clEnqueueReadImage(_commandQueue, _texture[1], CL_TRUE, origin, _scaledRegion, width * sizeof(uchar) * 4, 0, right, 0, NULL, &event[1]);
				clGetEventInfo(event[0], CL_EVENT_COMMAND_EXECUTION_STATUS, sizeof(status), &status, NULL);
				_errorCode = clEnqueueReleaseGLObjects(_commandQueue, 2, _texture, 2, event, NULL);
				SAMPLE_CHECK_ERRORS(_errorCode);
			}
			// Release temporaries
			clReleaseEvent(event[0]);
			clReleaseEvent(event[1]);
#endif
		}
		else
		{
			origin[0] += _width / 4;
			origin[1] += _height / 4;
			_errorCode = clEnqueueReadImage(_commandQueue, _l, CL_TRUE, origin, _scaledRegion, width * sizeof(uchar) * 4, 0, left, 0, NULL, NULL);
			_errorCode = clEnqueueReadImage(_commandQueue, _r, CL_TRUE, origin, _scaledRegion, width * sizeof(uchar) * 4, 0, right, 0, NULL, NULL);
		}
	}

//#if defined(WIN32) || defined(LINUX) || defined(MACOSX)
	// OpenGL shared texture
	// Reference: http://www.isus.jp/article/idz/vc/sharing-surfaces-between-opencl-and-opengl43/
	cl_mem OvrvisionProOpenCL::CreateGLTexture2D(GLuint texture, int width, int height)
	{
		cl_mem image;

		/*
		glBindTexture(GL_TEXTURE_2D, texture);
		glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA8, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, NULL);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
		glBindTexture(GL_TEXTURE_2D, 0);
		glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_REPLACE);
		*/

		// Attension: 
		// ****************************************************************
		//	OpenGL Internal format is CL_UNORM_INT8, not CL_UNSIGNED_INT8!
		// ****************************************************************
		image = clCreateFromGLTexture(_context, CL_MEM_WRITE_ONLY, GL_TEXTURE_2D, 0, texture, &_errorCode);

		SAMPLE_CHECK_ERRORS(_errorCode);
#ifdef _DEBUG
		size_t w, h, s;
		cl_image_format format;
		clGetImageInfo(image, CL_IMAGE_WIDTH, sizeof(w), &w, NULL);
		clGetImageInfo(image, CL_IMAGE_HEIGHT, sizeof(h), &h, NULL);
		clGetImageInfo(image, CL_IMAGE_ELEMENT_SIZE, sizeof(s), &s, NULL);
		clGetImageInfo(image, CL_IMAGE_FORMAT, sizeof(format), &format, NULL);
#endif
		return image;
	}
//#endif


#ifdef WIN32
	// TODO: Direct3D shared texture
	cl_mem OvrvisionProOpenCL::CreateD3DTexture2D(ID3D11Texture2D *texture, int width, int height)
	{
		/* Desciptor of texture must be R8B8G8A8_UINT format
		D3D11_TEXTURE2D_DESC texsture_desc = {
			width,				// Width
			height,				// Height
			1,								// MipLevels
			1,								// ArraySize
			DXGI_FORMAT_R8G8B8A8_UINT,	// Format
			{ 1 },							// SampleDesc.Count
			D3D11_USAGE_DEFAULT,			// Usage
		};
		*/
		if (_vendorD3D11 == NVIDIA)
		{
			return pclCreateFromD3D11Texture2DNV(_context, CL_MEM_WRITE_ONLY, texture, 0, &_errorCode);
		}
		else
		{
			return pclCreateFromD3D11Texture2DKHR(_context, CL_MEM_WRITE_ONLY, texture, 0, &_errorCode);
		}
	}
#endif
#pragma endregion

#pragma region SKIN_COLOR_EXTRACTION
	// Set Threshold
	int OvrvisionProOpenCL::SetThreshold(int threshold)
	{
		int previous = _skinThreshold;
		if (threshold < 256)
			_skinThreshold = threshold;
		return previous;
	}

	// Get Skin images
	void OvrvisionProOpenCL::SkinImages(cl_mem left, cl_mem right, cl_event *event_l, cl_event *event_r)
	{
		//int width = _scaledRegion[0];
		//int height = _scaledRegion[1];
		size_t origin[3] = { 0, 0, 0 };
		cl_mem mask[2];
		cl_event event[2];

		// Allocate mask
		mask[0] = clCreateImage(_context, CL_MEM_READ_WRITE, &_format8UC1, &_desc_scaled, 0, &_errorCode);
		SAMPLE_CHECK_ERRORS(_errorCode);
		mask[1] = clCreateImage(_context, CL_MEM_READ_WRITE, &_format8UC1, &_desc_scaled, 0, &_errorCode);
		SAMPLE_CHECK_ERRORS(_errorCode);

		// Create mask of skin color region
#if 1
		SkinRegion(mask[0], mask[1], &event[0], &event[1]);
#else
		SkinRegion(_skinmask[0]->data, _skinmask[1]->data, scaling);

		// TODO: Noise reduction filtering here on mask image
#		pragma omp parallel for
		for (int eyes = 0; eyes < 2; eyes++)
		{
			std::vector<std::vector<Point>> contours;
			std::vector<Vec4i> hierarchy;

			findContours(*_skinmask[eyes], contours, RETR_LIST, CHAIN_APPROX_SIMPLE);
			for (uint i = 0; i < contours.size(); i++)
			{
				vector<Point> contour = contours[i];
				try {
					if (200 < contours[i].size())
					{
						//drawContours(results[eyes], contours, i, Scalar(255, 255, 255), 1, 8);
					}
					else
					{
						std::vector<std::vector<Point>> erase;
						erase.push_back(contour);
						fillPoly(*_skinmask[eyes], erase, Scalar::all(64), 4);
					}
				}
				catch (std::exception ex)
				{
					puts(ex.what());
				}
			}
		}

		// write back to GPU
		//cl_event writeEvent;
		_errorCode = clEnqueueWriteImage(_commandQueue, mask[0], CL_TRUE, origin, _scaledRegion, width * sizeof(uchar), 0, _skinmask[0]->data, 0, NULL, &event[0]);
		SAMPLE_CHECK_ERRORS(_errorCode);
		_errorCode = clEnqueueWriteImage(_commandQueue, mask[1], CL_TRUE, origin, _scaledRegion, width * sizeof(uchar), 0, _skinmask[1]->data, 0, NULL, &event[0]);
		SAMPLE_CHECK_ERRORS(_errorCode);
#endif

		//__kernel void mask( 
		//		__read_only image2d_t src,	// CL_UNSIGNED_INT8 x 4
		//		__write_only image2d_t dst,	// CL_UNSIGNED_INT8 x 4
		//		__read_only image2d_t mask,	// CL_UNSIGNED_INT8
		//		__read_only int threshold)	//

		//__kernel void mask_opengl(
		//		__read_only image2d_t src,	// CL_UNSIGNED_INT8 x 4
		//		__write_only image2d_t dst,	// CL_UNORM_INT8 x 4	<- DIFFERENT FORMAT
		//		__read_only image2d_t mask,	// CL_UNSIGNED_INT8
		//		__read_only int threshold)	// 

		//__kernel void mask_d3d11( 
		//		__read_only image2d_t src,	// CL_UNSIGNED_INT8 x 4
		//		__write_only image2d_t dst,	// CL_UNORM_INT8 x 4	<- DIFFERENT FORMAT
		//		__read_only image2d_t mask,	// CL_UNSIGNED_INT8
		//		__read_only int threshold)	// 

		// Check destination image format 
		cl_image_format format;
		clGetImageInfo(left, CL_IMAGE_FORMAT, sizeof(format), &format, NULL);

		if (_sharing == OPENGL)
		{
			// OpenGL channel order == RGBA, and dataType == UNORM_INT8 
			clSetKernelArg(_maskOpengl, 0, sizeof(cl_mem), &_reducedL);
			clSetKernelArg(_maskOpengl, 1, sizeof(cl_mem), &left);
			clSetKernelArg(_maskOpengl, 2, sizeof(cl_mem), &mask[0]);
			clSetKernelArg(_maskOpengl, 3, sizeof(int), &_skinThreshold);
			_errorCode = clEnqueueNDRangeKernel(_commandQueue, _maskOpengl, 2, NULL, _scaledRegion, NULL, 1, &event[0], event_l);
			SAMPLE_CHECK_ERRORS(_errorCode);
			clSetKernelArg(_maskOpengl, 0, sizeof(cl_mem), &_reducedR);
			clSetKernelArg(_maskOpengl, 1, sizeof(cl_mem), &right);
			clSetKernelArg(_maskOpengl, 2, sizeof(cl_mem), &mask[1]);
			clSetKernelArg(_maskOpengl, 3, sizeof(int), &_skinThreshold);
			_errorCode = clEnqueueNDRangeKernel(_commandQueue, _maskOpengl, 2, NULL, _scaledRegion, NULL, 1, &event[1], event_r);
			SAMPLE_CHECK_ERRORS(_errorCode);
		}
		else if (format.image_channel_data_type == CL_UNORM_INT8)
		{
			// dataType == UNORM_INT8 for D3D11 pixel shader
			clSetKernelArg(_maskD3D11, 0, sizeof(cl_mem), &_reducedL);
			clSetKernelArg(_maskD3D11, 1, sizeof(cl_mem), &left);
			clSetKernelArg(_maskD3D11, 2, sizeof(cl_mem), &mask[0]);
			clSetKernelArg(_maskD3D11, 3, sizeof(int), &_skinThreshold);
			_errorCode = clEnqueueNDRangeKernel(_commandQueue, _maskD3D11, 2, NULL, _scaledRegion, NULL, 1, &event[0], event_l);
			SAMPLE_CHECK_ERRORS(_errorCode);
			clSetKernelArg(_maskD3D11, 0, sizeof(cl_mem), &_reducedR);
			clSetKernelArg(_maskD3D11, 1, sizeof(cl_mem), &right);
			clSetKernelArg(_maskD3D11, 2, sizeof(cl_mem), &mask[1]);
			clSetKernelArg(_maskD3D11, 3, sizeof(int), &_skinThreshold);
			_errorCode = clEnqueueNDRangeKernel(_commandQueue, _maskD3D11, 2, NULL, _scaledRegion, NULL, 1, &event[1], event_r);
			SAMPLE_CHECK_ERRORS(_errorCode);
		}
		else // dataType == UNSIGNED_INT8
		{
			clSetKernelArg(_mask, 0, sizeof(cl_mem), &_reducedL);
			clSetKernelArg(_mask, 1, sizeof(cl_mem), &left);
			clSetKernelArg(_mask, 2, sizeof(cl_mem), &mask[0]);
			clSetKernelArg(_mask, 3, sizeof(int), &_skinThreshold);
			_errorCode = clEnqueueNDRangeKernel(_commandQueue, _mask, 2, NULL, _scaledRegion, NULL, 1, &event[0], event_l);
			SAMPLE_CHECK_ERRORS(_errorCode);
			clSetKernelArg(_mask, 0, sizeof(cl_mem), &_reducedR);
			clSetKernelArg(_mask, 1, sizeof(cl_mem), &right);
			clSetKernelArg(_mask, 2, sizeof(cl_mem), &mask[1]);
			clSetKernelArg(_mask, 3, sizeof(int), &_skinThreshold);
			_errorCode = clEnqueueNDRangeKernel(_commandQueue, _mask, 2, NULL, _scaledRegion, NULL, 1, &event[1], event_r);
			SAMPLE_CHECK_ERRORS(_errorCode);
		}

		// Release temporaries
		clReleaseEvent(event[0]);
		clReleaseEvent(event[1]);
		clReleaseMemObject(mask[0]);
		clReleaseMemObject(mask[1]);
	}

	//
	void OvrvisionProOpenCL::CopyImage(cl_mem left, cl_mem right, cl_event *event_l, cl_event *event_r)
	{
		size_t width = _scaledRegion[0];
		size_t height = _scaledRegion[1];
		size_t origin[3] = { 0, 0, 0 };
		size_t region[3] = { width, height, 1 };

		//cl_event event[2];
		cl_image_format format;
		clGetImageInfo(left, CL_IMAGE_FORMAT, sizeof(format), &format, NULL);

		//__kernel void copy_opengl( 
		//		__read_only image2d_t src,	// CL_UNSIGNED_INT8 x 4
		//		__write_only image2d_t dst)	// CL_UNORM_INT8 x 4

		if (format.image_channel_data_type == CL_UNORM_INT8)
		{
			// dataType == UNORM_INT8 for D3D11 pixel shader
			_errorCode = clSetKernelArg(_copyOpengl, 0, sizeof(cl_mem), &_reducedL);
			_errorCode = clSetKernelArg(_copyOpengl, 1, sizeof(cl_mem), &left);
			_errorCode = clEnqueueNDRangeKernel(_commandQueue, _copyOpengl, 2, NULL, _scaledRegion, NULL, 0, NULL, event_l);
			SAMPLE_CHECK_ERRORS(_errorCode);
			clSetKernelArg(_copyOpengl, 0, sizeof(cl_mem), &_reducedR);
			clSetKernelArg(_copyOpengl, 1, sizeof(cl_mem), &right);
			_errorCode = clEnqueueNDRangeKernel(_commandQueue, _copyOpengl, 2, NULL, _scaledRegion, NULL, 0, NULL, event_r);
			SAMPLE_CHECK_ERRORS(_errorCode);
		}
		else // dataType == UNSIGNED_INT8
		{
			_errorCode = clEnqueueCopyImage(_commandQueue, _reducedL, left, origin, origin, region, NULL, NULL, event_l);
			SAMPLE_CHECK_ERRORS(_errorCode);
			_errorCode = clEnqueueCopyImage(_commandQueue, _reducedR, right, origin, origin, region, NULL, NULL, event_r);
			SAMPLE_CHECK_ERRORS(_errorCode);
		}

		// Release temporaries
		//clReleaseEvent(event[0]);
		//clReleaseEvent(event[1]);
	}

	//
	void OvrvisionProOpenCL::SkinImages(uchar *left, uchar *right)
	{
		uint width = _scaledRegion[0];
		uint height = _scaledRegion[1];
		size_t origin[3] = { 0, 0, 0 };
		cl_event event_l, event_r, event[2];

		cl_mem l = clCreateImage(_context, CL_MEM_READ_WRITE, &_format8UC4, &_desc_scaled, 0, &_errorCode);
		SAMPLE_CHECK_ERRORS(_errorCode);
		cl_mem r = clCreateImage(_context, CL_MEM_READ_WRITE, &_format8UC4, &_desc_scaled, 0, &_errorCode);
		SAMPLE_CHECK_ERRORS(_errorCode);

		SkinImages(l, r, &event_l, &event_r);

		// Read result
		_errorCode = clEnqueueReadImage(_commandQueue, l, CL_TRUE, origin, _scaledRegion, width * sizeof(uchar) * 4, 0, left, 1, &event_l, &event[0]);
		_errorCode = clEnqueueReadImage(_commandQueue, r, CL_TRUE, origin, _scaledRegion, width * sizeof(uchar) * 4, 0, right, 1, &event_r, &event[1]);
		clWaitForEvents(2, event);

		// Release temporaries
		clReleaseEvent(event_l);
		clReleaseEvent(event_r);
		clReleaseEvent(event[0]);
		clReleaseEvent(event[1]);
		clReleaseMemObject(l);
		clReleaseMemObject(r);
	}

	// 
	void OvrvisionProOpenCL::StartCalibration(int frames)
	{
		_calibration = true;
		_frameCounter = frames;
		_histgram[0]->setTo(Scalar(0));
		_histgram[1]->setTo(Scalar(0));
	}

	// Enamerate colors in HS space
	bool OvrvisionProOpenCL::EnumHS(Mat &result_l, Mat &result_r)
	{
		bool detect = false;
		uint width = _scaledRegion[0];
		uint height = _scaledRegion[1];
		Mat separate[2][4];
		Mat bilevel[2], work[2];
		Mat HSV[2];
		Mat *result[2] = { &result_l, &result_r };
		HSV[0].create(height, width, CV_8UC4);
		HSV[1].create(height, width, CV_8UC4);
		bilevel[0].create(height, width, CV_8UC1);
		bilevel[1].create(height, width, CV_8UC1);
		work[0].create(height, width, CV_8UC1);
		work[1].create(height, width, CV_8UC1);
		GetHSV(HSV[0].data, HSV[1].data);

#		pragma omp parallel for
		for (int eye = 0; eye < 2; eye++)
		{
			std::vector<Vec4i> hierarchy;
			std::vector<std::vector<Point> > contours;

			split(HSV[eye], separate[eye]);
			threshold(separate[eye][0], bilevel[eye], 30, 255, CV_THRESH_BINARY_INV);	// Red part
			threshold(separate[eye][1], work[eye], 80, 255, CV_THRESH_BINARY);		// High saturation part
			multiply(bilevel[eye], work[eye], bilevel[eye]);
			Canny(bilevel[eye], bilevel[eye], 60, 200);
			findContours(bilevel[eye], contours, hierarchy, RETR_TREE, CHAIN_APPROX_SIMPLE);

			// Detect fingers
			for (uint i = 0; i < contours.size(); i++)
			{
				int finger = 0; // number of finger
				std::vector<Point> contour = contours[i];
				if (200 < contour.size() && hierarchy[i][3] == -1)
				{
					Rect bound = boundingRect(contour);
					// ConvexHull
					std::vector<int> convex;
					std::vector<Vec4i> defects;
					convexHull(contour, convex, true);

					// Mass center
					Moments moment;
					moment = moments(contour);
					if (0 < moment.m00)
					{
						double mc[2] = { (moment.m10 / moment.m00), (moment.m01 / moment.m00) };
						Vec4b center = HSV[eye].at<Vec4b>((int)mc[1], (int)mc[0]);
						if (0 <= center[0] && center[0] <= 30 && _s_low <= center[1] && center[1] <= _s_high)
						{
							finger++;
						}
					}

					convexityDefects(contour, convex, defects);
					for (uint defect = 0; defect < defects.size(); defect++)
					{
						int startIdx = defects[defect][0];
						int endIdx = defects[defect][1];
						int farIdx = defects[defect][2];
						int tmp = defects[defect][3];
						float depth = (float)(defects[defect][3] / 256);
						int e = defects[defect][3] & 0xFF;
						if (80 < depth)
						{
							finger++;
						}
					}
					
					// Make histgram of HS values
					if (4 < finger)
					{
						detect = true;
						for (int y = bound.y; y < bound.y + bound.height; y++)
						{
							Vec4b *row = HSV[eye].ptr<Vec4b>(y);
							for (int x = bound.x; x < bound.x + bound.width; x++)
							{
								int h, s, *hs;
								try {
									h = row[x][0];
									s = row[x][1];
									if (0 < h && h < 30 && 0 < s)
									{
										hs = _histgram[eye]->ptr<int>(h);
										hs[s]++;
									}
								}
								catch (Exception ex)
								{
									puts(ex.msg.c_str());
								}
							}
						}

						drawContours(*result[eye], contours, i, Scalar::all(255), 2);
						Point next, prev = contour[convex[convex.size() - 1]];
						for (size_t j = 0; j < convex.size(); j++)
						{
							next = contour[convex[j]];
							line(*result[eye], prev, next, Scalar::all(255), 1);
							prev = next;
						}
						for (uint defect = 0; defect < defects.size(); defect++)
						{
							int startIdx = defects[defect][0];
							int endIdx = defects[defect][1];
							int farIdx = defects[defect][2];
							int tmp = defects[defect][3];
							float depth = (float)(defects[defect][3] / 256);
							int e = defects[defect][3] & 0xFF;
							if (80 < depth)
							{
								//line(*result[eye], contour[startIdx], contour[farIdx], Scalar(0, 0, 255), 1);
								//line(*result[eye], contour[endIdx], contour[farIdx], Scalar(0, 0, 255), 1);
								//circle(*result[eye], contour[startIdx], 3, Scalar(0, 0, 255), 1);
							}
						}
					}
				}
			}
		}
		return detect;
	}

	//
	void OvrvisionProOpenCL::EstimateColorRange()
	{
		Mat sum(256, 256, CV_32SC1);
		Mat normalized(256, 256, CV_8UC1);

		add(*_histgram[0], *_histgram[1], sum);
		cv::normalize(sum, normalized, 0, 255, NORM_MINMAX, normalized.type());
		medianBlur(normalized, normalized, 3);

		// Estimate color range in HS space
		double maxVal;
		Point maxLoc;
		cv::minMaxLoc(normalized, NULL, &maxVal, NULL, &maxLoc);
		int hLow, hHigh, sLow, sHigh;
		// H range
		for (int i = maxLoc.y; 0 < i; i--)
		{
			uchar h = normalized.at<uchar>(i, maxLoc.x);
			if (h < 8) // 5 %
			{
				hLow = i;
				break;
			}
		}
		for (int i = maxLoc.y; i < 180; i++)
		{
			uchar h = normalized.at<uchar>(i, maxLoc.x);
			if (h < 8)
			{
				hHigh = i;
				break;
			}
		}
		// S range
		for (int i = maxLoc.x; 0 < i; i--)
		{
			uchar s = normalized.at<uchar>(maxLoc.y, i);
			if (s < 8)
			{
				sLow = i;
				break;
			}
		}
		for (int i = maxLoc.x; i < 256; i++)
		{
			uchar s = normalized.at<uchar>(maxLoc.y, i);
			if (s < 8)
			{
				sHigh = i;
				break;
			}
		}
		printf("H:%d S:%d count %f H{%d - %d} S{%d - %d}\n",
			maxLoc.y, maxLoc.x, maxVal, hLow, hHigh, sLow, sHigh);
		imwrite("histgram.png", normalized);
		SetHSV(hLow, hHigh, sLow, sHigh);
	}

	// Calibration
	bool OvrvisionProOpenCL::Read(uchar *left, uchar *right)
	{
		size_t origin[3] = { 0, 0, 0 };
		cl_event event[2];
		_errorCode = clEnqueueReadImage(_commandQueue, _reducedL, CL_TRUE, origin, _scaledRegion, _scaledRegion[0] * sizeof(uchar) * 4, 0, left, 0, NULL, &event[0]);
		SAMPLE_CHECK_ERRORS(_errorCode);
		_errorCode = clEnqueueReadImage(_commandQueue, _reducedR, CL_TRUE, origin, _scaledRegion, _scaledRegion[0] * sizeof(uchar) * 4, 0, right, 0, NULL, &event[1]);
		SAMPLE_CHECK_ERRORS(_errorCode);
		clWaitForEvents(2, event);

		// Release temporaries
		clReleaseEvent(event[0]);
		clReleaseEvent(event[1]);

		// Skin color calibration
		uint width = _scaledRegion[0];
		uint height = _scaledRegion[1];
		Mat _left(height, width, CV_8UC4, left);
		Mat _right(height, width, CV_8UC4, right);

#ifdef WIN32
#pragma warning(push)
#pragma warning(disable:4996)
#endif
		if (0 < _frameCounter)
		{
			char buffer[30];

			if (_calibration)
			{
				if (EnumHS(_left, _right))
				{
					_frameCounter--;
				}

				sprintf(buffer, COUNTDOWN_MESSAGE, _frameCounter);
				putText(_left, buffer, Point(0, height - 5), CV_FONT_HERSHEY_TRIPLEX, 0.7, Scalar(0, 0, 255), 1, CV_AA);
				putText(_right, buffer, Point(0, height - 5), CV_FONT_HERSHEY_TRIPLEX, 0.7, Scalar(0, 0, 255), 1, CV_AA);
				putText(_left, ESTIMATION_INSTRUCTION, Point(10, height / 2), CV_FONT_HERSHEY_TRIPLEX, 0.7, Scalar(0, 0, 255), 1, CV_AA);
				putText(_right, ESTIMATION_INSTRUCTION, Point(10, height / 2), CV_FONT_HERSHEY_TRIPLEX, 0.7, Scalar(0, 0, 255), 1, CV_AA);

				if (_frameCounter == 0)
				{
					_frameCounter = 15;
					_calibration = false;
					EstimateColorRange();
				}
			}
			else
			{
				_frameCounter--;
				sprintf(buffer, "H:%d - %d S:%d - %d", _h_low, _h_high, _s_low, _s_high);
				putText(_left, buffer, Point(0, height - 5), CV_FONT_HERSHEY_TRIPLEX, 1, Scalar(0, 0, 255));
				putText(_right, ESTIMATED_MESSAGE, Point(0, height - 5), CV_FONT_HERSHEY_TRIPLEX, 1, Scalar(0, 0, 255));
			}
			return false;
		}
		else
		{
			return true;
		}
#ifdef WIN32
#pragma warning(pop)
#endif
	}

	//
	void OvrvisionProOpenCL::SkinRegion(cl_mem left, cl_mem right, cl_event *event_l, cl_event *event_r)
	{
		uint width = _scaledRegion[0], height = _scaledRegion[1];
		size_t origin[3] = { 0, 0, 0 };
		size_t region[3] = { width, height, 1 };
		size_t size[] = { width, height };

		cl_event event[2];
		GetHSVBlur(_L, _R, &event[0], &event[1]);

		//int h_low = 13, h_high = 21;
		//int s_low = 88, s_high = 136;

		//__kernel void skincolor( 
		//		__read_only image2d_t src,	// CL_UNSIGNED_INT8 x 4
		//		__write_only image2d_t mask,// CL_UNSIGNED_INT8
		//		__read_only int h_low,		// 
		//		__read_only int h_hight,	// 
		//		__read_only int s_low,		// 
		//		__read_only int s_hight)	// 
		clSetKernelArg(_skincolor, 0, sizeof(cl_mem), &_L);
		clSetKernelArg(_skincolor, 1, sizeof(cl_mem), &left);
		clSetKernelArg(_skincolor, 2, sizeof(int), &_h_low);
		clSetKernelArg(_skincolor, 3, sizeof(int), &_h_high);
		clSetKernelArg(_skincolor, 4, sizeof(int), &_s_low);
		clSetKernelArg(_skincolor, 5, sizeof(int), &_s_high);
		_errorCode = clEnqueueNDRangeKernel(_commandQueue, _skincolor, 2, NULL, size, NULL, 1, &event[0], event_l);
		SAMPLE_CHECK_ERRORS(_errorCode);
		clSetKernelArg(_skincolor, 0, sizeof(cl_mem), &_R);
		clSetKernelArg(_skincolor, 1, sizeof(cl_mem), &right);
		clSetKernelArg(_skincolor, 2, sizeof(int), &_h_low);
		clSetKernelArg(_skincolor, 3, sizeof(int), &_h_high);
		clSetKernelArg(_skincolor, 4, sizeof(int), &_s_low);
		clSetKernelArg(_skincolor, 5, sizeof(int), &_s_high);
		_errorCode = clEnqueueNDRangeKernel(_commandQueue, _skincolor, 2, NULL, size, NULL, 1, &event[1], event_r);
		SAMPLE_CHECK_ERRORS(_errorCode);

		// Release temporaries
		clReleaseEvent(event[0]);
		clReleaseEvent(event[1]);
	}

	//
	void OvrvisionProOpenCL::SkinRegion(uchar *left, uchar *right)
	{
		cl_mem l, r;
		uint width = _scaledRegion[0], height = _scaledRegion[1];
		size_t origin[3] = { 0, 0, 0 };
		size_t region[3] = { width, height, 1 };

		l = clCreateImage(_context, CL_MEM_READ_WRITE, &_format8UC1, &_desc_scaled, 0, &_errorCode);
		SAMPLE_CHECK_ERRORS(_errorCode);
		r = clCreateImage(_context, CL_MEM_READ_WRITE, &_format8UC1, &_desc_scaled, 0, &_errorCode);
		SAMPLE_CHECK_ERRORS(_errorCode);
		cl_event event_l, event_r, event[2];

		SkinRegion(l, r, &event_l, &event_r);

		_errorCode = clEnqueueReadImage(_commandQueue, l, CL_TRUE, origin, region, width * sizeof(uchar), 0, left, 1, &event_l, &event[0]);
		SAMPLE_CHECK_ERRORS(_errorCode);
		_errorCode = clEnqueueReadImage(_commandQueue, r, CL_TRUE, origin, region, width * sizeof(uchar), 0, right, 1, &event_r, &event[1]);
		SAMPLE_CHECK_ERRORS(_errorCode);
		clWaitForEvents(2, event);

		// Release temporaries
		clReleaseEvent(event_l);
		clReleaseEvent(event_r);
		clReleaseEvent(event[0]);
		clReleaseEvent(event[1]);
		clReleaseMemObject(l);
		clReleaseMemObject(r);
	}
#pragma endregion

#pragma region FILTERS
	// Set scaling 
	Size OvrvisionProOpenCL::SetScale(SCALING scaling)
	{
		int scale;

		switch (scaling)
		{
		case EIGHTH:
			scale = 8;
			break;

		case FOURTH:
			scale = 4;
			break;

		case HALF:
		default:
			scale = 2;
			break;
		}
		_scaledRegion[0] = _width / scale;
		_scaledRegion[1] = _height / scale;
		_scaledRegion[2] = 1;
		//SCALING prev = _scaling;
		_scaling = scaling;
		_desc_scaled.image_type = CL_MEM_OBJECT_IMAGE2D;
		_desc_scaled.image_width = _scaledRegion[0];
		_desc_scaled.image_height = _scaledRegion[1];
		return Size(_scaledRegion[0], _scaledRegion[1]);
	}

	// Get size
	Size OvrvisionProOpenCL::GetScaledSize()
	{
		return Size(_scaledRegion[0], _scaledRegion[1]);
	}

	// Resize
	void OvrvisionProOpenCL::Resize(const cl_mem src, cl_mem dst, enum SCALING scaling, cl_event *execute)
	{
		size_t width, height;
		clGetImageInfo(src, CL_IMAGE_WIDTH, sizeof(width), &width, NULL);
		clGetImageInfo(src, CL_IMAGE_HEIGHT, sizeof(height), &height, NULL);

		int scale = 1;
		switch (scaling)
		{
		case ORIGINAL:
			scale = 1;
			break;

		case HALF:
			scale = 2;
			break;

		case FOURTH:
			scale = 4;
			break;

		case EIGHTH:
			scale = 8;
			break;
		}
		size_t region[3] = { width / scale, height / scale, 1 };
		size_t origin[3] = { 0, 0, 0 };

		//__kernel void resize(
		//		__read_only image2d_t src,	// CL_UNSIGNED_INT8 x 4
		//		__write_only image2d_t dst,	// CL_UNSIGNED_INT8 x 4
		//		__read_only int scale)		// 2, 4, 8

		clSetKernelArg(_resize, 0, sizeof(cl_mem), &src);
		clSetKernelArg(_resize, 1, sizeof(cl_mem), &dst);
		clSetKernelArg(_resize, 2, sizeof(int), &scale);
		_errorCode = clEnqueueNDRangeKernel(_commandQueue, _resize, 2, NULL, region, 0, 0, NULL, execute);
		SAMPLE_CHECK_ERRORS(_errorCode);
	}

	// Read images region of interest
	void OvrvisionProOpenCL::Read(uchar *left, uchar *right, int offsetX, int offsetY, uint width, uint height)
	{
		size_t origin[3] = { static_cast<size_t>(offsetX), static_cast<size_t>(offsetY), 0 };
		size_t region[3] = { width, height, 1 };
		cl_event event[2];

		if (left != NULL)
		{
			_errorCode = clEnqueueReadImage(_commandQueue, _l, CL_TRUE, origin, region, width * sizeof(uchar) * 4, 0, left, 0, NULL, &event[0]);
		}
		if (right != NULL)
		{
			_errorCode = clEnqueueReadImage(_commandQueue, _r, CL_TRUE, origin, region, width * sizeof(uchar) * 4, 0, right, 0, NULL, &event[1]);
		}
		clWaitForEvents(2, event);

		// Release temporaries
		clReleaseEvent(event[0]);
		clReleaseEvent(event[1]);
	}

	//
	void OvrvisionProOpenCL::Grayscale(cl_mem left, cl_mem right, enum SCALING scaling, cl_event *event_l, cl_event *event_r)
	{
		if (scaling == _scaling)
		{
			// Convert to HSV
			//__kernel void convertGrayscale( 
			//		__read_only image2d_t src,	// CL_UNSIGNED_INT8 x 4
			//		__write_only image2d_t dst)	// CL_UNSIGNED_INT8

			clSetKernelArg(_convertGrayscale, 0, sizeof(cl_mem), &_reducedL);
			clSetKernelArg(_convertGrayscale, 1, sizeof(cl_mem), &left);
			_errorCode = clEnqueueNDRangeKernel(_commandQueue, _convertGrayscale, 2, NULL, _scaledRegion, NULL, 0, NULL, event_l);
			SAMPLE_CHECK_ERRORS(_errorCode);
			clSetKernelArg(_convertGrayscale, 0, sizeof(cl_mem), &_reducedR);
			clSetKernelArg(_convertGrayscale, 1, sizeof(cl_mem), &right);
			_errorCode = clEnqueueNDRangeKernel(_commandQueue, _convertGrayscale, 2, NULL, _scaledRegion, NULL, 0, NULL, event_r);
			SAMPLE_CHECK_ERRORS(_errorCode);
		}
		else
		{
			uint width = _width, height = _height;
			switch (scaling)
			{
			case OVR::ORIGINAL:
				width /= 1;
				height /= 1;
				break;
			case OVR::HALF:
				width /= 2;
				height /= 2;
				break;
			case OVR::FOURTH:
				width /= 4;
				height /= 4;
				break;
			case OVR::EIGHTH:
				width /= 8;
				height /= 8;
				break;
			}
			size_t origin[3] = { 0, 0, 0 };
			size_t region[3] = { width, height, 1 };
			size_t size[] = { width, height };

			cl_image_desc desc = { CL_MEM_OBJECT_IMAGE2D, width, height };
			cl_mem l = clCreateImage(_context, CL_MEM_READ_WRITE, &_format8UC4, &desc, 0, &_errorCode);
			SAMPLE_CHECK_ERRORS(_errorCode);
			cl_mem r = clCreateImage(_context, CL_MEM_READ_WRITE, &_format8UC4, &desc, 0, &_errorCode);
			SAMPLE_CHECK_ERRORS(_errorCode);

			// Resize
			cl_event event[2];
			Resize(_l, l, scaling, &event[0]);
			Resize(_r, r, scaling, &event[1]);
			// Convert to HSV
			//__kernel void convertGrayscale( 
			//		__read_only image2d_t src,	// CL_UNSIGNED_INT8 x 4
			//		__write_only image2d_t dst)	// CL_UNSIGNED_INT8

			clSetKernelArg(_convertGrayscale, 0, sizeof(cl_mem), &l);
			clSetKernelArg(_convertGrayscale, 1, sizeof(cl_mem), &left);
			_errorCode = clEnqueueNDRangeKernel(_commandQueue, _convertGrayscale, 2, NULL, size, NULL, 1, &event[0], event_l);
			SAMPLE_CHECK_ERRORS(_errorCode);
			clSetKernelArg(_convertGrayscale, 0, sizeof(cl_mem), &r);
			clSetKernelArg(_convertGrayscale, 1, sizeof(cl_mem), &right);
			_errorCode = clEnqueueNDRangeKernel(_commandQueue, _convertGrayscale, 2, NULL, size, NULL, 1, &event[1], event_r);
			SAMPLE_CHECK_ERRORS(_errorCode);

			// Release temporaries
			clReleaseEvent(event[0]);
			clReleaseEvent(event[1]);
			clReleaseMemObject(l);
			clReleaseMemObject(r);
		}
	}

	// Get resized grayscvale images
	void OvrvisionProOpenCL::Grayscale(uchar *left, uchar *right, enum SCALING scaling)
	{
		uint width = _width, height = _height;
		switch (scaling)
		{
		case OVR::ORIGINAL:
			width /= 1;
			height /= 1;
			break;
		case OVR::HALF:
			width /= 2;
			height /= 2;
			break;
		case OVR::FOURTH:
			width /= 4;
			height /= 4;
			break;
		case OVR::EIGHTH:
			width /= 8;
			height /= 8;
			break;
		}
		size_t origin[3] = { 0, 0, 0 };
		size_t region[3] = { width, height, 1 };
		cl_image_desc desc = { CL_MEM_OBJECT_IMAGE2D, width, height };

		cl_mem l = clCreateImage(_context, CL_MEM_READ_WRITE, &_format8UC1, &desc, 0, &_errorCode);
		SAMPLE_CHECK_ERRORS(_errorCode);
		cl_mem r = clCreateImage(_context, CL_MEM_READ_WRITE, &_format8UC1, &desc, 0, &_errorCode);
		SAMPLE_CHECK_ERRORS(_errorCode);
		cl_event event_l, event_r, event[2];

		Grayscale(l, r, scaling, &event_l, &event_r);

		_errorCode = clEnqueueReadImage(_commandQueue, l, CL_TRUE, origin, region, width * sizeof(uchar), 0, left, 1, &event_l, &event[0]);
		SAMPLE_CHECK_ERRORS(_errorCode);
		_errorCode = clEnqueueReadImage(_commandQueue, r, CL_TRUE, origin, region, width * sizeof(uchar), 0, right, 1, &event_r, &event[1]);
		SAMPLE_CHECK_ERRORS(_errorCode);
		clWaitForEvents(2, event);

		// Release temporaries
		clReleaseEvent(event_l);
		clReleaseEvent(event_r);
		clReleaseEvent(event[0]);
		clReleaseEvent(event[1]);
		clReleaseMemObject(l);
		clReleaseMemObject(r);
	}

	// Tone correction
	void OvrvisionProOpenCL::Tone(cl_mem src_l, cl_mem src_r, cl_mem left, cl_mem right, cl_event *event_l, cl_event *event_r)
	{
		size_t size[] = { _scaledRegion[0], _scaledRegion[1] };

		//__kernel void tone(
		//	__read_only image2d_t src,			// CL_UNSIGNED_INT8 x 4
		//	__write_only image2d_t	dst,		// CL_UNSIGNED_INT8 x 4
		//	__read_only image2d_t map)			// CL_UNSIGNED_INT8

		clSetKernelArg(_toneCorrection, 0, sizeof(cl_mem), &src_l);
		clSetKernelArg(_toneCorrection, 1, sizeof(cl_mem), &left);
		clSetKernelArg(_toneCorrection, 2, sizeof(cl_mem), &_toneMap);
		_errorCode = clEnqueueNDRangeKernel(_commandQueue, _toneCorrection, 2, NULL, size, NULL, 0, NULL, event_l);
		SAMPLE_CHECK_ERRORS(_errorCode);
		clSetKernelArg(_toneCorrection, 0, sizeof(cl_mem), &src_r);
		clSetKernelArg(_toneCorrection, 1, sizeof(cl_mem), &right);
		clSetKernelArg(_toneCorrection, 2, sizeof(cl_mem), &_toneMap);
		_errorCode = clEnqueueNDRangeKernel(_commandQueue, _toneCorrection, 2, NULL, size, NULL, 0, NULL, event_r);
		SAMPLE_CHECK_ERRORS(_errorCode);

	}

	// Get HSV images
	void OvrvisionProOpenCL::GetHSV(cl_mem left, cl_mem right, cl_event *event_l, cl_event *event_r)
	{
		size_t size[] = { _scaledRegion[0], _scaledRegion[1] };
#ifdef TONE_CORRECTION
		//__kernel void convertHSVTone( 
		//		__read_only image2d_t src,	// CL_UNSIGNED_INT8 x 4
		//		__write_only image2d_t dst,	// CL_UNSIGNED_INT8 x 4
		//		__read_only image2d_t map)	// CL_UNSIGNED_INT8

		clSetKernelArg(_convertHSVTone, 0, sizeof(cl_mem), &_reducedL);
		clSetKernelArg(_convertHSVTone, 1, sizeof(cl_mem), &left);
		clSetKernelArg(_convertHSVTone, 2, sizeof(cl_mem), &_toneMap);
		_errorCode = clEnqueueNDRangeKernel(_commandQueue, _convertHSVTone, 2, NULL, size, NULL, 0, NULL, event_l);
		SAMPLE_CHECK_ERRORS(_errorCode);
		clSetKernelArg(_convertHSVTone, 0, sizeof(cl_mem), &_reducedR);
		clSetKernelArg(_convertHSVTone, 1, sizeof(cl_mem), &right);
		clSetKernelArg(_convertHSVTone, 2, sizeof(cl_mem), &_toneMap);
		_errorCode = clEnqueueNDRangeKernel(_commandQueue, _convertHSVTone, 2, NULL, size, NULL, 0, NULL, event_r);
		SAMPLE_CHECK_ERRORS(_errorCode);
#else
		// Convert to HSV
		//__kernel void convertHSV( 
		//		__read_only image2d_t src,	// CL_UNSIGNED_INT8 x 4
		//		__write_only image2d_t dst)	// CL_UNSIGNED_INT8 x 4

		clSetKernelArg(_convertHSV, 0, sizeof(cl_mem), &_reducedL);
		clSetKernelArg(_convertHSV, 1, sizeof(cl_mem), &left);
		_errorCode = clEnqueueNDRangeKernel(_commandQueue, _convertHSV, 2, NULL, size, NULL, 0, NULL, event_l);
		SAMPLE_CHECK_ERRORS(_errorCode);
		clSetKernelArg(_convertHSV, 0, sizeof(cl_mem), &_reducedR);
		clSetKernelArg(_convertHSV, 1, sizeof(cl_mem), &right);
		_errorCode = clEnqueueNDRangeKernel(_commandQueue, _convertHSV, 2, NULL, size, NULL, 0, NULL, event_r);
		SAMPLE_CHECK_ERRORS(_errorCode);
#endif // TONE_CORRECTION
	}

	//
	void OvrvisionProOpenCL::GetHSVBlur(cl_mem left, cl_mem right, cl_event *event_l, cl_event *event_r)
	{
		size_t size[] = { _scaledRegion[0], _scaledRegion[1] };

		// Get HSV images
		cl_mem l = clCreateImage(_context, CL_MEM_READ_WRITE, &_format8UC4, &_desc_scaled, 0, &_errorCode);
		SAMPLE_CHECK_ERRORS(_errorCode);
		cl_mem r = clCreateImage(_context, CL_MEM_READ_WRITE, &_format8UC4, &_desc_scaled, 0, &_errorCode);
		SAMPLE_CHECK_ERRORS(_errorCode);

		cl_event event[2];
		GetHSV(l, r, &event[0], &event[1]);

		// TODO: Choice most effective filter
		//__kernel void gaussian( 
		//		__read_only image2d_t src,	// CL_UNSIGNED_INT8 x 4
		//		__write_only image2d_t dst)	// CL_UNSIGNED_INT8 x 4
#ifdef GAUSSIAN
		clSetKernelArg(_gaussianBlur3x3, 0, sizeof(cl_mem), &l);
		clSetKernelArg(_gaussianBlur3x3, 1, sizeof(cl_mem), &left);
		_errorCode = clEnqueueNDRangeKernel(_commandQueue, _gaussianBlur3x3, 2, NULL, size, NULL, 1, &event[0], event_l);
		SAMPLE_CHECK_ERRORS(_errorCode);
		clSetKernelArg(_gaussianBlur3x3, 0, sizeof(cl_mem), &r);
		clSetKernelArg(_gaussianBlur3x3, 1, sizeof(cl_mem), &right);
		_errorCode = clEnqueueNDRangeKernel(_commandQueue, _gaussianBlur3x3, 2, NULL, size, NULL, 1, &event[1], event_r);
		SAMPLE_CHECK_ERRORS(_errorCode);
#elif defined(MEDIAN_3x3)
		clSetKernelArg(_medianBlur3x3, 0, sizeof(cl_mem), &l);
		clSetKernelArg(_medianBlur3x3, 1, sizeof(cl_mem), &left);
		_errorCode = clEnqueueNDRangeKernel(_commandQueue, _medianBlur3x3, 2, NULL, size, NULL, 1, &event[0], event_l);
		SAMPLE_CHECK_ERRORS(_errorCode);
		clSetKernelArg(_medianBlur3x3, 0, sizeof(cl_mem), &r);
		clSetKernelArg(_medianBlur3x3, 1, sizeof(cl_mem), &right);
		_errorCode = clEnqueueNDRangeKernel(_commandQueue, _medianBlur3x3, 2, NULL, size, NULL, 1, &event[1], event_r);
		SAMPLE_CHECK_ERRORS(_errorCode);
#else // MEDIAN_5x5
		clSetKernelArg(_medianBlur5x5, 0, sizeof(cl_mem), &l);
		clSetKernelArg(_medianBlur5x5, 1, sizeof(cl_mem), &left);
		_errorCode = clEnqueueNDRangeKernel(_commandQueue, _medianBlur5x5, 2, NULL, size, NULL, 1, &event[0], event_l);
		SAMPLE_CHECK_ERRORS(_errorCode);
		clSetKernelArg(_medianBlur5x5, 0, sizeof(cl_mem), &r);
		clSetKernelArg(_medianBlur5x5, 1, sizeof(cl_mem), &right);
		_errorCode = clEnqueueNDRangeKernel(_commandQueue, _medianBlur5x5, 2, NULL, size, NULL, 1, &event[1], event_r);
		SAMPLE_CHECK_ERRORS(_errorCode);
#endif
		// Release temporaries
		clReleaseEvent(event[0]);
		clReleaseEvent(event[1]);
		clReleaseMemObject(l);
		clReleaseMemObject(r);
	}

	// Get HSV images
	void OvrvisionProOpenCL::GetHSV(uchar *left, uchar *right)
	{
		uint width = _scaledRegion[0], height = _scaledRegion[1];
		size_t origin[3] = { 0, 0, 0 };
		size_t region[3] = { width, height, 1 };

		cl_mem l = clCreateImage(_context, CL_MEM_READ_WRITE, &_format8UC4, &_desc_scaled, 0, &_errorCode);
		SAMPLE_CHECK_ERRORS(_errorCode);
		cl_mem r = clCreateImage(_context, CL_MEM_READ_WRITE, &_format8UC4, &_desc_scaled, 0, &_errorCode);
		SAMPLE_CHECK_ERRORS(_errorCode);
		cl_event event_l, event_r, event[2];

		GetHSV(l, r, &event_l, &event_r);

		_errorCode = clEnqueueReadImage(_commandQueue, l, CL_TRUE, origin, region, width * sizeof(uchar) * 4, 0, left, 1, &event_l, &event[0]);
		SAMPLE_CHECK_ERRORS(_errorCode);
		_errorCode = clEnqueueReadImage(_commandQueue, r, CL_TRUE, origin, region, width * sizeof(uchar) * 4, 0, right, 1, &event_r, &event[1]);
		SAMPLE_CHECK_ERRORS(_errorCode);
		clWaitForEvents(2, event);

		// Release temporaries
		clReleaseEvent(event_l);
		clReleaseEvent(event_r);
		clReleaseEvent(event[0]);
		clReleaseEvent(event[1]);
		clReleaseMemObject(l);
		clReleaseMemObject(r);
	}

	// 
	void OvrvisionProOpenCL::ColorHistgram(uchar *histgram)
	{
		uint width = _width, height = _height;
		switch (_scaling)
		{
		case OVR::HALF:
			width /= 2;
			height /= 2;
			break;
		case OVR::FOURTH:
			width /= 4;
			height /= 4;
			break;
		case OVR::EIGHTH:
			width /= 8;
			height /= 8;
			break;
		}
		Mat left(height, width, CV_8UC4);
		Mat right(height, width, CV_8UC4);
		Mat hist(180, 256, CV_32SC1);
		hist.setTo(Scalar::all(0));

		// Get HSV images
		GetHSV(left.data, right.data);

		for (uint y = 0; y < height; y++)
		{
			Vec4b *l = left.ptr<Vec4b>(y);
			Vec4b *r = right.ptr<Vec4b>(y);
			for (uint x = 0; x < width; x++)
			{
				int *count = hist.ptr<int>(l[x][0], l[x][1]);
				count[0]++;
				count = hist.ptr<int>(r[x][0], r[x][1]);
				count[0]++;
			}
		}
		Mat h(180, 256, CV_8UC1, histgram);
		cv::normalize(hist, h, 0, 255, NORM_MINMAX, h.type());
	}

	// Depricate?
	void OvrvisionProOpenCL::ConvertHSV(cl_mem src, cl_mem dst, enum FILTER filter, cl_event *execute)
	{
		size_t width, height;
		clGetImageInfo(src, CL_IMAGE_WIDTH, sizeof(width), &width, NULL);
		clGetImageInfo(src, CL_IMAGE_HEIGHT, sizeof(height), &height, NULL);
		size_t origin[3] = { 0, 0, 0 };
		size_t region[3] = { width, height, 1 };
		size_t size[] = { width, height };

		//__kernel void convertHSV( 
		//		__read_only image2d_t src,	// CL_UNSIGNED_INT8 x 4
		//		__write_only image2d_t dst)	// CL_UNSIGNED_INT8 x 4

		clSetKernelArg(_resize, 0, sizeof(cl_mem), &src);
		clSetKernelArg(_resize, 1, sizeof(cl_mem), &dst);
		_errorCode = clEnqueueNDRangeKernel(_commandQueue, _convertHSV, 2, NULL, size, 0, 0, NULL, execute);
		SAMPLE_CHECK_ERRORS(_errorCode);
	}
#pragma endregion

#pragma region DEMOSAIC_AND_REMAP
	// Demosaic, MOST PRIMITIVE function
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

		// Release temporaries
		clReleaseEvent(writeEvent);
	}

	// 
	void OvrvisionProOpenCL::Demosaic(const ushort* src, cl_event *event_l, cl_event *event_r)
	{
		cl_event wait;
		Demosaic(src, _l, _r, &wait);

		// Resize
		int scale;
		switch (_scaling)
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
		}
		size_t origin[3] = { 0, 0, 0 };

		//__kernel void resize( 
		//		__read_only image2d_t src,	// CL_UNSIGNED_INT8 x 4
		//		__write_only image2d_t dst,	// CL_UNSIGNED_INT8 x 4
		//		__read_only int scale)		// 2, 4, 8

		clSetKernelArg(_resize, 0, sizeof(cl_mem), &_l);
		clSetKernelArg(_resize, 1, sizeof(cl_mem), &_reducedL);
		clSetKernelArg(_resize, 2, sizeof(int), &scale);
		_errorCode = clEnqueueNDRangeKernel(_commandQueue, _resize, 2, NULL, _scaledRegion, 0, 1, &wait, event_l);
		SAMPLE_CHECK_ERRORS(_errorCode);
		clSetKernelArg(_resize, 0, sizeof(cl_mem), &_r);
		clSetKernelArg(_resize, 1, sizeof(cl_mem), &_reducedR);
		clSetKernelArg(_resize, 2, sizeof(int), &scale);
		_errorCode = clEnqueueNDRangeKernel(_commandQueue, _resize, 2, NULL, _scaledRegion, 0, 1, &wait, event_r);
		SAMPLE_CHECK_ERRORS(_errorCode);

		if (event_l == NULL || event_r == NULL)
		{
			clFinish(_commandQueue);
		}
		// Release temporaries
		clReleaseEvent(wait);
	}

	//
	void OvrvisionProOpenCL::Demosaic(const ushort* src, uchar *left, uchar *right)
	{
		size_t origin[3] = { 0, 0, 0 };
		size_t region[3] = { _width, _height, 1 };
		cl_event execute, event[2];

		Demosaic(src, &execute);

		// Read result
		_errorCode = clEnqueueReadImage(_commandQueue, _l, CL_TRUE, origin, region, _width * sizeof(uchar) * 4, 0, left, 1, &execute, &event[0]);
		_errorCode = clEnqueueReadImage(_commandQueue, _r, CL_TRUE, origin, region, _width * sizeof(uchar) * 4, 0, right, 1, &execute, &event[1]);
		SAMPLE_CHECK_ERRORS(_errorCode);
		clWaitForEvents(2, event);

		// Release temporaries
		clReleaseEvent(execute);
		clReleaseEvent(event[0]);
		clReleaseEvent(event[1]);
	}

	/*
	void OvrvisionProOpenCL::Demosaic(const ushort *src, Mat &left, Mat &right)
	{
		size_t origin[3] = { 0, 0, 0 };
		size_t region[3] = { _width, _height, 1 };
		cl_event execute;

		Demosaic(src, &execute);

		// Read result
		_errorCode = clEnqueueReadImage(_commandQueue, _l, CL_TRUE, origin, region, _width * sizeof(uchar) * 4, 0, left.ptr(0), 1, &execute, NULL);
		_errorCode = clEnqueueReadImage(_commandQueue, _r, CL_TRUE, origin, region, _width * sizeof(uchar) * 4, 0, right.ptr(0), 1, &execute, NULL);

		// Release temporaries
		clReleaseEvent(execute);
	}

	//
	void OvrvisionProOpenCL::Demosaic(const Mat src, Mat &left, Mat &right)
	{
		const uchar *ptr = src.ptr(0);
		Demosaic((const ushort *)ptr, left, right);
	}
	*/

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
	void OvrvisionProOpenCL::DemosaicRemap(const ushort* src, cl_mem left, cl_mem right, cl_event *event_l, cl_event *event_r)
	{
		size_t origin[3] = { 0, 0, 0 };
		size_t region[3] = { _width, _height, 1 };
		size_t demosaicSize[] = { _width / 2, _height / 2 };
		cl_event writeEvent, execute;

		_errorCode = clEnqueueWriteImage(_commandQueue, _src, CL_TRUE, origin, region, _width * sizeof(ushort), 0, src, 0, NULL, &writeEvent);
		SAMPLE_CHECK_ERRORS(_errorCode);

		//__kernel void demosaic(
		//	__read_only image2d_t src,	// CL_UNSIGNED_INT16
		//	__write_only image2d_t left,	// CL_UNSIGNED_INT8 x 4
		//	__write_only image2d_t right)	// CL_UNSIGNED_INT8 x 4
		//cl_kernel _demosaic = clCreateKernel(_program, "demosaic", &_errorCode);
		//SAMPLE_CHECK_ERRORS(_errorCode);

		clSetKernelArg(_demosaic, 0, sizeof(cl_mem), &_src);
		clSetKernelArg(_demosaic, 1, sizeof(cl_mem), &_L);
		clSetKernelArg(_demosaic, 2, sizeof(cl_mem), &_R);
		_errorCode = clEnqueueNDRangeKernel(_commandQueue, _demosaic, 2, NULL, demosaicSize, 0, 1, &writeEvent, &execute);
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
			_errorCode = clEnqueueNDRangeKernel(_commandQueue, _remap, 2, NULL, remapSize, 0, 1, &execute, event_l);
			SAMPLE_CHECK_ERRORS(_errorCode);
			clSetKernelArg(_remap, 0, sizeof(cl_mem), &_R);
			clSetKernelArg(_remap, 1, sizeof(cl_mem), &_mx[1]);
			clSetKernelArg(_remap, 2, sizeof(cl_mem), &_my[1]);
			clSetKernelArg(_remap, 3, sizeof(cl_mem), &right);
			_errorCode = clEnqueueNDRangeKernel(_commandQueue, _remap, 2, NULL, remapSize, 0, 1, &execute, event_r);
			SAMPLE_CHECK_ERRORS(_errorCode);
		}
		// Release temporaries
		clReleaseEvent(writeEvent);
		clReleaseEvent(execute);
	}

	// 
	void OvrvisionProOpenCL::DemosaicRemap(const ushort* src, cl_event *event_l, cl_event *event_r)
	{
		cl_event wait_l, wait_r;
		DemosaicRemap(src, _l, _r, &wait_l, &wait_r);

		// Resize
		int scale;
		switch (_scaling)
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
		}
		size_t origin[3] = { 0, 0, 0 };

		//__kernel void resize( 
		//		__read_only image2d_t src,	// CL_UNSIGNED_INT8 x 4
		//		__write_only image2d_t dst,	// CL_UNSIGNED_INT8 x 4
		//		__read_only int scale)		// 2, 4, 8

		clSetKernelArg(_resize, 0, sizeof(cl_mem), &_l);
		clSetKernelArg(_resize, 1, sizeof(cl_mem), &_reducedL);
		clSetKernelArg(_resize, 2, sizeof(int), &scale);
		_errorCode = clEnqueueNDRangeKernel(_commandQueue, _resize, 2, NULL, _scaledRegion, 0, 1, &wait_l, event_l);
		SAMPLE_CHECK_ERRORS(_errorCode);
		clSetKernelArg(_resize, 0, sizeof(cl_mem), &_r);
		clSetKernelArg(_resize, 1, sizeof(cl_mem), &_reducedR);
		clSetKernelArg(_resize, 2, sizeof(int), &scale);
		_errorCode = clEnqueueNDRangeKernel(_commandQueue, _resize, 2, NULL, _scaledRegion, 0, 1, &wait_r, event_r);
		SAMPLE_CHECK_ERRORS(_errorCode);

		if (event_l == NULL || event_r == NULL)
		{
			clFinish(_commandQueue);
		}
		// Release temporaries
		clReleaseEvent(wait_l);
		clReleaseEvent(wait_r);
	}

	//
	void OvrvisionProOpenCL::DemosaicRemap(const ushort* src, uchar *left, uchar *right)
	{
		size_t origin[3] = { 0, 0, 0 };
		size_t region[3] = { _width, _height, 1 };
		cl_event execute_l, execute_r, event[2];

		DemosaicRemap(src, &execute_l, &execute_r);
		// Read result
		_errorCode = clEnqueueReadImage(_commandQueue, _l, CL_TRUE, origin, region, _width * sizeof(uchar) * 4, 0, left, 1, &execute_l, &event[0]);
		_errorCode = clEnqueueReadImage(_commandQueue, _r, CL_TRUE, origin, region, _width * sizeof(uchar) * 4, 0, right, 1, &execute_r, &event[1]);
		SAMPLE_CHECK_ERRORS(_errorCode);
		clWaitForEvents(2, event);

		// Release temporaries
		clReleaseEvent(execute_l);
		clReleaseEvent(execute_r);
		clReleaseEvent(event[0]);
		clReleaseEvent(event[1]);
	}

	/*
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

		// Release temporaries
		clReleaseEvent(execute);
	}

	//
	void OvrvisionProOpenCL::DemosaicRemap(const Mat src, Mat &left, Mat &right)
	{
		const uchar *ptr = src.ptr(0);
		DemosaicRemap((const ushort *)ptr, left, right);
	}
	*/
#pragma endregion

#pragma region DEPRICATED
#ifdef WIN32
#pragma warning(push)
#pragma warning(disable:4996)
#endif
	// CreateProgram from file
	void OvrvisionProOpenCL::createProgram(const char *filename, bool binary)
	{
		FILE *file;
		struct stat st;
		stat(filename, &st);
		size_t size = st.st_size;
		char *buffer = new char[size];
		if (binary)
		{
			if ((file = fopen(filename, "rb")) != NULL)
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
			if ((file = fopen(filename, "r")) != NULL)
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
					free(log);
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
		if ((file = fopen(filename, "w")) != NULL)
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

	//
	void OvrvisionProOpenCL::Download(const cl_mem image, uchar *ptr, int offsetX, int offsetY, uint width, uint height)
	{
		size_t origin[3] = { static_cast<size_t>(offsetX), static_cast<size_t>(offsetY), 0 };
		size_t region[3] = { width, height, 1 };
		size_t size;
		cl_image_format format;
		clGetImageInfo(image, CL_IMAGE_FORMAT, sizeof(format), &format, NULL);
		clGetImageInfo(image, CL_IMAGE_ELEMENT_SIZE, sizeof(size), &size, NULL);
		size_t channels;
		switch (format.image_channel_order)
		{
		case CL_R:
		case CL_A:
		case CL_INTENSITY:
		case CL_LUMINANCE:
			channels = 1;
			break;
		case CL_RG:
		case CL_RA:
		case CL_Rx:
			channels = 2;
			break;
		case CL_RGB:
		case CL_RGx:
			channels = 3;
			break;
		case CL_RGBA:
		case CL_BGRA:
		case CL_ARGB:
		case CL_RGBx:
			channels = 4;
			break;
		}
		cl_event execute;
		_errorCode = clEnqueueReadImage(_commandQueue, image, CL_TRUE, origin, region, width * size * channels, 0, ptr, 1, &execute, NULL);
	}
#ifdef WIN32
#pragma warning(pop)
#endif
#pragma endregion
}
