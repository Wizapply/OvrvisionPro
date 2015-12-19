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


#include <opencv2/core/core.hpp>

#ifdef WIN32
// OpenCL header
#include <CL/opencl.h>// OpenCL and its extensions

#include <windows.h>
#include <dxgi.h>
#include <d3d11.h>
#include <GL/gl.h> 
#include <CL/cl_d3d11_ext.h>	// for OpenCL and Direct3D11 interoperability (NV and KHR are equivalent)
#endif

#ifdef MACOSX
// OpenCL header
#include <OpenCL/cl.h>// OpenCL and its extensions
#include <OpenGL/gl.h>
#include <sys/stat.h>

#endif

//ovrvision setting
#include "ovrvision_setting.h"

using namespace cv;

namespace OVR
{
	// OpenCL Sharing mode 
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

	// Convex object
	typedef struct {
		int mx, my;				// mass center
        std::vector<cv::Point> convexs;	// convex contor
	} Convex;

	// OpenCL extension callback function
	typedef int(*EXTENSION_CALLBACK)(void *pItem, const char *extensions);

	// OpenCL version
	class OVRVISIONPRODLL_API OvrvisionProOpenCL {
		public:
			/*! @brief Constructor 
                @param width of image
                @param height of image
                @param mode of sharing with D3D11 or OpenGL 
                @param pDevice for D3D11 */
			OvrvisionProOpenCL(int width, int height, enum SHARING_MODE mode = NONE, void *pDevice = NULL);
			~OvrvisionProOpenCL();

			/*! @brief release resources */
			void Close();

			// Select GPU device
			cl_device_id SelectGPU(const char *platform, const char *version);

			// Load camera parameters
			bool LoadCameraParams(const char *filename);
			bool LoadCameraParams(OvrvisionSetting* ovrset);

			// Demosaicing
			void Demosaic(const ushort* src, cl_event *execute);	// for OpenGL/D3D sharing 
			void Demosaic(const ushort* src, cl_mem left, cl_mem right, cl_event *execute);
			void Demosaic(const ushort* src, uchar *left, uchar *right);
			//void Demosaic(const ushort* src, Mat &left, Mat &right);
			//void Demosaic(const Mat src, Mat &left, Mat &right);

			// Demosaic and Remap
			void DemosaicRemap(const ushort* src, cl_event *execute);	// for OpenGL/D3D sharing
			void DemosaicRemap(const ushort* src, cl_mem left, cl_mem right, cl_event *execute);
			void DemosaicRemap(const ushort* src, uchar *left, uchar *right);
			//void DemosaicRemap(const ushort* src, Mat &left, Mat &right);
			void DemosaicRemap(const Mat src, Mat &left, Mat &right);

			/*! @brief set scaling (1/2, 1/4, 1/8) 
				@param scaling (HALF, FOURTH, EIGHTH)
				@return size of scaled image */
            cv::Size SetScale(SCALING scaling);

			/*! @brief Get size of scaled image 
            @return size */
            cv::Size GetScaledSize();

			/*! @brief Get half scaled image
			@param src
			@param dst
			@param scale */
			void Resize(const cl_mem src, cl_mem dst, enum SCALING scale, cl_event *execute);

			/*! @brief set HSV region for SkinRegion */
			void SetHSV(int h_low, int h_high, int s_low, int s_high) { _h_low = h_low; _h_high = h_high; _s_low = s_low; _s_high = s_high; }

			/*! @brief Create Skin textures 
				@param width of texture
				@param height of texture
				@param left texture 
				@param right texure */
			void CreateSkinTextures(int width, int height, void *left, void *right);

			/*! @brief Update skin textures 
				@param left texture
				@param right texure */
			void UpdateSkinTextures(void *left, void *right);

#ifdef WIN32
			/*! @brief Get D3D11 Skin image for Unity Native
			@param pTexture
			@param pDevice */
			void SkinImageForUnityNativeD3D11(ID3D11Texture2D *pTexture[2], ID3D11Device* pDevice);
#endif // WIN32

