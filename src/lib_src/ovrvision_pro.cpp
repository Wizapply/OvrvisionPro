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
	m_isCameraSync = false;
}

OvrvisionPro::~OvrvisionPro()
{
	Close();

#ifdef WIN32
	delete m_pODS;
#endif
#ifdef MACOSX
	[m_pOAV dealloc];
#endif
#ifdef LINUX

#endif
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
	case OV_CAMVR_QVGA:
		cam_width = 320;
		cam_height = 240;
		cam_framerate = 120;
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

	Sleep(50);	//50ms wait

	m_pFrame = new ushort[cam_width*cam_height];
	m_pPixels[0] = new byte[cam_width*cam_height*OV_PIXELSIZE_RGB];
	m_pPixels[1] = new byte[cam_width*cam_height*OV_PIXELSIZE_RGB];

	//Error
	if (objs == 0)
		return 0;

	//Initialize OpenCL system
	m_pOpenCL = new OvrvisionProOpenCL(cam_width, cam_height);

	//Opened
	m_isOpen = true;

	//Initialize Camera system
	InitCameraSetting();

	m_width = cam_width;
	m_height = cam_height;
	m_framerate = cam_framerate;

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
	delete[] m_pFrame;
	delete[] m_pPixels[0];
	delete[] m_pPixels[1];

	m_isOpen = false;
}

//Get OpenCL extensions of GPU
int OvrvisionPro::OpenCLExtensions(EXTENSION_CALLBACK callback, void *item)
{
	return m_pOpenCL->DeviceExtensions(callback, item);
}

#ifdef _WIN32
// Create D3D11 texture
void* OvrvisionPro::CreateD3DTexture2D(void *texture, int width, int height)
{
	return m_pOpenCL->CreateD3DTexture2D((ID3D11Texture2D*)texture, width, height);
}
#endif

// Create OpenGL Texture
void* OvrvisionPro::CreateGLTexture2D(unsigned int texture, int width, int height)
{
	return m_pOpenCL->CreateGLTexture2D(texture, width, height);
}

// Grayscaled images 1/2 scaled
void OvrvisionPro::GrayscaleHalf(unsigned char *left, unsigned char *right)
{
	return m_pOpenCL->Grayscale(left, right, SCALING::HALF);
}

// 1/4 scaled
void OvrvisionPro::GrayscaleFourth(unsigned char *left, unsigned char *right)
{
	return m_pOpenCL->Grayscale(left, right, SCALING::FOURTH);
}

// 1/8 scaled
void OvrvisionPro::GrayscaleEighth(unsigned char *left, unsigned char *right)
{
	return m_pOpenCL->Grayscale(left, right, SCALING::EIGHTH);
}

// Capture frame
void OvrvisionPro::Capture(OVR::Camqt qt)
{
	if (!m_isOpen)
		return;

	if (qt == OVR::Camqt::OV_CAMQT_NONE)
		return;

	if (m_pODS->GetBayer16Image((uchar *)m_pFrame, !m_isCameraSync) == RESULT_OK) {
		if (qt == OVR::Camqt::OV_CAMQT_DMSRMP)
			m_pOpenCL->DemosaicRemap(m_pFrame);	//OpenCL
		else if (qt == OVR::Camqt::OV_CAMQT_DMS)
			m_pOpenCL->Demosaic(m_pFrame);		//OpenCL
	}
}

//Get Camera data pre-store.
void OvrvisionPro::PreStoreCamData(OVR::Camqt qt)
{
	if (!m_isOpen)
		return;

	if (qt == OVR::Camqt::OV_CAMQT_NONE)
		return;

	if (m_pODS->GetBayer16Image((uchar *)m_pFrame, !m_isCameraSync) == RESULT_OK) {
		if (qt == OVR::Camqt::OV_CAMQT_DMSRMP)
			m_pOpenCL->DemosaicRemap(m_pFrame, m_pPixels[0], m_pPixels[1]);	//OpenCL
		else if (qt == OVR::Camqt::OV_CAMQT_DMS)
			m_pOpenCL->Demosaic(m_pFrame, m_pPixels[0], m_pPixels[1]);		//OpenCL
	}
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
		SetCameraExposure(ovrset.m_propExposure);
		SetCameraGain(ovrset.m_propGain);
		SetCameraBLC(ovrset.m_propBLC);
		SetCameraWhiteBalanceAuto((bool)ovrset.m_propWhiteBalanceAuto);
		if (ovrset.m_propWhiteBalanceAuto != 0) {
			SetCameraWhiteBalanceR(ovrset.m_propWhiteBalanceR);
			SetCameraWhiteBalanceG(ovrset.m_propWhiteBalanceG);
			SetCameraWhiteBalanceB(ovrset.m_propWhiteBalanceB);
		}
		m_focalpoint = ovrset.m_focalPoint.at<float>(0);
		m_rightgap[0] = (float)-ovrset.m_trans.at<double>(0);	//T:X
		m_rightgap[1] = (float)ovrset.m_trans.at<double>(1);	//T:Y
		m_rightgap[2] = (float)ovrset.m_trans.at<double>(2);	//T:Z
	}
	m_pOpenCL->LoadCameraParams(&ovrset);

	Sleep(50);	//50ms wait
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

