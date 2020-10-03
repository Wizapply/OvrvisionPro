// ovrvision_pro.h
// Version 1.62 : 22/Mar/2016
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
#if defined(WIN32)
#include "ovrvision_ds.h"	//!DirectShow
#elif defined(MACOSX)
#include "ovrvision_avf.h"	//!AVFoundation
#elif defined(LINUX)
#include "ovrvision_v4l.h"	//!Video4Linux
#endif
#include "OvrvisionProCL.h"	//!OpenCL Engine
#else
//USB cameras driver
#ifdef WIN32
class OvrvisionDirectShow;
#elif defined(MACOSX)
#define OvrvisionAVFoundation   void
#elif defined(LINUX)
class OvrvisionVideo4Linux;
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
	#define OVRPORT
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

//! ROI
typedef struct {
	int offsetX;			//!OffsetX
	int offsetY;			//!OffsetY
	unsigned int width;		//!Width
	unsigned int height;	//!Height
} ROI;

//Sensor Define
const double SensorSizeWidth = 4.529;
const double SensorSizeHeight = 3.423;
const double SensorSizeScale = 0.7;

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
		@param pVendorName c style string with the vendor name ("NVIDIA Corporation", "Intel(R) Corporation", )
        @param deviceType (2:D3D11, 0:OpenGL, -1:Dont share)
		@param pD3D11Device ptr to D3D11 device when deviceType == 2
		@return If successful, the return value is 0< */
	int Open(int locationID, OVR::Camprop prop, const char *pVendorName = NULL, int deviceType = -1, void *pD3D11Device = NULL);
	/*!	@brief Close the Ovrvision Pro */
	void Close();

	//Processor
	/*!	@brief This function gets data from OvrvisionPro inside. 
		@param qt Set an image processing method. */
	void PreStoreCamData(OVR::Camqt qt);
	/*!	@brief Gets the image data of 32 bits of BGRA form. 
		@param eye OV_CAMEYE_LEFT or OV_CAMEYE_RIGHT  */
	unsigned char* GetCamImageBGRA(OVR::Cameye eye);
	/*!	@brief This function gets data from OvrvisionPro inside.
		@param pImageBuf Image buffer pointer
		@param eye OV_CAMEYE_LEFT or OV_CAMEYE_RIGHT */
	void GetCamImageBGRA(unsigned char* pImageBuf, OVR::Cameye eye);


	//Callback
	void SetCallbackImageFunction(void(*func)());

	/*!	@brief Get camera image region of interest
		@param pLeft Image buffer pointer for left eye
		@param pRight Image buffer pointer for right eye
		@param roi ROI */
	void GetStereoImageBGRA(unsigned char* pLeft, unsigned char* pRight, ROI roi);

	/*!	@brief Check whether OvrvisionPro is open. 
		@return If open, It is true */
	bool isOpen();

	//Propaty
	/*!	@brief Get the width of the Ovrvision image. 
		@return pixel size. */
	int GetCamWidth();
	/*!	@brief Get the height of the Ovrvision image.
		@return pixel size. */
	int GetCamHeight();
	/*!	@brief Get the framerate of the Ovrvision.
		@return fps */
	int GetCamFramerate();
	/*!	@brief Get the focal point of the Ovrvision image.
		@return focal point */
	float GetCamFocalPoint();
	/*!	@brief Get the gap between images for HMD. 
		@return value */
	float GetHMDRightGap(int at);

	/*!	@brief Get the buffer size of the Ovrvision image.
		@return size */
	int GetCamBuffersize();
	/*!	@brief Get the pixel data size. default is BGRA 4 byte
		@return size */
	int GetCamPixelsize();

	//Camera Propaty
	/*!	@brief Get exposure value of the Ovrvision.
		@return Exposure time. */
	int GetCameraExposure();
	/*!	@brief Set exposure of the Ovrvision.
		@param value Exposure time. Range of 0 - 32767 */
	void SetCameraExposure(int value);
	/*!	@brief Set exposure of the Ovrvision.
		@param value Exposure time per Sec. 60Hz Range of 30 - 240 frame, 50Hz Range of 25 - 200 frame
		@return error, true or false */
	bool SetCameraExposurePerSec(float fps);
	/*!	@brief Get gain value of the Ovrvision.
		@return gain value. */
	int GetCameraGain();
	/*!	@brief Set gain of the Ovrvision.
		@param value gain. Range of 0 - 47 */
	void SetCameraGain(int value);
	/*!	@brief Set white balance gain of the Ovrvision.
		@param value gain. Range of 1000K - 12000K */
	void SetCameraWhiteBalanceKelvin(int kelvin);
	/*!	@brief Get white balance R gain value of the Ovrvision.
		@return R gain value. */
	int GetCameraWhiteBalanceR();
	/*!	@brief Set white balance R gain of the Ovrvision.
		@param value R gain. Range of 0 - 4095 */
	void SetCameraWhiteBalanceR(int value);
	/*!	@brief Get white balance G gain value of the Ovrvision.
		@return G gain value. */
	int GetCameraWhiteBalanceG();
	/*!	@brief Set white balance G gain of the Ovrvision.
		@param value G gain. Range of 0 - 4095 */
	void SetCameraWhiteBalanceG(int value);
	/*!	@brief Get white balance B gain value of the Ovrvision.
		@return B gain value. */
	int GetCameraWhiteBalanceB();
	/*!	@brief Set white balance B gain of the Ovrvision.
		@param value B gain. Range of 0 - 4095 */
	void SetCameraWhiteBalanceB(int value);
	/*!	@brief Set backlight compensation(BLC) value of the Ovrvision.
		@return blc value. */
	int GetCameraBLC();
	/*!	@brief Set backlight compensation(BLC) of the Ovrvision.
		@param value BLC. Range of 0 - 255 */
	void SetCameraBLC(int value);

	/*!	@brief Get automatic mode of the Ovrvision White Balance.
		@return It is true or false. */
	bool GetCameraWhiteBalanceAuto();
	/*!	@brief Set automatic mode of the Ovrvision White Balance.
		@param value Mode.*/
	void SetCameraWhiteBalanceAuto(bool value);

	/*!	@brief Set sync mode for the Ovrvision.
		@param value True is sync mode. */
	void SetCameraSyncMode(bool value);

	/*!	@brief Get OpenCL extensions of GPU */
	int OpenCLExtensions(int(*callback)(void *, const char *), void *item);

	// Grayscale image
	/*!	@brief Grayscaled image of 1/2 scaled */
	void Grayscale(unsigned char *left, unsigned char *right);		// 1/1 scaled
	/*!	@brief Grayscaled image of 1/2 scaled */
	void GrayscaleHalf(unsigned char *left, unsigned char *right);		// 1/2 scaled
	/*!	@brief Grayscaled image of 1/4 scaled */
	void GrayscaleFourth(unsigned char *left, unsigned char *right);	// 1/4 scaled
	/*!	@brief Grayscaled image of 1/8 scaled */
	void GrayscaleEighth(unsigned char *left, unsigned char *right);	// 1/8 scaled

	//Parameter EEPROM (Don't touch)
	void UserDataAccessUnlock();
	void UserDataAccessLock();
	void UserDataAccessSelectAddress(unsigned int addr);
	unsigned char UserDataAccessGetData();
	void UserDataAccessSetData(unsigned char value);
	void UserDataAccessSave();
	void UserDataAccessCheckSumAddress();
	//Save the present setup to EEPROM. (Don't touch)
	bool CameraParamSaveEEPROM();
	bool CameraParamResetEEPROM();

	// GPU texture
	/*! @brief Create Skin textures
		@param width of texture
		@param height of texture
		@param left texture
		@param right texure 

		/////////////////////////////////////////////////////////////////////////////////////
		// How to Create GPU texture and Update texture

		// Set scale 1/2 and get its size
		OVR::ROI size = ovrvision.SetSkinScale(2); 

		D3D11_TEXTURE2D_DESC desc = {
			size.width,					// Width
			size.height,				// Height
			1,							// MipLevels
			1,							// ArraySize
			DXGI_FORMAT_R8G8B8A8_UINT,	// Format, BE CAREFUL
			{ 1 },						// SampleDesc.Count
			D3D11_USAGE_DEFAULT,		// Usage
		};

		// Create Textures
		ID3D11Texture2D *pTextures[2];
		res = DIRECTX.Device->CreateTexture2D(&desc, NULL, &pTextures[0]);
		res = DIRECTX.Device->CreateTexture2D(&desc, NULL, &pTextures[1]);

		// Create GPU sharing textures
		ovrvision.CreateSkinTextures(size.width, size.height, pTextures[0], pTextures[1]);
		/////////////////////////////////////////////////////////////////////////////////////
	*/
	void CreateSkinTextures(int width, int height, unsigned int left, unsigned int right);
