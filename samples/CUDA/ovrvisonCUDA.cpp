//

#include "OvrvisionCUDA.h"

#include "ovrvision_setting.h"

/////////// VARS AND DEFS ///////////

//OVRVISION USB SETTING
//Vender id
#define OV_USB_VENDERID		(0x2C33)
//Product id
#define OV_USB_PRODUCTID	(0x0001)	//Reversal

//PixelSize
#define OV_PIXELSIZE_RGB	(4)
#define OV_PIXELSIZE_BY8	(1)

//Challenge num
#define OV_CHALLENGENUM		(3)	//3

namespace OVR
{
	namespace CUDA
	{
		//Constructor/Destructor
		OvrvisionPro::OvrvisionPro()
		{
#if defined(WIN32)
			m_pODS = new OvrvisionDirectShow();
#elif defined(MACOSX)
			m_pOAV = [[OvrvisionAVFoundation alloc] init];
#elif defined(LINUX)
			m_pOV4L = new OvrvisionVideo4Linux();
#endif
			m_width = 960;
			m_height = 950;
			m_framerate = 60;
			m_expo_f = 937156.80f;

			m_focalpoint = 1.0f;
			m_rightgap[0] = m_rightgap[1] = m_rightgap[2] = 0.0f;

			m_isOpen = false;
			m_isCameraSync = false;
		}

		OvrvisionPro::~OvrvisionPro()
		{
			Close();

#if defined(WIN32)
			delete m_pODS;
#elif defined(MACOSX)
			[m_pOAV dealloc];
#elif defined(LINUX)
			delete m_pOV4L;
#endif
		}

		//Initialize
		//Open the Ovrvision
		int OvrvisionPro::Open(int locationID, OVR::Camprop prop, int deviceType, void *pDevice)
		{
			int objs = 0;
			int challenge;

			int cam_width;
			int cam_height;
			int cam_framerate;
			float cam_expo_f;

			if (m_isOpen)
				return 0;

			switch (prop) {
			case OV_CAM5MP_FULL:
				cam_width = 2560;
				cam_height = 1920;
				cam_framerate = 15;
				cam_expo_f = 480000.00f;
				break;
			case OV_CAM5MP_FHD:
				cam_width = 1920;
				cam_height = 1080;
				cam_framerate = 30;
				cam_expo_f = 570579.49f;
				break;
			case OV_CAMHD_FULL:
				cam_width = 1280;
				cam_height = 960;
				cam_framerate = 45;
				cam_expo_f = 720112.52f;
				break;
			case OV_CAMVR_FULL:
				cam_width = 960;
				cam_height = 950;
				cam_framerate = 60;
				cam_expo_f = 937156.80f;
				break;
			case OV_CAMVR_WIDE:
				cam_width = 1280;
				cam_height = 800;
				cam_framerate = 60;
				cam_expo_f = 783273.84f;
				break;
			case OV_CAMVR_VGA:
				cam_width = 640;
				cam_height = 480;
				cam_framerate = 90;
				cam_expo_f = 720112.52f;
				break;
			case OV_CAMVR_QVGA:
				cam_width = 320;
				cam_height = 240;
				cam_framerate = 120;
				cam_expo_f = 491520.00f;
				break;
			case OV_CAM20HD_FULL:
				cam_width = 1280;
				cam_height = 960;
				cam_framerate = 15;
				cam_expo_f = 240000.00f;
				break;
			case OV_CAM20VR_VGA:
				cam_width = 640;
				cam_height = 480;
				cam_framerate = 30;
				cam_expo_f = 240000.00f;
				break;
			default:
				cam_width = 960;
				cam_height = 950;
				cam_framerate = 60;
				cam_expo_f = 937156.80f;
				return 0;
			};

			//Open
			for (challenge = 0; challenge < OV_CHALLENGENUM; challenge++) {	//CHALLENGEN
#if defined(WIN32)
				if (m_pODS->CreateDevice(OV_USB_VENDERID, OV_USB_PRODUCTID, cam_width, cam_height, cam_framerate, locationID) == 0) {
					objs++;
					break;
				}
				Sleep(150);	//150ms wait
#elif defined(MACOSX)
				if ([m_pOAV createDevice : OV_USB_VENDERID pid : OV_USB_PRODUCTID
				cam_w : cam_width cam_h : cam_height rate : cam_framerate locate : locationID] == 0) {
				objs++;
				break;
				}
				[NSThread sleepForTimeInterval : 0.150];	//150ms wait
#elif defined(LINUX)
				if (m_pOV4L->OpenDevice(locationID, cam_width, cam_height, cam_framerate) == 0) {
					objs++;
					break;
				}
				usleep(150000);	//150ms wait
#endif
			}

			//Error
			if (objs == 0)
				return 0;

			buffer.create(cam_height, cam_width, CV_16UC1);
			gpuBuffer.create(cam_height, cam_width, CV_16UC1);

			//Opened
			m_isOpen = true;

#if defined(WIN32)
			m_pODS->StartTransfer();
#elif defined(MACOSX)
			[m_pOAV startTransfer];
#elif defined(LINUX)
			m_pOV4L->StartTransfer();
#endif

			m_width = cam_width;
			m_height = cam_height;
			m_framerate = cam_framerate;
			m_expo_f = cam_expo_f;

			//Initialize Camera system
			//InitCameraSetting();

			return objs;
		}

		//Close the Ovrvision
		void OvrvisionPro::Close()
		{
			if (!m_isOpen)
				return;

#if defined(WIN32)
			m_pODS->DeleteDevice();
#elif defined(MACOSX)
			[m_pOAV deleteDevice];
#elif defined(LINUX)
			m_pOV4L->DeleteDevice();
#endif
			buffer.release();
			gpuBuffer.release();

			m_isOpen = false;
		}

		/*!	@brief Get camera image region of interest
		*/
		void OvrvisionPro::GetStereoImageBGRA(GpuMat &left, GpuMat &right)
		{
			// UNDER CONSTRUCTION
#if defined(WIN32)
			if (m_pODS->GetBayer16Image((uchar *)buffer.data, !m_isCameraSync) == RESULT_OK)
#elif defined(MACOSX)
			if ([m_pOAV getBayer16Image : (uchar *)m_pFrame blocking : !m_isCameraSync] == RESULT_OK)
#elif defined(LINUX)
			if (m_pOV4L->GetBayer16Image((uchar *)m_pFrame, !m_isCameraSync) == RESULT_OK)
#endif
			{
				gpuBuffer.upload(buffer);
				bayerGB2BGR(gpuBuffer, left, right);
			}
		}
	}
}