// OpenCV.cpp : コンソール アプリケーションのエントリ ポイントを定義します。
//

#include <opencv2/core.hpp>
#include <opencv2/highgui.hpp>
#include <opencv2/imgproc.hpp>
#include <opencv2/video.hpp>

#include "ovrvision_pro.h"

#define CROP_W 1024
#define CROP_H 768

//using namespace std;
using namespace cv;
using namespace OVR;

// Convex object
typedef struct {
	int mx, my;				// mass center
	std::vector<Point> convex;	// convex contor
} Convex;

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

int hsvRange[4] = {
	9,	//_h_low = 13;
	21,	//_h_high = 21;
	100, //_s_low = 88;
	150	//_s_high = 136;
};
int hMean = (hsvRange[0] + hsvRange[1]) / 2;
int sMean = (hsvRange[2] + hsvRange[3]) / 2;

OvrvisionPro *ovrvision = new OvrvisionPro();
Camqt mode = Camqt::OV_CAMQT_DMSRMP;
enum FILTER filter = MEDIAN;
int width;
int height;
int ksize = 5;
bool simulate = true;
bool useHistgram = false;



int evaluation(int h, int s)
{
	int hDiff = (hMean - h) * 10;
	int sDiff = (sMean - s);
	return (hDiff * hDiff) + (sDiff * sDiff);
}

int DetectHand(int frames);

int main(int argc, char* argv[])
{
	Mat images[2];
	Mat bilevel[2];
	Mat hsv[2], HSV[2];
	Mat results[2];
	Mat histgram(180, 256, CV_8UC1);

	
	Mat tone = imread("tone2.bmp", 0);
	uchar *pixel = tone.ptr<uchar>(1);
	for (int i = 0; i < 256; i += 8)
	{
		for (int j = 0; j < 8; j++)
		{
			printf("%3d, ", pixel[i + j]);
		}
		puts("");
	}
	

	ovrvision->CheckGPU();
	if (ovrvision->Open(0, Camprop::OV_CAMHD_FULL, 0))
	{
		width = ovrvision->GetCamWidth();
		height = ovrvision->GetCamHeight();

		//Sync
		ovrvision->SetCameraSyncMode(true);
#if 1
		// Set scaling and size of scaled image
		ROI roi = ovrvision->SetSkinScale(2);
		width = roi.width;
		height = roi.height;
		images[0].create(height, width, CV_8UC4);
		images[1].create(height, width, CV_8UC4);

		detect:
		// Estimate skin color range with 60 frames
		ovrvision->DetectHand(60);
		for (bool done = false; done == false; )
		{
			ovrvision->Capture(mode);
			done = ovrvision->GetScaledImageRGBA(images[0].data, images[1].data);
			waitKey(1);
			imshow("L", images[0]);
			imshow("R", images[1]);
		}
		for (bool loop = true; loop; )
		{
			ovrvision->Capture(mode);
			ovrvision->GetSkinImage(images[0].data, images[1].data);
			imshow("L", images[0]);
			imshow("R", images[1]);

			switch (waitKey(1))
			{
			case 'q':
				loop = false;
				break;
			case ' ':
				imwrite("result_l.png", images[0]);
				imwrite("result_r.png", images[1]);
				break;
			case 'd':
				goto detect;
			}
		}
#else
		width /= 2;
		height /= 2;
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
		Mat multi(height, width, CV_8UC1);

		ovrvision->SetSkinHSV(hsvRange);

		for (bool loop = true; loop;)
		{
			// Capture frame
			ovrvision->Capture(mode);

			if (simulate)
			{		
				///////////////////// Simulation
				// Retrieve frame data
				ovrvision->GetScaledImageRGBA(images[0].data, images[1].data);
#if 0
				results[0].setTo(Scalar(0, 0, 0, 255));
				results[1].setTo(Scalar(0, 0, 0, 255));
				ovrvision->SkinRegion(bilevel[0].data, bilevel[1].data);
#else
				Mat separate[4];

				ovrvision->GetStereoImageHSV(hsv[0].data, hsv[1].data);

				// ここでOpenCVでの加工など
				// ここはthread safeではないようなので、OpenMPに入れないこと！
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
				split(HSV[0], separate);
				threshold(separate[0], bilevel[0], 30, 255, CV_THRESH_BINARY_INV);
				//imshow("H:CV_THRESH_BINARY_INV", bilevel[0]);
				threshold(separate[1], bilevel[1], 80, 255, CV_THRESH_BINARY);
				//imshow("S:CV_THRESH_BINARY", bilevel[1]);
				multiply(bilevel[0], bilevel[1], bilevel[1]);
				imshow("S x H", bilevel[1]);

#				pragma omp parallel for
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
								if (hsvRange[0] <= h && h <= hsvRange[1] && hsvRange[2] <= s && s <= hsvRange[3])
								{
									Lpixel[x] = images[i].at<Vec4b>(y, x);
									b_l[x] = 255;
								}
							}
						}
					}
				}
