// ovrvision_csharp.cpp
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

#ifdef WIN32
#include <ovrvision_pro.h>
#include <ovrvision_ar.h>
#include <ovrvision_tracking.h>
#include "ovrvision_setting.h"
#include "ovrvision_calibration.h"
#elif MACOSX
//config gdata class
#include "ovrvision_setting.h"
#include "ovrvision_tracking.h"
#include "ovrvision_calibration.h"
#undef _OVRVISION_EXPORTS
#include "ovrvision_pro.h"
#include "ovrvision_ar.h"
#else //LINUX
#include <ovrvision_pro.h>
#include <ovrvision_ar.h>
#include <ovrvision_tracking.h>
#include "ovrvision_setting.h"
#include "ovrvision_calibration.h"
#endif

#ifdef WIN32
#define SUPPORT_D3D9 1
#define SUPPORT_D3D11 1 // comment this out if you don't have D3D11 header/library files
#define SUPPORT_OPENGL 1
#endif

#ifdef MACOSX
#define SUPPORT_OPENGL 1
#endif

#ifdef LINUX
#define SUPPORT_OPENGL 1
#endif


#if SUPPORT_D3D9
#include <d3d9.h>
#endif

#if SUPPORT_D3D11
#include <d3d11.h>
#endif

#if SUPPORT_OPENGL
	#if WIN32
	#include <gl/GL.h>
	#elif MACOSX
	#include <OpenGL/gl.h>
	typedef unsigned int GLuint;
	#else //LINUX
	#include <GL/gl.h>
	#include <GL/glx.h>
	#endif
#endif

/////////// VARS AND DEFS ///////////

//Exporter
#ifdef WIN32
#define CSHARP_EXPORT __declspec(dllexport)
#elif MACOSX
#define CSHARP_EXPORT 
#else //LINUX
#define CSHARP_EXPORT
#endif

//AR deta size
#define FLOATDATA_DATA_OFFSET	(10)

//Size
#define BGR_DATASIZE	(3)

//Main Ovrvision Object
static OVR::OvrvisionPro* g_ovOvrvision = NULL;	// Always open
//AR Ovrvision Object
static OVR::OvrvisionAR* g_ovOvrvisionAR = NULL;
//AR Ovrvision Object
static OVR::OvrvisionTracking* g_ovOvrvisionTrack = NULL;
//Calibration Ovrvision Object
static OVR::OvrvisionCalibration* g_ovOvrvisionCalib = NULL;

//for GL Call
static void* g_callTexture2DLeft = NULL;
static void* g_callTexture2DRight = NULL;

/////////// EXPORT FUNCTION ///////////

