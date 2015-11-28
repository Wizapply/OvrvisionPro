// ovrvision_pro.h
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
#include "ovrvision_ds.h"	//!DirectShow
#include "ovrvision_avf.h"	//!AVFoundation

#include "OvrvisionProCL.h"	//!OpenCL Engine
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

//! OvrvisionSDK Group
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

typedef struct {
	int offsetX, offsetY;
	unsigned int width, height;
} ROI;

//unsigned char to byte
typedef unsigned char byte;
typedef unsigned char* pbyte;

/////////// CLASS ///////////

//! OvrvisionPro class
class OVRPORT OvrvisionPro
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
		@return If successful, the return value is 0< */
	int Open(int locationID, OVR::Camprop prop);
	/*!	@brief Close the Ovrvision Pro */
	void Close();

	//Processor
	/*!	@brief This function gets data from OvrvisionPro inside. 
		@param qt Image processing@qality */
	void PreStoreCamData(OVR::Camqt qt);
	/*!	@brief Gets the image data of 32 bits of BGRA form. 
		@param eye OV_CAMEYE_LEFT or OV_CAMEYE_RIGHT  */
	unsigned char* GetCamImageBGRA(OVR::Cameye eye);
	/*!	@brief This function gets data from OvrvisionPro inside.
		@param pImageBuf Image buffer pointer
		@param eye OV_CAMEYE_LEFT or OV_CAMEYE_RIGHT */
	void GetCamImageBGRA(unsigned char* pImageBuf, OVR::Cameye eye);

	/*!	@brief Capture frame and hold it in GPU for image processing(Grayscale, Skin color extraction etc.)
		@param qt Image processing@qality */
	void Capture(OVR::Camqt qt);
	/*!	@brief Get camera image region of interest
		@param pLeft Image buffer pointer for left eye
		@param pRight Image buffer pointer for right eye
		@param roi ROI */
	void GetStereoImageBGRA(unsigned char* pLeft, unsigned char* pRight, ROI roi);

	/*!	@brief Check whether OvrvisionPro is open. 
		@return If open, It is true */
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
	void SetCameraWhiteBalanceR(int value);
	int GetCameraWhiteBalanceG();
	void SetCameraWhiteBalanceG(int value);
	int GetCameraWhiteBalanceB();
	void SetCameraWhiteBalanceB(int value);
	int GetCameraBLC();
	void SetCameraBLC(int value);

	bool GetCameraWhiteBalanceAuto();
	void SetCameraWhiteBalanceAuto(bool value);

	//Thread sync
	void SetCameraSyncMode(bool value);

	//Parameter EEPROM
	void UserDataAccessUnlock();
	void UserDataAccessLock();
	void UserDataAccessSelectAddress(unsigned int addr);
	unsigned char UserDataAccessGetData();
	void UserDataAccessSetData(unsigned char value);
	void UserDataAccessSave();
	void UserDataAccessCheckSumAddress();

	//Save the present setup to EEPROM. 
	bool CameraParamSaveEEPROM();

	//Get OpenCL extensions of GPU
	int OpenCLExtensions(int(*callback)(void *, const char *), void *item);

	// Grayscaled images
	void GrayscaleHalf(unsigned char *left, unsigned char *right);		// 1/2 scaled
	void GrayscaleFourth(unsigned char *left, unsigned char *right);	// 1/4 scaled
	void GrayscaleEighth(unsigned char *left, unsigned char *right);	// 1/8 scaled

#ifdef _WIN32
	// Create D3D11 texture
	void* CreateD3DTexture2D(void *texture, int width, int height);
#endif

	// Create OpenGL Texture
	void* CreateGLTexture2D(unsigned int texture, int width, int height);

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

	//Frame buffer
	unsigned short*			m_pFrame;

	//Pixels
	byte*			m_pPixels[OV_CAMNUM];

	//Camera status data
	int				m_width;
	int				m_height;
	int				m_framerate;
	float			m_focalpoint;
	float			m_rightgap[3];	//vector

	bool			m_isOpen;
	bool			m_isCameraSync;

	//initialize setting
	void InitCameraSetting();
};

};

#endif /*__OVRVISION_PRO__*/
