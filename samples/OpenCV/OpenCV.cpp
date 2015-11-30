// OpenCV.cpp : コンソール アプリケーションのエントリ ポイントを定義します。
//

#include <opencv2/core.hpp>
#include <opencv2/highgui.hpp>
#include <opencv2/imgproc.hpp>

#include "ovrvision_pro.h"

#define CROP_W 800
#define CROP_H 600

//using namespace std;
using namespace cv;
using namespace OVR;

static 	OvrvisionPro ovrvision;

int callback(void *pItem, const char *extensions)
{
	if (extensions != NULL)
	{
		puts(extensions);
	}
	return 0;
}

// Estimate skin color 
void estimateSkincolor(Mat &histgram, OvrvisionPro &camera, ROI roi)
{
	Mat left(roi.height, roi.width, CV_8UC4);
	Mat right(roi.height, roi.width, CV_8UC4);
	Mat images[2];
	images[0].create(roi.height, roi.width, CV_8UC4);
	images[1].create(roi.height, roi.width, CV_8UC4);

	int channels[] = { 0, 1 }; // H, S
	int histSize[] = { 256, 256 };
	float hranges[] = { 0, 256 };
	float sranges[] = { 0, 256 };
	const float* ranges[] = { hranges, sranges };

	while (waitKey(10) != 'a')
	{
		// Capture frame
		ovrvision.Capture(Camqt::OV_CAMQT_DMSRMP);

		// Retrieve frame data
		ovrvision.GetStereoImageBGRA(left.data, right.data, roi);
		imshow("Left", left);
		imshow("Right", right);
	}

	// back ground
	Mat background(256, 256, CV_32FC1);
	background.setTo(Scalar::all(0));
	for (int i = 0; i < 50; i++)
	{
		// Capture frame
		ovrvision.Capture(Camqt::OV_CAMQT_DMSRMP);

		// Retrieve frame data
		ovrvision.GetStereoImageBGRA(left.data, right.data, roi);
		cvtColor(left, images[0], CV_BGR2HSV_FULL);
		cvtColor(right, images[1], CV_BGR2HSV_FULL);
		calcHist(images, 2, channels, Mat(), background, 2, histSize, ranges, true, true);

		imshow("Left", left);
		imshow("Right", right);
	}
	while (waitKey(10) != 'a')
	{
		// Capture frame
		ovrvision.Capture(Camqt::OV_CAMQT_DMSRMP);

		// Retrieve frame data
		ovrvision.GetStereoImageBGRA(left.data, right.data, roi);

		putText(left, "Waiting...", Point(0, 50), cv::FONT_HERSHEY_PLAIN, 3, Scalar(0, 255, 255), 2);
		putText(right, "Waiting...", Point(0, 50), cv::FONT_HERSHEY_PLAIN, 3.0, Scalar(0, 255, 255), 2);
		imshow("Left", left);
		imshow("Right", right);
	}

	// weave hands
	Mat foreground(256, 256, CV_32FC1);
	foreground.setTo(Scalar::all(0));
	for (int i = 0; i < 50; i++)
	{
		// Capture frame
		ovrvision.Capture(Camqt::OV_CAMQT_DMSRMP);

		// Retrieve frame data
		ovrvision.GetStereoImageBGRA(left.data, right.data, roi);
		cvtColor(left, images[0], CV_BGR2HSV_FULL);
		cvtColor(right, images[1], CV_BGR2HSV_FULL);
		calcHist(images, 2, channels, Mat(), foreground, 2, histSize, ranges, true, true);

		putText(left, "Initiating...", Point(0, 50), cv::FONT_HERSHEY_PLAIN, 3, Scalar(0, 255, 255), 2);
		putText(right, "Initiating...", Point(0, 50), cv::FONT_HERSHEY_PLAIN, 3.0, Scalar(0, 255, 255), 2);
		imshow("Left", left);
		imshow("Right", right);
	}
	
	// Compare histgram
	Mat difference(256, 256, CV_32FC1);
	difference.setTo(Scalar::all(0));
	float maxVal = 0;
	for (int h = 3; h < 256; h++)
	{
		float *b = background.ptr<float>(h);
		float *f = foreground.ptr<float>(h);
		float *d = difference.ptr<float>(h);
		for (int s = 0; s < 256; s++)
		{
			float diff = f[s] - b[s];
			if (0 < diff)
			{
				d[s] = diff;
				if (maxVal < diff)
					maxVal = diff;
			}
		}
	}
	Mat diff(256, 256, CV_32FC1);
	GaussianBlur(difference, diff, Size(3, 3), 8, 6);
	//normalize(background, histgram, 0, 255, NORM_MINMAX, histgram.type());
	//imshow("background", histgram);
	//normalize(foreground, histgram, 0, 255, NORM_MINMAX, histgram.type());
	//imshow("foreground", histgram);
	normalize(diff, histgram, 0, 255, NORM_MINMAX, histgram.type());
	imshow("histgram", histgram);
}

