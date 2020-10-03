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

#ifndef __OVRVISION_CALIBRATION__
#define __OVRVISION_CALIBRATION__

/////////// INCLUDE //////////

#include "ovrvision_pro.h"
#include "ovrvision_setting.h"

//Marker 
#ifdef _OVRVISION_EXPORTS
#include <opencv2/opencv.hpp>
//#include <opencv2/ocl/ocl.hpp>
#else
#error This source is only dll export.
#endif

//OVR Group
namespace OVR {

/////////// VARS AND DEFS ///////////

//Clamp 0.0 - 1.0
#define ovClamp(x)	(((x) > 1.0) ? 1.0 : ((x) < 0.0) ? 0.0 : (x))

//RGB color data pixel byte
#define OV_RGB_DATASIZE	(4)

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

class OvrvisionCalibration
{
public:
	//Constructor / Destructor
	OvrvisionCalibration(int img_size_w, int img_size_h, int pattern_size_w, int pattern_size_h,
		double chess_length_mm, int max_chess_count=10000);
	OvrvisionCalibration();
	~OvrvisionCalibration();

	//Method
	int InitializeCalibration(int img_size_w, int img_size_h, int pattern_size_w, int pattern_size_h,
		double chess_length_mm, int max_chess_count=10000);

	//Detecter
	bool FindChessBoardCorners(const unsigned char* left_img, const unsigned char* right_img);
	void DrawChessboardCorners(const unsigned char* src_img, unsigned char* dest_img, Cameye eye);
	void SolveStereoParameter();

	//Save
	void SaveCalibrationParameter(OvrvisionPro* ovrpro, bool param_output = false);

	int GetImageCount() const{ return m_image_count; }	

	//Param : Camera intirinsic var
	std::vector< std::vector<cv::Point2f> > m_subpix_corners_left;
	std::vector< std::vector<cv::Point2f> > m_subpix_corners_right;

	struct {
		cv::Size pixelSize;
		cv::Mat intrinsic;
		cv::Mat distortion;
		cv::Mat R;
		cv::Mat P;
		double focalPoint;
		double fovY;
	} m_cameraCalibration[OV_CAMNUM];

private:

	//Ready
	bool m_isReady;
	//image infomation
	int m_image_count;
	cv::Size m_image_size;		//image resolution
	cv::Size m_pattern_size;	//num. of col and row in a pattern

	double m_CHESS_LENGTH_MM;	//length(mm)
	int m_MAX_CHESS_COUNT;
	bool m_isFound[OV_CAMNUM];

	cv::Mat m_relate_rot;
	cv::Mat m_relate_trans;
	cv::Mat m_E;		//essential matrix
	cv::Mat m_F;		//fundamental matrix
	cv::Mat m_Q;		//map matrix

	//Private method
	void StereoRectificationMatrix();
};


};


#endif /*__OVRVISION_CALIBRATION__*/
