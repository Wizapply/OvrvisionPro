// OvrvisionProCUDA.h
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

// The following ifdef block is the standard way of creating macros which make exporting 
// from a DLL simpler. All files within this DLL are compiled with the OVRVISIONPRODLL_EXPORTS
// symbol defined on the command line. This symbol should not be defined on any project
// that uses this DLL. This way any other project whose source files include this file see 
// OVRVISIONPRODLL_API functions as being imported from a DLL, whereas this DLL sees symbols
// defined with this macro as being exported.

#ifdef WIN32
#ifdef _OVRVISION_EXPORTS
#define OVRVISIONPRODLL_API __declspec(dllexport)
#else
#define OVRVISIONPRODLL_API __declspec(dllimport)
#endif
#else
#define OVRVISIONPRODLL_API
#endif


#ifdef WIN32
// OpenCL header
//#include <CL/opencl.h>			// OpenCL and its extensions
//#include <CL/cl_d3d11.h>		// for OpenCL and Direct3D11 interoperability (KHR)
//#include <CL/cl_d3d11_nvidia.h>	// for OpenCL and Direct3D11 interoperability (NV)
#include <windows.h>
#include <dxgi.h>
#include <d3d11.h>
#include <GL/gl.h> 
typedef void *TEXTURE;
#endif

#ifdef LINUX
//#include <CL/cl.h>	// OpenCL and its extensions
//#include <CL/cl_ext.h>
//#include <CL/cl_gl.h>       // OpenCL/OpenGL interoperabillity
//#include <CL/cl_gl_ext.h>   // OpenCL/OpenGL interoperabillity
#include <GL/gl.h>
#include <GL/glx.h>
typedef unsigned int TEXTURE;
#endif

#ifdef JETSON_TK1
#	ifndef OPENCV_VERSION_2_4
#	define OPENCV_VERSION_2_4
#	endif
#endif

#include <opencv2/opencv.hpp>
#include <opencv2/core/core.hpp>
#ifdef OPENCV_VERSION_2_4
#include <opencv2/gpu/gpu.hpp>
using namespace cv;
using namespace cv::gpu;
#else
#include <opencv2/core/cuda.hpp>
using namespace cv;
using namespace cv::cuda;
#endif


//ovrvision setting
//#include "ovrvision_setting.h"


namespace OVR
{
	enum SHARING_MODE {
		NONE = 0,
		OPENGL,
		D3D11,
		//D3D9
	};

	// Scaling
	enum SCALING {
		HALF,	// 1/2
		FOURTH,	// 1/4
		EIGHTH	// 1/8
	};

	// Extension vendor 
	enum VENDOR {
		KHRONOS,	// Khronos specific extension
		INTELGPU,	// Intel specific extension
		AMD,		// AMD specific extension
		NVIDIA		// NVIDIA specific extension
	};

	// Filter mode
	enum FILTER {
		RAW,
		GAUSSIAN,
		MEDIAN,
		GAUSSIAN_3,
		GAUSSIAN_5,
		GAUSSIAN_7,
		MEDIAN_3,
		MEDIAN_5,
		MEDIAN_7,
	};

	typedef int(*PENUMDEVICE)(void *pItem,
		const char *deviceName,
		const char *opencl_version,
		const char *deviceExtension,
		const int majorVersion,
		const int minorVersion);

	OVRVISIONPRODLL_API int EnumerateGPU(PENUMDEVICE callback = NULL, void *pItem = NULL);

	// This class is exported from the OvrvisionProDLL.dll
	class OVRVISIONPRODLL_API OvrvisionProCUDA {
	public:
		OvrvisionProCUDA(int width, int height, enum SHARING_MODE mode = NONE);
		~OvrvisionProCUDA();

		/*! @brief release resources */
		void Close();

		// Load camera parameters
		bool LoadCameraParams(const char *filename);
		//bool LoadCameraParams(OvrvisionSetting* ovrset);

		// Demosaicing
		void Demosaic(const Mat src, Mat &left, Mat &right);
		void Demosaic(const Mat src);
		void Demosaic(const Mat src, GpuMat &left, GpuMat &right);

		// Demosaic and Remap
		void DemosaicRemap(const Mat src, Mat &left, Mat &right);
		void DemosaicRemap(const Mat src, GpuMat &left, GpuMat &right);

		/*! @brief set scaling (1/2, 1/4, 1/8)
		@param scaling (HALF, FOURTH, EIGHTH)
		@return size of scaled image */
		cv::Size SetScale(SCALING scaling);

		/*! @brief Get size of scaled image
		@return size */
		cv::Size GetScaledSize();

		/*! @brief Check ZEROCOPY capability */
		static bool CanZeroCopy();

#ifdef JETSON_TK1
		unsigned char *GetBufferPtr();
		void Demosaic();
#endif

	public:
		Size _size;
		Mat	_srcMat;
		Mat	_left, _right;

	private:
		//OvrvisionSetting _settings;
		bool canZeroCopy;
#ifdef JETSON_TK1
		CudaMem _srcCuda;
		CudaMem _lCuda, _rCuda;
		GpuMat _src;
		GpuMat	_l, _r;
		GpuMat	_R, _L;
		GpuMat	_mx[2], _my[2];
#else
		GpuMat _src;
		GpuMat _l, _r, _L, _R;	// remap image
		GpuMat _mx[2], _my[2]; // map for remap in GPU
		Mat *_mapX[2], *_mapY[2]; // camera parameter
#endif
		bool	_remapAvailable;
	};

	OVRVISIONPRODLL_API double bayerGB2BGR(GpuMat src, GpuMat left, GpuMat right);
	OVRVISIONPRODLL_API double remap(const GpuMat src, GpuMat dst, const GpuMat mapx, const GpuMat mapy);
}