int main(int argc, char* argv[])
{
	if (ovrvision.Open(0, Camprop::OV_CAMHD_FULL))
	{
		int ksize = 5;
		int width = ovrvision.GetCamWidth();
		int height = ovrvision.GetCamHeight();
		ROI roi = {(width - CROP_W) / 2, (height - CROP_H) / 2, CROP_W, CROP_H};
		Mat left(roi.height, roi.width, CV_8UC4);
		Mat right(roi.height, roi.width, CV_8UC4);
		Mat histgram(256, 256, CV_8UC1);

		Mat LEFT(roi.height / 2, roi.width / 2, CV_8UC4);
		Mat RIGHT(roi.height / 2, roi.width / 2, CV_8UC4);
		Mat Lhsv(roi.height / 2, roi.width / 2, CV_8UC3);
		Mat Rhsv(roi.height / 2, roi.width / 2, CV_8UC3);
		Mat Lresult(roi.height / 2, roi.width / 2, CV_8UC4);
		Mat Rresult(roi.height / 2, roi.width / 2, CV_8UC4);
		Mat blur(roi.height / 2, roi.width / 2, CV_8UC4);

		std::vector<std::vector<Point>> contours;

		//Sync
		ovrvision.SetCameraSyncMode(true);

		Camqt mode = Camqt::OV_CAMQT_DMSRMP;
		bool show = true;

		estimateSkincolor(histgram, ovrvision, roi);

		for (bool loop = true; loop;)
		{
			if (show)
			{
				// Capture frame
				ovrvision.Capture(mode);

				// Retrieve frame data
				ovrvision.GetStereoImageBGRA(left.data, right.data, roi);

				// ここでOpenCVでの加工など
				if (0 < ksize)
				{
					resize(left, LEFT, LEFT.size());
					cvtColor(LEFT, Lhsv, CV_BGR2HSV_FULL);
					resize(right, RIGHT, RIGHT.size());
					cvtColor(RIGHT, Rhsv, CV_BGR2HSV_FULL);

					Lresult.setTo(Scalar::all(0));
					Rresult.setTo(Scalar::all(0));
					for (uint y = 0; y < roi.height / 2; y++)
					{
						Vec3b *l = Lhsv.ptr<Vec3b>(y);
						Vec3b *r = Rhsv.ptr<Vec3b>(y);
						Vec4b *Lpixel = Lresult.ptr<Vec4b>(y);
						Vec4b *Rpixel = Rresult.ptr<Vec4b>(y);
						for (uint x = 0; x < roi.width / 2; x++)
						{
							uchar h = l[x][0];
							uchar s = l[x][1];
							if (15 <= h && h <= 29 && 55 < s && s < 160)
							{
								Lpixel[x] = LEFT.at<Vec4b>(y, x);
							}
							h = r[x][0];
							s = r[x][1];
							if (15 <= h && h <= 29 && 55 < s && s < 160)
							{
								Rpixel[x] = RIGHT.at<Vec4b>(y, x);
							}
						}
					}
					medianBlur(Lresult, blur, ksize);
					// Show frame data
					imshow("Left", LEFT);
					imshow("Right", RIGHT);
					imshow("L", Lresult);
					imshow("R", Rresult);
					imshow("Blur", blur);
					imshow("Lhsv", Lhsv);
				}
				else
				{
					// Show frame data
					imshow("Left", left);
					imshow("Right", right);
				}
			}
			else
			{
				ovrvision.Capture(mode);
			}

			switch (waitKey(1))
			{
			case 'q':
				loop = false;
				break;

			case 'r':
				mode = Camqt::OV_CAMQT_DMSRMP;
				break;

			case 'd':
				mode = Camqt::OV_CAMQT_DMS;
				break;

			case 's':
				show = true;
				break;

			case 'n':
				show = false;
				break;

			case '0':
			case '1':
				ksize = 0;
				break;

			case '3':
				ksize = 3;
				break;

			case '5':
				ksize = 5;
				break;

			case '7':
				ksize = 7;
				break;

			case '9':
				ksize = 9;
				break;

			case ' ':
				imwrite("left.png", left);
				imwrite("right.png", right);
				imwrite("histgram.png", histgram);
				imwrite("hsv_l.png", Lhsv);
				imwrite("result_l.png", Lresult);
				imwrite("blur_l.png", blur);
				break;

			case 'e':
				if (callback != NULL)
				{
					callback(NULL, "Device Extensions");
				}
				ovrvision.OpenCLExtensions(callback, NULL);
				break;
			}
		}
	}
	else
	{
		puts("FAILED TO OPEN CAMERA");
	}
	return 0;
}


