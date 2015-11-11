// ovrvisionPro.cpp
//
//MIT License
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//THE SOFTWARE.
//
// Oculus Rift : TM & Copyright Oculus VR, Inc. All Rights Reserved
// Unity : TM & Copyright Unity Technologies. All Rights Reserved


/////////// INCLUDE ///////////

#include "ovrvision_pro.h"
#include <opencv2/opencv.hpp>

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

/////////// CLASS ///////////

//Group
namespace OVR
{

//Constructor/Destructor
OvrvisionPro::OvrvisionPro()
{
#ifdef WIN32
	m_pODS = new OvrvisionDirectShow();
#endif
#ifdef MACOSX
	m_pOAV = [[OvrvisionAVFoundation alloc] init];
#endif
#ifdef LINUX

#endif
	m_pPixels[0] = m_pPixels[1] = NULL;
	m_pOpenCL = NULL;

	m_width = 960;
	m_height = 950;
	m_framerate = 60;

	m_focalpoint = 1.0f;
	m_rightgap[0] = m_rightgap[1] = m_rightgap[2] = 0.0f;

	m_isOpen = false;
}

OvrvisionPro::~OvrvisionPro()
{
	Close();
	delete m_pODS;
}

//Initialize
//Open the Ovrvision
int OvrvisionPro::Open(int locationID, OVR::Camprop prop)
{
	int objs = 0;
	int challenge;

	int cam_width;
	int cam_height;
	int cam_framerate;

	if (m_isOpen)
		return 0;

	switch (prop) {
	case OV_CAM5MP_FULL:
		cam_width = 2560;
		cam_height = 1920;
		cam_framerate = 15;
		break;
	case OV_CAM5MP_FHD:
		cam_width = 1920;
		cam_height = 1080;
		cam_framerate = 30;
		break;
	case OV_CAMHD_FULL:
		cam_width = 1280;
		cam_height = 960;
		cam_framerate = 45;
		break;
	case OV_CAMVR_FULL:
		cam_width = 960;
		cam_height = 950;
		cam_framerate = 60;
		break;
	case OV_CAMVR_WIDE:
		cam_width = 1280;
		cam_height = 800;
		cam_framerate = 60;
		break;
	case OV_CAMVR_VGA:
		cam_width = 640;
		cam_height = 480;
		cam_framerate = 90;
		break;
	case OV_CAM20HD_FULL:
		cam_width = 1280;
		cam_height = 960;
		cam_framerate = 15;
		break;
	case OV_CAM20VR_VGA:
		cam_width = 640;
		cam_height = 480;
		cam_framerate = 30;
		break;
	default:
		return 0;
	};

	//Open
	for(challenge = 0; challenge < OV_CHALLENGENUM; challenge++) {	//CHALLENGEN
		if (m_pODS->CreateDevice(OV_USB_VENDERID, OV_USB_PRODUCTID, cam_width, cam_height, cam_framerate, locationID) == 0) {
			objs++;
			break;
		}
		Sleep(150);	//150ms wait
	}

	m_pPixels[0] = new byte[cam_width*cam_height*OV_PIXELSIZE_RGB];
	m_pPixels[1] = new byte[cam_width*cam_height*OV_PIXELSIZE_RGB];

	//Error
	if (objs == 0)
		return 0;

	//Initialize OpenCL system
	m_pOpenCL = new OvrvisionProOpenCL(cam_width, cam_height);
	m_pOpenCL->createProgram("kernel.cl");	//¡‚ÍƒpƒX‚ð’¼Ú“ü‚ê‚Ä‚¢‚é‚ªA•ÏX—\’è

	//Initialize Camera system
	InitCameraSetting();

	m_width = cam_width;
	m_height = cam_height;
	m_framerate = cam_framerate;

	m_isOpen = true;

	return objs;
}

//Close the Ovrvision
void OvrvisionPro::Close()
{
	if (!m_isOpen)
		return;

	m_pODS->DeleteDevice();

	if (m_pOpenCL) {
		delete m_pOpenCL;
		m_pOpenCL = NULL;
	}

	delete[] m_pPixels[0];
	delete[] m_pPixels[1];

	m_isOpen = false;
}

//Get Camera data pre-store.
void OvrvisionPro::PreStoreCamData(OVR::Camqt qt)
{
	if (!m_isOpen)
		return;

	cv::Mat raw8_double(cv::Size(m_width, m_height), CV_16UC1);
	cv::Mat raw8_left(cv::Size(m_width, m_height), CV_8UC4);
	cv::Mat raw8_right(cv::Size(m_width, m_height), CV_8UC4);

	cv::Mat rgb24(cv::Size(m_width, m_height), CV_8UC3);

	m_pODS->GetBayer16Image(raw8_double.data, false);
	if (qt == OVR::Camqt::OV_CAMQT_DMSRMP)
		m_pOpenCL->DemosaicRemap(raw8_double, raw8_left, raw8_right);	//OpenCL
	else if (qt == OVR::Camqt::OV_CAMQT_DMS)
		m_pOpenCL->Demosaic(raw8_double, raw8_left, raw8_right);	//OpenCL
	//else

	memcpy(m_pPixels[0], raw8_left.data, m_width*m_height*OV_PIXELSIZE_RGB);	//‰ü‘P—\’è
	memcpy(m_pPixels[1], raw8_right.data, m_width*m_height*OV_PIXELSIZE_RGB);
}

unsigned char* OvrvisionPro::GetCamImageBGRA(OVR::Cameye eye)
{
	return m_pPixels[(int)eye];
}

void OvrvisionPro::GetCamImageBGRA(unsigned char* pImageBuf, OVR::Cameye eye)
{
	memcpy(pImageBuf, m_pPixels[(int)eye], m_width*m_height*OV_PIXELSIZE_RGB);
}

//Private method
void OvrvisionPro::InitCameraSetting()
{
	//Read files.
	OvrvisionSetting ovrset(this);
	if (ovrset.ReadEEPROM()) {
		//Read Set
		//SetCameraExposure(ovrset.m_propExposure);	//‚Ü‚¾Žg‚í‚È‚¢
		//SetCameraGain(ovrset.m_propGain);
		//SetCameraWhiteBalanceR(ovrset.m_propWhiteBalanceR);
		//SetCameraWhiteBalanceG(ovrset.m_propWhiteBalanceG);
		//SetCameraWhiteBalanceB(ovrset.m_propWhiteBalanceB);
		m_focalpoint = ovrset.m_focalPoint;
		m_rightgap[0] = (float)-ovrset.m_trans.at<double>(0);	//T:X
		m_rightgap[1] = (float)ovrset.m_trans.at<double>(1);	//T:Y
		m_rightgap[2] = (float)ovrset.m_trans.at<double>(2);	//T:Z

		m_pOpenCL->LoadCameraParams(&ovrset);
	}
}

bool OvrvisionPro::isOpen(){
	return m_isOpen;
}

int OvrvisionPro::GetCamWidth(){
	return m_width;
}
int OvrvisionPro::GetCamHeight(){
	return m_height;
}
int OvrvisionPro::GetCamFramerate(){
	return m_framerate;
}
int OvrvisionPro::GetCamBuffersize(){
	return m_width*m_height*OV_PIXELSIZE_RGB;
}
int OvrvisionPro::GetCamPixelsize(){
	return OV_PIXELSIZE_RGB;
}

float OvrvisionPro::GetCamFocalPoint(){
	return m_focalpoint;
}
float OvrvisionPro::GetHMDRightGap(int at){
	return m_rightgap[at];
}

//Camera Propaty
int OvrvisionPro::GetCameraExposure(){
	int value = 0;
	bool automode = false;

	if (!m_isOpen)
		return (-1);

	m_pODS->GetCameraSetting(OV_CAMSET_EXPOSURE, &value, &automode);
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

	//set
	//m_propExposure = value;

#ifdef WIN32
	m_pODS->SetCameraSetting(OV_CAMSET_EXPOSURE, value, false);
	m_pODS->SetCameraSetting(OV_CAMSET_EXPOSURE, value, false);
#elif MACOSX
	[m_pOAV setCameraSetting:OV_CAMSET_EXPOSURE value : value automode : false];
	[m_pOAV setCameraSetting:OV_CAMSET_EXPOSURE value : value automode : false];
#elif LINUX
	//NONE
#endif
}

int OvrvisionPro::GetCameraGain(){
	int value = 0;
	bool automode = false;

	if (!m_isOpen)
		return (-1);

	m_pODS->GetCameraSetting(OV_CAMSET_GAIN, &value, &automode);
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
	//m_propExposure = value;

#ifdef WIN32
	m_pODS->SetCameraSetting(OV_CAMSET_GAIN, value, false);
	m_pODS->SetCameraSetting(OV_CAMSET_GAIN, value, false);
#elif MACOSX
	[m_pOAV setCameraSetting : OV_CAMSET_GAIN value : value automode : false];
	[m_pOAV setCameraSetting : OV_CAMSET_GAIN value : value automode : false];
#elif LINUX
	//NONE
#endif
}

int OvrvisionPro::GetCameraWhiteBalanceR(){
	int value = 0;
	bool automode = false;

	if (!m_isOpen)
		return (-1);

	m_pODS->GetCameraSetting(OV_CAMSET_WHITEBALANCER, &value, &automode);
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
#ifdef WIN32
	m_pODS->SetCameraSetting(OV_CAMSET_WHITEBALANCER, value, false);
	m_pODS->SetCameraSetting(OV_CAMSET_WHITEBALANCER, value, false);
#elif MACOSX
	[m_pOAV setCameraSetting : OV_CAMSET_WHITEBALANCER value : value automode : false];
	[m_pOAV setCameraSetting : OV_CAMSET_WHITEBALANCER value : value automode : false];
#elif LINUX
	//NONE
#endif
}
int OvrvisionPro::GetCameraWhiteBalanceG(){
	int value = 0;
	bool automode = false;

	if (!m_isOpen)
		return (-1);

	m_pODS->GetCameraSetting(OV_CAMSET_WHITEBALANCEG, &value, &automode);
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
#ifdef WIN32
	m_pODS->SetCameraSetting(OV_CAMSET_WHITEBALANCEG, value, false);
	m_pODS->SetCameraSetting(OV_CAMSET_WHITEBALANCEG, value, false);
#elif MACOSX
	[m_pOAV setCameraSetting : OV_CAMSET_WHITEBALANCEG value : value automode : false];
	[m_pOAV setCameraSetting : OV_CAMSET_WHITEBALANCEG value : value automode : false];
#elif LINUX
	//NONE
#endif
}
int OvrvisionPro::GetCameraWhiteBalanceB(){
	int value = 0;
	bool automode = false;

	if (!m_isOpen)
		return (-1);

	m_pODS->GetCameraSetting(OV_CAMSET_WHITEBALANCEB, &value, &automode);
	return value;
}
void OvrvisionPro::SetCameraWhiteBalanceB(int value){
	if (!m_isOpen)
		return;

	//The range specification
	if (value < 0)	//low
		value = 0;
	if (value > 4095)	//high
		value = 4095;

	//set
#ifdef WIN32
	m_pODS->SetCameraSetting(OV_CAMSET_WHITEBALANCEB, value, false);
	m_pODS->SetCameraSetting(OV_CAMSET_WHITEBALANCEB, value, false);
#elif MACOSX
	[m_pOAV setCameraSetting : OV_CAMSET_WHITEBALANCEB value : value automode : false];
	[m_pOAV setCameraSetting : OV_CAMSET_WHITEBALANCEB value : value automode : false];
#elif LINUX
	//NONE
#endif
}

//Save camera parameter
int OvrvisionPro::SaveCamStatusToEEPROM(){
	OvrvisionSetting ovrset(this);
	return ovrset.SaveStatusEEPROM();
}

/*

if(0) {
FILE *fp = fopen("imagedata.raw", "wb");
fseek(fp, 0L, SEEK_SET);
fwrite(raw8_double.data,sizeof(uchar),m_width*2*m_height,fp);
fclose(fp);
}
*/

};
