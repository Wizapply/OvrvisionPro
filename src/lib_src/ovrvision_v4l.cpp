// ovrvision_v4l.cpp

// Linux only
#ifdef LINUX

#include "ovrvision_v4l.h"

//Group
namespace OVR
{
	OvrvisionVideo4Linux::OvrvisionVideo4Linux()
	{
	}

	OvrvisionVideo4Linux::~OvrvisionVideo4Linux()
	{
	}

	//Delete device
	int OvrvisionVideo4Linux::DeleteDevice()
	{
		return 0;
	}

	//Transfer status
	int OvrvisionVideo4Linux::StartTransfer()
	{
		return 0;
	}
	
	int OvrvisionVideo4Linux::StopTransfer()
	{
		return 0;
	}

	//Get pixel data
	//In non blocking, when data cannot be acquired, RESULT_FAILED returns. 
	int OvrvisionVideo4Linux::GetBayer16Image(unsigned char* pimage, bool nonblocking)
	{
		return 0;
	}

	//Set camera setting
	int OvrvisionVideo4Linux::SetCameraSetting(CamSetting proc, int value, bool automode)
	{
		return 0;
	}

	//Get camera setting
	int OvrvisionVideo4Linux::GetCameraSetting(CamSetting proc, int* value, bool* automode)
	{
		return 0;	
	}
};

#endif // LINUX