#endif
				// ここまでGPU（OpenCL）で

				// CPU側で評価関数（OpenCV）
#				pragma omp parallel for
				for (int eyes = 0; eyes < 2; eyes++)
				{
					std::vector<Vec4i> hierarchy;
					std::vector<std::vector<Point>> contours;

					// 1. Reduct small regions
					findContours(bilevel[eyes], contours, hierarchy, RETR_TREE, CHAIN_APPROX_SIMPLE);
					for (uint i = 0; i < contours.size(); i++)
					{
						std::vector<Point> contour = contours[i];
						size_t size = contour.size();
						if (size < 200 && hierarchy[i][3] == -1)
						{
							std::vector<std::vector<Point>> erase;
							erase.push_back(contours.at(i));
							fillPoly(results[eyes], erase, Scalar(size, size, size, 255), 4);
						}
					}
					contours.clear();
					hierarchy.clear();

					// 2. Choice tracking candidate 			
					int minimum = 65535;
					findContours(bilevel[eyes], contours, hierarchy, RETR_TREE, CHAIN_APPROX_SIMPLE);
					for (uint i = 0; i < contours.size(); i++)
					{
						std::vector<Point> contour = contours[i];
						if (200 < contour.size() && hierarchy[i][3] == -1)
						{
							// Mass center
							Moments moment;
							moment = moments(contour);
							double mc[2] = { (moment.m10 / moment.m00), (moment.m01 / moment.m00) };
							Mat mass_center(2, 1, CV_64FC1, mc);
							Vec4b center = HSV[eyes].at<Vec4b>((int)mc[1], (int)mc[0]);
							int diff = evaluation(center[0], center[1]);
							if (diff < minimum)
							{
								minimum = diff;
							}
						}
					}
					//printf("%d\n", minimum);
					// 3. Track candidate
					for (uint i = 0; i < contours.size(); i++)
					{
						std::vector<Point> contour = contours[i];
						if (hierarchy[i][3] == -1)
						{
							// Mass center
							Moments moment;
							moment = moments(contour);
							double mc[2] = { (moment.m10 / moment.m00), (moment.m01 / moment.m00) };
							double area = contourArea(contour);

							if (2000 < area)
							{
								Mat mass_center(2, 1, CV_64FC1, mc);
								Vec4b center = HSV[eyes].at<Vec4b>((int)mc[1], (int)mc[0]);
								int score = evaluation(center[0], center[1]);
								if (score - minimum < 100)
								{
									// draw convex
									std::vector<int> hull;
									convexHull(contour, hull, true);
									Point next, prev = contour[hull[hull.size() - 1]];
									for (size_t j = 0; j < hull.size(); j++)
									{
										next = contour[hull[j]];
										//line(results[eyes], prev, next, Scalar::all(255));
										prev = next;
									}
									//_kalman.correct(mass_center);
									//Mat predict = _kalman.predict();

									//std::vector<std::vector<Point>> paint;
									//paint.push_back(contour);
									//fillPoly(results[eyes], paint, Scalar(95, 132, 163, 255), 4);
									drawContours(results[eyes], contours, i, Scalar(0, 0, 255), 1, 8);
									circle(results[eyes], Point((int)mc[0], (int)mc[1]), 5, Scalar(0, 0, 255), 2);
								}
								char buffer[30];
								sprintf(buffer, "%d", (int)area);
								putText(results[eyes], buffer, Point((int)mc[0], (int)mc[1]), CV_FONT_HERSHEY_TRIPLEX, 0.5, Scalar(255, 255, 255));
							}
						}
					}
				}

				// ここまでOpenCVで処理してGPUに戻す

				// Show frame data
				//imshow("bilevel(L)", bilevel[0]);
				//imshow("bilevel(R)", bilevel[1]);
				//imshow("Left", images[0]);
				//imshow("Right", images[1]);
				imshow("L", results[0]);
				imshow("R", results[1]);
			}
			else
			{
				try {
					ovrvision->GetSkinImage(results[0].data, results[1].data);
				}
				catch (Exception ex)
				{
					puts(ex.what());
				}
				//ovrvision->GrayscaleFourth(bilevel[0].data, bilevel[1].data);

				//ovrvision->SkinRegion(bilevel[0].data, bilevel[1].data);

				//imshow("bilevel(L)", bilevel[0]);
				// imshow("bilevel(R)", bilevel[1]);
				//imshow("Left", images[0]);
				//imshow("Right", images[1]);
				imshow("L", results[0]);
				imshow("R", results[1]);
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

			case 'h':
				useHistgram = !useHistgram;
				break;

			case 's':
				simulate = !simulate;
				break;

			case 'g':
				filter = GAUSSIAN;
				break;

			case 'm':
				filter = MEDIAN;
				break;

			case 'n':
				filter = NONE;
				break;

			case '+':
				ovrvision->SetSkinThreshold(128);
				break;

			case '-':
				ovrvision->SetSkinThreshold(0);
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
				if (simulate)
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
				else
				{
					ovrvision->GetScaledImageRGBA(images[0].data, images[1].data);
					ovrvision->GetStereoImageHSV(hsv[0].data, hsv[1].data);
					ovrvision->SkinRegion(bilevel[0].data, bilevel[1].data);
					imwrite("hsv_l.tiff", hsv[0]);
					imwrite("hsv_r.tiff", hsv[1]);
					imwrite("left.tiff", images[0]);
					imwrite("right.tiff", images[1]);
					imwrite("result_l.tiff", results[0]);
					imwrite("result_r.tiff", results[1]);
					imwrite("bilevel_l.tiff", bilevel[0]);
					imwrite("bilevel_r.tiff", bilevel[1]);
				}
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
#endif
		ovrvision->Close();
	}
	else
	{
		puts("FAILED TO OPEN CAMERA");
	}
	delete ovrvision;
	return 0;
}

