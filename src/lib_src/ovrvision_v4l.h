// ovrvision_v4l.h

#ifndef __OVRVISION_V4L__
#define __OVRVISION_V4L__

#ifdef LINUX
/////////// INCLUDE ///////////
#include <asm/types.h>
#include <linux/videodev2.h>	//!Video4Linux
#include <linux/v4l2-common.h>
#include <linux/v4l2-controls.h>
#include <linux/v4l2-dv-timings.h>
#include <linux/v4l2-mediabus.h>
#include <linux/v4l2-subdev.h>

//Group
namespace OVR
{
/////////// VARS AND DEFS ///////////

//Function status
#define RESULT_OK		(0)
#define RESULT_FAILED	(1)

//RGB color data pixel byte
#define OV_RGB_COLOR	(3)

//Device name buffer size
#define OV_DEVICENAMENUM	(256)

//ID
typedef unsigned short usb_id;

//Device Status
typedef enum ov_devstatus {
	OV_DEVNONE = 0,
	OV_DEVCREATTING,
	OV_DEVSTOP,
	OV_DEVRUNNING,
} DevStatus;

//Camera Setting enum
typedef enum ov_camseet {
	OV_CAMSET_EXPOSURE = 0,		//Exposure
	OV_CAMSET_GAIN,				//Gain
	OV_CAMSET_WHITEBALANCER,	//Saturation
	OV_CAMSET_WHITEBALANCEG,	//Brightness
	OV_CAMSET_WHITEBALANCEB,	//Sharpness
	OV_CAMSET_BLC,				//Backlight Compensation
	OV_CAMSET_DATA,				//EEPROM Data Access
} CamSetting;

/////////// CLASS ///////////
//class
class OvrvisionVideo4Linux
{
public:
	//Constructor/Destructor
	OvrvisionVideo4Linux();
	~OvrvisionVideo4Linux();

	//Delete device
	int DeleteDevice();

	//Transfer status
	int StartTransfer();
	int StopTransfer();

	//Get pixel data
	//In non blocking, when data cannot be acquired, RESULT_FAILED returns. 
	int GetBayer16Image(unsigned char* pimage, bool nonblocking = false);

	//Set camera setting
	int SetCameraSetting(CamSetting proc, int value, bool automode);
	//Get camera setting
	int GetCameraSetting(CamSetting proc, int* value, bool* automode);
};

}; // namespave OVR
#endif // LINUX

#endif // __OVRVISION_V4L__