//C language
#ifdef __cplusplus
extern "C" {
#endif

// Provide them with an address to a function of this signature.
typedef void(__stdcall * UnityRenderNative)(int eventID);

// int ovOpen(void)
CSHARP_EXPORT int ovOpen(int locationID, float arMeter, int type)
{
	//Create object
	if(g_ovOvrvision==NULL)
		g_ovOvrvision = new OVR::OvrvisionPro();	//MainVideo

	//Ovrvision Open
	if (g_ovOvrvision->Open(locationID, (OVR::Camprop)type) == 0)	//0=Error
		return 1;	//FALSE

	//Create AR object
	if(g_ovOvrvisionAR==NULL)
		g_ovOvrvisionAR = new OVR::OvrvisionAR(arMeter, g_ovOvrvision->GetCamWidth(),
														 g_ovOvrvision->GetCamHeight(),
														 g_ovOvrvision->GetCamFocalPoint());	//AR
	//Create AR object
	if (g_ovOvrvisionTrack == NULL)
		g_ovOvrvisionTrack = new OVR::OvrvisionTracking(g_ovOvrvision->GetCamWidth(),
						g_ovOvrvision->GetCamHeight(), g_ovOvrvision->GetCamFocalPoint());	//Tracking

	//Clear
	g_callTexture2DLeft = NULL;
	g_callTexture2DRight = NULL;

	return 0;	//OK
}

// int ovClose(void)
CSHARP_EXPORT int ovClose(void)
{
	//Delete
	if (g_ovOvrvisionTrack) {
		delete g_ovOvrvisionTrack;
		g_ovOvrvisionTrack = NULL;
	}

	if (g_ovOvrvisionAR) {
		delete g_ovOvrvisionAR;
		g_ovOvrvisionAR = NULL;
	}

	//Close
	if (g_ovOvrvision)
		g_ovOvrvision->Close();

	return 0;	//OK
}

// int ovRelease(void) -> Exit
CSHARP_EXPORT int ovRelease(void)
{
	//Delete
	if (g_ovOvrvisionTrack) {
		delete g_ovOvrvisionTrack;
		g_ovOvrvisionTrack = NULL;
	}

	if (g_ovOvrvisionAR) {
		delete g_ovOvrvisionAR;
		g_ovOvrvisionAR = NULL;
	}

	if (g_ovOvrvision) {
		delete g_ovOvrvision;
		g_ovOvrvision = NULL;
	}

	return 0;	//OK
}

// int ovPreStoreCamData() -> need ovGetCamImage : ovGetCamImageBGR
CSHARP_EXPORT void ovPreStoreCamData(int qt)
{
	if (g_ovOvrvision == NULL)
		return;

	g_ovOvrvision->PreStoreCamData((OVR::Camqt)qt);	//Renderer
}

// int ovGetCamImage(unsigned char* pImage, int eye)
CSHARP_EXPORT void ovGetCamImageBGRA(unsigned char* pImage, int eye)
{
	if(g_ovOvrvision==NULL)
		return;

	//Get image
	g_ovOvrvision->GetCamImageBGRA(pImage, (OVR::Cameye)eye);
}
CSHARP_EXPORT unsigned char* ovGetCamImageBGRAPointer(int eye)
{
	if (g_ovOvrvision == NULL)
		return NULL;

	//Get image
	return g_ovOvrvision->GetCamImageBGRA((OVR::Cameye)eye);
}
// int ovGetCamImageRGB(unsigned char* pImage, int eye)
CSHARP_EXPORT void ovGetCamImageRGB(unsigned char* pImage, int eye)
{
	if(g_ovOvrvision==NULL)
		return;

	//local var
	int i, srcj = 0;

	//Get image
	unsigned char* pData = g_ovOvrvision->GetCamImageBGRA((OVR::Cameye)eye);

	int length = g_ovOvrvision->GetCamWidth() * g_ovOvrvision->GetCamHeight() * BGR_DATASIZE;
	int offsetlen = g_ovOvrvision->GetCamPixelsize();

	//Image copy
	for (i = 0; i < length; i += 3) {
		//Left Eye
		pImage[i + 0] = pData[srcj + 2];	//R
		pImage[i + 1] = pData[srcj + 1];	//G
		pImage[i + 2] = pData[srcj + 0];	//B
		srcj += offsetlen;
	}
}
// int ovGetCamImageRGB(unsigned char* pImage, int eye)
CSHARP_EXPORT void ovGetCamImageBGR(unsigned char* pImage, int eye)
{
	if (g_ovOvrvision == NULL)
		return;

	//local var
	int i, srcj = 0;

	//Get image
	unsigned char* pData = g_ovOvrvision->GetCamImageBGRA((OVR::Cameye)eye);

	int length = g_ovOvrvision->GetCamWidth() * g_ovOvrvision->GetCamHeight() * BGR_DATASIZE;
	int offsetlen = g_ovOvrvision->GetCamPixelsize();

	//Image copy
	for (i = 0; i < length; i += 3) {
		//Left Eye
		pImage[i + 0] = pData[srcj + 0];	//B
		pImage[i + 1] = pData[srcj + 1];	//G
		pImage[i + 2] = pData[srcj + 2];	//R
		srcj += offsetlen;
	}
}

// void ovGetCamImageForUnity(unsigned char* pImagePtr_Left, unsigned char* pImagePtr_Right, int qt, int useTrack)
CSHARP_EXPORT void ovGetCamImageForUnity(unsigned char* pImagePtr_Left, unsigned char* pImagePtr_Right)
{
	if(g_ovOvrvision==NULL)
		return;

	//local var
	int i;

	//Get image
	unsigned char* pLeft = g_ovOvrvision->GetCamImageBGRA(OVR::OV_CAMEYE_LEFT);
	unsigned char* pRight = g_ovOvrvision->GetCamImageBGRA(OVR::OV_CAMEYE_RIGHT);

	int length = g_ovOvrvision->GetCamWidth() * g_ovOvrvision->GetCamHeight() * g_ovOvrvision->GetCamPixelsize();
	int offsetlen = g_ovOvrvision->GetCamPixelsize();

	//Image copy
	for (i = 0; i < length; i+=offsetlen) {
		//Left Eye
		pImagePtr_Left[i + 0] = pLeft[i + 2];	//R
		pImagePtr_Left[i + 1] = pLeft[i + 1];	//G
		pImagePtr_Left[i + 2] = pLeft[i + 0];	//B
		pImagePtr_Left[i + 3] = pLeft[i + 3];	//A

		//Right Eye
		pImagePtr_Right[i + 0] = pRight[i + 2];
		pImagePtr_Right[i + 1] = pRight[i + 1];
		pImagePtr_Right[i + 2] = pRight[i + 0];
		pImagePtr_Right[i + 3] = pRight[i + 3];
	}
}

//for Unity extern
extern float g_Time;
extern int g_DeviceType;
#if SUPPORT_D3D11
extern ID3D11Device* g_D3D11Device;
#endif
#if SUPPORT_D3D9
extern IDirect3DDevice9* g_D3D9Device;
#endif

// void ovGetCamImageForUnityNative(void* pTexPtr_Left, void* pTexPtr_Right, int qt, int useAR)
CSHARP_EXPORT void ovGetCamImageForUnityNative(void* pTexPtr_Left, void* pTexPtr_Right)
{
	if (g_ovOvrvision == NULL)
		return;

	//Get image
	unsigned char* pLeft = g_ovOvrvision->GetCamImageBGRA(OVR::OV_CAMEYE_LEFT);
	unsigned char* pRight = g_ovOvrvision->GetCamImageBGRA(OVR::OV_CAMEYE_RIGHT);

	int length = g_ovOvrvision->GetCamWidth() * g_ovOvrvision->GetCamHeight() * g_ovOvrvision->GetCamPixelsize();
	int offsetlen = g_ovOvrvision->GetCamPixelsize();

	if (g_DeviceType == 2) {	//Direct11
#if SUPPORT_D3D11
		ID3D11DeviceContext* ctx = NULL;
		ID3D11Device* device = (ID3D11Device*)g_D3D11Device;
		device->GetImmediateContext(&ctx);

		D3D11_TEXTURE2D_DESC desc_left, desc_right;
		ID3D11Texture2D* d3dtex_left = (ID3D11Texture2D*)pTexPtr_Left;
		ID3D11Texture2D* d3dtex_right = (ID3D11Texture2D*)pTexPtr_Right;

		d3dtex_left->GetDesc(&desc_left);
		d3dtex_right->GetDesc(&desc_right);

		ctx->UpdateSubresource(d3dtex_left, 0, NULL, pLeft, g_ovOvrvision->GetCamWidth() * offsetlen, 0);
		ctx->UpdateSubresource(d3dtex_right, 0, NULL, pRight, g_ovOvrvision->GetCamWidth() * offsetlen, 0);

		ctx->Release();
#endif
	}
	else if (g_DeviceType == 1) {	//DirectX9
#if SUPPORT_D3D9
		IDirect3DTexture9* d3dtex_left = (IDirect3DTexture9*)pTexPtr_Left;
		IDirect3DTexture9* d3dtex_right = (IDirect3DTexture9*)pTexPtr_Right;
		D3DSURFACE_DESC desc_left, desc_right;
		d3dtex_left->GetLevelDesc(0, &desc_left);
		d3dtex_left->GetLevelDesc(0, &desc_right);

		D3DLOCKED_RECT lr;
		d3dtex_left->LockRect(0, &lr, NULL, 0);
		memcpy((unsigned char*)lr.pBits, pLeft, length);
		d3dtex_left->UnlockRect(0);

		d3dtex_right->LockRect(0, &lr, NULL, 0);
		memcpy((unsigned char*)lr.pBits, pRight, length);
		d3dtex_right->UnlockRect(0);
#endif
	}
	else if (g_DeviceType == 18) {	//DirectX12
#if SUPPORT_D3D12

#endif
	}
	else if (g_DeviceType == 0) {	//OpenGL
#if SUPPORT_OPENGL
        uintptr_t gltex_left = (uintptr_t)pTexPtr_Left;
        uintptr_t gltex_right = (uintptr_t)pTexPtr_Right;

		glBindTexture(GL_TEXTURE_2D, (GLuint)gltex_left);
		glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, g_ovOvrvision->GetCamWidth(), g_ovOvrvision->GetCamHeight(), GL_BGRA_EXT, GL_UNSIGNED_BYTE, pLeft);
		glBindTexture(GL_TEXTURE_2D, (GLuint)gltex_right);
		glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, g_ovOvrvision->GetCamWidth(), g_ovOvrvision->GetCamHeight(), GL_BGRA_EXT, GL_UNSIGNED_BYTE, pRight);
#endif
	}
	else if (g_DeviceType == 17) {	//OpenGLCore
#if SUPPORT_OPENGL
		uintptr_t gltex_left = (uintptr_t)pTexPtr_Left;
		uintptr_t gltex_right = (uintptr_t)pTexPtr_Right;

		glBindTexture(GL_TEXTURE_2D, gltex_left);
		glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, g_ovOvrvision->GetCamWidth(), g_ovOvrvision->GetCamHeight(), GL_RGBA, GL_UNSIGNED_BYTE, pLeft);
		glBindTexture(GL_TEXTURE_2D, gltex_right);
		glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, g_ovOvrvision->GetCamWidth(), g_ovOvrvision->GetCamHeight(), GL_RGBA, GL_UNSIGNED_BYTE, pRight);
