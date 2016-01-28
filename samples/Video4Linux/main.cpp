#include "ovrvision_v4l.h"

using namespace OVR;

int main(int argc, char *argv[])
{
	OvrvisionVideo4Linux v4l;
	v4l.OpenDevice(0, 0, 0, 0);
	v4l.QueryCapability();
	v4l.EnumFormats();
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
