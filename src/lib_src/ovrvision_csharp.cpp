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
#include "ovrvision_setting.h"
#include "ovrvision_calibration.h"
#elif MACOSX
//config gdata class
#include "ovrvision_setting.h"
#include "ovrvision_calibration.h"
#undef _OVRVISION_EXPORTS
#include "ovrvision_pro.h"
#include "ovrvision_ar.h"
#endif

/////////// VARS AND DEFS ///////////

//Exporter
#ifdef WIN32
#define CSHARP_EXPORT __declspec(dllexport)
#elif MACOSX
#define CSHARP_EXPORT 
#endif

//AR deta size
#define FLOATDATA_DATA_OFFSET	(10)

//Main Ovrvision Object
static OVR::OvrvisionPro* g_ovOvrvision = NULL;	// Always open
//AR Ovrvision Object
static OVR::OvrvisionAR* g_ovOvrvisionAR = NULL;
//Calibration Ovrvision Object
static OVR::OvrvisionCalibration* g_ovOvrvisionCalib = NULL;

/////////// EXPORT FUNCTION ///////////

//C language
#ifdef __cplusplus
extern "C" {
#endif

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

	return 0;	//OK
}

// int ovClose(void)
CSHARP_EXPORT int ovClose(void)
{
	//Delete
	if(g_ovOvrvision==NULL)
		return 1;

	//Close Ovrvision
	g_ovOvrvision->Close();

	if(g_ovOvrvisionAR) {
		delete g_ovOvrvisionAR;
		g_ovOvrvisionAR = NULL;
	}

	delete g_ovOvrvision;
	g_ovOvrvision = NULL;

	return 0;	//OK
}

// int ovPreStoreCamData() -> need ovGetCamImage : ovGetCamImageBGR
CSHARP_EXPORT void ovPreStoreCamData(int qt)
{
	g_ovOvrvision->PreStoreCamData((OVR::Camqt)qt);	//Renderer

}

// int ovGetCamImage(unsigned char* pImage, int eye, int qt)
CSHARP_EXPORT void ovGetCamImageBGRA(unsigned char* pImage, int eye, int useAR)
{
	if(g_ovOvrvision==NULL)
		return;

	//Get image
	g_ovOvrvision->GetCamImageBGRA(pImage, (OVR::Cameye)eye);

	//AR System
	if (useAR) {
		if (g_ovOvrvisionAR != NULL) g_ovOvrvisionAR->SetImageBGRA(pImage);
	}

}
// int ovGetCamImageRGB(unsigned char* pImage, int eye, int qt)
CSHARP_EXPORT void ovGetCamImageRGB(unsigned char* pImage, int eye, int useAR)
{
	if(g_ovOvrvision==NULL)
		return;

	//local var
	int i, srcj = 0;

	//Get image
	unsigned char* pData = g_ovOvrvision->GetCamImageBGRA((OVR::Cameye)eye);

	int length = g_ovOvrvision->GetCamWidth() * g_ovOvrvision->GetCamHeight() * 3;
	int offsetlen = g_ovOvrvision->GetCamPixelsize();

	//Image copy
	for (i = 0; i < length; i += 3) {
		//Left Eye
		pImage[i + 0] = pData[srcj + 2];	//R
		pImage[i + 1] = pData[srcj + 1];	//G
		pImage[i + 2] = pData[srcj + 0];	//B
		srcj += offsetlen;
	}

	//AR System
	if (useAR) {
		if (g_ovOvrvisionAR != NULL) g_ovOvrvisionAR->SetImageBGRA(pImage);
	}
}

// int ovGetCamImageRGB(unsigned char* pImage, int eye, int qt)
CSHARP_EXPORT void ovGetCamImageBGR(unsigned char* pImage, int eye, int useAR)
{
	if (g_ovOvrvision == NULL)
		return;

	//local var
	int i, srcj = 0;

	//Get image
	unsigned char* pData = g_ovOvrvision->GetCamImageBGRA((OVR::Cameye)eye);

	int length = g_ovOvrvision->GetCamWidth() * g_ovOvrvision->GetCamHeight() * 3;
	int offsetlen = g_ovOvrvision->GetCamPixelsize();

	//Image copy
	for (i = 0; i < length; i += 3) {
		//Left Eye
		pImage[i + 0] = pData[srcj + 0];	//B
		pImage[i + 1] = pData[srcj + 1];	//G
		pImage[i + 2] = pData[srcj + 2];	//R
		srcj += offsetlen;
	}

	//AR System
	if (useAR) {
		if (g_ovOvrvisionAR != NULL) g_ovOvrvisionAR->SetImageBGRA(pImage);
	}
}