#endif
	}
}
//for GL.IssuePluginEvent
static void __stdcall ovGetCamImageForUnityNativeEvent(int eventID)
{
	ovGetCamImageForUnityNative(g_callTexture2DLeft, g_callTexture2DRight);
}
CSHARP_EXPORT UnityRenderNative __stdcall ovGetCamImageForUnityNativeGLCall(void* pTexPtr_Left, void* pTexPtr_Right)
{
	g_callTexture2DLeft = pTexPtr_Left;
	g_callTexture2DRight = pTexPtr_Right;
	return ovGetCamImageForUnityNativeEvent;
}

//This method will be detected if a hand is put in front of a camera. 
CSHARP_EXPORT int ovPutHandInFrontOfCamera(unsigned char thres_less, unsigned char* pImageBuf)
{
	return 0;// (int)g_ovOvrvision->PutHandInFrontOfCamera(thres_less, pImageBuf);
}

//Get image width
CSHARP_EXPORT int ovGetImageWidth()
{
	if(g_ovOvrvision==NULL)
		return 0;

	return g_ovOvrvision->GetCamWidth();
}

//Get image height
CSHARP_EXPORT int ovGetImageHeight()
{
	if(g_ovOvrvision==NULL)
		return 0;

	return g_ovOvrvision->GetCamHeight();
}

