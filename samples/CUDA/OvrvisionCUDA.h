//
#if	defined(WIN32)
#include "ovrvision_ds.h"	//!DirectShow
#elif	defined(LINUX)
#include "ovrvision_v4l.h"
#endif

#include <opencv2/core/core.hpp>

using namespace cv;
#ifdef OPENCV_VERSION_2_4
#include <opencv2/gpu/gpu.hpp>
using namespace cv::gpu;
#else
#include <opencv2/core/cuda.hpp>
using namespace cv::cuda;
#endif

namespace OVR
{
#ifndef _OV_CAMEYE_ENUM_
#define _OV_CAMEYE_ENUM_
	//! @enum ov_cameraeye
	//! Eye selection the Left or Right.
	typedef enum ov_cameraeye {
		OV_CAMEYE_LEFT = 0,		//!Left camera
		OV_CAMEYE_RIGHT,		//!Right camera
		OV_CAMNUM,
	} Cameye;
#endif

	//! @enum ov_cameraprop
	//! Camera open types
	typedef enum ov_cameraprop {
		OV_CAM5MP_FULL = 0,		//!2560x1920 @15fps x2
		OV_CAM5MP_FHD,			//!1920x1080 @30fps x2
		OV_CAMHD_FULL,			//!1280x960  @45fps x2
		OV_CAMVR_FULL, 			//!960x950   @60fps x2
		OV_CAMVR_WIDE,			//!1280x800  @60fps x2
		OV_CAMVR_VGA,			//!640x480   @90fps x2
		OV_CAMVR_QVGA,			//!320x240   @120fps x2
		OV_CAM20HD_FULL,		//!1280x960  @15fps x2 Only USB2.0 connection
		OV_CAM20VR_VGA,			//!640x480   @30fps x2 Only USB2.0 connection
	} Camprop;

	//! @enum ov_cameraquality
	//! The image-processing method 
	typedef enum ov_cameraquality {
		OV_CAMQT_DMSRMP = 0,	//!Demosaic & Remap
		OV_CAMQT_DMS,			//!Demosaic
		OV_CAMQT_NONE,			//!None
	} Camqt;

	//! ROI
	typedef struct {
		int offsetX;			//!OffsetX
		int offsetY;			//!OffsetY
		unsigned int width;		//!Width
		unsigned int height;	//!Height
	} ROI;

	//unsigned char to byte
	typedef unsigned char byte;
	typedef unsigned char* pbyte;

	namespace CUDA
	{
		double bayerGB2BGR(GpuMat src, GpuMat left, GpuMat right);
		double remap(const GpuMat src, GpuMat dst, const GpuMat mapx, const GpuMat mapy);

		/////////// CLASS ///////////

		//! OvrvisionPro class
		class OvrvisionPro
		{
		public:
			//!Constructor
			OvrvisionPro();
			//!Destructor
			~OvrvisionPro();

			//Initialize
			/*!	@brief Open the Ovrvision Pro
			@param locationID Connection number
			@param prop Camera property
			@param deviceType (2:D3D11, 0:OpenGL, -1:Dont share)
			@param pD3D11Device ptr to D3D11 device when deviceType == 2
			@return If successful, the return value is 0< */
			int Open(int locationID, OVR::Camprop prop, int deviceType = -1, void *pD3D11Device = NULL);
			/*!	@brief Close the Ovrvision Pro */
			void Close();

			/*!	@brief Get camera image region of interest
			 */
			void GetStereoImageBGRA(GpuMat &left, GpuMat &right);
			void GetStereoImageBGRA(Mat &left, Mat &right);

		private:
#ifdef WIN32
			//DirectShow
			OvrvisionDirectShow*	m_pODS;
#elif defined(MACOSX)
			OvrvisionAVFoundation*  m_pOAV;
#elif defined(LINUX)
			OvrvisionVideo4Linux*	m_pOV4L;
#endif
			//Frame buffer
			Mat buffer;
			GpuMat gpuBuffer, m_left, m_right;

			//Camera status data
			int				m_width;
			int				m_height;
			int				m_framerate;
			float			m_focalpoint;
			float			m_rightgap[3];	//vector3
			float			m_expo_f;

			bool			m_isOpen;
			bool			m_isCameraSync;

			//initialize setting
			void InitCameraSetting();
		};
	}
}
