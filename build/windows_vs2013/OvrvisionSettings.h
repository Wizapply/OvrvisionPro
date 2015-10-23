#ifndef __OVRVISION_SETTING__
#define __OVRVISION_SETTING__

#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <string.h>

//#ifdef _OVRVISION_EXPORTS
//#define OVRVISIONPRODLL_API __declspec(dllexport)
//#else
//#define OVRVISIONPRODLL_API __declspec(dllimport)
//#endif

//Marker 
#ifdef _OVRVISION_EXPORTS  
#include <opencv2/opencv.hpp>
typedef cv::Mat ovMat;
#else
#define ovMat int
#endif

namespace OVR
{
	//Left or Right camera.
#ifndef _OV_CAMEYE_ENUM_
#define _OV_CAMEYE_ENUM_
	typedef enum ov_cameraeye {
		OV_CAMEYE_LEFT = 0,		//Left camera
		OV_CAMEYE_RIGHT,		//Right camera
		OV_CAMNUM,
	} Cameye;
#endif

	class OvrvisionSetting
	{
	public:
		//Constructor
		OvrvisionSetting();
		OvrvisionSetting(char* filepath);

		// Destructor
		~OvrvisionSetting();


		//Methods
		//Read Setting
		bool Read(const char* filepath);
		//Write Setting
		bool Write(const char* filepath);

		// Calculate Undistortion Matrix
		void GetUndistortionMatrix(Cameye eye, ovMat &mapX, ovMat &mapY, int width, int height);

	protected:
		//Initialize Data
		void InitValue();

		//Var
		//OK
		bool isReaded;

		//Camera Setting
		int	m_propExposure;		//Exposure
		int	m_propWhiteBalance;	//Whitebalance
		int m_propContrast;		//Contrast
		int	m_propSaturation;	//Saturation
		int	m_propBrightness;	//Brightness
		int	m_propSharpness;	//Sharpness
		int	m_propGamma;		//Gamma

		float m_ipd_horizontal;	//IPD(not used)

		//UndistortSetting
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
	};
}

#endif /*__OVRVISION_SETTING__*/
