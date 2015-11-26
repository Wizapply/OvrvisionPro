// OpenCV.cpp : コンソール アプリケーションのエントリ ポイントを定義します。
//

#include <opencv2/core.hpp>
#include <opencv2/highgui.hpp>
#include <opencv2/imgproc.hpp>

#include "ovrvision_pro.h"

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
		Mat left(height, width, CV_8UC4);
		Mat right(height, width, CV_8UC4);
		Mat lBlur(height, width, CV_8UC4);	// work
		Mat rBlur(height, width, CV_8UC4);
		Mat YCrCb(height, width, CV_8UC3);
		Mat YRB[3];

		//Sync
		ovrvision.SetCameraSyncMode(true);

		Camqt mode = Camqt::OV_CAMQT_DMSRMP;
		bool show = true;

		for (bool loop = true; loop;)
		{
			//DWORD begin = GetTickCount();
			if (show)
			{
				// Capture frame
				ovrvision.PreStoreCamData(mode);

				// Retrieve frame data
				ovrvision.GetCamImageBGRA(left.data, Cameye::OV_CAMEYE_LEFT);
				ovrvision.GetCamImageBGRA(right.data, Cameye::OV_CAMEYE_RIGHT);

				// ここでOpenCVでの加工など
				if (0 < ksize)
				{
					//medianBlur(left, lBlur, ksize);
					medianBlur(right, rBlur, ksize);
					cvtColor(rBlur, YCrCb, CV_BGR2YCrCb);
					split(YCrCb, YRB);

					// Show frame data
					//imshow("Left", lBlur);
					imshow("Right", rBlur);
					imshow("Cr", YRB[1]);
					imshow("Cb", YRB[2]);
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

			//DWORD end = GetTickCount();
			//printf("%f fps %d ms/frame\n", 1000.0f / (end - begin), (end - begin));

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


