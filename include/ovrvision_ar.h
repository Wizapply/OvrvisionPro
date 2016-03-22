// ovrvision_ar.h
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

#ifndef __OVRVISION_AR__
#define __OVRVISION_AR__

/////////// INCLUDE ///////////

#pragma warning (disable : 4251)
#pragma warning (disable : 4290)

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
#include <aruco.h>
#include <opencv2/opencv.hpp>
typedef aruco::MarkerDetector MarkerDetector;
typedef aruco::Marker Marker;
typedef aruco::CameraParameters CameraParameters;
typedef cv::Mat ovMat;
#else
#define MarkerDetector void
#define Marker void
#define CameraParameters void
#define ovMat void
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

/*! @brief Vector2D structure for ov_st_marker_data */
typedef struct OVRPORT ov_st_vector2d {
	union {
		float v[2];
		struct {
			float x;
			float y;
		};
	};
} OvVector2D;

/*! @brief Vector3D structure for ov_st_marker_data */
typedef struct OVRPORT ov_st_vector3d {
	union {
		float v[3];
		struct {
			float x;
			float y;
			float z;
		};
	};
} OvVector3D;

/*! @brief Vector4D structure for ov_st_marker_data */
typedef struct OVRPORT ov_st_vector4d {
	union {
		float v[4];
		struct {
			float x;
			float y;
			float z;
			float w;
		};
	};
} OvVector4D;

/*! @brief Ovrvision AR Marker data structure */
typedef struct OVRPORT ov_st_marker_data {
	int				id;					//!MarkerID
	OvVector3D		translate;			//!Position data
	OvVector4D		quaternion;			//!Rotation data
	OvVector2D		centerPtOfImage;	//!Center Position of image
} OvMarkerData;

//unsigned char to byte
typedef unsigned char byte;

//Result define
#define OV_RESULT_OK		(0)	//!Result define
#define OV_RESULT_FAILED	(1)	//!Result define

/////////// CLASS ///////////

//! OvrvisionPro AR class
class OVRPORT OvrvisionAR
{
public:
	//Constructor/Destructor
	/*! @brief Constructor
		@param markersize_meter Actual marker size. meter 1.0f = 100cm
		@param w Image width.
		@param h Image height.
		@param focalPoint Image focal point. */
	OvrvisionAR(float markersize_meter, int w, int h, float focalPoint);
	//!Destructor
	~OvrvisionAR();

	//Methods

	/*!	@brief Set the pointer of image data. 
		@param pImage Image buffer pointer. */
	void SetImageBGRA(unsigned char* pImage);
	/*!	@brief Set the pointer of OpenCV Mat data.
		@param pImageMat OpenCV Mat pointer. */
	void SetImageOpenCVImage(ovMat* pImageMat);
	/*!	@brief Run marker detection processing. */
	void Render();

	/*!	@brief Get the data size of AR markers.
		@return size */
	int				   GetMarkerDataSize();
	/*!	@brief Get the data of AR markers.
		@return OvMarkerData pointer */
	OVR::OvMarkerData* GetMarkerData();
	/*!	@brief Get the data of AR marker. Specify an index.
		@param idx Data index
		@return OvMarkerData pointer */
	OVR::OvMarkerData* GetMarkerData(int idx);

	/*!	@brief Setup the actual size of AR marker. 
		@param value Meter size 1.0f = 100cm */
	void SetMarkerSizeMeter(float value) { m_markerSize_Meter = value; };
	/*!	@brief Get the actual size of AR marker.
		@return Meter size 1.0f = 100cm */
	float GetMarkerSizeMeter(){ return m_markerSize_Meter; };

	/*!	@brief Set the Threashold value
	@param value threashold 0-255 */
	void SetDetectThreshold(float value) { m_threshold = value; };
	/*!	@brief Get the Threashold value
	@return threashold value 0-255 */
	float GetDetectThreshold(){ return m_threshold; };

	//Reserved method.
	void SetInstantTraking(bool value);

private:
	//Marker detector
	MarkerDetector*			m_detector;
	CameraParameters*		m_cameraParam;
	float					m_threshold;
	//Marker size
	float					m_markerSize_Meter;

	//Marker data
	OVR::OvMarkerData*		m_pMarkerData;
	int						m_markerDataSize;

	//Set image infomation
	byte*	m_pImageSrc;		//image pointer
	ovMat*	m_pImageOpenCVMat;	//opencv type image
	int		m_width;			//width
	int		m_height;			//height
	bool	m_isReady;

	//Private Methods
	//Rotation Matrix to Quaternion
	void RotMatToQuaternion(OvVector4D* outQuat, const float* inMat);
	//Multiply Quaternion
	OvVector4D MultiplyQuaternion(OvVector4D* a, OvVector4D* b);
};

};

#endif /*__OVRVISION_AR__*/
