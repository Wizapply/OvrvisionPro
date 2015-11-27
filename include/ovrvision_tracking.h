// ovrvision_tracking.h
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

#ifndef __OVRVISION_TRACKING__
#define __OVRVISION_TRACKING__

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
#include <vector>

//Marker 
#ifdef _OVRVISION_EXPORTS
#include <opencv2/opencv.hpp>
typedef cv::Mat ovMat;
#else
#define ovMat void
#endif

//Left or Right camera.
#ifndef _OV_CAMEYE_ENUM_
#define _OV_CAMEYE_ENUM_
typedef enum ov_cameraeye {
	OV_CAMEYE_LEFT = 0,		//Left camera
	OV_CAMEYE_RIGHT,		//Right camera
	OV_CAMNUM,
} Cameye;
#endif

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

//unsigned char to byte
typedef unsigned char byte;

//Result define
#define OV_RESULT_OK		(0)	//!Result define
#define OV_RESULT_FAILED	(1)	//!Result define

/////////// CLASS ///////////

//! OvrvisionPro AR class
class OVRPORT OvrvisionTracking
{
public:
	//Constructor/Destructor
	//markersize_meter : 15cm = 0.15f, 1m = 1.0f
	//!Constructor
	OvrvisionTracking(int w, int h);
	//!Destructor
	~OvrvisionTracking();

	//Methods

	//image set
	void SetImageBGRA(unsigned char* pLeftImage, unsigned char* pRightImage);
	void SetImageOpenCVImage(ovMat* pLeftImageMat, ovMat* pRightImageMat);
	//Detect marker
	void Render();
	//Get tracking data

	//set
	void SetHue();

private:
	//Set image infomation
	byte*	m_pImageSrc[OV_CAMNUM];			//image pointer
	ovMat*	m_pImageOpenCVMat[OV_CAMNUM];	//opencv type image
	int		m_width;						//width
	int		m_height;						//height
	bool	m_isReady;

	unsigned char m_hue_min;
	unsigned char m_hue_max;

	bool		m_set;
};

};

#endif /*__OVRVISION_TRACKING__*/
