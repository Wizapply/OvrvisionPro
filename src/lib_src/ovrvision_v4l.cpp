// ovrvision_v4l.cpp

// Linux only
#ifdef LINUX
#include <fcntl.h>              /* low-level i/o */
#include <unistd.h>
#include <errno.h>
#include <malloc.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/time.h>
#include <sys/mman.h>
#include <sys/ioctl.h>

#include "ovrvision_v4l.h"

#define CLEAR(x) memset (&(x), 0, sizeof (x))

//Group
namespace OVR
{
	OvrvisionVideo4Linux::OvrvisionVideo4Linux()
	{
	}

	OvrvisionVideo4Linux::~OvrvisionVideo4Linux()
	{
	}

	int OvrvisionVideo4Linux::OpenDevice(int num, int width, int height, int frame_rate)
	{
		struct stat st; 

		sprintf(_device_name, "/dev/video%d", num);

		if(-1 == stat(_device_name, &st))
		{
			fprintf(stderr, "Cannot identify '%s': %d, %s\n",
				_device_name, errno, strerror(errno));
			//exit(EXIT_FAILURE);
			return -1;
		}

		if(!S_ISCHR(st.st_mode))
		{
			fprintf(stderr, "%s is no device\n", _device_name);
			//exit(EXIT_FAILURE);
			return -1;
		}
		_fd = open(_device_name, O_RDWR /* required */ | O_NONBLOCK, 0);
		if(-1 == _fd)
		{
			fprintf(stderr, "Cannot open '%s': %d, %s\n",
				_device_name, errno, strerror(errno));
			//exit(EXIT_FAILURE);
			return -1;
		}
		_width = width;
		_height = height;
		return Init();
	}

	//Delete device
	int OvrvisionVideo4Linux::DeleteDevice()
	{
		for(uint i = 0; i < _n_buffers; ++i)
		{
			if(-1 == munmap(_buffers[i].start, _buffers[i].length))
			{
				//errno_exit("munmap");
			}
		}
		free(_buffers);
		return close(_fd);
	}

	//Transfer status
	int OvrvisionVideo4Linux::StartTransfer()
	{
		unsigned int i;
		enum v4l2_buf_type type = V4L2_BUF_TYPE_VIDEO_CAPTURE;

		for(i = 0; i < _n_buffers; ++i)
		{
			struct v4l2_buffer buf;
			CLEAR(buf);
			buf.type        = V4L2_BUF_TYPE_VIDEO_CAPTURE;
			buf.memory      = V4L2_MEMORY_MMAP;
			buf.index       = i;

			if(-1 == Control(VIDIOC_QBUF, &buf))
				return -1;
		}
		return Control(VIDIOC_STREAMON, &type);
	}
	
	int OvrvisionVideo4Linux::StopTransfer()
	{
		enum v4l2_buf_type type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
		return Control(VIDIOC_STREAMOFF, &type);
	}

	//Get pixel data
	//In non blocking, when data cannot be acquired, RESULT_FAILED returns. 
	int OvrvisionVideo4Linux::GetBayer16Image(unsigned char* pimage, bool nonblocking)
	{
		struct v4l2_buffer buf;

		CLEAR(buf);
		buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
		buf.memory = V4L2_MEMORY_MMAP;
		if (-1 == Control(VIDIOC_DQBUF, &buf))
		{
			switch(errno)
			{
			case EAGAIN:
				return 0;
			case EIO:
				/* Could ignore EIO, see spec. */
				/* fall through */
			default:
				//errno_exit("VIDIOC_DQBUF");
				return -1;
			}
		}
		//assert(buf.index < _n_buffers);
		//if(count == 0)
		//	process_image(buffers[buf.index].start,buffers[buf.index].length);
		return Control(VIDIOC_QBUF, &buf);
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

	int OvrvisionVideo4Linux::Control(int request, void *arg)
	{
		int result;
		do {
			result = ioctl(_fd, request, arg);
		} while(-1 == result && EINTR == errno);
		return result;
	}

	int OvrvisionVideo4Linux::Init()
	{
		struct v4l2_capability cap;
		struct v4l2_cropcap cropcap;
		struct v4l2_crop crop;
		struct v4l2_format fmt;
		unsigned int min;

		if (-1 == Control(VIDIOC_QUERYCAP, &cap))
		{
			if (EINVAL == errno)
			{
				fprintf(stderr, "%s is no V4L2 device\n", _device_name);
				//exit(EXIT_FAILURE);
				return -1;
			}
			else
			{
				//errno_exit("VIDIOC_QUERYCAP");
				return -1;
			}
		}
		if (!(cap.capabilities & V4L2_CAP_VIDEO_CAPTURE))
		{
			fprintf(stderr, "%s is no video capture device\n", _device_name);
			//exit(EXIT_FAILURE);
			return -1;
		}
		if (!(cap.capabilities & V4L2_CAP_STREAMING))
		{
			fprintf(stderr, "%s does not support streaming i/o\n",
				_device_name);
			//exit(EXIT_FAILURE);
			return -1;
		}
		/* Select video input, video standard and tune here. */
		CLEAR(cropcap);

		cropcap.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;

		if (0 == Control(VIDIOC_CROPCAP, &cropcap))
		{
			crop.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
			crop.c = cropcap.defrect; /* reset to default */

			if (-1 == Control(VIDIOC_S_CROP, &crop))
			{
				switch (errno)
				{
				case EINVAL:
					/* Cropping not supported. */
					break;
				default:
					/* Errors ignored. */
					break;
				}
			}
		}
		else
		{
			/* Errors ignored. */
		}
		CLEAR(fmt);

		fmt.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
		fmt.fmt.pix.width = _width;
		fmt.fmt.pix.height = _height;
		fmt.fmt.pix.pixelformat = V4L2_PIX_FMT_Y16;	// Gray scale 16bit depth
		fmt.fmt.pix.field = V4L2_FIELD_NONE;		// or V4L2_FIELD_ANY

		if (0 == Control(VIDIOC_S_FMT, &fmt))
		{
			/* Note VIDIOC_S_FMT may change width and height. */
			_width = fmt.fmt.pix.width;
			_height = fmt.fmt.pix.height;
			return 0;
		}
		else  
		{
			return -1;
		}
	}
};

#endif // LINUX
