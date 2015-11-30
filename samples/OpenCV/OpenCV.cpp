// OpenCV.cpp : コンソール アプリケーションのエントリ ポイントを定義します。
//

#include <opencv2/core.hpp>
#include <opencv2/highgui.hpp>
#include <opencv2/imgproc.hpp>

#include "ovrvision_pro.h"

#define CROP_W 800
#define CROP_H 600

using namespace std;
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
		Mat histgram(256, 256, CV_16UC1);

		Mat LEFT(roi.height / 2, roi.width / 2, CV_8UC4);
		Mat RIGHT(roi.height / 2, roi.width / 2, CV_8UC4);
		Mat Lhsv(roi.height / 2, roi.width / 2, CV_8UC3);
		Mat Rhsv(roi.height / 2, roi.width / 2, CV_8UC3);
		Mat Lresult(roi.height / 2, roi.width / 2, CV_8UC4);
		Mat Rresult(roi.height / 2, roi.width / 2, CV_8UC4);
		Mat blur(roi.height / 2, roi.width / 2, CV_8UC4);

		vector<vector<Point>> contours;

		//Sync
		ovrvision.SetCameraSyncMode(true);

		Camqt mode = Camqt::OV_CAMQT_DMSRMP;
		bool show = true;

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

					histgram.setTo(Scalar::all(0));
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
							if (15 <= h && h <= 29 && 55 < s && s < 150)
							{
								Lpixel[x] = LEFT.at<Vec4b>(y, x);
							}
							ushort *hs = histgram.ptr<ushort>(s, h);
							hs[0]++;
							h = r[x][0];
							s = r[x][1];
							if (15 <= h && h <= 29 && 55 < s && s < 150)
							{
								Rpixel[x] = RIGHT.at<Vec4b>(y, x);
							}
							hs = histgram.ptr<ushort>(s, h);
							hs[0]++;
						}
					}
					medianBlur(Lresult, blur, ksize);
					//threshold(LEFT, bilevel, 30, 255, THRESH_BINARY_INV);
					//Canny(LEFT, bilevel, 50, 150);
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
				//imwrite("histgram.png", histgram);
				imwrite("Hue.png", LEFT);
				//imwrite("Sat.png", Lhsv[1]);
				imwrite("Lhsv.png", Lhsv);
				//imwrite("HCrCb.png", Lresult);
				//imwrite("YCrCb.png", YCrCb);
				imwrite("left.png", left);
				imwrite("right.png", right);
				imwrite("Lresult.tiff", Lresult);
				imwrite("blur.png", blur);
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


