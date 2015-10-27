

#include "OvrvisionSettings.h"

/////////// VARS AND DEFS ///////////

using namespace cv;

//Group
namespace OVR
{

	/////////// CLASS ///////////

	//Ovrvision Setting Class
	OvrvisionSetting::OvrvisionSetting()
	{
		InitValue();
	}
	OvrvisionSetting::OvrvisionSetting(char* filepath)
	{
		InitValue();

		//Read data
		Read(filepath);
	}

	OvrvisionSetting::~OvrvisionSetting()
	{
		m_leftCameraInstric.release();
		m_rightCameraInstric.release();
		m_leftCameraDistortion.release();
		m_rightCameraDistortion.release();
		m_R1.release();
		m_R2.release();
		m_P1.release();
		m_P2.release();
		m_trans.release();
	}

	//Initialize Data
	void OvrvisionSetting::InitValue()
	{
		isReaded = false;

		//initialize Camera Setting
		m_propExposure = (-1);		//Exposure
		m_propWhiteBalance = (-1);	//Whitebalance
		m_propContrast = 30;		//Contrast
		m_propSaturation = 40;		//Saturation
		m_propBrightness = 90;		//Brightness
		m_propSharpness = 2;		//Sharpness
		m_propGamma = 7;			//Gamma

		m_leftCameraInstric = (Mat_<double>(3, 3)
			<< 4.0768711844201607e+002, 0., 3.1599488824979869e+002, 0., 4.0750044944511359e+002, 2.5007314115490510e+002, 0., 0., 1.);
		m_rightCameraInstric = (Mat_<double>(3, 3)
			<< 4.0878762064521919e+002, 0., 2.8311681185825847e+002, 0., 4.0825537520787026e+002, 2.4381566435176578e+002, 0., 0., 1.);
		m_leftCameraDistortion = (Mat_<double>(1, 8)
			<< -4.2458440662577490e-001, 2.3121567636931981e-001, -1.5829281626491789e-004, 1.6999874238679152e-003, -6.0114888845709327e-002, -3.9034090837567321e-003, 1.9700153740470510e-003, 1.4063166137046505e-002);
		m_rightCameraDistortion = (Mat_<double>(1, 8)
			<< -4.0744820114573010e-001, 2.0171583152642691e-001, -4.4738715469520878e-004, 4.1095581557611528e-004, -4.1763229516509355e-002, 4.5735235536665661e-003, -9.1320982418901485e-003, 2.1334691234753463e-002);
		m_R1 = (Mat_<double>(3, 3)
			<< 9.9907565324445191e-001, -5.1759301554768307e-003, -4.2673748853334297e-002, 5.2520129651301567e-003, 9.9998481198689648e-001, 1.6709743699574722e-003, 4.2664451877247045e-002, -1.8935528924684318e-003, 9.9908766332262233e-001);
		m_R2 = (Mat_<double>(3, 3)
			<< 9.9932579788971709e-001, -5.3451019623971369e-004, -3.6710543048700750e-002, 4.6905532288108175e-004, 9.9999828509701150e-001, -1.7915887195344561e-003, 3.6711437716118824e-002, 1.7731615510161245e-003, 9.9932433485777250e-001);
		m_P1 = Mat_<double>(3, 4);
		m_P2 = Mat_<double>(3, 4);
		m_trans = (Mat_<double>(1, 3)
			<< -4.9835903233329809e+001, 4.1639373820797368e-002, 1.1584886767486973e+000);

		m_focalPoint = (-320.0f);
	}

	//Read Setting
	bool OvrvisionSetting::Read(const char* filepath)
	{
		//file
		String filename(filepath);
		FileStorage cvfs;
		if (cvfs.open(filepath, CV_STORAGE_READ | CV_STORAGE_FORMAT_XML))
		{
			//if (!cvfs.isOpened())
			//	return isReaded;

			//get data node
			FileNode data(cvfs.fs, NULL);

			//Write camera param
			m_propExposure = data["exposure"];
			m_propWhiteBalance = data["whitebalance"];
			m_propContrast = data["contrast"];
			m_propSaturation = data["saturation"];
			m_propBrightness = data["brightness"];
			m_propSharpness = data["sharpness"];
			m_propGamma = data["gamma"];

			//Write undistort param
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
		}
		return isReaded;
	}

	//Write Setting
	bool OvrvisionSetting::Write(const char* filepath)
	{
		//OpenCV XML Writer
		String filename(filepath);
		FileStorage cvfs(filename, CV_STORAGE_WRITE | CV_STORAGE_FORMAT_XML);

		//Write camera param
		write(cvfs, "exposure", m_propExposure);
		write(cvfs, "whitebalance", m_propWhiteBalance);
		write(cvfs, "contrast", m_propContrast);
		write(cvfs, "saturation", m_propSaturation);
		write(cvfs, "brightness", m_propBrightness);
		write(cvfs, "sharpness", m_propSharpness);
		write(cvfs, "gamma", m_propGamma);

		//Write undistort param
		write(cvfs, "LeftCameraInstric", m_leftCameraInstric);
		write(cvfs, "RightCameraInstric", m_rightCameraInstric);
		write(cvfs, "LeftCameraDistortion", m_leftCameraDistortion);
		write(cvfs, "RightCameraDistortion", m_rightCameraDistortion);
		write(cvfs, "R1", m_R1);
		write(cvfs, "R2", m_R2);
		write(cvfs, "P1", m_P1);
		write(cvfs, "P2", m_P2);
		write(cvfs, "T", m_trans);

		write(cvfs, "FocalPoint", m_focalPoint);

		cvfs.release();

		return true;
	}

	// Calculate Undistortion Matrix
	void OvrvisionSetting::GetUndistortionMatrix(Cameye eye, ovMat &mapX, ovMat &mapY, int width, int height)
	{
		//Default camera matrix
		Mat cameramat(3, 3, CV_32FC1);
		Mat distorsionCoeff(1, 8, CV_32FC1, 0.0);
		Size size(width, height);
		cameramat.at<float>(0) = m_focalPoint;	//f=3.1mm
		cameramat.at<float>(1) = 0.0f;
		cameramat.at<float>(2) = (float)(width / 2);
		cameramat.at<float>(3) = 0.0f;
		cameramat.at<float>(4) = m_focalPoint;
		cameramat.at<float>(5) = (float)(height / 2);
		cameramat.at<float>(6) = 0.0f;
		cameramat.at<float>(7) = 0.0f;
		cameramat.at<float>(8) = 1.0f;
		Mat camPs = getOptimalNewCameraMatrix(cameramat, distorsionCoeff, size, 0, size, 0);

		//Undistort
		if (eye == OV_CAMEYE_LEFT) {
			//Mat camPs = getOptimalNewCameraMatrix(m_leftCameraInstric, distorsionCoeff, size, 0, size, 0);
			initUndistortRectifyMap(m_leftCameraInstric, m_leftCameraDistortion, m_R1,
				camPs, size, CV_32FC1, mapX, mapY);
		}
		if (eye == OV_CAMEYE_RIGHT) {
			//Mat camPs = getOptimalNewCameraMatrix(m_rightCameraInstric, distorsionCoeff, size, 0, size, 0);
			initUndistortRectifyMap(m_rightCameraInstric, m_rightCameraDistortion, m_R2,
				camPs, size, CV_32FC1, mapX, mapY);
		}
	}
};
