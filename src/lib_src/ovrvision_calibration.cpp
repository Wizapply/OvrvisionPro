// ovrvisino_calibration.cpp
//
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

#include "ovrvision_calibration.h"

/////////// VARS AND DEFS ///////////

//for cv::imshow
//#pragma comment(lib, "Comctl32.lib")
//#pragma comment(lib, "opencv_highgui248.lib") 
//#define OV_CONFIG_USEOPENCL

/////////// CLASS ///////////

//Group
namespace OVR
{

	//Ovrvision Calibration Class
	OvrvisionCalibration::OvrvisionCalibration(int img_size_w, int img_size_h, int pattern_size_w, int pattern_size_h,
		double chess_length_mm, int max_chess_count)
	{
		m_isReady = true;

		//Create with initialize
		InitializeCalibration(img_size_w, img_size_h, pattern_size_w, pattern_size_h, chess_length_mm, max_chess_count);

		m_relate_rot.create(1, 3, CV_64FC1);
		m_relate_trans.create(1, 3, CV_64FC1);
		m_E = cv::Mat::eye(3, 3, CV_64FC1);
		m_F = cv::Mat::eye(3, 3, CV_64FC1);
		m_Q.create(4, 4, CV_64FC1);	//map matrix
	}

	OvrvisionCalibration::OvrvisionCalibration()
	{
		m_isReady = true;
		m_image_count = 0;
		m_isFound[0] = m_isFound[1] = false;

		m_relate_rot.create(1, 3, CV_64FC1);
		m_relate_trans.create(1, 3, CV_64FC1);
		m_E = cv::Mat::eye(3, 3, CV_64FC1);
		m_F = cv::Mat::eye(3, 3, CV_64FC1);
		m_Q.create(4, 4, CV_64FC1);	//map matrix
	}

	OvrvisionCalibration::~OvrvisionCalibration()
	{
		//none
	}

	//Method
	int OvrvisionCalibration::InitializeCalibration(int img_size_w, int img_size_h, int pattern_size_w, int pattern_size_h,
		double chess_length_mm, int max_chess_count)
	{
		cv::Size img_size(img_size_w, img_size_h);
		cv::Size pattern_size(pattern_size_w, pattern_size_h);

		m_image_count = 0;
		m_image_size = img_size;
		m_pattern_size = pattern_size;
		m_CHESS_LENGTH_MM = chess_length_mm;
		m_MAX_CHESS_COUNT = max_chess_count;

		for (int i = 0; i < OV_CAMNUM; i++) {
			m_cameraCalibration[i].intrinsic = cv::Mat::eye(3, 3, CV_64FC1);
			m_cameraCalibration[i].R.create(3, 3, CV_64FC1);	//R1 R2
			m_cameraCalibration[i].P.create(3, 4, CV_64FC1);	//P1 P2
			m_cameraCalibration[i].distortion.create(1, 8, CV_64FC1);//distortion param 8
			m_isFound[i] = false;
		}

		m_subpix_corners_left.clear();
		m_subpix_corners_right.clear();

		m_isReady = false;

		return true;
	}

	bool OvrvisionCalibration::FindChessBoardCorners(const unsigned char* left_img, const unsigned char* right_img)
	{
		bool ret = false;

		if (m_isReady)
			return false;

		cv::Mat src_left(m_image_size, CV_MAKETYPE(CV_8U, OV_RGB_DATASIZE));
		cv::Mat src_right(m_image_size, CV_MAKETYPE(CV_8U, OV_RGB_DATASIZE));
		cv::Mat src_gray_left;
		cv::Mat src_gray_right;

		memcpy(src_left.data, left_img, sizeof(unsigned char) * m_image_size.width * m_image_size.height * OV_RGB_DATASIZE);
		memcpy(src_right.data, right_img, sizeof(unsigned char) * m_image_size.width * m_image_size.height * OV_RGB_DATASIZE);

		cv::cvtColor(src_left, src_gray_left, CV_BGRA2GRAY);
		cv::cvtColor(src_right, src_gray_right, CV_BGRA2GRAY);

		//Detect
		std::vector<cv::Point2f> current_corners_left;
		std::vector<cv::Point2f> current_corners_right;

		m_isFound[OV_CAMEYE_LEFT] = cv::findChessboardCorners(src_gray_left, m_pattern_size, current_corners_left);
		m_isFound[OV_CAMEYE_RIGHT] = cv::findChessboardCorners(src_gray_right, m_pattern_size, current_corners_right);

		if (m_isFound[OV_CAMEYE_LEFT] && m_isFound[OV_CAMEYE_RIGHT])
		{
			cv::TermCriteria criteria(CV_TERMCRIT_ITER | CV_TERMCRIT_EPS, 20, 0.001);

			//Left image
			cv::cornerSubPix(src_gray_left, current_corners_left, cv::Size(11, 11), cv::Size(-1, -1), criteria);
			m_subpix_corners_left.push_back(current_corners_left);

			//Right image
			cv::cornerSubPix(src_gray_right, current_corners_right, cv::Size(11, 11), cv::Size(-1, -1), criteria);
			m_subpix_corners_right.push_back(current_corners_right);

			m_image_count++;
			ret = true;
		}

		return ret;
	}

