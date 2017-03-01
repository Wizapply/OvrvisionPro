// ovrvision_tracking.cpp
//
//MIT License
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//THE SOFTWAR
//
// Oculus Rift : TM & Copyright Oculus VR, Inc. All Rights Reserved
// Unity : TM & Copyright Unity Technologies. All Rights Reserved

/////////// INCLUDE ///////////

#include "ovrvision_tracking.h"

#pragma warning(disable : 4819)
#include <opencv/cv.h>
#include <opencv2/core/core.hpp>
#include <opencv2/imgproc/imgproc.hpp>
#include <opencv2/highgui/highgui.hpp>
#pragma warning(default : 4819)

//for cv::imshow
#ifdef _DEBUG
#pragma comment(lib, "Comctl32.lib")
#pragma comment(lib, "IlmImfd.lib")
#pragma comment(lib, "ippicvmt.lib")
#pragma comment(lib, "libjpegd.lib")
#pragma comment(lib, "libpngd.lib")
#pragma comment(lib, "libtiffd.lib")
#pragma comment(lib, "libwebpd.lib")
#pragma comment(lib, "libjasperd.lib")
#pragma comment(lib, "strmiids.lib")
#pragma comment(lib, "zlibd.lib")
#pragma comment(lib, "opencv_highgui320d.lib")
#else
#pragma comment(lib, "Comctl32.lib")
#pragma comment(lib, "IlmImf.lib")
#pragma comment(lib, "ippicvmt.lib")
#pragma comment(lib, "libjpeg.lib")
#pragma comment(lib, "libpng.lib")
#pragma comment(lib, "libtiff.lib")
#pragma comment(lib, "libwebp.lib")
#pragma comment(lib, "libjasper.lib")
#pragma comment(lib, "strmiids.lib")
#pragma comment(lib, "zlib.lib")
#pragma comment(lib, "opencv_highgui320.lib")
#endif
//#define OV_CONFIG_USEOPENCL

#include "ovrvision_handimage.h"

/////////// VARS AND DEFS ///////////

#define OV_RGB_DATASIZE		(4)	//32bit

/////////// CLASS ///////////

