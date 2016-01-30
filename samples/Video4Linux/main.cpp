#include <opencv2/opencv.hpp>
#include "ovrvision_v4l.h"

using namespace OVR;
using namespace cv;

#define WIDTH 1280
#define HEIGHT	960

int main(int argc, char *argv[])
{
	Mat image(HEIGHT, WIDTH, CV_16UC1);
	OvrvisionVideo4Linux v4l;
	v4l.OpenDevice(0, WIDTH, HEIGHT, 0);
	v4l.QueryCapability();
	v4l.EnumFormats();
	v4l.StartTransfer();
	if (0 == v4l.GetBayer16Image(image.data))
	{
		imshow("Bayer", image);
	}
	v4l.StopTransfer();
	v4l.DeleteDevice();
}

/* Result
Driver name     : uvcvideo
Driver Version  : 3.10.40
Device name     : OvrvisionPro
Bus information : usb-tegra-ehci.0-1
Capabilities    : 84000001h
V4L2_CAP_VIDEO_CAPTURE (Video Capture)
V4L2_CAP_STREAMING (Streaming I/O method)
*/
\