#ifdef WIN32
	void CreateSkinTextures(int width, int height, void* left, void* right); // for D3D11
#endif
    
	/*!	@brief Capture frame and hold it in GPU for image processing(Grayscale, Skin color extraction etc.)
		@param qt Set an image processing method. */
	void Capture(OVR::Camqt qt);

	/*! @brief Update skin textures
		@param n count of onjects
		@param textureObjects 

		/////////////////////////////////////////////////////////////////////////////////////
		// Capture image and hold it only in GPU
		ovrvision.Capture(OVR::Camqt::OV_CAMQT_DMSRMP);
		// Update textures
		ovrvision.UpdateSkinTextures(pTextures[0], pTextures[1]);
		/////////////////////////////////////////////////////////////////////////////////////
	*/
	void UpdateSkinTextures(unsigned int left, unsigned int right);
	void UpdateImageTextures(unsigned int left, unsigned int right);
#ifdef  WIN32
	void UpdateSkinTextures(void* left, void* right);   // for D3D11
	void UpdateImageTextures(void* left, void* right);
#endif

    
	// Skin property
	/*! @brief Set Skin image scale
		@param scale (2, 4, 8) of scale dominant
		@return size of scaled image */
	ROI SetSkinScale(unsigned int scale);

	/*! @brief Get scaled images while calibration
		@param left ptr to buffer
		@param right ptr to buffer
		@return true when calibration done */
	bool GetScaledImageRGBA(unsigned char *left, unsigned char *right);

	/*! @brief Get Skin images
		@param pLeft Image buffer pointer (RGBA IMAGE)
		@param pRight Image buffer pointer (RGBA IMAGE) */
	void GetSkinImage(unsigned char* pLeft, unsigned char* pRight);

	/*! @brief Detect color range
		@param frames sampling frame */
	void DetectHand(int frames);

	/*! @brief Get skin color region
		@param left image (MONOCHROME MASK)
		@param right image (MONOCHROME MASK)
		@return scale (2, 4) */
	int SkinRegion(unsigned char* left, unsigned char* right);

	/*! @brief set HSV region for SkinRegion
		@param h_low (0 < h_low < h_high)
		@param h_high (h_low < h_high < 180)
		@param s_low (0 < s_low < s_high)
		@param s_high (s_low < s_high < 256) */
	void SetSkinHSV(int h_low, int h_high, int s_low, int s_high);

	/*! @brief set HSV region for SkinRegion
		@param range[0]:h_low (0 < h_low < h_high)
		@param range[1]:h_high (h_low < h_high < 180)
		@param range[2]:s_low (0 < s_low < s_high)
		@param range[3]:s_high (s_low < s_high < 256) */
	void SetSkinHSV(int range[4]);

	/*! @brief set skin threshold to extract region
		@param threshold (0..255)
		@return previous threshold */
	int SetSkinThreshold(int threshold);

	/*! @brief Get color histgram in HSV space
		@param HSV histgram (256S x 180H)
		@return scale (2, 4) */
	int ColorHistgram(unsigned char* histgram);

	/*! @brief UNDER CONSTRUCTION */
	void GetStereoImageHSV(unsigned char* pLeft, unsigned char* pRight);

	void InspectTextures(unsigned char *left, unsigned char *right, unsigned int type = 0);

	/*! @brief Check GPU specification 
		@return true if satisfaied for OrvisionPro */
	static bool CheckGPU();

private:
#ifdef WIN32
	//DirectShow
	OvrvisionDirectShow*	m_pODS;
#elif defined(MACOSX)
	OvrvisionAVFoundation*  m_pOAV;
#elif defined(LINUX)
	OvrvisionVideo4Linux*	m_pOV4L;
#endif

	//OpenCL Ovrvision System
	OvrvisionProOpenCL* m_pOpenCL;

	//Frame buffer
	unsigned short*	m_pFrame;

	//Pixels
	byte*			m_pPixels[OV_CAMNUM];

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

};

#endif /*__OVRVISION_PRO__*/