//OVR Group
namespace OVR {

cv::Point2i FingerTracker(cv::Mat &image, cv::Mat &fgimage);

cv::Mat g_pImageHandCalib;

//Constructor/Destructor
OvrvisionTracking::OvrvisionTracking(int w, int h, float focalpoint)
{
	m_pImageSrc[OV_CAMEYE_LEFT] = NULL;
	m_pImageSrc[OV_CAMEYE_RIGHT] = NULL;
	m_pImageOpenCVMat[OV_CAMEYE_LEFT] = NULL;
	m_pImageOpenCVMat[OV_CAMEYE_RIGHT] = NULL;

	m_width = w;
	m_height = h;
	m_focalpoint = focalpoint;

	m_hue_min = 0;
	m_hue_max = 0;

	m_hue_min_finger = 0;
	m_hue_max_finger = 0;

	m_pos_x = 0.0f;
	m_pos_y = 0.0f;
	m_pos_z = 0.0f;

	cv::Mat dat = cv::Mat(cv::Size(sizeof(g_handImage), 1), CV_MAKETYPE(CV_8U, 1), g_handImage);
	g_pImageHandCalib = cv::imdecode(dat, CV_LOAD_IMAGE_UNCHANGED);
	cv::cvtColor(g_pImageHandCalib, g_pImageHandCalib, CV_RGB2BGRA);
	
	m_set = false;
}

//OvrvisionAR::OvrvisionAR(int markersize){}
OvrvisionTracking::~OvrvisionTracking()
{
	g_pImageHandCalib.release();
}

//image set
void OvrvisionTracking::SetImageBGRA(unsigned char* pLeftImage, unsigned char* pRightImage)
{
	m_pImageSrc[OV_CAMEYE_LEFT] = pLeftImage;
	m_pImageSrc[OV_CAMEYE_RIGHT] = pRightImage;
	m_pImageOpenCVMat[OV_CAMEYE_LEFT] = NULL;
	m_pImageOpenCVMat[OV_CAMEYE_RIGHT] = NULL;
}

void OvrvisionTracking::SetImageOpenCVImage(ovMat* pLeftImageMat, ovMat* pRightImageMat)
{
	m_pImageSrc[OV_CAMEYE_LEFT] = NULL;
	m_pImageSrc[OV_CAMEYE_RIGHT] = NULL;
	m_pImageOpenCVMat[OV_CAMEYE_LEFT] = pLeftImageMat;
	m_pImageOpenCVMat[OV_CAMEYE_RIGHT] = pRightImageMat;
}

//Detect marker
void OvrvisionTracking::Render(bool calib, bool debug) {
	cv::Mat	pCamBGRAImg_L;
	cv::Mat	pCamBGRAImg_R;

	if (m_pImageSrc[OV_CAMEYE_LEFT] == NULL ||
		m_pImageSrc[OV_CAMEYE_RIGHT] == NULL)
		return;

	//create image
	pCamBGRAImg_L = cv::Mat(cv::Size(m_width, m_height), CV_MAKETYPE(CV_8U, OV_RGB_DATASIZE), m_pImageSrc[OV_CAMEYE_LEFT]);
	pCamBGRAImg_R = cv::Mat(cv::Size(m_width, m_height), CV_MAKETYPE(CV_8U, OV_RGB_DATASIZE), m_pImageSrc[OV_CAMEYE_RIGHT]);

	cv::Mat pCamBGRAResize_L(cv::Size(m_width / 4, m_width / 4), CV_MAKETYPE(CV_8U, OV_RGB_DATASIZE));
	cv::resize(pCamBGRAImg_L, pCamBGRAResize_L, cv::Size(m_width / 4, m_width / 4), cv::INTER_CUBIC);
	cv::Mat pCamBGRAResize_R(cv::Size(m_width / 4, m_width / 4), CV_MAKETYPE(CV_8U, OV_RGB_DATASIZE));
	cv::resize(pCamBGRAImg_R, pCamBGRAResize_R, cv::Size(m_width / 4, m_width / 4), cv::INTER_CUBIC);

	//変換
	cv::Mat pCamBGR_L(pCamBGRAResize_L.size(), CV_MAKETYPE(CV_8U, 3));
	cv::cvtColor(pCamBGRAResize_L, pCamBGR_L, CV_BGRA2BGR);		// BGRA->BGR変換
	cv::cvtColor(pCamBGR_L, pCamBGR_L, CV_BGR2HLS);				// BGR->HLS変換

	cv::Mat pCamBGR_R(pCamBGRAResize_R.size(), CV_MAKETYPE(CV_8U, 3));
	cv::cvtColor(pCamBGRAResize_R, pCamBGR_R, CV_BGRA2BGR);		// BGRA->BGR変換
	cv::cvtColor(pCamBGR_R, pCamBGR_R, CV_BGR2HLS);				// BGR->HLS変換

	//抽出済みの２値
	cv::Mat pCamExtractionImg_L(pCamBGR_L.size(), CV_MAKETYPE(CV_8U, 1));
	cv::Mat pCamExtractionImg_R(pCamBGR_R.size(), CV_MAKETYPE(CV_8U, 1));
	cv::Mat pCamExtractionImgFinger_L(pCamBGR_L.size(), CV_MAKETYPE(CV_8U, 1));
	cv::Mat pCamExtractionImgFinger_R(pCamBGR_R.size(), CV_MAKETYPE(CV_8U, 1));
	pCamExtractionImg_L = cv::Scalar::all(0);
	pCamExtractionImg_R = cv::Scalar::all(0);
	pCamExtractionImgFinger_L = cv::Scalar::all(0);
	pCamExtractionImgFinger_R = cv::Scalar::all(0);

	unsigned char* thPointerL = (unsigned char*)pCamExtractionImg_L.data;
	unsigned char* thPointerR = (unsigned char*)pCamExtractionImg_R.data;
	unsigned char* thPointerFgL = (unsigned char*)pCamExtractionImgFinger_L.data;
	unsigned char* thPointerFgR = (unsigned char*)pCamExtractionImgFinger_R.data;

	//RGBモノトーン、HSV色空間での抽出
	int i, j;
	for (i = 0; i < pCamBGR_L.rows; i++) {
		for (j = 0; j < pCamBGR_L.cols; j++) {
			unsigned char t = pCamBGR_L.data[(i*pCamBGR_L.cols + j) * 3];
			unsigned char s = pCamBGR_L.data[(i*pCamBGR_L.cols + j) * 3 + 1];
			unsigned char v = pCamBGR_L.data[(i*pCamBGR_L.cols + j) * 3 + 2];
			unsigned char tr = pCamBGR_R.data[(i*pCamBGR_R.cols + j) * 3];
			unsigned char sr = pCamBGR_R.data[(i*pCamBGR_R.cols + j) * 3 + 1];
			unsigned char vr = pCamBGR_R.data[(i*pCamBGR_R.cols + j) * 3 + 2];

			//除外
			if ((t >= m_hue_min && t <= m_hue_max) && (s >= 10 && s <= 240) && (v >= 10 && v <= 240)) {
				thPointerL[(i*pCamBGR_L.cols + j)] = pCamBGR_L.data[(i*pCamBGR_L.cols + j) * 3 + 1];					//A(FULL)
			}
			if ((tr >= m_hue_min && tr <= m_hue_max) && (sr >= 10 && sr <= 240) && (vr >= 10 && vr <= 240)) {
				thPointerR[(i*pCamBGR_R.cols + j)] = pCamBGR_R.data[(i*pCamBGR_R.cols + j) * 3 + 1];					//A(FULL)
			}

			if ((t >= m_hue_min_finger && t <= m_hue_max_finger) && (s >= 10 && s <= 240) && (v >= 10 && v <= 240)) {
				thPointerFgL[(i*pCamBGR_L.cols + j)] = 255;					//A(FULL
				thPointerL[(i*pCamBGR_L.cols + j)] = pCamBGR_L.data[(i*pCamBGR_L.cols + j) * 3 + 1];
			}
			if ((tr >= m_hue_min_finger && tr <= m_hue_max_finger) && (sr >= 10 && sr <= 240) && (vr >= 10 && vr <= 240)) {
				thPointerFgR[(i*pCamBGR_R.cols + j)] = 255;					//A(FULL)
				thPointerR[(i*pCamBGR_R.cols + j)] = pCamBGR_R.data[(i*pCamBGR_R.cols + j) * 3 + 1];					//A(FULL)
			}
		}
	}

	cv::Point2i lpos = FingerTracker(pCamExtractionImg_L, pCamExtractionImgFinger_L);
	cv::Point2i rpos = FingerTracker(pCamExtractionImg_R, pCamExtractionImgFinger_R);

	if (m_set) {
		cv::Vec3b colorhls_l = pCamBGR_L.at<cv::Vec3b>(pCamBGR_L.size().height / 2 + 20, pCamBGR_L.size().width / 2 + 20);
		cv::Vec3b colorhls_fg = pCamBGR_L.at<cv::Vec3b>(pCamBGR_L.size().height / 2, pCamBGR_L.size().width / 2);
		m_hue_min = colorhls_l[0] - 5;
		m_hue_max = colorhls_l[0] + 5;

		m_hue_min_finger = colorhls_fg[0] - 8;
		m_hue_max_finger = colorhls_fg[0] + 8;
		m_set = false;
	}

	cv::cvtColor(pCamBGR_L, pCamBGR_L, CV_HLS2BGR);				// 変換


	//Default camera matrix
	cv::Mat cameramat(3, 3, CV_32FC1);
	cv::Mat cameramat_inv(3, 3, CV_32FC1);
	cv::Mat distorsionCoeff(1, 8, CV_32FC1, 0.0);
	cv::Size size(m_width, m_height);
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

	cameramat.at<float>(0) = m_focalpoint * (float)m_focalPointScale;
	cameramat.at<float>(1) = 0.0f;
	cameramat.at<float>(2) = (float)(size.width / 2);
	cameramat.at<float>(3) = 0.0f;
	cameramat.at<float>(4) = m_focalpoint * (float)m_focalPointScale;
	cameramat.at<float>(5) = (float)(size.height / 2);
	cameramat.at<float>(6) = 0.0f;
	cameramat.at<float>(7) = 0.0f;
	cameramat.at<float>(8) = 1.0f;

	cv::invert(cameramat, cameramat_inv, CV_LU);

	if (lpos.x != 0 && lpos.y != 0) {
		if (rpos.x != 0 && rpos.y != 0) {
			float pos_x = lpos.x*4.0f;
			float pos_y = lpos.y*4.0f;
			float posr_x = rpos.x*4.0f;
			float posr_y = rpos.y*4.0f;

			m_pos_z = (m_focalpoint * 0.06f) / (pos_x - posr_x);

			m_pos_x = ((pos_x*2.0f) / (float)m_width) - 1.0f;
			m_pos_y = ((pos_y*-2.0f) / (float)m_height) + 1.0f;
			
			m_pos_x *= m_pos_z;
			m_pos_y *= m_pos_z;

			m_lifetime = 10;
		}
	}
	else {
		if (m_lifetime > 0) {
			--m_lifetime;
		}
		else {
			m_pos_x = m_pos_y = m_pos_z = 0.0f;
		}
	}

	if (debug) {
		if (m_pos_z > 0.0f && m_pos_z < 1.0f) {
			char buf[32];
			sprintf(buf, "X:%.4f,Y%.4f,Z:%.4f", m_pos_x, m_pos_y,m_pos_z);
			cv::putText(pCamBGRAImg_L, buf, cv::Point(m_width/2-200, m_height/2-200), cv::FONT_HERSHEY_SIMPLEX, 0.5, cv::Scalar(0, 0, 255, 255), 2, 0);
		}
	}

	if (calib) {
		cv::circle(pCamBGRAImg_L, cv::Point(pCamBGRAImg_L.size().width / 2 + (20 * 4), pCamBGRAImg_L.size().height / 2 + (20 * 4)), 10, cv::Scalar(0, 0, 255, 255), 3, 0);
		cv::circle(pCamBGRAImg_L, cv::Point(pCamBGRAImg_L.size().width / 2, pCamBGRAImg_L.size().height / 2), 10, cv::Scalar(255, 0, 0, 255), 3, 0);
		cv::Mat srcROIMat(pCamBGRAImg_L, cv::Rect(0, 0, g_pImageHandCalib.cols, g_pImageHandCalib.rows));
		pCamBGRAImg_L += g_pImageHandCalib;
	}
}

cv::Point2i FingerTracker(cv::Mat &image, cv::Mat &fgimage)
{
	cv::Mat canny_image(image.size(), CV_MAKETYPE(CV_8U, 1));
	cv::Canny(image, canny_image, 50, 200, 3);
	canny_image = ~canny_image;
	cv::erode(canny_image, canny_image, cv::Mat(), cv::Point(-1, -1), 1);
	cv::Mat image_detect = image & canny_image;

	// ラベル用画像生成(※CV_32S or CV_16Uにする必要あり)
	cv::Mat labelImage(image_detect.size(), CV_32S);
	// ラベリング実行．戻り値がラベル数．また，このサンプルでは8近傍でラベリングする．
	int nLabelsL = cv::connectedComponents(image_detect, labelImage, 8);

	// ラベリング結果の描画色を決定
	std::vector<unsigned int> colors(nLabelsL);
	colors.clear();
	for (int y = 0; y < labelImage.rows; ++y)
		for (int x = 0; x < labelImage.cols; ++x)
			colors[labelImage.at<int>(y, x)]++;

	int maxs = 0;
	int save = 0;
	for (int i = 1; i < nLabelsL; i++) {
		if (maxs < colors[i]) {
			maxs = colors[i];
			save = i;
		}
	}

	int mensize = 0;
	cv::Mat dst(image.size(), CV_8UC1);
	for (int y = 0; y < dst.rows; ++y)
	{
		for (int x = 0; x < dst.cols; ++x)
		{
			int label = labelImage.at<int>(y, x);
			unsigned char &pixel = dst.at<unsigned char>(y, x);
			pixel = 0x00;
			if (label == save) {
				pixel = 0xFF;
				++mensize;
			}
		}
	}

	cv::Point2i center = cv::Point2i(0, 0);

	if (mensize < 30)
		return center;

	cv::dilate(dst, dst, cv::Mat(), cv::Point(-1, -1), 12);
	cv::dilate(dst, dst, cv::Mat(), cv::Point(-1, -1), 12);
	cv::dilate(dst, dst, cv::Mat(), cv::Point(-1, -1), 10);
	cv::Mat dst_img2 = fgimage & dst;
	cv::erode(dst_img2, dst_img2, cv::Mat(), cv::Point(-1, -1), 1);
	//cv::imshow("hand", dst);
	//cv::imshow("finger", fgimage);
	//cv::imshow("output", dst_img2);

	cv::Moments moment = cv::moments(dst_img2, true);
	if (moment.m00 != 0)
	{
		center.x = (int)(moment.m10 / moment.m00);
		center.y = (int)(moment.m01 / moment.m00);
	}

	return center;
}

/*
double cmin, cmax;
cv::Mat pdes, pDisparity_data;

//cv::Mat pCamBGRAGrayImg_L(pCamExtractionImg_L.size(), CV_MAKETYPE(CV_8U, 1));
//cv::Mat pCamBGRAGrayImg_R(pCamExtractionImg_R.size(), CV_MAKETYPE(CV_8U, 1));
//cv::cvtColor(pCamBGRAResize_L, pCamBGRAGrayImg_L, CV_BGRA2GRAY);
//cv::cvtColor(pCamBGRAResize_R, pCamBGRAGrayImg_R, CV_BGRA2GRAY);

cv::Ptr<cv::StereoBM> bm = cv::StereoBM::create(m_dasat, m_dasat2);
bm->compute(pCamExtractionImg_L, pCamExtractionImg_R, pDisparity_data);

cv::minMaxLoc(pDisparity_data, &cmin, &cmax);
pDisparity_data.convertTo(pdes, CV_8UC1, 255.0 / (cmax - cmin), -255.0 * cmin / (cmax - cmin));
//cv::normalize(pDisparity_map, pDisparity_map, 0, 255);
cv::imshow("ovr_test", pdes);

cv::imshow("ovr_test2", pCamExtractionImg_L);

*/

//Get tracking data


//Private Methods

void OvrvisionTracking::SetHue(){
	m_set = true;
}
};