	void OvrvisionCalibration::DrawChessboardCorners(const unsigned char* src_img, unsigned char* dest_img, Cameye eye)
	{
		if (m_isReady)
			return;

		cv::Mat src_image(m_image_size, CV_MAKETYPE(CV_8U, OV_RGB_DATASIZE));
		memcpy(src_image.data, src_img, sizeof(unsigned char) * m_image_size.width * m_image_size.height * OV_RGB_DATASIZE);

		//Create image clone
		cv::Mat dest = src_image.clone();

		if (m_image_count - 1 < 0)
			return;

		//Draw
		if (eye == OV_CAMEYE_LEFT)
			cv::drawChessboardCorners(dest, m_pattern_size, m_subpix_corners_left[m_image_count - 1], m_isFound[OV_CAMEYE_LEFT]);
		else
			cv::drawChessboardCorners(dest, m_pattern_size, m_subpix_corners_right[m_image_count - 1], m_isFound[OV_CAMEYE_RIGHT]);

		//Copy
		memcpy(dest_img, dest.data, sizeof(unsigned char) * m_image_size.width * m_image_size.height * OV_RGB_DATASIZE);
	}

	void OvrvisionCalibration::SolveStereoParameter()
	{
		if (m_isReady)
			return;

		if (m_image_count<3)
		{
			return;
		}

		//setup 2D-3D points data

		//all data
		std::vector <std::vector <cv::Point3f> > object_points;
		std::vector <std::vector <cv::Point2f> > image_points1;
		std::vector <std::vector <cv::Point2f> > image_points2;

		//each picture cache
		std::vector<cv::Point3f> objects(m_pattern_size.area());
		std::vector<cv::Point2f> corners1(m_pattern_size.area());
		std::vector<cv::Point2f> corners2(m_pattern_size.area());

		for (int i = 0; i < m_image_count; i++)
		{
			for (int j = 0; j < m_pattern_size.height; j++)
			{
				for (int k = 0; k < m_pattern_size.width; k++)
				{
					objects[j * m_pattern_size.width + k].x = (float)(j * m_CHESS_LENGTH_MM);
					objects[j * m_pattern_size.width + k].y = (float)(k * m_CHESS_LENGTH_MM);
					objects[j * m_pattern_size.width + k].z = 0.0f;

					corners1[j * m_pattern_size.width + k].x = m_subpix_corners_left[i][j * m_pattern_size.width + k].x;
					corners1[j * m_pattern_size.width + k].y = m_subpix_corners_left[i][j * m_pattern_size.width + k].y;
					corners2[j * m_pattern_size.width + k].x = m_subpix_corners_right[i][j * m_pattern_size.width + k].x;
					corners2[j * m_pattern_size.width + k].y = m_subpix_corners_right[i][j * m_pattern_size.width + k].y;
				}
			}
			//copy current points to all
			object_points.push_back(objects);
			image_points1.push_back(corners1);
			image_points2.push_back(corners2);
		}

		std::vector<cv::Mat> rvecs;
		std::vector<cv::Mat> tvecs;
		double result_left = cv::calibrateCamera(object_points, image_points1, m_image_size,
			m_cameraCalibration[OV_CAMEYE_LEFT].intrinsic,
			m_cameraCalibration[OV_CAMEYE_LEFT].distortion, rvecs, tvecs);
		double result_right = cv::calibrateCamera(object_points, image_points2, m_image_size,
			m_cameraCalibration[OV_CAMEYE_RIGHT].intrinsic,
			m_cameraCalibration[OV_CAMEYE_RIGHT].distortion, rvecs, tvecs);

		double fovx = 0;
		double focalLength = 0;
		cv::Point2d principalPoint(0.0, 0.0);
		double aspectRatio = 0;

		m_cameraCalibration[OV_CAMEYE_LEFT].pixelSize = m_image_size;
		m_cameraCalibration[OV_CAMEYE_RIGHT].pixelSize = m_image_size;

		cv::calibrationMatrixValues(m_cameraCalibration[OV_CAMEYE_LEFT].intrinsic, m_image_size, SensorSizeWidth, SensorSizeHeight,
			fovx, m_cameraCalibration[OV_CAMEYE_LEFT].fovY, m_cameraCalibration[OV_CAMEYE_LEFT].focalPoint, principalPoint, aspectRatio);

		cv::calibrationMatrixValues(m_cameraCalibration[OV_CAMEYE_RIGHT].intrinsic, m_image_size, SensorSizeWidth, SensorSizeHeight,
			fovx, m_cameraCalibration[OV_CAMEYE_RIGHT].fovY, m_cameraCalibration[OV_CAMEYE_RIGHT].focalPoint, principalPoint, aspectRatio);

		//intrinsic parameters
		cv::TermCriteria criteria(CV_TERMCRIT_ITER | CV_TERMCRIT_EPS, 20, 0.001);

		double rms = cv::stereoCalibrate(object_points, image_points1, image_points2,
			m_cameraCalibration[OV_CAMEYE_LEFT].intrinsic, m_cameraCalibration[OV_CAMEYE_LEFT].distortion,
			m_cameraCalibration[OV_CAMEYE_RIGHT].intrinsic, m_cameraCalibration[OV_CAMEYE_RIGHT].distortion,
			m_image_size, m_relate_rot, m_relate_trans, m_E, m_F,
			CV_CALIB_RATIONAL_MODEL | CV_CALIB_USE_INTRINSIC_GUESS | CV_CALIB_FIX_PRINCIPAL_POINT, criteria);

		//Rectification
		StereoRectificationMatrix();
	}

