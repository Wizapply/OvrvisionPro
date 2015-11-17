// The following ifdef block is the standard way of creating macros which make exporting 
// from a DLL simpler. All files within this DLL are compiled with the OVRVISIONPRODLL_EXPORTS
// symbol defined on the command line. This symbol should not be defined on any project
// that uses this DLL. This way any other project whose source files include this file see 
// OVRVISIONPRODLL_API functions as being imported from a DLL, whereas this DLL sees symbols
// defined with this macro as being exported.
#ifdef _OVRVISION_EXPORTS
#define OVRVISIONPRODLL_API __declspec(dllexport)
#else
#define OVRVISIONPRODLL_API __declspec(dllimport)
#endif

#include <opencv2/core/core.hpp>
// OpenCL header
#include <CL/opencl.h>
#include <CL/cl_d3d11_ext.h>	// for OpenCL and Direct3D11 interoperability (NV and KHR are equivalent)

//ovrvision setting
#include "ovrvision_setting.h"

using namespace cv;

namespace OVR
{
	typedef int(*PENUMDEVICE)(void *pItem,
		const char *deviceName,
		const char *opencl_version,
		const char *deviceExtension,
		const int majorVersion,
		const int minorVersion);

	OVRVISIONPRODLL_API int EnumerateGPU(PENUMDEVICE callback = NULL, void *pItem = NULL);

	// OpenCL Sharing mode 
	enum SHARING_MODE {
		NONE = 0,
		OPENGL,
		D3D11,
		//D3D10
	};

	// OpenCL version
	//namespace OPENCL
	//{
	class OVRVISIONPRODLL_API OvrvisionProOpenCL {
		public:
			OvrvisionProOpenCL(int width, int height, enum SHARING_MODE mode = NONE);
			~OvrvisionProOpenCL();

			// Load camera parameters
			bool LoadCameraParams(const char *filename);
			bool LoadCameraParams(OvrvisionSetting* ovrset);

			// Demosaicing
			void Demosaic(const ushort* src, Mat &left, Mat &right);
			void Demosaic(const Mat src, Mat &left, Mat &right);

			// Demosaic and Remap
			void DemosaicRemap(const ushort* src, Mat &left, Mat &right);
			void DemosaicRemap(const Mat src, Mat &left, Mat &right);

			cl_device_id SelectGPU(const char *platform, const char *version);

			void createProgram(const char *filename, bool binary = false);
			int saveBinary(const char *filename);
			//void Remap(Cameye eye, const Mat src, Mat &dst);
			//bool SaveSettings(const char *filename);

		private:
			//void CreateProgram(); // TODO: ヘッダファイルからカーネルを作成
			int _width, _height;
			Mat *mapX[2], *mapY[2]; // camera parameter
			enum SHARING_MODE _sharing;	// Sharing with OpenGL or Direct3D11 

		protected:
			// OpenCL variables
			cl_platform_id	_platformId;
			cl_device_id	_deviceId;
			cl_context		_context;
			cl_program		_program;
			cl_kernel		_demosaic;
			cl_kernel		_remap;
			cl_command_queue _commandQueue;
			cl_image_format	_format16UC1;
			cl_image_format	_format8UC4;
			cl_image_format _formatMap;
			cl_int			_errorCode;

		private:
			cl_mem	_src;
			cl_mem	_l, _r, _L, _R;
			cl_mem	_mx[2], _my[2]; // map for remap in GPU
			bool	_remapAvailable;
		};
	//}

	/*
	// CUDA version
	namespace CUDA
	{
		// This class is exported from the OvrvisionProDLL.dll
		class OVRVISIONPRODLL_API OvrvisionPro {
		public:
			OvrvisionPro(Size size);
			~OvrvisionPro();

			// Load camera parameters
			bool LoadCameraParams(const char *filename);
			// Demosaicing
			void Demosaic(const Mat src, Mat &left, Mat &right);
			void Demosaic(const Mat src, cuda::GpuMat &left, cuda::GpuMat &right);
			// Demosaic and Remap
			void DemosaicRemap(const Mat src, Mat &left, Mat &right);
			void DemosaicRemap(const Mat src, cuda::GpuMat &left, cuda::GpuMat &right);

		public:
			Size size;
			Mat *mapX[2], *mapY[2]; // camera parameter

		private:
			OvrvisionSetting _settings;

			cuda::GpuMat _src;
			cuda::GpuMat _l, _r, _L, _R;	// remap image
			cuda::GpuMat _mx[2], _my[2]; // map for remap in GPU
			bool	_remapAvailable;
		};

		OVRVISIONPRODLL_API double bayerGB2BGR(cuda::GpuMat src, cuda::GpuMat left, cuda::GpuMat right);
		OVRVISIONPRODLL_API double remap(const cuda::GpuMat src, cuda::GpuMat dst, const cuda::GpuMat mapx, const cuda::GpuMat mapy);
	}
	*/
}
