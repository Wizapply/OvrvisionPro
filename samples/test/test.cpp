// test.cpp : コンソール アプリケーションのエントリ ポイントを定義します。
//

#include "stdafx.h"
#include "ovrvision_ds.h"
#include <opencv2/core.hpp>
#include <opencv2/highgui.hpp>
#include <opencv2/imgcodecs.hpp>
#include <opencv2/videoio.hpp>

using namespace OVR;

#define OV_USB_VENDERID		(0x2C33)	//Product id
#define OV_USB_PRODUCTID	(0x0001)	//Reversal
#define WIDTH	1280
#define HEIGHT	960
#define FPS		45


int main()
{
	bool open = false;
	OvrvisionDirectShow* ds = new OvrvisionDirectShow();
	for (int i = 0; i < 10; i++)
	{
		if (0 == ds->CreateDevice(OV_USB_VENDERID, OV_USB_PRODUCTID, WIDTH, HEIGHT, FPS, 0))
		{
			open = true;
			break;
		}
		Sleep(150);
	}
	if (open)
	{
		printf("opened\n");
		ds->StartTransfer();

		cv::Mat buffer(HEIGHT, WIDTH, CV_16U);
		cv::Mat left(HEIGHT, WIDTH, CV_8U);
		cv::Mat right(HEIGHT, WIDTH, CV_8U);

		for (bool loop = true; loop;)
		{
			if (ds->GetBayer16Image(buffer.data, true) == RESULT_OK)
			{
				// 左右のRAWデータに分離
				uchar *src = buffer.data;
				uchar *r = right.data;
				uchar *l = left.data;
				for (int y = 0; y < HEIGHT; y++)
				{
					for (int x = 0; x < WIDTH; x++)
					{
						r[x] = src[x * 2];
						l[x] = src[x * 2 + 1];
					}
					src += WIDTH * 2;
					r += WIDTH;
					l += WIDTH;
				}
				cv::imshow("Left", left);
				cv::imshow("Right", right);
			}
			switch (cv::waitKey(10))
			{
			case 'Q':
			case 'q':
				loop = false;
				break;

			case ' ':
				cv::imwrite("Left.png", left);
				cv::imwrite("Right.png", right);
				break;
			}

		}
		ds->StopTransfer();
		ds->DeleteDevice();
	}
	delete ds;

    return 0;
}