			/*! @brief Get OpenGL skin image for Unity Native
                @param texture */
			void SkinImageForUnityNativeGL(GLuint texture[2]);

			/*! @brief Get Skin images
				@param left ptr of BGRA image
				@param right ptr of BGRA image */
			void SkinImages(uchar *left, uchar *right);
			void SkinImages(cl_mem left, cl_mem right, cl_event *event_l, cl_event *event_r);

			/*! @brief set skin threshold to extract region 
				@param threshold (0..255)
				@return previous threshold */
			int SetThreshold(int threshold);

			/*! @brief Start skin color calibration
			@param frames for calibration */
			void StartCalibration(int frames);

			// Skin color region 
			/*! @brief Skin color region mask 
			@param left ptr for left HSV image
			@param right ptr for right HSV image */
			void SkinRegion(uchar *left, uchar *right);
			/*! @brief Skin color region mask */
			void SkinRegion(cl_mem left, cl_mem right, cl_event *event_l, cl_event *event_r);

			/*! @brief Get HSV images for skin color detection
			@param left ptr for left HSV image
			@param right ptr for right HSV image */
			void GetHSV(uchar *left, uchar *right);
			/*! @brief Get HSV images for skin color detection */
			void GetHSV(cl_mem left, cl_mem right, cl_event *event_l, cl_event *event_r);
			void GetHSVBlur(cl_mem left, cl_mem right, cl_event *event_l, cl_event *event_r);
			void ColorHistgram(uchar *histgram);

			/*! @brief Get resized gray image
			@param left ptr for left HSV image
			@param right ptr for right HSV image
			@param scale (HALF, FOURTH, EIGHTH) */
			void Grayscale(uchar *left, uchar *right, enum SCALING scale);
			void Grayscale(cl_mem left, cl_mem right, enum SCALING scale, cl_event *event_l, cl_event *event_r);

			// Read images region of interest
			void Read(uchar *left, uchar *right, int offsetX, int offsetY, uint width, uint height);

			bool Read(uchar *left, uchar *right);

			/*! @brief Download from GPU
				@param image 
				@param ptr for read buffer 
				@param offsetX
				@param offsetY
				@param width
				@param height */
			void Download(const cl_mem image, uchar *ptr, int offsetX, int offsetY, uint width, uint height);

			// Remap
			void Remap(const cl_mem src, uint width, uint height, const cl_mem mapX, const cl_mem mapY, cl_mem dst, cl_event *execute = NULL);
			

			// Convert to HSV color space
			/*! @brief Convert image to HSV color space
			@param src image
			@param dst image
			@param filter */
			void ConvertHSV(cl_mem src, cl_mem dst, enum FILTER filter = RAW, cl_event *execute = NULL);

			// OpenGL shared textrue
			// pixelFormat must be GL_RGBA
			// dataType must be GL_UNSIGNED_BYTE
			cl_mem CreateGLTexture2D(GLuint texture, int width, int height);

			/*! @brief Update skin textures for drawing
				@param textures textures[0]:left textures[1]:right */
			//void UpdateSkinTextureObjects(uint n, void *textures[]);

#ifdef _WIN32
			// Direct3D shared texture
			cl_mem CreateD3DTexture2D(ID3D11Texture2D *texture, int width, int height);
#endif

			// Enumerate OpenCL extensions
			int DeviceExtensions(EXTENSION_CALLBACK callback = NULL, void *item = NULL);

		protected:
			/*! @brief Create context with sharing with D3D!! or OpenGL 
                @param mode shareing 
                @param pDevice to share texture */
			void CreateContext(SHARING_MODE mode, void *pDevice);

			/*! @brief enumerate pixels
			@param left histgram
			@param right histgram
			@return true if hand detected */
			bool EnumHS(Mat &result_l, Mat &result_r);

			/*! @brief Estimate skin color range
			@param histgram */
			void EstimateColorRange();

		private:
			bool CreateProgram();
			bool Prepare4Sharing();		// Prepare for OpenGL/D3D sharing
			void createProgram(const char *filename, bool binary = false);
			int saveBinary(const char *filename);
			//bool SaveSettings(const char *filename);

#ifdef _WIN32
			enum VENDOR _vendorD3D11;	// D3D11 sharing depends on vendor specific extensions

