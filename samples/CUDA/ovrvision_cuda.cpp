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

			//initialize Camera Setting
			m_propExposure = 7808;		//Exposure
			m_propGain = 20;			//Gain
			m_propBLC = 32;				//BLC
			m_propWhiteBalanceR = 1472;	//WhitebalanceR
			m_propWhiteBalanceG = 1024;	//WhitebalanceG
			m_propWhiteBalanceB = 1536;	//WhitebalanceB
			m_propWhiteBalanceAuto = 1; //WhitebalanceAuto
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
			m_left.create(cam_height, cam_width, CV_8UC3);
			m_right.create(cam_height, cam_width, CV_8UC3);

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
			InitCameraSetting();

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
			m_left.release();
			m_right.release();

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
			if ([m_pOAV getBayer16Image : (uchar *)buffer.data blocking : !m_isCameraSync] == RESULT_OK)
#elif defined(LINUX)
			if (m_pOV4L->GetBayer16Image((uchar *)buffer.data, !m_isCameraSync) == RESULT_OK)
#endif
			{
#ifdef _DEBUG
				//imshow("RAW", buffer);
#endif
				gpuBuffer.upload(buffer);
				bayerGB2BGR(gpuBuffer, left, right);
			}
		}

		void OvrvisionPro::GetStereoImageBGRA(Mat &left, Mat &right)
		{
			// UNDER CONSTRUCTION
#if defined(WIN32)
			if (m_pODS->GetBayer16Image((uchar *)buffer.data, !m_isCameraSync) == RESULT_OK)
#elif defined(MACOSX)
			if ([m_pOAV getBayer16Image : (uchar *)buffer.data blocking : !m_isCameraSync] == RESULT_OK)
#elif defined(LINUX)
			if (m_pOV4L->GetBayer16Image((uchar *)buffer.data, !m_isCameraSync) == RESULT_OK)
#endif
			{
				gpuBuffer.upload(buffer);
				bayerGB2BGR(gpuBuffer, m_left, m_right);
				m_left.download(left);
				m_right.download(right);
			}
		}

		//Private method
		void OvrvisionPro::InitCameraSetting()
		{
			//Read files.
			//OvrvisionSetting ovrset(this);
			if (ReadEEPROM()) {

				//Read Set
				SetCameraExposure(m_propExposure);
				SetCameraGain(m_propGain);
				SetCameraBLC(m_propBLC);
				SetCameraWhiteBalanceAuto((bool)m_propWhiteBalanceAuto);
				if (m_propWhiteBalanceAuto == 0) {
					SetCameraWhiteBalanceR(m_propWhiteBalanceR);
					SetCameraWhiteBalanceG(m_propWhiteBalanceG);
					SetCameraWhiteBalanceB(m_propWhiteBalanceB);
				}

				//50ms wait
#if defined(WIN32)
				Sleep(50);
#elif defined(MACOSX)
				[NSThread sleepForTimeInterval : 0.05];
#elif defined(LINUX)
				usleep(50000);
#endif
				m_focalpoint = m_focalPoint.at<float>(0);
				m_rightgap[0] = (float)-m_trans.at<double>(0);	//T:X
				m_rightgap[1] = (float)m_trans.at<double>(1);	//T:Y
				m_rightgap[2] = (float)m_trans.at<double>(2);	//T:Z
			}

		}

		//Camera Propaty
		int OvrvisionPro::GetCameraExposure(){
			int value = 0;
			bool automode = false;

			if (!m_isOpen)
				return (-1);

#if defined(WIN32)
			m_pODS->GetCameraSetting(OV_CAMSET_EXPOSURE, &value, &automode);
#elif defined(MACOSX)
			[m_pOAV getCameraSetting : OV_CAMSET_EXPOSURE value : &value automode : &automode];
#elif defined(LINUX)
			m_pOV4L->GetCameraSetting(OV_CAMSET_EXPOSURE, &value, &automode);
#endif

			return value;
		}
		void OvrvisionPro::SetCameraExposure(int value){
			if (!m_isOpen)
				return;

			//The range specification
			if (value < 0)	//low
				value = 0;
			if (value > 32767)	//high
				value = 32767;

			// Number is divided by 8
			value -= value % 8;

#if defined(WIN32)
			m_pODS->SetCameraSetting(OV_CAMSET_EXPOSURE, value, false);
#elif defined(MACOSX)
			[m_pOAV setCameraSetting : OV_CAMSET_EXPOSURE value : value automode : false];
#elif defined(LINUX)
			m_pOV4L->SetCameraSetting(OV_CAMSET_EXPOSURE, value, false);
#endif
		}
		bool OvrvisionPro::SetCameraExposurePerSec(float fps){
			if (!m_isOpen)
				return false;

			//The range specification
			if (fps < 25.0f)	//low
				fps = 25.0f;
			if (fps > 240.0f)	//high
				fps = 240.0f;

			fps += 0.5f;
			if ((float)m_framerate > fps) {
				return false;
			}

			int fpsint = (int)(m_expo_f / fps);
			SetCameraExposure(fpsint);
			return true;
		}

		int OvrvisionPro::GetCameraGain(){
			int value = 0;
			bool automode = false;

			if (!m_isOpen)
				return (-1);

#if defined(WIN32)
			m_pODS->GetCameraSetting(OV_CAMSET_GAIN, &value, &automode);
#elif defined(MACOSX)
			[m_pOAV getCameraSetting : OV_CAMSET_GAIN value : &value automode : &automode];
#elif defined(LINUX)
			m_pOV4L->GetCameraSetting(OV_CAMSET_GAIN, &value, &automode);
#endif

			return value;
		}
		void OvrvisionPro::SetCameraGain(int value){
			if (!m_isOpen)
				return;

			//The range specification
			if (value < 0)	//low
				value = 0;
			if (value > 47)	//high
				value = 47;

			//set
#if defined(WIN32)
			m_pODS->SetCameraSetting(OV_CAMSET_GAIN, value, false);
#elif defined(MACOSX)
			[m_pOAV setCameraSetting : OV_CAMSET_GAIN value : value automode : false];
#elif defined(LINUX)
			m_pOV4L->SetCameraSetting(OV_CAMSET_GAIN, value, false);
#endif
		}

		int OvrvisionPro::GetCameraWhiteBalanceR(){
			int value = 0;
			bool automode = false;

			if (!m_isOpen)
				return (-1);

#if defined(WIN32)
			m_pODS->GetCameraSetting(OV_CAMSET_WHITEBALANCER, &value, &automode);
#elif defined(MACOSX)
			[m_pOAV getCameraSetting : OV_CAMSET_WHITEBALANCER value : &value automode : &automode];
#elif defined(LINUX)
			m_pOV4L->GetCameraSetting(OV_CAMSET_WHITEBALANCER, &value, &automode);
#endif
			return value;
		}
		void OvrvisionPro::SetCameraWhiteBalanceR(int value){
			if (!m_isOpen)
				return;

			//The range specification
			if (value < 0)	//low
				value = 0;
			if (value > 4095)	//high
				value = 4095;

			//set
#if defined(WIN32)
			m_pODS->SetCameraSetting(OV_CAMSET_WHITEBALANCER, value, false);
#elif defined(MACOSX)
			[m_pOAV setCameraSetting : OV_CAMSET_WHITEBALANCER value : value automode : false];
#elif defined(LINUX)
			m_pOV4L->SetCameraSetting(OV_CAMSET_WHITEBALANCER, value, false);
#endif
		}
		int OvrvisionPro::GetCameraWhiteBalanceG(){
			int value = 0;
			bool automode = false;

			if (!m_isOpen)
				return (-1);

#if defined(WIN32)
			m_pODS->GetCameraSetting(OV_CAMSET_WHITEBALANCEG, &value, &automode);
#elif defined(MACOSX)
			[m_pOAV getCameraSetting : OV_CAMSET_WHITEBALANCEG value : &value automode : &automode];
#elif defined(LINUX)
			m_pOV4L->GetCameraSetting(OV_CAMSET_WHITEBALANCEG, &value, &automode);
#endif

			return value;
		}
		void OvrvisionPro::SetCameraWhiteBalanceG(int value){
			if (!m_isOpen)
				return;

			//The range specification
			if (value < 0)	//low
				value = 0;
			if (value > 4095)	//high
				value = 4095;

			//set
#if defined(WIN32)
			m_pODS->SetCameraSetting(OV_CAMSET_WHITEBALANCEG, value, false);
#elif defined(MACOSX)
			[m_pOAV setCameraSetting : OV_CAMSET_WHITEBALANCEG value : value automode : false];
#elif defined(LINUX)
			m_pOV4L->SetCameraSetting(OV_CAMSET_WHITEBALANCEG, value, false);
#endif
		}
		int OvrvisionPro::GetCameraWhiteBalanceB(){
			int value = 0;
			bool automode = false;

			if (!m_isOpen)
				return (-1);

#if defined(WIN32)
			m_pODS->GetCameraSetting(OV_CAMSET_WHITEBALANCEB, &value, &automode);
#elif defined(MACOSX)
			[m_pOAV getCameraSetting : OV_CAMSET_WHITEBALANCEB value : &value automode : &automode];
#elif defined(LINUX)
			m_pOV4L->GetCameraSetting(OV_CAMSET_WHITEBALANCEB, &value, &automode);
#endif
			return value;
		}
		void OvrvisionPro::SetCameraWhiteBalanceB(int value) {
			if (!m_isOpen)
				return;

			//The range specification
			if (value < 0)	//low
				value = 0;
			if (value > 4095)	//high
				value = 4095;

			bool curval = GetCameraWhiteBalanceAuto();

			//set
#if defined(WIN32)
			m_pODS->SetCameraSetting(OV_CAMSET_WHITEBALANCEB, value, curval);
#elif defined(MACOSX)
			[m_pOAV setCameraSetting : OV_CAMSET_WHITEBALANCEB value : value automode : curval];
#elif defined(LINUX)
			m_pOV4L->SetCameraSetting(OV_CAMSET_WHITEBALANCEB, value, curval);
#endif
		}

		int OvrvisionPro::GetCameraBLC(){
			int value = 0;
			bool automode = false;

			if (!m_isOpen)
				return (-1);

#if defined(WIN32)
			m_pODS->GetCameraSetting(OV_CAMSET_BLC, &value, &automode);
#elif defined(MACOSX)
			[m_pOAV getCameraSetting : OV_CAMSET_BLC value : &value automode : &automode];
#elif defined(LINUX)
			m_pOV4L->GetCameraSetting(OV_CAMSET_BLC, &value, &automode);
#endif
			return value;
		}
		void OvrvisionPro::SetCameraBLC(int value){
			if (!m_isOpen)
				return;

			//The range specification
			if (value < 0)	//low
				value = 0;
			if (value > 1023)	//high
				value = 1023;

			//set
#if defined(WIN32)
			m_pODS->SetCameraSetting(OV_CAMSET_BLC, value, false);
#elif defined(MACOSX)
			[m_pOAV setCameraSetting : OV_CAMSET_BLC value : value automode : false];
#elif defined(LINUX)
			m_pOV4L->SetCameraSetting(OV_CAMSET_BLC, value, false);
#endif
		}

		bool OvrvisionPro::GetCameraWhiteBalanceAuto(){
			int value = 0;
			bool automode = false;

			if (!m_isOpen)
				return false;

#if defined(WIN32)
			m_pODS->GetCameraSetting(OV_CAMSET_WHITEBALANCEB, &value, &automode);
#elif defined(MACOSX)
			[m_pOAV getCameraSetting : OV_CAMSET_WHITEBALANCEB value : &value automode : &automode];
#elif defined(LINUX)
			m_pOV4L->GetCameraSetting(OV_CAMSET_WHITEBALANCEB, &value, &automode);
#endif
			return automode;
		}

		void OvrvisionPro::SetCameraWhiteBalanceAuto(bool value){
			if (!m_isOpen)
				return;

			int curval = GetCameraWhiteBalanceB();

			//set
#if defined(WIN32)
			m_pODS->SetCameraSetting(OV_CAMSET_WHITEBALANCEB, curval, value);
#elif defined(MACOSX)
			[m_pOAV setCameraSetting : OV_CAMSET_WHITEBALANCEB value : curval  automode : value];
#elif defined(LINUX)
			m_pOV4L->SetCameraSetting(OV_CAMSET_WHITEBALANCEB, curval, value);
#endif
		}

		//EEPROM
		//Read EEPROM Setting
		bool OvrvisionPro::ReadEEPROM()
		{
			cv::FileStorage cvfs("ovrvisionpro_conf.xml", CV_STORAGE_READ | CV_STORAGE_FORMAT_XML);

			if (!cvfs.isOpened())
			{
				size_t i;
				// not find file
				// used eeprom

				UserDataAccessUnlock();
				UserDataAccessSelectAddress(0x0000);

				unsigned char version = UserDataAccessGetData();	//Version	//1byte

				if (version != EEPROM_SYSTEM_VERSION)
					return true;	//default return

				m_propExposure = (int)UserDataAccessGetData();			//4byte
				m_propExposure |= (int)UserDataAccessGetData() << 8;
				m_propExposure |= (int)UserDataAccessGetData() << 16;
				m_propExposure |= (int)UserDataAccessGetData() << 24;

				m_propGain = (int)UserDataAccessGetData();				//4byte
				m_propGain |= (int)UserDataAccessGetData() << 8;
				m_propGain |= (int)UserDataAccessGetData() << 16;
				m_propGain |= (int)UserDataAccessGetData() << 24;

				m_propBLC = (int)UserDataAccessGetData();				//4byte
				m_propBLC |= (int)UserDataAccessGetData() << 8;
				m_propBLC |= (int)UserDataAccessGetData() << 16;
				m_propBLC |= (int)UserDataAccessGetData() << 24;

				m_propWhiteBalanceR = (int)UserDataAccessGetData();		//4byte
				m_propWhiteBalanceR |= (int)UserDataAccessGetData() << 8;
				m_propWhiteBalanceR |= (int)UserDataAccessGetData() << 16;
				m_propWhiteBalanceR |= (int)UserDataAccessGetData() << 24;

				m_propWhiteBalanceG = (int)UserDataAccessGetData();		//4byte
				m_propWhiteBalanceG |= (int)UserDataAccessGetData() << 8;
				m_propWhiteBalanceG |= (int)UserDataAccessGetData() << 16;
				m_propWhiteBalanceG |= (int)UserDataAccessGetData() << 24;

				m_propWhiteBalanceB = (int)UserDataAccessGetData();		//4byte
				m_propWhiteBalanceB |= (int)UserDataAccessGetData() << 8;
				m_propWhiteBalanceB |= (int)UserDataAccessGetData() << 16;
				m_propWhiteBalanceB |= (int)UserDataAccessGetData() << 24;

				m_propWhiteBalanceAuto = UserDataAccessGetData();	//1byte

				//----26 byte----

				//Reserved

				//----32 byte----

				UserDataAccessSelectAddress(0x0020);

				for (i = 0; i < m_leftCameraInstric.total()*m_leftCameraInstric.elemSize(); i++) {
					m_leftCameraInstric.data[i] = UserDataAccessGetData();
				}
				for (i = 0; i < m_rightCameraInstric.total()*m_rightCameraInstric.elemSize(); i++) {
					m_rightCameraInstric.data[i] = UserDataAccessGetData();
				}
				for (i = 0; i < m_leftCameraDistortion.total()*m_leftCameraDistortion.elemSize(); i++) {
					m_leftCameraDistortion.data[i] = UserDataAccessGetData();
				}
				for (i = 0; i < m_rightCameraDistortion.total()*m_rightCameraDistortion.elemSize(); i++) {
					m_rightCameraDistortion.data[i] = UserDataAccessGetData();
				}

				for (i = 0; i < m_R1.total()*m_R1.elemSize(); i++) {
					m_R1.data[i] = UserDataAccessGetData();
				}
				for (i = 0; i < m_R2.total()*m_R2.elemSize(); i++) {
					m_R2.data[i] = UserDataAccessGetData();
				}
				for (i = 0; i < m_trans.total()*m_trans.elemSize(); i++) {
					m_trans.data[i] = UserDataAccessGetData();
				}

				for (i = 0; i < m_focalPoint.total()*m_focalPoint.elemSize(); i++) {
					m_focalPoint.data[i] = UserDataAccessGetData();
				}
				UserDataAccessLock();

				// For Test
				/*
				String filename("ovrvision_eepromtest.xml");
				FileStorage cvfs(filename, CV_STORAGE_WRITE | CV_STORAGE_FORMAT_XML);

				//Write undistort param
				write(cvfs, "LeftCameraInstric", m_leftCameraInstric);
				write(cvfs, "RightCameraInstric", m_rightCameraInstric);
				write(cvfs, "LeftCameraDistortion", m_leftCameraDistortion);
				write(cvfs, "RightCameraDistortion", m_rightCameraDistortion);
				write(cvfs, "R1", m_R1);
				write(cvfs, "R2", m_R2);
				write(cvfs, "T", m_trans);

				write(cvfs, "FocalPoint", m_focalPoint);

				cvfs.release();
				*/
			}
			else
			{
				int mode = 0;

				//get data node
				cv::FileNode data(cvfs.fs, NULL);

				mode = data["Mode"];

				//read camera setting
				m_propExposure = data["Exposure"];
				m_propGain = data["Gain"];
				m_propBLC = data["BLC"];
				m_propWhiteBalanceR = data["WhiteBalanceR"];
				m_propWhiteBalanceG = data["WhiteBalanceG"];
				m_propWhiteBalanceB = data["WhiteBalanceB"];

				m_propWhiteBalanceAuto = (char)((int)data["WhiteBalanceAuto"] & 0x00000001);

				//read undistort param
				data["LeftCameraInstric"] >> m_leftCameraInstric;
				data["RightCameraInstric"] >> m_rightCameraInstric;
				data["LeftCameraDistortion"] >> m_leftCameraDistortion;
				data["RightCameraDistortion"] >> m_rightCameraDistortion;
				data["R1"] >> m_R1;
				data["R2"] >> m_R2;
				data["T"] >> m_trans;
				data["FocalPoint"] >> m_focalPoint;

				cvfs.release();

				//Mode
				if (mode == 2) {
					//WriteEEPROM(WRITE_EEPROM_FLAG_ALLWR);
					return false;
				}
			}

			return true;
		}
		void OvrvisionPro::UserDataAccessUnlock(){
			if (!m_isOpen)
				return;

#if defined(WIN32)
			//UNLOCK Signal
			m_pODS->SetCameraSetting(OV_CAMSET_DATA, 0x00007000, false);
			m_pODS->SetCameraSetting(OV_CAMSET_DATA, 0x00006000, false);
			m_pODS->SetCameraSetting(OV_CAMSET_DATA, 0x00007000, false);
#elif defined(MACOSX)
			[m_pOAV setCameraSetting : OV_CAMSET_DATA value : 0x00007000 automode : false];
			[m_pOAV setCameraSetting : OV_CAMSET_DATA value : 0x00006000 automode : false];
			[m_pOAV setCameraSetting : OV_CAMSET_DATA value : 0x00007000 automode : false];
#elif defined(LINUX)
			m_pOV4L->SetCameraSetting(OV_CAMSET_DATA, 0x00007000, false);
			m_pOV4L->SetCameraSetting(OV_CAMSET_DATA, 0x00006000, false);
			m_pOV4L->SetCameraSetting(OV_CAMSET_DATA, 0x00007000, false);
#endif
		}

		void OvrvisionPro::UserDataAccessLock() {
			if (!m_isOpen)
				return;

#if defined(WIN32)
			//LOCK Signal
			m_pODS->SetCameraSetting(OV_CAMSET_DATA, 0x00000000, false);
#elif defined(MACOSX)
			[m_pOAV setCameraSetting : OV_CAMSET_DATA value : 0x00000000 automode : false];
#elif defined(LINUX)
			m_pOV4L->SetCameraSetting(OV_CAMSET_DATA, 0x00000000, false);
#endif
		}
		void OvrvisionPro::UserDataAccessSelectAddress(unsigned int addr) {
			if (!m_isOpen)
				return;

			addr &= 0x000001FF;
			addr |= 0x00001000;	//cmd

#if defined(WIN32)
			m_pODS->SetCameraSetting(OV_CAMSET_DATA, addr, false);
#elif defined(MACOSX)
			[m_pOAV setCameraSetting : OV_CAMSET_DATA value : addr automode : false];
#elif defined(LINUX)
			m_pOV4L->SetCameraSetting(OV_CAMSET_DATA, addr, false);
#endif

		}
		unsigned char OvrvisionPro::UserDataAccessGetData() {

			int value = 0;
			bool automode_none = false;

			if (!m_isOpen)
				return 0x00;

#if defined(WIN32)
			m_pODS->GetCameraSetting(OV_CAMSET_DATA, &value, &automode_none);
#elif defined(MACOSX)
			[m_pOAV getCameraSetting : OV_CAMSET_DATA value : &value automode : &automode_none];
#elif defined(LINUX)
			m_pOV4L->GetCameraSetting(OV_CAMSET_DATA, &value, &automode_none);
#endif
			return (unsigned char)value;
		}
		void OvrvisionPro::UserDataAccessSetData(unsigned char value){
			if (!m_isOpen)
				return;

			int value_int = (int)value;
			value_int |= 0x00002000;	//cmd

#if defined(WIN32)
			m_pODS->SetCameraSetting(OV_CAMSET_DATA, value_int, false);
#elif defined(MACOSX)
			[m_pOAV setCameraSetting : OV_CAMSET_DATA value : value_int automode : false];
#elif defined(LINUX)
			m_pOV4L->SetCameraSetting(OV_CAMSET_DATA, value_int, false);
#endif

		}
		void OvrvisionPro::UserDataAccessSave(){
			if (!m_isOpen)
				return;

#if defined(WIN32)
			m_pODS->SetCameraSetting(OV_CAMSET_DATA, 0x00003000, false);
#elif defined(MACOSX)
			[m_pOAV setCameraSetting : OV_CAMSET_DATA value : 0x00003000 automode : false];
#elif defined(LINUX)
			m_pOV4L->SetCameraSetting(OV_CAMSET_DATA, 0x00003000, false);
#endif
		}

		void OvrvisionPro::UserDataAccessCheckSumAddress(){
			if (!m_isOpen)
				return;

#if (WIN32)
			m_pODS->SetCameraSetting(OV_CAMSET_DATA, 0x00005000, false);
#elif defined(MACOSX)
			[m_pOAV setCameraSetting : OV_CAMSET_DATA value : 0x00005000 automode : false];
#elif defined(LINUX)
			m_pOV4L->SetCameraSetting(OV_CAMSET_DATA, 0x00005000, false);
#endif
		}
	}
}