//Get image framerate
CSHARP_EXPORT int ovGetImageRate()
{
	if(g_ovOvrvision==NULL)
		return 0;

	return g_ovOvrvision->GetCamFramerate();
}

//Get buffer size
CSHARP_EXPORT int ovGetBufferSize()
{
	if(g_ovOvrvision==NULL)
		return 0;

	return g_ovOvrvision->GetCamBuffersize();
}

//Get buffer size
CSHARP_EXPORT int ovGetPixelSize()
{
	if (g_ovOvrvision == NULL)
		return 0;

	return g_ovOvrvision->GetCamPixelsize();
}

//Set exposure
CSHARP_EXPORT void ovSetExposure(int value)
{
	if(g_ovOvrvision==NULL)
		return;

	g_ovOvrvision->SetCameraExposure(value);
}
//Set exposure per sec
CSHARP_EXPORT int ovSetExposurePerSec(float fps)
{
	if (g_ovOvrvision == NULL)
		return 0;

	return g_ovOvrvision->SetCameraExposurePerSec(fps);
}


//Set gain
CSHARP_EXPORT void ovSetGain(int value)
{
	if(g_ovOvrvision==NULL)
		return;

	g_ovOvrvision->SetCameraGain(value);
}

//Set WhiteBalanceR ( manual only )
CSHARP_EXPORT void ovSetWhiteBalanceR(int value)
{
	if(g_ovOvrvision==NULL)
		return;

	g_ovOvrvision->SetCameraWhiteBalanceR(value);
}

//Set WhiteBalanceG ( manual only )
CSHARP_EXPORT void ovSetWhiteBalanceG(int value)
{
	if(g_ovOvrvision==NULL)
		return;

	g_ovOvrvision->SetCameraWhiteBalanceG(value);
}

//Set WhiteBalanceB ( manual only )
CSHARP_EXPORT void ovSetWhiteBalanceB(int value)
{
	if(g_ovOvrvision==NULL)
		return;

	g_ovOvrvision->SetCameraWhiteBalanceB(value);
}

//Set WhiteBalance Auto
CSHARP_EXPORT void ovSetWhiteBalanceAuto(int value)
{
	if (g_ovOvrvision == NULL)
		return;

	g_ovOvrvision->SetCameraWhiteBalanceAuto((bool)value);
}