			// Extension functions for NVIDIA 
			clGetDeviceIDsFromD3D11NV_fn        clGetDeviceIDsFromD3D11NV = NULL;
			clCreateFromD3D11BufferNV_fn		clCreateFromD3D11BufferNV = NULL;
			clCreateFromD3D11Texture2DNV_fn		clCreateFromD3D11Texture2DNV = NULL;
			clCreateFromD3D11Texture3DNV_fn     clCreateFromD3D11Texture3DNV = NULL;
			clEnqueueAcquireD3D11ObjectsNV_fn	clEnqueueAcquireD3D11ObjectsNV = NULL;
			clEnqueueReleaseD3D11ObjectsNV_fn	clEnqueueReleaseD3D11ObjectsNV = NULL;

			// Extension functions for Khronos
			clGetDeviceIDsFromD3D11KHR_fn       clGetDeviceIDsFromD3D11KHR = NULL;
			clCreateFromD3D11BufferKHR_fn		clCreateFromD3D11BufferKHR = NULL;
			clCreateFromD3D11Texture2DKHR_fn	clCreateFromD3D11Texture2DKHR = NULL;
			clCreateFromD3D11Texture3DKHR_fn    clCreateFromD3D11Texture3DKHR = NULL;
			clEnqueueAcquireD3D11ObjectsKHR_fn	clEnqueueAcquireD3D11ObjectsKHR = NULL;
			clEnqueueReleaseD3D11ObjectsKHR_fn	clEnqueueReleaseD3D11ObjectsKHR = NULL;
#endif
			char	*_deviceExtensions;
			Mat		*_mapX[2], *_mapY[2];	// camera parameter
			Mat		*_skinmask[2];				// skin mask
			Mat		*_histgram[2];
			int		_skinThreshold;
			uint	_width, _height;
			// HSV color region 
			int		_h_low, _h_high;
			int		_s_low, _s_high;
			bool	_remapAvailable;
			bool	_released;
			bool	_calibration;
			int		_frameCounter;
			enum SHARING_MODE _sharing;	// Sharing with OpenGL or Direct3D11 
			enum SCALING	_scaling;	//
			size_t	_scaledRegion[3];
			Convex	_convex[2];			// Assume to be both hands
			//KalmanFilter _kalman[2];

		protected:
			// OpenCL variables
			cl_platform_id	_platformId;
			cl_device_id	_deviceId;
			cl_context		_context;

			cl_command_queue _commandQueue;
			cl_image_format	_format16UC1;
			cl_image_format	_format8UC4;
			cl_image_format _format8UC1;
			cl_image_format _formatMap;
			cl_int			_errorCode;

			cl_program		_program;
			cl_kernel		_demosaic;
			cl_kernel		_remap;
			cl_kernel		_resize;
			cl_kernel		_convertHSV;
			cl_kernel		_convertGrayscale;
			cl_kernel		_skincolor;
			cl_kernel		_gaussianBlur3x3;
			cl_kernel		_gaussianBlur5x5;
			cl_kernel		_medianBlur3x3;
			cl_kernel		_medianBlur5x5;
			cl_kernel		_mask;
			cl_kernel		_invertMask;

		private:
			//cl_event _execute;
			cl_mem	_src;
			cl_mem	_l, _r;			// demosaic and remapped image
			cl_mem	_L, _R;			// work image
			cl_mem	_mx[2], _my[2]; // map for remap in GPU
			cl_mem	_reducedL, _reducedR;	// reduced image
			cl_mem	_texture[2];	// Texture sharing
		};

	/*
	typedef int(*PENUMDEVICE)(void *pItem,
	const char *deviceName,
	const char *opencl_version,
	const char *deviceExtension,
	const int majorVersion,
	const int minorVersion);

	OVRVISIONPRODLL_API int EnumerateGPU(PENUMDEVICE callback = NULL, void *pItem = NULL);
	*/
}
