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
#include "ovrvision_pro.h"

/////////// VARS AND DEFS ///////////

//Group
namespace OVR
{

/////////// CLASS ///////////

//Ovrvision Setting Class
OvrvisionSetting::OvrvisionSetting(OvrvisionPro* system_ptr)
{
	m_pSystem = system_ptr;
	InitValue();
}

//Initialize Data
void OvrvisionSetting::InitValue()
{
	isReaded = false;

	//initialize Camera Setting
	m_propExposure = 7808;		//Exposure
	m_propGain = 20;			//Gain
	m_propBLC = 32;				//BLC
	m_propWhiteBalanceR = 1472;	//WhitebalanceR
	m_propWhiteBalanceG = 1024;	//WhitebalanceG
	m_propWhiteBalanceB = 1536;	//WhitebalanceB
	m_propWhiteBalanceAuto = 1; //WhitebalanceAuto

	m_pixelSize = cv::Size(1280.0, 960.0);

	m_leftCameraInstric = (cv::Mat_<double>(3,3)
		<< 6.7970157255511901e+002, 0., 6.0536133655058381e+002, 0., 6.8042527485960966e+002, 5.5465392353996174e+002, 0., 0., 1.);
	m_rightCameraInstric = (cv::Mat_<double>(3,3)
		<< 6.8865122458251960e+002, 0., 6.1472005979575772e+002, 0., 6.8933034565503726e+002, 5.0684212440916116e+002, 0., 0., 1.);
	m_leftCameraDistortion = (cv::Mat_<double>(1,8)
		<< -4.1335867833577783e-001, 2.1178505767332989e-001, -4.7504756919241204e-004, 3.2255999104604089e-003, 3.7887562626108255e-002, -9.2038953879423846e-002, 3.1299065818407031e-002, 1.3086219827422665e-001);
	m_rightCameraDistortion = (cv::Mat_<double>(1,8)
		<< -3.0493990540623439e-001, 1.3662653080461551e-001, 1.0423167776015031e-003, 2.8491358735884113e-003, 5.9120577005421594e-002, 3.3803762878286243e-002, -5.1376486225192128e-002, 1.5379685303460996e-001);
	m_R1 = (cv::Mat_<double>(3,3)
		<< 9.9989337632971764e-001, -1.3329319960629154e-002, -5.9636567091731069e-003, 1.3333406344070171e-002, 9.9991089752301443e-001, 6.4597986305001164e-004, 5.9545148603057114e-003, -7.2542684450603058e-004, 9.9998200859249042e-001);
	m_R2 = (cv::Mat_<double>(3,3)
		<< 9.9977730126048470e-001, -1.2839202046508414e-002, -1.6748217072606403e-002, 1.2827713773375438e-002, 9.9991740689173758e-001, -7.9319244304950341e-004, 1.6757017743338598e-002, 5.7817446527048781e-004, 9.9985942415453444e-001);
	m_trans = (cv::Mat_<double>(1,3)
		<< -6.1249914523852240e+001, 7.5758816805225948e-001, 1.6870717314641153e+000);
	m_focalPoint = (cv::Mat_<float>(1, 1)
		<< 2.5f);
}

//Read EEPROM Setting
bool OvrvisionSetting::ReadEEPROM() {

	if (m_pSystem == NULL)
		return false;

	cv::FileStorage cvfs(".\\ovrvisionpro_conf.xml", CV_STORAGE_READ | CV_STORAGE_FORMAT_XML);

	if (!cvfs.isOpened())
	{
		size_t i;
		// not find file
		// used eeprom

		m_pSystem->UserDataAccessUnlock();
		m_pSystem->UserDataAccessSelectAddress(0x0000);

		unsigned char version = m_pSystem->UserDataAccessGetData();	//Version	//1byte

		if (version != EEPROM_SYSTEM_VERSION)
			return true;	//default return

		m_propExposure = (int)m_pSystem->UserDataAccessGetData();			//4byte
		m_propExposure |= (int)m_pSystem->UserDataAccessGetData() << 8;
		m_propExposure |= (int)m_pSystem->UserDataAccessGetData() << 16;
		m_propExposure |= (int)m_pSystem->UserDataAccessGetData() << 24;

		m_propGain = (int)m_pSystem->UserDataAccessGetData();				//4byte
		m_propGain |= (int)m_pSystem->UserDataAccessGetData() << 8;
		m_propGain |= (int)m_pSystem->UserDataAccessGetData() << 16;
		m_propGain |= (int)m_pSystem->UserDataAccessGetData() << 24;

		m_propBLC = (int)m_pSystem->UserDataAccessGetData();				//4byte
		m_propBLC |= (int)m_pSystem->UserDataAccessGetData() << 8;
		m_propBLC |= (int)m_pSystem->UserDataAccessGetData() << 16;
		m_propBLC |= (int)m_pSystem->UserDataAccessGetData() << 24;

		m_propWhiteBalanceR = (int)m_pSystem->UserDataAccessGetData();		//4byte
		m_propWhiteBalanceR |= (int)m_pSystem->UserDataAccessGetData() << 8;
		m_propWhiteBalanceR |= (int)m_pSystem->UserDataAccessGetData() << 16;
		m_propWhiteBalanceR |= (int)m_pSystem->UserDataAccessGetData() << 24;

		m_propWhiteBalanceG = (int)m_pSystem->UserDataAccessGetData();		//4byte
		m_propWhiteBalanceG |= (int)m_pSystem->UserDataAccessGetData() << 8;
		m_propWhiteBalanceG |= (int)m_pSystem->UserDataAccessGetData() << 16;
		m_propWhiteBalanceG |= (int)m_pSystem->UserDataAccessGetData() << 24;

		m_propWhiteBalanceB = (int)m_pSystem->UserDataAccessGetData();		//4byte
		m_propWhiteBalanceB |= (int)m_pSystem->UserDataAccessGetData() << 8;
		m_propWhiteBalanceB |= (int)m_pSystem->UserDataAccessGetData() << 16;
		m_propWhiteBalanceB |= (int)m_pSystem->UserDataAccessGetData() << 24;

		m_propWhiteBalanceAuto = m_pSystem->UserDataAccessGetData();	//1byte

		//----26 byte----

		//Reserved

		//----32 byte----

		m_pSystem->UserDataAccessSelectAddress(0x0020);

		for (i = 0; i < m_leftCameraInstric.total()*m_leftCameraInstric.elemSize(); i++) {
			m_leftCameraInstric.data[i] = m_pSystem->UserDataAccessGetData();
		}
		for (i = 0; i < m_rightCameraInstric.total()*m_rightCameraInstric.elemSize(); i++) {
			m_rightCameraInstric.data[i] = m_pSystem->UserDataAccessGetData();
		}
		for (i = 0; i < m_leftCameraDistortion.total()*m_leftCameraDistortion.elemSize(); i++) {
			m_leftCameraDistortion.data[i] = m_pSystem->UserDataAccessGetData();
		}
		for (i = 0; i < m_rightCameraDistortion.total()*m_rightCameraDistortion.elemSize(); i++) {
			m_rightCameraDistortion.data[i] = m_pSystem->UserDataAccessGetData();
		}

		for (i = 0; i < m_R1.total()*m_R1.elemSize(); i++) {
			m_R1.data[i] = m_pSystem->UserDataAccessGetData();
		}
		for (i = 0; i < m_R2.total()*m_R2.elemSize(); i++) {
			m_R2.data[i] = m_pSystem->UserDataAccessGetData();
		}
		for (i = 0; i < m_trans.total()*m_trans.elemSize(); i++) {
			m_trans.data[i] = m_pSystem->UserDataAccessGetData();
		}

		for (i = 0; i < m_focalPoint.total()*m_focalPoint.elemSize(); i++) {
			m_focalPoint.data[i] = m_pSystem->UserDataAccessGetData();
		}
		m_pSystem->UserDataAccessLock();

		// For Test
		/*
		String filename("ovrvision_eepromtest.xml");
		FileStorage cvfs(filename, CV_STORAGE_WRITE | CV_STORAGE_FORMAT_XML);

		//Write undistort param
		write(cvfs, "LeftCameraInstric", m_leftCameraInstric);
		write(cvfs, "RightCameraInstric", m_rightCameraInstric);
		write(cvfs, "LeftCameraDistortion", m_leftCameraDistortion);
		write(cvfs, "RightCameraDistortion", m_rightCameraDistortion);
		write(cvfs, "R1", m_R1);
		write(cvfs, "R2", m_R2);
		write(cvfs, "T", m_trans);

		write(cvfs, "FocalPoint", m_focalPoint);

		cvfs.release();
		*/
	}
	else
	{
		int mode = 0;

		//get data node
		cv::FileNode data(cvfs.fs, NULL);

		mode = data["Mode"];

		//read camera setting
		m_propExposure = data["Exposure"];
		m_propGain = data["Gain"];
		m_propBLC = data["BLC"];
		m_propWhiteBalanceR = data["WhiteBalanceR"];
		m_propWhiteBalanceG = data["WhiteBalanceG"];
		m_propWhiteBalanceB = data["WhiteBalanceB"];

		m_propWhiteBalanceAuto = (char)((int)data["WhiteBalanceAuto"] & 0x00000001);

		//read undistort param
		data["LeftCameraInstric"] >> m_leftCameraInstric;
		data["RightCameraInstric"] >> m_rightCameraInstric;
		data["LeftCameraDistortion"] >> m_leftCameraDistortion;
		data["RightCameraDistortion"] >> m_rightCameraDistortion;
		data["R1"] >> m_R1;
		data["R2"] >> m_R2;
		data["T"] >> m_trans;
		data["FocalPoint"] >> m_focalPoint;

		cvfs.release();

		//Mode
		if (mode == 2) {
			WriteEEPROM(WRITE_EEPROM_FLAG_ALLWR);
			return false;
		}
	}

	isReaded = true;

	return isReaded;
}

//Write EEPROM Setting
bool OvrvisionSetting::WriteEEPROM(unsigned char flag) {

	unsigned char chsum = 0;	//for checksum

	if (m_pSystem == NULL)
		return false;

	m_pSystem->UserDataAccessUnlock();
	m_pSystem->UserDataAccessSelectAddress(0x0000);
	m_pSystem->UserDataAccessSetData(EEPROM_SYSTEM_VERSION);			//Version:1byte

	if (flag & WRITE_EEPROM_FLAG_CAMERASETWR)
	{
		m_pSystem->UserDataAccessSetData(m_propExposure & 0xFF);			//4byte
		m_pSystem->UserDataAccessSetData((m_propExposure >> 8) & 0xFF);
		m_pSystem->UserDataAccessSetData((m_propExposure >> 16) & 0xFF);
		m_pSystem->UserDataAccessSetData((m_propExposure >> 24) & 0xFF);

		m_pSystem->UserDataAccessSetData(m_propGain & 0xFF);				//4byte
		m_pSystem->UserDataAccessSetData((m_propGain >> 8) & 0xFF);
		m_pSystem->UserDataAccessSetData((m_propGain >> 16) & 0xFF);
		m_pSystem->UserDataAccessSetData((m_propGain >> 24) & 0xFF);

		m_pSystem->UserDataAccessSetData(m_propBLC & 0xFF);					//4byte
		m_pSystem->UserDataAccessSetData((m_propBLC >> 8) & 0xFF);
		m_pSystem->UserDataAccessSetData((m_propBLC >> 16) & 0xFF);
		m_pSystem->UserDataAccessSetData((m_propBLC >> 24) & 0xFF);

		m_pSystem->UserDataAccessSetData(m_propWhiteBalanceR & 0xFF);		//4byte
		m_pSystem->UserDataAccessSetData((m_propWhiteBalanceR >> 8) & 0xFF);
		m_pSystem->UserDataAccessSetData((m_propWhiteBalanceR >> 16) & 0xFF);
		m_pSystem->UserDataAccessSetData((m_propWhiteBalanceR >> 24) & 0xFF);

		m_pSystem->UserDataAccessSetData(m_propWhiteBalanceG & 0xFF);		//4byte
		m_pSystem->UserDataAccessSetData((m_propWhiteBalanceG >> 8) & 0xFF);
		m_pSystem->UserDataAccessSetData((m_propWhiteBalanceG >> 16) & 0xFF);
		m_pSystem->UserDataAccessSetData((m_propWhiteBalanceG >> 24) & 0xFF);

		m_pSystem->UserDataAccessSetData(m_propWhiteBalanceB & 0xFF);		//4byte
		m_pSystem->UserDataAccessSetData((m_propWhiteBalanceB >> 8) & 0xFF);
		m_pSystem->UserDataAccessSetData((m_propWhiteBalanceB >> 16) & 0xFF);
		m_pSystem->UserDataAccessSetData((m_propWhiteBalanceB >> 24) & 0xFF);

		m_pSystem->UserDataAccessSetData(m_propWhiteBalanceAuto);			//1byte
	}

	//----26 byte----

	for (int i = 0; i < 6; i++)
		chsum = chsum^0x00;

	//Reserved

	//----32 byte----

	m_pSystem->UserDataAccessSelectAddress(0x0020);

	if (flag & WRITE_EEPROM_FLAG_LENSPARAMWR)
	{
		size_t i;
		for (i = 0; i < m_leftCameraInstric.total()*m_leftCameraInstric.elemSize(); i++) {
			m_pSystem->UserDataAccessSetData(m_leftCameraInstric.data[i]);
		}
		for (i = 0; i < m_rightCameraInstric.total()*m_rightCameraInstric.elemSize(); i++) {
			m_pSystem->UserDataAccessSetData(m_rightCameraInstric.data[i]);
		}
		int writesafect = m_leftCameraDistortion.total();
		if (writesafect > 8) writesafect = 8;	//for calib
		for (i = 0; i < writesafect*m_leftCameraDistortion.elemSize(); i++) {
			m_pSystem->UserDataAccessSetData(m_leftCameraDistortion.data[i]);
		}
		
		writesafect = m_rightCameraDistortion.total();
		if (writesafect > 8) writesafect = 8;	 //for calib
		for (i = 0; i < writesafect*m_rightCameraDistortion.elemSize(); i++) {
			m_pSystem->UserDataAccessSetData(m_rightCameraDistortion.data[i]);
		}

		for (i = 0; i < m_R1.total()*m_R1.elemSize(); i++) {
			m_pSystem->UserDataAccessSetData(m_R1.data[i]);
		}
		for (i = 0; i < m_R2.total()*m_R2.elemSize(); i++) {
			m_pSystem->UserDataAccessSetData(m_R2.data[i]);
		}
		for (i = 0; i < m_trans.total()*m_trans.elemSize(); i++) {
			m_pSystem->UserDataAccessSetData(m_trans.data[i]);
		}

		for (i = 0; i < m_focalPoint.total()*m_focalPoint.elemSize(); i++) {
			m_pSystem->UserDataAccessSetData(m_focalPoint.data[i]);
		}
	}

	//save eeprom
	m_pSystem->UserDataAccessSave();
	//checksum developing
	//m_pSystem->UserDataAccessCheckSumAddress();
	//unsigned char checksum = m_pSystem->UserDataAccessGetData();//1byte

	// For Test
	/*
	String filename("ovrvision_writetest.xml");
	FileStorage cvfs(filename, CV_STORAGE_WRITE | CV_STORAGE_FORMAT_XML);

	//Write undistort param
	write(cvfs, "LeftCameraInstric", m_leftCameraInstric);
	write(cvfs, "RightCameraInstric", m_rightCameraInstric);
	write(cvfs, "LeftCameraDistortion", m_leftCameraDistortion);
	write(cvfs, "RightCameraDistortion", m_rightCameraDistortion);
	write(cvfs, "R1", m_R1);
	write(cvfs, "R2", m_R2);
	write(cvfs, "T", m_trans);

	write(cvfs, "FocalPoint", m_focalPoint);

	cvfs.release();
	*/

	m_pSystem->UserDataAccessLock();

	return true;
}

//Reset Setting
bool OvrvisionSetting::ResetEEPROM()
{
	if (m_pSystem == NULL)
		return false;

	m_pSystem->UserDataAccessUnlock();
	m_pSystem->UserDataAccessSelectAddress(0x0000);
	m_pSystem->UserDataAccessSetData(0x00);			//Version:1byte reset

	//save eeprom
	m_pSystem->UserDataAccessSave();

	m_pSystem->UserDataAccessLock();

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
	double m_focalPointScale = 1.00; 
	//Rect roi; // Valid Region of Interest

	//Adjustment calc
	if (size.width > 1280) {
		m_focalPointScale = 2.0;
	}
	else if (size.width <= 640) {
		if (size.width <= 320)
			m_focalPointScale = 0.25;
		else
			m_focalPointScale = 0.5;
	}

	cameramat.at<float>(0) = m_focalPoint.at<float>(0) * (float)m_focalPointScale;
	cameramat.at<float>(1) = 0.0f;
	cameramat.at<float>(2) = (float)(size.width / 2);
	cameramat.at<float>(3) = 0.0f;
	cameramat.at<float>(4) = m_focalPoint.at<float>(0) * (float)m_focalPointScale;
	cameramat.at<float>(5) = (float)(size.height / 2);
	cameramat.at<float>(6) = 0.0f;
	cameramat.at<float>(7) = 0.0f;
	cameramat.at<float>(8) = 1.0f;

	double cals_x = (double)size.width / (double)sizeCalibBase.width;
	double cals_y = (double)size.height / (double)sizeCalibBase.height;

    // Stereo rectify maps need calibrated camera matrix and coeffs
	if (eye == OV_CAMEYE_LEFT)
	{
		cv::Mat camPs = getOptimalNewCameraMatrix(cameramat, distorsionCoeff, size, 0, size, &m_leftROI, false);

		//Calc clone
		cv::Mat left_CamIns = m_leftCameraInstric.clone();

		//Position
		left_CamIns.at<double>(2) = m_leftCameraInstric.at<double>(2) * cals_x;
		left_CamIns.at<double>(5) = m_leftCameraInstric.at<double>(5) * cals_y;

		left_CamIns.at<double>(0) = m_leftCameraInstric.at<double>(0) * m_focalPointScale;
		left_CamIns.at<double>(4) = m_leftCameraInstric.at<double>(4) * m_focalPointScale;

		//Undistort
		initUndistortRectifyMap(left_CamIns, m_leftCameraDistortion, m_R1,
			camPs, size, CV_32FC1, mapX, mapY);
	}
	else 
	{
		cv::Mat camPs = getOptimalNewCameraMatrix(cameramat, distorsionCoeff, size, 0, size, &m_rightROI, false);

		//Calc clone
		cv::Mat right_CamIns = m_rightCameraInstric.clone();

		//Position
		right_CamIns.at<double>(2) = m_rightCameraInstric.at<double>(2) * cals_x;
		right_CamIns.at<double>(5) = m_rightCameraInstric.at<double>(5) * cals_y;

		right_CamIns.at<double>(0) = m_rightCameraInstric.at<double>(0) * m_focalPointScale;
		right_CamIns.at<double>(4) = m_rightCameraInstric.at<double>(4) * m_focalPointScale;

		//Undistort
		initUndistortRectifyMap(right_CamIns, m_rightCameraDistortion, m_R2,
			camPs, size, CV_32FC1, mapX, mapY);
	}
}

};