//Set Backlight Compensation
CSHARP_EXPORT void ovSetBLC(int value)
{
	if (g_ovOvrvision == NULL)
		return;

	g_ovOvrvision->SetCameraBLC(value);
}

//Set Camera SyncMode
CSHARP_EXPORT void ovSetCamSyncMode(int value)
{
	if (g_ovOvrvision == NULL)
		return;

	g_ovOvrvision->SetCameraSyncMode((bool)value);
}

//Get exposure
CSHARP_EXPORT int ovGetExposure()
{
	if(g_ovOvrvision==NULL)
		return 0;

	return g_ovOvrvision->GetCameraExposure();
}

//Get gain
CSHARP_EXPORT int ovGetGain()
{
	if(g_ovOvrvision==NULL)
		return 0;

	return g_ovOvrvision->GetCameraGain();
}

//Get whiteBalanceR
CSHARP_EXPORT int ovGetWhiteBalanceR()
{
	if(g_ovOvrvision==NULL)
		return 0;

	return g_ovOvrvision->GetCameraWhiteBalanceR();
}

//Get whiteBalanceG
CSHARP_EXPORT int ovGetWhiteBalanceG()
{
	if(g_ovOvrvision==NULL)
		return 0;

	return g_ovOvrvision->GetCameraWhiteBalanceG();
}

//Get whiteBalanceB
CSHARP_EXPORT int ovGetWhiteBalanceB()
{
	if(g_ovOvrvision==NULL)
		return 0;

	return g_ovOvrvision->GetCameraWhiteBalanceB();
}

CSHARP_EXPORT int ovGetWhiteBalanceAuto()
{
	if (g_ovOvrvision == NULL)
		return 0;

	return (int)g_ovOvrvision->GetCameraWhiteBalanceAuto();
}

//Get Backlight Compensation
CSHARP_EXPORT int ovGetBLC()
{
	if (g_ovOvrvision == NULL)
		return 0;

	return g_ovOvrvision->GetCameraBLC();
}

//Get focalPoint
CSHARP_EXPORT float ovGetFocalPoint()
{
	if(g_ovOvrvision==NULL)
		return 0;

	return g_ovOvrvision->GetCamFocalPoint();
}

//Get HMD Right-eye Gap
CSHARP_EXPORT float ovGetHMDRightGap(int at)
{
	if(g_ovOvrvision==NULL)
		return 0;

	return g_ovOvrvision->GetHMDRightGap(at);
}


//Save parameter
CSHARP_EXPORT int ovSaveCamStatusToEEPROM()
{
	if(g_ovOvrvision==NULL)
		return 0;

	return g_ovOvrvision->CameraParamSaveEEPROM();
}

CSHARP_EXPORT void* ovOvrvisionProObject()
{
	return (void*)g_ovOvrvision;
}

////////////// Ovrvision AR //////////////

// void ovARRender(void)
CSHARP_EXPORT void ovARRender()
{
	if(g_ovOvrvisionAR==NULL)
		return;

	unsigned char* pLeft = g_ovOvrvision->GetCamImageBGRA(OVR::OV_CAMEYE_LEFT);
	g_ovOvrvisionAR->SetImageBGRA(pLeft);

	//Rendering
	g_ovOvrvisionAR->Render();
}

// int ovARGetData(float* mdata, int datasize) : mdata*FLOATDATA_DATA_OFFSET(10)
CSHARP_EXPORT int ovARGetData(float* mdata, int datasize)
{
	int i;
	if(g_ovOvrvisionAR==NULL)
		return (-1);

	if (mdata == NULL)
		return (-1);

	int marklen = g_ovOvrvisionAR->GetMarkerDataSize();
	OVR::OvMarkerData* dt = g_ovOvrvisionAR->GetMarkerData();

	for(i = 0; i < marklen; i++)
	{
		int ioffset = i * FLOATDATA_DATA_OFFSET;
		if(i >= (datasize / FLOATDATA_DATA_OFFSET))
			break;

		mdata[ioffset+0] = (float)dt[i].id;
		mdata[ioffset+1] = dt[i].translate.x;
		mdata[ioffset+2] = dt[i].translate.y;
		mdata[ioffset+3] = dt[i].translate.z;
		mdata[ioffset+4] = dt[i].quaternion.x;
		mdata[ioffset+5] = dt[i].quaternion.y;
		mdata[ioffset+6] = dt[i].quaternion.z;
		mdata[ioffset+7] = dt[i].quaternion.w;
		mdata[ioffset+8] = dt[i].centerPtOfImage.x;
		mdata[ioffset+9] = dt[i].centerPtOfImage.y;
	}

	return marklen;	//S_OK
}

