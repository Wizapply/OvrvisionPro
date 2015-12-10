// OpenCV.cpp : コンソール アプリケーションのエントリ ポイントを定義します。
//

#include <opencv2/core.hpp>
#include <opencv2/highgui.hpp>
#include <opencv2/imgproc.hpp>

#include "ovrvision_pro.h"

#define CROP_W 1024
#define CROP_H 768

//using namespace std;
using namespace cv;
using namespace OVR;

//static 	OvrvisionPro ovrvision;

int callback(void *pItem, const char *extensions)
{
	if (extensions != NULL)
	{
		puts(extensions);
	}
	return 0;
}


enum FILTER {
	GAUSSIAN,
	MEDIAN,
	NONE,
};

int main(int argc, char* argv[])
{
	OvrvisionPro *ovrvision = new OvrvisionPro();
	if (ovrvision->Open(0, Camprop::OV_CAMHD_FULL))
	{
		int ksize = 5;
		enum FILTER filter = GAUSSIAN;
		int width = ovrvision->GetCamWidth() / 2;
		int height = ovrvision->GetCamHeight() / 2;
		ROI roi = { 0, 0, width, height };
		Camqt mode = Camqt::OV_CAMQT_DMSRMP;
		//bool show = true;
		bool useHistgram = false;

		Mat images[2];
		Mat bilevel[2];
		Mat hsv[2], HSV[2];
		Mat results[2];
		Mat histgram(180, 256, CV_8UC1);

		results[0].create(height, width, CV_8UC4);
		results[1].create(height, width, CV_8UC4);
		hsv[0].create(height, width, CV_8UC4);
		hsv[1].create(height, width, CV_8UC4);
		HSV[0].create(height, width, CV_8UC4);
		HSV[1].create(height, width, CV_8UC4);
		images[0].create(height, width, CV_8UC4);
		images[1].create(height, width, CV_8UC4);
		bilevel[0].create(height, width, CV_8UC1);
		bilevel[1].create(height, width, CV_8UC1);

		//Sync
		ovrvision->SetCameraSyncMode(true);

		//_h_low = 13;
		//_h_high = 21;
		//_s_low = 88;
		//_s_high = 136;
		ovrvision->SetSkinHSV(9, 22, 80, 143);

		for (bool loop = true; loop;)
		{
			//if (show)
			//{
			// Capture frame
			ovrvision->Capture(mode);

			// Retrieve frame data
			ovrvision->Read(images[0].data, images[1].data);				
			ovrvision->GetStereoImageHSV(hsv[0].data, hsv[1].data);

			// ここでOpenCVでの加工など
			if (0 < ksize)
			{
				switch (filter)
				{
				case GAUSSIAN:
					GaussianBlur(hsv[0], HSV[0], Size(ksize, ksize), 0);
					GaussianBlur(hsv[1], HSV[1], Size(ksize, ksize), 0);
					break;

				case MEDIAN:
					medianBlur(hsv[0], HSV[0], ksize);
					medianBlur(hsv[1], HSV[1], ksize);
					break;

				default:
					hsv[0].copyTo(HSV[0]);
					hsv[1].copyTo(HSV[1]);
					break;
				}
					
#					pragma omp parallel for
				for (int i = 0; i < 2; i++)
				{
					results[i].setTo(Scalar(0, 0, 0, 255));
					bilevel[i].setTo(Scalar::all(0));

					for (int y = 0; y < height; y++)
					{
						Vec4b *l = HSV[i].ptr<Vec4b>(y);
						Vec4b *Lpixel = results[i].ptr<Vec4b>(y);
						uchar *b_l = bilevel[i].ptr<uchar>(y);
						for (int x = 0; x < width; x++)
						{
							uchar h = l[x][0];
							uchar s = l[x][1];
							if (useHistgram)
							{
								if (1 < histgram.at<uchar>(h, s))
								{
									Lpixel[x] = images[i].at<Vec4b>(y, x);
									b_l[x] = 255;
								}
							}
							else
							{
								if (10 <= h && h <= 26 && 55 < s && s < 150)
								{
									Lpixel[x] = images[i].at<Vec4b>(y, x);
									b_l[x] = 255;
								}
							}
						}
					}
				}
				// ここまでGPU（OpenCL）で

				// TODO: ここはOpenMPで左右を並行処理する
				// CPU側（OpenCV）
#					pragma omp parallel for
				for (int eyes = 0; eyes < 2; eyes++)
				{
					std::vector<std::vector<Point>> contours;
					std::vector<Vec4i> hierarchy;

					findContours(bilevel[eyes], contours, RETR_LIST, CHAIN_APPROX_SIMPLE);
					for (uint i = 0; i < contours.size(); i++)
					{
						if (200 < contours[i].size())
							drawContours(results[eyes], contours, i, Scalar(255, 255, 255), 1, 8);
					}
				}

				// ここまでOpenCVで処理してGPUに戻す

				// Show frame data
				//imshow("bilevel(L)", bilevel[0]);
				//imshow("bilevel(R)", bilevel[1]);
				imshow("Left", images[0]);
				imshow("Right", images[1]);
				imshow("L", results[0]);
				imshow("R", results[1]);
			}
			else
			{
				imshow("Left", images[0]);
				imshow("Right", images[1]);
			}
			//}

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

			case 'h':
				useHistgram = !useHistgram;
				break;

			//case 's':
			//	show = !show;
			//	break;

			case 'g':
				filter = GAUSSIAN;
				break;

			case 'm':
				filter = MEDIAN;
				break;

			case 'n':
				filter = NONE;
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
				//if (show)
				{
					imwrite("left.png", images[0]);
					imwrite("right.png", images[1]);
					imwrite("hsv_L.bmp", HSV[0]);
					imwrite("hsv_R.bmp", HSV[1]);
					imwrite("hsv_l.png", hsv[0]);
					imwrite("hsv_r.png", hsv[1]);
					imwrite("result_l.png", results[0]);
					imwrite("result_r.png", results[1]);
					//imwrite("blur_l.png", blur);
					//imwrite("blur_r.png", blur2);
					//imwrite("histgram.png", histgram);
				}
				//else
				//{
				//	imwrite("LEFT.tiff", images[0]);
				//	imwrite("RIGHT.tiff", images[1]);
				//	imwrite("bilevel_l.png", bilevel[0]);
				//	imwrite("bilevel_r.png", bilevel[1]);
				//}
				break;

			case 'e':
				if (callback != NULL)
				{
					callback(NULL, "Device Extensions");
				}
				ovrvision->OpenCLExtensions(callback, NULL);
				break;
			}
		}
	}
	else
	{
		puts("FAILED TO OPEN CAMERA");
	}
	//ovrvision->Close();
	delete ovrvision;
	return 0;
}


