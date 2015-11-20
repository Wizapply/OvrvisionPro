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
	m_propExposure = 12960;		//Exposure
	m_propGain = 8;				//Gain
	m_propBLC = 32;				//BLC
	m_propWhiteBalanceR = 1472;	//WhitebalanceR
	m_propWhiteBalanceG = 1024;	//WhitebalanceG
	m_propWhiteBalanceB = 1336;	//WhitebalanceB
	m_propWhiteBalanceAuto = 1; //WhitebalanceAuto

	m_leftCameraInstric = (cv::Mat_<double>(3,3)
		<< 6.9936527007017332e+002, 0., 6.5787909981011887e+002, 0., 6.9956938260156028e+002, 5.3847199238543192e+002, 0., 0., 1.);
	m_rightCameraInstric = (cv::Mat_<double>(3,3)
		<< 6.9393656647972443e+002, 0., 6.5530854019912022e+002, 0., 6.9409047124436847e+002, 5.1652887936019681e+002, 0., 0., 1.);
	m_leftCameraDistortion = (cv::Mat_<double>(1,8)
		<< -3.2466981386980487e-001, 1.3017177269032637e-001, -1.5853018773530858e-005, 7.5957976826835499e-004, -2.5877743621233330e-002, 3.9215001580130153e-004, -2.0027132740568131e-004, 1.0402737707754896e-003, 0.);
	m_rightCameraDistortion = (cv::Mat_<double>(1,8)
		<< -3.2551395719861603e-001, 1.3196823645655870e-001, -2.0890097504471043e-004, -2.7803902758435393e-002, -8.2566502258511076e-005, 4.5735235536665661e-003, 1.8856961316045134e-004, 8.3455386062889218e-004, 0.);
	m_R1 = (cv::Mat_<double>(3,3)
		<< 9.9996857558646768e-001, 4.2200343497671372e-003, -6.7111213412999722e-003, -4.1838706495675041e-003, 9.9997670207919198e-001, 5.3935633129183098e-003, 6.7337260085745896e-003, -5.3653153597487992e-003, 9.9996293447563944e-001);
	m_R2 = (cv::Mat_<double>(3,3)
		<< 9.9995548163643899e-001, 3.6264510065401861e-003, 8.7111192354668732e-003, -3.5795367051996993e-003, 9.9997903951037470e-001, -5.3951327031361036e-003, -8.7305018305642215e-003, 5.3637107496102426e-003, 9.9994750309442804e-001);
	m_trans = (cv::Mat_<double>(1,3)
		<< -6.0796545954233977e+001, -3.0278201074508349e-001, 1.3454368850001630e+000);
	m_focalPoint = (cv::Mat_<float>(1, 1)
		<< 427.99000740051270e+000);
}

//Read EEPROM Setting
bool OvrvisionSetting::ReadEEPROM() {

	if (system == NULL)
		return false;

	cv::FileStorage cvfs("ovrvisionpro_conf.xml", CV_STORAGE_READ | CV_STORAGE_FORMAT_XML);

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

		/* For Test
		String filename("ovrvision_test.xml");
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
		if (mode==2) WriteEEPROM(WRITE_EEPROM_FLAG_ALLWR);
	}

	isReaded = true;

	return isReaded;
}

//Write EEPROM Setting
bool OvrvisionSetting::WriteEEPROM(unsigned char flag) {

	unsigned char chsum = 0;	//for checksum

	if (system == NULL)
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
		for (i = 0; i < m_leftCameraDistortion.total()*m_leftCameraDistortion.elemSize(); i++) {
			m_pSystem->UserDataAccessSetData(m_leftCameraDistortion.data[i]);
		}
		for (i = 0; i < m_rightCameraDistortion.total()*m_rightCameraDistortion.elemSize(); i++) {
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

	m_pSystem->UserDataAccessLock();

	Sleep(50);	//50ms write wait

	return true;
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
	cv::Mat camPs = getOptimalNewCameraMatrix(cameramat, distorsionCoeff, size, 0, size, 0);

	//Calc clone
	cv::Mat left_CamIns = m_leftCameraInstric.clone();
	cv::Mat right_CamIns = m_rightCameraInstric.clone();

	double cals_x = (double)size.width / (double)sizeCalibBase.width;
	double cals_y = (double)size.height / (double)sizeCalibBase.height;

	//Position
	left_CamIns.at<double>(2) = m_leftCameraInstric.at<double>(2) * cals_x;
	right_CamIns.at<double>(2) = m_rightCameraInstric.at<double>(2) * cals_x;
	left_CamIns.at<double>(5) = m_leftCameraInstric.at<double>(5) * cals_y;
	right_CamIns.at<double>(5) = m_rightCameraInstric.at<double>(5) * cals_y;

	left_CamIns.at<double>(0) = m_leftCameraInstric.at<double>(0) * m_focalPointScale;
	right_CamIns.at<double>(0) = m_rightCameraInstric.at<double>(0) * m_focalPointScale;
	left_CamIns.at<double>(4) = m_leftCameraInstric.at<double>(4) * m_focalPointScale;
	right_CamIns.at<double>(4) = m_rightCameraInstric.at<double>(4) * m_focalPointScale;

	//Undistort
	if (eye == OV_CAMEYE_LEFT) {
		initUndistortRectifyMap(left_CamIns, m_leftCameraDistortion, m_R1,
			camPs, size, CV_32FC1, mapX, mapY);
	}
	if (eye == OV_CAMEYE_RIGHT) {
		initUndistortRectifyMap(right_CamIns, m_rightCameraDistortion, m_R2,
			camPs, size, CV_32FC1, mapX, mapY);
	}
}

};
