// OvrvisionProTest.cpp : Defines the entry point for the console application.
//

#include <opencv2/core.hpp>
#include <opencv2/highgui.hpp>

#include "ovrvision_ds.h"
#include "../src/OvrvisionProDLL.h"

/////////// VARS AND DEFS ///////////

//OVRVISION USB SETTING
//Vender id
#define OV_USB_VENDERID		(0x2C33)
//Product id
#define OV_USB_PRODUCTID	(0x0001)	//Reversal

//PixelSize
#define OV_PIXELSIZE_RGB	(4)
#define OV_PIXELSIZE_BY8	(1)

//Challenge num
#define OV_CHALLENGENUM		(3)	//3

#define WIDTH 1280
#define HEIGHT 960
#define BUFFER_SIZE	(WIDTH * HEIGHT)

using namespace cv;
using namespace OVR;

static OvrvisionProOpenCL opencl(WIDTH, HEIGHT);

int main(int argc, char* argv[])
{
	int cam_width = WIDTH;
	int cam_height = HEIGHT;
	int cam_framerate = 45;
	byte *m_pPixels[2];
	ushort *m_pFrame = new ushort[cam_width*cam_height];
	m_pPixels[0] = new byte[cam_width*cam_height*OV_PIXELSIZE_RGB];
	m_pPixels[1] = new byte[cam_width*cam_height*OV_PIXELSIZE_RGB];

	OvrvisionDirectShow *m_pODS = new OvrvisionDirectShow();
	//Open
	for (int challenge = 0; challenge < OV_CHALLENGENUM; challenge++) {	//CHALLENGEN
		if (m_pODS->CreateDevice(OV_USB_VENDERID, OV_USB_PRODUCTID, cam_width, cam_height, cam_framerate, 0) == 0) {
			//objs++;
			break;
		}
		Sleep(150);	//150ms wait
	}

	Sleep(50);	//50ms wait

	int width = cam_width / 2;
	int height = cam_height / 2;

	Mat left(height, width, CV_8UC4);
	Mat right(height, width, CV_8UC4);
	Mat hist(180, 256, CV_16UC1);
	Mat histgram(180, 256, CV_8UC1);

	cl_event events[2], event;
	while (waitKey(10) != 'q')
	{ 
		if (m_pODS->GetBayer16Image((uchar *)m_pFrame) == RESULT_OK) {
			opencl.Demosaic(m_pFrame);		//OpenCL
			opencl.SkinColorGaussianBlur(left.data, right.data, HALF);
			//opencl.SkinColor(left.data, right.data, HALF);
			hist.setTo(Scalar::all(0));
			for (int y = 0; y < height; y++)
			{
				Vec4b *l = left.ptr<Vec4b>(y);
				Vec4b *r = right.ptr<Vec4b>(y);
				for (int x = 0; x < width; x++)
				{
					short h, s, *count;
					try {
						h = l[x][0];
						s = l[x][1];
						count = hist.ptr<short>(h);
						count[s]++;
						h = r[x][0];
						s = r[x][1];
						count = hist.ptr<short>(h);
						count[s]++;
					}
					catch (Exception ex)
					{
						printf("X:%d Y:%d H:%d S:%d\t", x, y, h, s);
						printf("%s\n", ex.msg);
					}
				}
			}

			normalize(hist, histgram, 0, 255, NORM_MINMAX, histgram.type());
			imshow("histgram", histgram);
			imshow("Left", left);
			imshow("Right", right);
		}
	}

	m_pODS->DeleteDevice();
	delete m_pODS;
	delete[] m_pPixels[0];
	delete[] m_pPixels[1];
	delete m_pFrame;
}

