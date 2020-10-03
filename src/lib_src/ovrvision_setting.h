// ovrvisino_undistort.h
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

#ifndef __OVRVISION_SETTING__
#define __OVRVISION_SETTING__

/////////// INCLUDE //////////

//Common header
#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <string.h>

//Marker 
#include <opencv2/opencv.hpp>
typedef cv::Mat ovMat;

//OVR Group
namespace OVR {

//for system
class OvrvisionPro;

//Left or Right camera.
#ifndef _OV_CAMEYE_ENUM_
#define _OV_CAMEYE_ENUM_
	typedef enum ov_cameraeye {
		OV_CAMEYE_LEFT = 0,		//Left camera
		OV_CAMEYE_RIGHT,		//Right camera
		OV_CAMNUM,
	} Cameye;
#endif

//WriteEEPROM flag
#define WRITE_EEPROM_FLAG_LENSPARAMWR	(0x00000001)
#define WRITE_EEPROM_FLAG_CAMERASETWR	(0x00000002)
#define WRITE_EEPROM_FLAG_ALLWR			(0x00000003)

//Version
#define EEPROM_SYSTEM_VERSION	(0x01)

/////////// CLASS ///////////

class OvrvisionSetting
{
public:
	//Constructor
	OvrvisionSetting(OvrvisionPro* system_ptr);

	//Methods
	//Read Setting
	bool ReadEEPROM();
	//Write Setting
	bool WriteEEPROM(unsigned char flag);

	//Reset Setting
	bool ResetEEPROM();

	// Calculate Undistortion Matrix
	void GetUndistortionMatrix(Cameye eye, ovMat &mapX, ovMat &mapY, int width, int height);

	//Initialize Data
	void InitValue();

	//Var
	//OK
	bool isReaded;

	//Camera Setting
	int	m_propExposure;			//Exposure
	int	m_propGain;				//Gain
	int	m_propBLC;				//BLC
	int m_propWhiteBalanceR;	//WhiteBaranceR
	int	m_propWhiteBalanceG;	//WhiteBaranceG
	int	m_propWhiteBalanceB;	//WhiteBaranceB

	char m_propWhiteBalanceAuto;

	//UndistortSetting : External variable
	cv::Size m_pixelSize;
	ovMat	m_leftCameraInstric;
	ovMat	m_rightCameraInstric;
	ovMat	m_leftCameraDistortion;
	ovMat	m_rightCameraDistortion;
	ovMat	m_R1;
	ovMat	m_R2;
	ovMat	m_trans;
	ovMat	m_focalPoint;

	cv::Rect m_leftROI;
	cv::Rect m_rightROI;

	//system
	OvrvisionPro*	m_pSystem;
};

};


#endif /*__OVRVISION_SETTING__*/
