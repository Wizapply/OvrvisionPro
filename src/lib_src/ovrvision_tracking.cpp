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
#pragma comment(lib, "Comctl32.lib")
#pragma comment(lib, "IlmImf.lib")
#pragma comment(lib, "ippicvmt.lib")
#pragma comment(lib, "libjpeg.lib")
#pragma comment(lib, "libpng.lib")
#pragma comment(lib, "libtiff.lib")
#pragma comment(lib, "libwebp.lib")
#pragma comment(lib, "libjasper.lib")
#pragma comment(lib, "opencv_highgui300.lib") 
//#define OV_CONFIG_USEOPENCL



/////////// VARS AND DEFS ///////////

#define OV_RGB_DATASIZE		(4)	//32bit

/////////// CLASS ///////////

//OVR Group
namespace OVR {

	cv::Point2i dasdasa(cv::Mat &image);

//Constructor/Destructor
OvrvisionTracking::OvrvisionTracking(int w, int h, float focalpoint)
{
	m_pImageSrc[OV_CAMEYE_LEFT] = NULL;
	m_pImageSrc[OV_CAMEYE_RIGHT] = NULL;
	m_pImageOpenCVMat[OV_CAMEYE_LEFT] = NULL;
	m_pImageOpenCVMat[OV_CAMEYE_RIGHT] = NULL;

	m_width = w;
	m_height = h;

	m_hue_min = 85;
	m_hue_max = 150;
	m_set = false;
}

//OvrvisionAR::OvrvisionAR(int markersize){}
OvrvisionTracking::~OvrvisionTracking()
{

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
	//m_pImageOpenCVMat[OV_CAMEYE_LEFT] = pLeftImageMat;
	//m_pImageOpenCVMat[OV_CAMEYE_RIGHT] = pRightImageMat;
}

//Detect marker
void OvrvisionTracking::Render() {
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
	cv::cvtColor(pCamBGR_L, pCamBGR_L, CV_BGR2HLS);		// BGR->HLS変換

	cv::Mat pCamBGR_R(pCamBGRAResize_R.size(), CV_MAKETYPE(CV_8U, 3));
	cv::cvtColor(pCamBGRAResize_R, pCamBGR_R, CV_BGRA2BGR);		// BGRA->BGR変換
	cv::cvtColor(pCamBGR_R, pCamBGR_R, CV_BGR2HLS);		// BGR->HLS変換

	//抽出済みの２値
	cv::Mat pCamExtractionImg_L(pCamBGR_L.size(), CV_MAKETYPE(CV_8U, 1));
	cv::Mat pCamExtractionImg_R(pCamBGR_R.size(), CV_MAKETYPE(CV_8U, 1));
	unsigned char* thPointerL = (unsigned char*)pCamExtractionImg_L.data;
	unsigned char* thPointerR = (unsigned char*)pCamExtractionImg_R.data;
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
			thPointerL[(i*pCamBGR_L.cols + j)] = 0;
			thPointerR[(i*pCamBGR_R.cols + j)] = 0;
			if ((t >= m_hue_min && t <= m_hue_max) && (s >= 10 && s <= 240) && (v >= 10 && v <= 240)) {
				thPointerL[(i*pCamBGR_L.cols + j)] = 255;					//A(FULL)
			}
			if ((tr >= m_hue_min && tr <= m_hue_max) && (sr >= 10 && sr <= 240) && (vr >= 10 && vr <= 240)) {
				thPointerR[(i*pCamBGR_R.cols + j)] = 255;					//A(FULL)
			}

			if ((t >= 20 && t <= 30) && (s >= 10 && s <= 240) && (v >= 10 && v <= 240)) {
			//	thPointerL[(i*pCamBGR_L.cols + j)] = 128;					//A(FULL)
			}
			if ((tr >= 20 && tr <= 30) && (sr >= 10 && sr <= 240) && (vr >= 10 && vr <= 240)) {
				//thPointerR[(i*pCamBGR_R.cols + j)] = 128;					//A(FULL)
			}
		}
	}

	cv::Point2i lpos = dasdasa(pCamExtractionImg_L);
	cv::Point2i rpos = dasdasa(pCamExtractionImg_R);

	if (m_set) {
		cv::Vec3b colorhls_l = pCamBGR_L.at<cv::Vec3b>(pCamBGR_L.size().width / 2, pCamBGR_L.size().height / 2);
		//cv::Vec3b colorhls_r = pCamBGR_R.at<cv::Vec3b>(rpos.x, rpos.y);
		m_hue_min = colorhls_l[0] - 5;
		m_hue_max = colorhls_l[0] + 5;
		m_set = false;
	}

	cv::circle(pCamBGRAImg_L, cv::Point(lpos.x*4.0f, lpos.y*4.0f), 20, cv::Scalar(0, 0, 255), -1, 0);
	cv::circle(pCamBGRAImg_L, cv::Point(rpos.x*4.0f, rpos.y*4.0f), 30, cv::Scalar(0, 255, 255), -1, 0);

	cv::circle(pCamBGRAImg_R, cv::Point(lpos.x*4.0f, lpos.y*4.0f), 20, cv::Scalar(0, 0, 255), -1, 0);
	cv::circle(pCamBGRAImg_R, cv::Point(rpos.x*4.0f, rpos.y*4.0f), 30, cv::Scalar(0, 255, 255), -1, 0);

	cv::circle(pCamBGRAImg_L, cv::Point(pCamBGRAImg_L.size().width / 2, pCamBGRAImg_L.size().height / 2), 10, cv::Scalar(255, 0, 0), 1, 0);
	cv::imshow("dOvrasda32", pCamBGRAImg_L);
	cv::imshow("dOvrasda2", pCamExtractionImg_L);

}

cv::Point2i dasdasa(cv::Mat &image) {
	// ラベル用画像生成(※CV_32S or CV_16Uにする必要あり)
	cv::Mat labelImage(image.size(), CV_32S);
	// ラベリング実行．戻り値がラベル数．また，このサンプルでは8近傍でラベリングする．
	int nLabelsL = cv::connectedComponents(image, labelImage, 8);

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
			}

		}
	}

	cv::Point2i center = cv::Point2i(0, 0);
	cv::Moments moment = cv::moments(dst, true);
	if (moment.m00 != 0)
	{
		center.x = (int)(moment.m10 / moment.m00);
		center.y = (int)(moment.m01 / moment.m00);
	}

	return center;
}

//Get tracking data


//Private Methods


void OvrvisionTracking::SetHue(){
	m_set = true;
}
};