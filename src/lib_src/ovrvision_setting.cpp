// ovrvisino_undistort.cpp
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

#include "ovrvision_setting.h"
//for eeprom system
#include "Ovrvision_pro.h"

/////////// VARS AND DEFS ///////////

//Group
namespace OVR
{

/////////// CLASS ///////////

//Ovrvision Setting Class
OvrvisionSetting::OvrvisionSetting(OvrvisionPro* system)
{
	m_pSystem = system;
	InitValue();
}

//Initialize Data
void OvrvisionSetting::InitValue()
{
	isReaded = false;

	//initialize Camera Setting
	m_propExposure = (-1);		//Exposure
	m_propGain = 8;				//Gain
	m_propWhiteBalanceR = 1472;	//WhitebalanceR
	m_propWhiteBalanceG = 1024;	//WhitebalanceG
	m_propWhiteBalanceB = 1336;	//WhitebalanceB

	m_leftCameraInstric = (cv::Mat_<double>(3,3)
		<< 4.0768711844201607e+002, 0., 3.1599488824979869e+002, 0., 4.0750044944511359e+002, 2.5007314115490510e+002, 0., 0., 1.);
	m_rightCameraInstric = (cv::Mat_<double>(3,3)
		<< 4.0878762064521919e+002, 0., 2.8311681185825847e+002, 0., 4.0825537520787026e+002, 2.4381566435176578e+002, 0., 0., 1.);
	m_leftCameraDistortion = (cv::Mat_<double>(1,8)
		<< -4.2458440662577490e-001, 2.3121567636931981e-001, -1.5829281626491789e-004, 1.6999874238679152e-003, -6.0114888845709327e-002, -3.9034090837567321e-003, 1.9700153740470510e-003, 1.4063166137046505e-002);
	m_rightCameraDistortion = (cv::Mat_<double>(1,8)
		<< -4.0744820114573010e-001, 2.0171583152642691e-001, -4.4738715469520878e-004, 4.1095581557611528e-004, -4.1763229516509355e-002, 4.5735235536665661e-003, -9.1320982418901485e-003, 2.1334691234753463e-002 );
	m_R1 = (cv::Mat_<double>(3,3)
		<< 9.9907565324445191e-001, -5.1759301554768307e-003, -4.2673748853334297e-002, 5.2520129651301567e-003, 9.9998481198689648e-001, 1.6709743699574722e-003, 4.2664451877247045e-002, -1.8935528924684318e-003, 9.9908766332262233e-001);
	m_R2 = (cv::Mat_<double>(3,3)
		<< 9.9932579788971709e-001, -5.3451019623971369e-004, -3.6710543048700750e-002, 4.6905532288108175e-004, 9.9999828509701150e-001, -1.7915887195344561e-003, 3.6711437716118824e-002, 1.7731615510161245e-003, 9.9932433485777250e-001);
	m_P1= cv::Mat_<double>(3,4);
	m_P2 = cv::Mat_<double>(3,4);
	m_trans = (cv::Mat_<double>(1,3)
		<< -4.9835903233329809e+001, 4.1639373820797368e-002, 1.1584886767486973e+000);

	m_focalPoint = 3.2798999023437500e+002;
}

//Read EEPROM Setting
bool OvrvisionSetting::ReadEEPROM() {
	//テスト用
	cv::FileStorage cvfs("ovrvisionpro_dev_conf.xml", CV_STORAGE_READ | CV_STORAGE_FORMAT_XML);

	if (!cvfs.isOpened())
		return isReaded;

	//get data node
	cv::FileNode data(cvfs.fs, NULL);

	//read undistort param
	data["LeftCameraInstric"] >> m_leftCameraInstric;
	data["RightCameraInstric"] >> m_rightCameraInstric;
	data["LeftCameraDistortion"] >> m_leftCameraDistortion;
	data["RightCameraDistortion"] >> m_rightCameraDistortion;
	data["R1"] >> m_R1;
	data["R2"] >> m_R2;
	data["P1"] >> m_P1;
	data["P2"] >> m_P2;
	data["T"] >> m_trans;

	m_focalPoint = data["FocalPoint"];

	cvfs.release();
	isReaded = true;

	return isReaded;
}

//Write EEPROM Setting
bool OvrvisionSetting::WriteEEPROM() {
	//OpenCV XML Writer
	cv::FileStorage cvfs("ovrvisionpro_dev_conf.xml", CV_STORAGE_WRITE | CV_STORAGE_FORMAT_XML);

	//Write camera param save

	//Write undistort param
	cv::write(cvfs, "LeftCameraInstric", m_leftCameraInstric);
	cv::write(cvfs, "RightCameraInstric", m_rightCameraInstric);
	cv::write(cvfs, "LeftCameraDistortion", m_leftCameraDistortion);
	cv::write(cvfs, "RightCameraDistortion", m_rightCameraDistortion);
	cv::write(cvfs, "R1", m_R1);
	cv::write(cvfs, "R2", m_R2);
	cv::write(cvfs, "P1", m_P1);
	cv::write(cvfs, "P2", m_P2);
	cv::write(cvfs, "T", m_trans);

	cv::write(cvfs, "FocalPoint", m_focalPoint);

	cvfs.release();

	return true;
}

bool OvrvisionSetting::SaveStatusEEPROM() {
	return false;
}

// Calculate Undistortion Matrix
void OvrvisionSetting::GetUndistortionMatrix(Cameye eye, ovMat &mapX, ovMat &mapY, int width, int height)
{
	//Default camera matrix
	cv::Mat cameramat(3, 3, CV_32FC1);
	cv::Mat distorsionCoeff(1, 8, CV_32FC1, 0.0);
	cv::Size size(width, height);
	cv::Size sizeCalibBase(1280, 960);
	cameramat.at<float>(0) = m_focalPoint;
	cameramat.at<float>(1) = 0.0f;
	cameramat.at<float>(2) = (float)(size.width / 2);
	cameramat.at<float>(3) = 0.0f;
	cameramat.at<float>(4) = m_focalPoint;
	cameramat.at<float>(5) = (float)(size.height / 2);
	cameramat.at<float>(6) = 0.0f;
	cameramat.at<float>(7) = 0.0f;
	cameramat.at<float>(8) = 1.0f;
	cv::Mat camPs = getOptimalNewCameraMatrix(cameramat, distorsionCoeff, size, 0, size, 0);

	//Calc
	/*
	double calc1x = ((double)sizeCalibBase.width - (double)size.width) / (double)sizeCalibBase.width;
	double calc1y = ((double)sizeCalibBase.height - (double)size.height) / (double)sizeCalibBase.height;
	m_leftCameraInstric.at<double>(2) -= m_leftCameraInstric.at<double>(2) * calc1x;	//Posision
	m_leftCameraInstric.at<double>(5) -= m_leftCameraInstric.at<double>(5) * calc1y;
	m_rightCameraInstric.at<double>(2) -= m_rightCameraInstric.at<double>(2) * (calc1x);
	m_rightCameraInstric.at<double>(5) -= m_rightCameraInstric.at<double>(5) * (calc1y);
	*/
	/*
	m_leftCameraInstric.at<double>(0) *= 0.5;	//Scale
	m_rightCameraInstric.at<double>(0) *= 1.0;
	m_leftCameraInstric.at<double>(4) *= 0.5;
	m_rightCameraInstric.at<double>(4) *= 1.0;
	*/
	//Undistort
	if (eye == OV_CAMEYE_LEFT) {
		initUndistortRectifyMap(m_leftCameraInstric, m_leftCameraDistortion, m_R1,
			camPs, size, CV_32FC1, mapX, mapY);
	}
	if (eye == OV_CAMEYE_RIGHT) {
		initUndistortRectifyMap(m_rightCameraInstric, m_rightCameraDistortion, m_R2,
			camPs, size, CV_32FC1, mapX, mapY);
	}
}

};
