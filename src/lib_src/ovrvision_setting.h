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

/////////// CLASS ///////////

class OvrvisionSetting
{
public:
	//Constructor
	OvrvisionSetting(OvrvisionPro* system);

	//Methods
	//Read Setting
	bool ReadEEPROM();
	//Write Setting
	bool WriteEEPROM();
	//Save status
	bool SaveStatusEEPROM();

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
	int m_propWhiteBalanceR;	//WhiteBaranceR
	int	m_propWhiteBalanceG;	//WhiteBaranceG
	int	m_propWhiteBalanceB;	//WhiteBaranceB

	//UndistortSetting : External variable
	ovMat	m_leftCameraInstric;
	ovMat	m_rightCameraInstric;
	ovMat	m_leftCameraDistortion;
	ovMat	m_rightCameraDistortion;
	ovMat	m_R1;
	ovMat	m_R2;
	ovMat	m_P1;	//nope
	ovMat	m_P2;	//nope
	ovMat	m_trans;
	float	m_focalPoint;

	//system
	OvrvisionPro*	m_pSystem;
};

};


#endif /*__OVRVISION_SETTING__*/