	void OvrvisionCalibration::StereoRectificationMatrix()
	{
		cv::Mat Q(4, 4, CV_64FC1);	//map matrix

		cv::stereoRectify(m_cameraCalibration[OV_CAMEYE_LEFT].intrinsic, m_cameraCalibration[OV_CAMEYE_LEFT].distortion,
			m_cameraCalibration[OV_CAMEYE_RIGHT].intrinsic, m_cameraCalibration[OV_CAMEYE_RIGHT].distortion,
			m_image_size, m_relate_rot, m_relate_trans,
			m_cameraCalibration[OV_CAMEYE_LEFT].R, m_cameraCalibration[OV_CAMEYE_RIGHT].R,
			m_cameraCalibration[OV_CAMEYE_LEFT].P, m_cameraCalibration[OV_CAMEYE_RIGHT].P, m_Q, cv::CALIB_ZERO_DISPARITY);

		//vertical or horizontal
		bool isVerticalStereo = fabs(m_cameraCalibration[OV_CAMEYE_RIGHT].P.at<double>(1, 3)) > fabs(m_cameraCalibration[OV_CAMEYE_RIGHT].P.at<double>(0, 3));
	}

	//Save
	void OvrvisionCalibration::SaveCalibrationParameter(OvrvisionPro* system, bool param_output)
	{
		//Read files.
		OvrvisionSetting ovrset(system);

		//Read Set

		//Save Calib Data
		ovrset.m_pixelSize = m_cameraCalibration[OV_CAMEYE_LEFT].pixelSize;
		ovrset.m_leftCameraInstric = m_cameraCalibration[OV_CAMEYE_LEFT].intrinsic;
		ovrset.m_rightCameraInstric = m_cameraCalibration[OV_CAMEYE_RIGHT].intrinsic;
		ovrset.m_leftCameraDistortion = m_cameraCalibration[OV_CAMEYE_LEFT].distortion;
		ovrset.m_rightCameraDistortion = m_cameraCalibration[OV_CAMEYE_RIGHT].distortion;
		ovrset.m_R1 = m_cameraCalibration[OV_CAMEYE_LEFT].R;
		ovrset.m_R2 = m_cameraCalibration[OV_CAMEYE_RIGHT].R;
		//ovrset.m_P1 = m_cameraCalibration[OV_CAMEYE_LEFT].P; //none
		//ovrset.m_P2 = m_cameraCalibration[OV_CAMEYE_RIGHT].P; //none
		ovrset.m_trans = m_relate_rot * m_relate_trans;
		ovrset.m_focalPoint.at<float>(0) = m_cameraCalibration[OV_CAMEYE_LEFT].focalPoint;

		//Write
		ovrset.WriteEEPROM(WRITE_EEPROM_FLAG_ALLWR);	//WRITE_EEPROM_FLAG_LENSPARAMWR

		//50ms wait
#ifdef WIN32
		Sleep(50);
#elif MACOSX
		[NSThread sleepForTimeInterval : 0.05];
#elif LINUX

#endif
		if (param_output) {
			FileStorage cvfs("./ovrvision_param_output.xml", CV_STORAGE_WRITE | CV_STORAGE_FORMAT_XML);
			write(cvfs, "PixelSize", ovrset.m_pixelSize);
			write(cvfs, "LeftCameraInstric", ovrset.m_leftCameraInstric);
			write(cvfs, "RightCameraInstric", ovrset.m_rightCameraInstric);
			write(cvfs, "LeftCameraDistortion", ovrset.m_leftCameraDistortion);
			write(cvfs, "RightCameraDistortion", ovrset.m_rightCameraDistortion);
			write(cvfs, "R1", ovrset.m_R1);
			write(cvfs, "R2", ovrset.m_R2);
			write(cvfs, "T", ovrset.m_trans);
			write(cvfs, "LeftFocalPoint", m_cameraCalibration[OV_CAMEYE_LEFT].focalPoint);
			write(cvfs, "RightFocalPoint", m_cameraCalibration[OV_CAMEYE_RIGHT].focalPoint);
			write(cvfs, "LeftFOVY", m_cameraCalibration[OV_CAMEYE_LEFT].fovY);
			write(cvfs, "RightFOVY", m_cameraCalibration[OV_CAMEYE_RIGHT].fovY);
			cvfs.release();
		}
	}

};