// void ovARSetMarkerSize(float value)
CSHARP_EXPORT void ovARSetMarkerSize(float value)
{
	if(g_ovOvrvisionAR==NULL)
		return;

	g_ovOvrvisionAR->SetMarkerSizeMeter(value);
}

// float ovARGetMarkerSize()
CSHARP_EXPORT float ovARGetMarkerSize()
{
	if(g_ovOvrvisionAR==NULL)
		return 0;

	return g_ovOvrvisionAR->GetMarkerSizeMeter();
}

// void ov3DInstantTraking_Metaio(int value)
CSHARP_EXPORT void ov3DInstantTraking_Metaio(int value)
{
	if(g_ovOvrvisionAR==NULL)
		return;

	g_ovOvrvisionAR->SetInstantTraking((bool)value);
}

////////////// Ovrvision Tracking //////////////

// ovTrackRender
CSHARP_EXPORT void ovTrackRender(bool calib, bool point)
{
	if (g_ovOvrvisionTrack == NULL)
		return;

	unsigned char* pLeft = g_ovOvrvision->GetCamImageBGRA(OVR::OV_CAMEYE_LEFT);
	unsigned char* pRight = g_ovOvrvision->GetCamImageBGRA(OVR::OV_CAMEYE_RIGHT);
	g_ovOvrvisionTrack->SetImageBGRA(pLeft, pRight);

	g_ovOvrvisionTrack->Render(calib, point);
}

CSHARP_EXPORT int ovGetTrackData(float* mdata)
{
	if (g_ovOvrvisionTrack == NULL)
		return 0 ;

	if (mdata == NULL)
		return (-1);

	mdata[0] = g_ovOvrvisionTrack->FingerPosX();
	mdata[1] = g_ovOvrvisionTrack->FingerPosY();
	mdata[2] = g_ovOvrvisionTrack->FingerPosZ();

	if (mdata[2] <= 0.0f || mdata[2] >= 1.0f)	//z0.0~1.0
		return 0;

	return 1;
}

CSHARP_EXPORT void ovTrackingCalibReset()
{
	if (g_ovOvrvisionTrack == NULL)
		return;

	g_ovOvrvisionTrack->SetHue();
}

////////////// Ovrvision Calibration //////////////

CSHARP_EXPORT void ovCalibInitialize(int pattern_size_w, int pattern_size_h, double chessSizeMM)
{
	if(g_ovOvrvision == NULL)
		return;

	if(g_ovOvrvisionCalib)
		delete g_ovOvrvisionCalib;

	g_ovOvrvisionCalib = new OVR::OvrvisionCalibration(
		g_ovOvrvision->GetCamWidth(),g_ovOvrvision->GetCamHeight(),
		pattern_size_w,pattern_size_h,chessSizeMM);
}

CSHARP_EXPORT void ovCalibClose()
{
	if (g_ovOvrvisionCalib)
		delete g_ovOvrvisionCalib;
}

CSHARP_EXPORT int ovCalibFindChess()
{
	if(g_ovOvrvisionCalib == NULL)
		return 0;

	g_ovOvrvision->PreStoreCamData(OVR::OV_CAMQT_DMS);	//ReRenderer
	unsigned char* pLeft = g_ovOvrvision->GetCamImageBGRA(OVR::OV_CAMEYE_LEFT);
	unsigned char* pRight = g_ovOvrvision->GetCamImageBGRA(OVR::OV_CAMEYE_RIGHT);

	return g_ovOvrvisionCalib->FindChessBoardCorners(pLeft, pRight);
}

CSHARP_EXPORT void ovCalibSolveStereoParameter(bool param_output)
{
	if (g_ovOvrvision == NULL)
		return;
	if(g_ovOvrvisionCalib == NULL)
		return;

	g_ovOvrvisionCalib->SolveStereoParameter();
	g_ovOvrvisionCalib->SaveCalibrationParameter(g_ovOvrvision, param_output);	//default 
	//g_ovOvrvisionCalib->SaveCalibrationParameterToEEPROM();
}

CSHARP_EXPORT int ovCalibGetImageCount()
{
	if(g_ovOvrvisionCalib == NULL)
		return -1;

	return g_ovOvrvisionCalib->GetImageCount();
}


#ifdef __cplusplus
}
#endif