int DetectHand(int frames)
{
	Mat separate[2][4];
	Mat histgram[2];
	Mat bilevel[2];
	Mat HSV[2];
	Mat sum(256, 256, CV_32SC1);
	Mat normalized(256, 256, CV_8UC1);

	HSV[0].create(height, width, CV_8UC4);
	HSV[1].create(height, width, CV_8UC4);
	bilevel[0].create(height, width, CV_8UC1);
	bilevel[1].create(height, width, CV_8UC1);
	histgram[0].create(256, 256, CV_32SC1);
	histgram[1].create(256, 256, CV_32SC1);
	histgram[0].setTo(Scalar(0));
	histgram[1].setTo(Scalar(0));

	for (int frame = 0; frame < frames; frame++)
	{
		// Capture frame
		ovrvision->Capture(mode);
		ovrvision->GetStereoImageHSV(HSV[0].data, HSV[1].data);

#		pragma omp parallel for
		for (int eye = 0; eye < 2; eye++)
		{
			std::vector<Vec4i> hierarchy;
			std::vector<std::vector<Point>> contours;

			split(HSV[eye], separate[eye]);
			//threshold(separate[eye][1], bilevel[eye], 0, 255, CV_THRESH_BINARY | CV_THRESH_OTSU);
			threshold(separate[eye][1], bilevel[eye], 80, 255, CV_THRESH_TOZERO);
			Canny(bilevel[eye], bilevel[eye], 60, 200);
			cv::findContours(bilevel[eye], contours, hierarchy, RETR_TREE, CHAIN_APPROX_SIMPLE);
			// Detect fingers
			for (uint i = 0; i < contours.size(); i++)
			{
				std::vector<Point> contour = contours[i];
				if (200 < contour.size() && hierarchy[i][3] == -1)
				{
					Rect bound = boundingRect(contour);
					// Make histgram of HS values
					for (int y = bound.y; y < bound.y + bound.height; y++)
					{
						Vec4b *row = HSV[eye].ptr<Vec4b>(y);
						for (int x = bound.x; x < bound.x + bound.width; x++)
						{
							// Check inside contour
							//if (0 < pointPolygonTest(contour, Point2f(x, y), false))
							{
								int h, s, *hs;
								try {
									h = row[x][0];
									s = row[x][1];
									if (0 < h && h < 30 && 0 < s)
									{
										hs = histgram[eye].ptr<int>(h);
										hs[s]++;
									}
								}
								catch (Exception ex)
								{
									puts(ex.msg.c_str());
								}
							}
						}
					}

					std::vector<int> convex;
					std::vector<Vec4i> defects;
					convexHull(contour, convex, true);
					convexityDefects(contour, convex, defects);
					for (uint defect = 0; defect < defects.size(); defect++)
					{
						int startIdx = defects[defect][0];
						int endIdx = defects[defect][1];
						int farIdx = defects[defect][2];
						int e = defects[defect][3] & 0xFF;
						float depth = (float)(defects[defect][3] / 256);
						line(HSV[eye], contour[startIdx], contour[farIdx], Scalar(0, 0, 255), 1);
						line(HSV[eye], contour[endIdx], contour[farIdx], Scalar(0, 0, 255), 1);
					}
					drawContours(HSV[eye], contours, i, Scalar::all(255));

				}
			}
		}

		cv::imshow("HSV(L)", HSV[0]);
		//imshow("HSV(R)", HSV[1]);
		cv::imshow("S(L)", separate[0][1]);
		//imshow("S(R)", separate[1][1]);
		cv::imshow("bilevel(L)", bilevel[0]);
		//imshow("bilevel(R)", bilevel[1]);

		switch (waitKey(10))
		{
		case ' ':
			//loop = false;
			break;

		case 's':
			imwrite("S.png", separate[0][1]);
			imwrite("bilevel.png", bilevel[0]);
			imwrite("histgram.png", normalized);
			break;
		}
	}

	add(histgram[0], histgram[1], sum);
	cv::normalize(sum, normalized, 0, 255, NORM_MINMAX, normalized.type());
	cv::medianBlur(normalized, normalized, 3);

	// Estimate color range in HS space
	double maxVal;
	Point maxLoc;
	cv::minMaxLoc(normalized, NULL, &maxVal, NULL, &maxLoc);
	int hLow, hHigh, sLow, sHigh;
	// H range
	for (int i = maxLoc.y; 0 < i; i--)
	{
		uchar h = normalized.at<uchar>(i, maxLoc.x);
		if (h < 8) // 5 %
		{
			hLow = i;
			break;
		}
	}
	for (int i = maxLoc.y; i < 180; i++)
	{
		uchar h = normalized.at<uchar>(i, maxLoc.x);
		if (h < 8)
		{
			hHigh = i;
			break;
		}
	}
	// S range
	for (int i = maxLoc.x; 0 < i; i--)
	{
		uchar s = normalized.at<uchar>(maxLoc.y, i);
		if (s < 8)
		{
			sLow = i;
			break;
		}
	}
	for (int i = maxLoc.x; i < 256; i++)
	{
		uchar s = normalized.at<uchar>(maxLoc.y, i);
		if (s < 8)
		{
			sHigh = i;
			break;
		}
	}
	printf("H:%d S:%d count %f H{%d - %d} S{%d - %d}\n",
		maxLoc.y, maxLoc.x, maxVal, hLow, hHigh, sLow, sHigh);
	hsvRange[0] = hLow;
	hsvRange[1] = hHigh;
	hsvRange[2] = sLow;
	hsvRange[3] = sHigh;
	//rectangle(normalized, Point(hsvRange[2], hsvRange[0]), Point(hsvRange[3], hsvRange[1]), Scalar(255));
	cv::imshow("normalized", normalized);
	imwrite("histgram.png", normalized);
	return 0;
}



