// ovrvisionPro.h
// Version 1.00 : 1/Dec/2015
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

#ifndef __OVRVISION_PRO__
#define __OVRVISION_PRO__

/////////// INCLUDE ///////////

//Pratform header
#ifdef WIN32
#ifndef _WIN32_WINNT
#define _WIN32_WINNT 0x400
#endif
#include <windows.h>
#endif /*WIN32*/

#ifdef MACOSX

#endif	/*MACOSX*/
	
#ifdef LINUX

#endif	/*LINUX*/

//Common header
#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <string.h>

#ifdef _OVRVISION_EXPORTS	//in ovrvision
#include "ovrvision_ds.h"	//DirectShow
#include "ovrvision_avf.h"	//AVFoundation
#include "OvrvisionProCL.h"	//OpenCL Engine
#else
//USB cameras driver
#ifdef WIN32
class OvrvisionDirectShow;
#elif MACOSX
#define OvrvisionAVFoundation   void
#elif LINUX

#endif
//opencl class
class OvrvisionProOpenCL;
#endif /*_OVRVISION_EXPORTS*/

//OVR Group
namespace OVR {

/////////// VARS AND DEFS ///////////

#ifdef WIN32
    #ifdef _OVRVISION_EXPORTS
    #define OVRPORT __declspec(dllexport)
    #else
    #define OVRPORT __declspec(dllimport)
    #endif
#endif /*WIN32*/
    
#ifdef MACOSX
    #define OVRPORT 
#endif	/*MACOSX*/
	
#ifdef LINUX
    
#endif	/*LINUX*/

//Left or Right camera.
#ifndef _OV_CAMEYE_ENUM_
#define _OV_CAMEYE_ENUM_
typedef enum ov_cameraeye {
	OV_CAMEYE_LEFT = 0,		//Left camera
	OV_CAMEYE_RIGHT,		//Right camera
	OV_CAMNUM,
} Cameye;
#endif

//Open Flags
typedef enum ov_cameraprop {
	OV_CAM5MP_FULL = 0,		//2560x1920 @15fps x2
	OV_CAM5MP_FHD,			//1920x1080 @30fps x2
	OV_CAMHD_FULL,			//1280x960  @45fps x2
	OV_CAMVR_FULL, 			//960x950   @60fps x2
	OV_CAMVR_WIDE,			//1280x800  @60fps x2
	OV_CAMVR_VGA,			//640x480   @90fps x2

	OV_CAM20HD_FULL,		//1280x960 @15fps x2
	OV_CAM20VR_VGA,			//640x480  @30fps x2
} Camprop;

//Open Flags
typedef enum ov_cameraquality {
	OV_CAMQT_DMSRMP = 0,	//Demosaic & Remap
	OV_CAMQT_DMS,			//Demosaic
	OV_CAMQT_NONE,			//None
} Camqt;

//unsigned char to byte
typedef unsigned char byte;
typedef unsigned char* pbyte;

//File path
#define OV_DEFAULT_SETTING_FILEPATH		"ovrvision_conf2.xml"

/////////// CLASS ///////////

//Ovrvision
class OVRPORT OvrvisionPro
{
public:
	//Constructor/Destructor
	OvrvisionPro();
	~OvrvisionPro();

	//Initialize
	//Open the Ovrvision
	int Open(int locationID, OVR::Camprop prop);
	//Close the Ovrvision
	void Close();

	void PreStoreCamData(OVR::Camqt qt);
	unsigned char* GetCamImageBGRA(OVR::Cameye eye);
	void GetCamImageBGRA(unsigned char* pImageBuf, OVR::Cameye eye);

	bool isOpen();

	//Propaty
	int GetCamWidth();
	int GetCamHeight();
	int GetCamFramerate();
	float GetCamFocalPoint();
	float GetHMDRightGap(int at);

	int GetCamBuffersize();
	int GetCamPixelsize();

	//Camera Propaty
	int GetCameraExposure();
	void SetCameraExposure(int value);

	int GetCameraGain();
	void SetCameraGain(int value);

	int GetCameraWhiteBalanceR();
	void GetCameraWhiteBalanceR(int value);
	int GetCameraWhiteBalanceG();
	void GetCameraWhiteBalanceG(int value);
	int GetCameraWhiteBalanceB();
	void GetCameraWhiteBalanceB(int value);

private:
#ifdef WIN32
	//DirectShow
	OvrvisionDirectShow*	m_pODS;
#elif MACOSX
	OvrvisionAVFoundation*  m_pOAV;
#elif LINUX
	//NONE
#endif

	//OpenCL Ovrvision System
	OvrvisionProOpenCL* m_pOpenCL;

	//Pixels
	byte*			m_pPixels[OV_CAMNUM];

	//Camera status data
	int				m_width;
	int				m_height;
	int				m_framerate;
	float			m_focalpoint;
	float			m_rightgap[3];	//vector

	bool			m_isOpen;
};

};

#endif /*__OVRVISION_PRO__*/