// void ovGetCamImageForUnity(unsigned char* pImagePtr_Left, unsigned char* pImagePtr_Right, int qt)
CSHARP_EXPORT void ovGetCamImageForUnity(unsigned char* pImagePtr_Left,
										 unsigned char* pImagePtr_Right, int qt, int useAR)
{
	if(g_ovOvrvision==NULL)
		return;

	//local var
	int i;

	//Get image
	g_ovOvrvision->PreStoreCamData((OVR::Camqt)qt);	//Renderer
	unsigned char* pLeft = g_ovOvrvision->GetCamImageBGRA(OVR::OV_CAMEYE_LEFT);
	unsigned char* pRight = g_ovOvrvision->GetCamImageBGRA(OVR::OV_CAMEYE_RIGHT);

	int length = g_ovOvrvision->GetCamWidth() * g_ovOvrvision->GetCamHeight() * 3;
	int offsetlen = g_ovOvrvision->GetCamPixelsize();

	//Image copy
	for (i = 0; i < length; i+=offsetlen) {
		//Left Eye
		pImagePtr_Left[i + 0] = pLeft[i + 2];	//R
		pImagePtr_Left[i + 1] = pLeft[i + 1];	//G
		pImagePtr_Left[i + 2] = pLeft[i + 0];	//B
		pImagePtr_Left[i + 3] = pLeft[i + 3];	//A
	}

	for (i = 0; i < length; i+=offsetlen) {
		//Right Eye
		pImagePtr_Right[i + 0] = pRight[i + 2];
		pImagePtr_Right[i + 1] = pRight[i + 1];
		pImagePtr_Right[i + 2] = pRight[i + 0];
		pImagePtr_Right[i + 3] = pRight[i + 3];
	}

	//AR System
	if (useAR) {
		if (g_ovOvrvisionAR != NULL) g_ovOvrvisionAR->SetImageBGRA(pLeft);
	}
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

//Set white balance
CSHARP_EXPORT void ovSetGain(int value)
{
	if(g_ovOvrvision==NULL)
		return;

	g_ovOvrvision->SetCameraGain(value);
}

//Set contrast ( manual only )
CSHARP_EXPORT void ovSetWhiteBalanceR(int value)
{
	if(g_ovOvrvision==NULL)
		return;

	g_ovOvrvision->SetCameraWhiteBalanceR(value);
}

//Set Saturation ( manual only )
CSHARP_EXPORT void ovSetWhiteBalanceG(int value)
{
	if(g_ovOvrvision==NULL)
		return;

	g_ovOvrvision->SetCameraWhiteBalanceG(value);
}

//Set brightness ( manual only )
CSHARP_EXPORT void ovSetWhiteBalanceB(int value)
{
	if(g_ovOvrvision==NULL)
		return;

	g_ovOvrvision->SetCameraWhiteBalanceB(value);
}

//Get exposure
CSHARP_EXPORT int ovGetExposure()
{
	if(g_ovOvrvision==NULL)
		return 0;

	return g_ovOvrvision->GetCameraExposure();
}

//Get white balance
CSHARP_EXPORT int ovGetGain()
{
	if(g_ovOvrvision==NULL)
		return 0;

	return g_ovOvrvision->GetCameraGain();
}

//Get contrast
CSHARP_EXPORT int ovGetWhiteBalanceR()
{
	if(g_ovOvrvision==NULL)
		return 0;

	return g_ovOvrvision->GetCameraWhiteBalanceR();
}

//Get saturation
CSHARP_EXPORT int ovGetWhiteBalanceG()
{
	if(g_ovOvrvision==NULL)
		return 0;

	return g_ovOvrvision->GetCameraWhiteBalanceG();
}

//Get brightness
CSHARP_EXPORT int ovGetWhiteBalanceB()
{
	if(g_ovOvrvision==NULL)
		return 0;

	return g_ovOvrvision->GetCameraWhiteBalanceB();
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
CSHARP_EXPORT void ovSaveCamStatusToEEPROM()
{
	if(g_ovOvrvision==NULL)
		return;

	g_ovOvrvision->SaveCamStatusToEEPROM();
}

////////////// Ovrvision AR //////////////

// ovARSetImage(unsigned char* pImgSrc)
CSHARP_EXPORT void ovARSetImageBGRA(unsigned char* pImgSrc)
{
	if(g_ovOvrvisionAR==NULL)
		return;

	g_ovOvrvisionAR->SetImageBGRA(pImgSrc);
}

// void ovARRender(void)
CSHARP_EXPORT void ovARRender()
{
	if(g_ovOvrvisionAR==NULL)
		return;

	//Rendering
	g_ovOvrvisionAR->Render();
}

// int ovARGetData(float* mdata, int datasize)
CSHARP_EXPORT int ovARGetData(float* mdata, int datasize)
{
	int i;
	if(g_ovOvrvisionAR==NULL)
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

	g_ovOvrvision->PreStoreCamData(OVR::Camqt::OV_CAMQT_DMS);	//ReRenderer
	unsigned char* pLeft = g_ovOvrvision->GetCamImageBGRA(OVR::OV_CAMEYE_LEFT);
	unsigned char* pRight = g_ovOvrvision->GetCamImageBGRA(OVR::OV_CAMEYE_RIGHT);

	return g_ovOvrvisionCalib->FindChessBoardCorners(pLeft,pRight);
}

CSHARP_EXPORT void ovCalibSolveStereoParameter()
{
	if (g_ovOvrvision == NULL)
		return;
	if(g_ovOvrvisionCalib == NULL)
		return;

	g_ovOvrvisionCalib->SolveStereoParameter();
	g_ovOvrvisionCalib->SaveCalibrationParameter(g_ovOvrvision);	//default 
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