//Thread sync
void OvrvisionPro::SetCameraSyncMode(bool value){
	m_isCameraSync = value;
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

#ifdef WIN32
	m_pODS->SetCameraSetting(OV_CAMSET_EXPOSURE, value, false);
#elif MACOSX
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
#ifdef WIN32
	m_pODS->SetCameraSetting(OV_CAMSET_GAIN, value, false);
#elif MACOSX
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
#elif MACOSX
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
#elif MACOSX
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
#elif MACOSX
	[m_pOAV setCameraSetting : OV_CAMSET_WHITEBALANCEB value : value automode : false];
#elif LINUX
	//NONE
#endif
}

int OvrvisionPro::GetCameraBLC(){
	int value = 0;
	bool automode = false;

	if (!m_isOpen)
		return (-1);

	m_pODS->GetCameraSetting(OV_CAMSET_BLC, &value, &automode);
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
#ifdef WIN32
	m_pODS->SetCameraSetting(OV_CAMSET_BLC, value, false);
#elif MACOSX
	[m_pOAV setCameraSetting : OV_CAMSET_BLC value : value automode : false];
#elif LINUX
	//NONE
#endif
}

bool OvrvisionPro::GetCameraWhiteBalanceAuto(){
	int value = 0;
	bool automode = false;

	if (!m_isOpen)
		return false;

	m_pODS->GetCameraSetting(OV_CAMSET_WHITEBALANCEB, &value, &automode);
	return automode;
}

void OvrvisionPro::SetCameraWhiteBalanceAuto(bool value){
	if (!m_isOpen)
		return;

	int curval = GetCameraWhiteBalanceB();

	//set
#ifdef WIN32
	m_pODS->SetCameraSetting(OV_CAMSET_WHITEBALANCEB, curval, value);
#elif MACOSX
	[m_pOAV setCameraSetting : OV_CAMSET_WHITEBALANCEB curval : value automode : value];
#elif LINUX
	//NONE
#endif
}

//EEPROM
void OvrvisionPro::UserDataAccessUnlock(){
	if (!m_isOpen)
		return;

#ifdef WIN32
	//UNLOCK Signal
	m_pODS->SetCameraSetting(OV_CAMSET_DATA, 0x00007000, false);
	m_pODS->SetCameraSetting(OV_CAMSET_DATA, 0x00006000, false);
	m_pODS->SetCameraSetting(OV_CAMSET_DATA, 0x00007000, false);
#elif MACOSX
	
#elif LINUX
	//NONE
#endif
}

void OvrvisionPro::UserDataAccessLock() {
	if (!m_isOpen)
		return;

#ifdef WIN32
	//LOCK Signal
	m_pODS->SetCameraSetting(OV_CAMSET_DATA, 0x00000000, false);
#elif MACOSX

#elif LINUX
	//NONE
#endif
}
void OvrvisionPro::UserDataAccessSelectAddress(unsigned int addr) {
	if (!m_isOpen)
		return;

	addr &= 0x000001FF;
	addr |= 0x00001000;	//cmd

#ifdef WIN32
	m_pODS->SetCameraSetting(OV_CAMSET_DATA, addr, false);
#elif MACOSX

#elif LINUX
	//NONE
#endif

}
unsigned char OvrvisionPro::UserDataAccessGetData(){

	int value = 0;
	bool automode_none = false;

	if (!m_isOpen)
		return 0x00;

#ifdef WIN32
	m_pODS->GetCameraSetting(OV_CAMSET_DATA, &value, &automode_none);
#elif MACOSX

#elif LINUX
	//NONE
#endif
	return (unsigned char)value;
}
void OvrvisionPro::UserDataAccessSetData(unsigned char value){
	if (!m_isOpen)
		return;

	int value_int = (int)value;
	value_int |= 0x00002000;	//cmd

#ifdef WIN32
	m_pODS->SetCameraSetting(OV_CAMSET_DATA, value_int, false);
#elif MACOSX

#elif LINUX
	//NONE
#endif

}
void OvrvisionPro::UserDataAccessSave(){
	if (!m_isOpen)
		return;

#ifdef WIN32
	m_pODS->SetCameraSetting(OV_CAMSET_DATA, 0x00003000, false);
#elif MACOSX

#elif LINUX
	//NONE
#endif
}

void OvrvisionPro::UserDataAccessCheckSumAddress(){
	if (!m_isOpen)
		return;

#ifdef WIN32
	m_pODS->SetCameraSetting(OV_CAMSET_DATA, 0x00005000, false);
#elif MACOSX

#elif LINUX
	//NONE
#endif
}

bool OvrvisionPro::CameraParamSaveEEPROM(){
	OvrvisionSetting ovrset(this);
	
	//Distort param is readed.
	ovrset.m_propExposure = GetCameraExposure();
	ovrset.m_propGain = GetCameraGain();
	ovrset.m_propBLC = GetCameraBLC();
	ovrset.m_propWhiteBalanceR = GetCameraWhiteBalanceR();
	ovrset.m_propWhiteBalanceG = GetCameraWhiteBalanceG();
	ovrset.m_propWhiteBalanceB = GetCameraWhiteBalanceB();
	ovrset.m_propWhiteBalanceAuto = (char)GetCameraWhiteBalanceAuto();

	return ovrset.WriteEEPROM(WRITE_EEPROM_FLAG_CAMERASETWR);
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
