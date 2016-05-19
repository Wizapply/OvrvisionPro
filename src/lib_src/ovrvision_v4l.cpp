/// ovrvision_v4l.cpp
//
//MIT License
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//THE SOFTWARE.
//
// Oculus Rift : TM & Copyright Oculus VR, Inc. All Rights Reserved
// Unity : TM & Copyright Unity Technologies. All Rights Reserved

// Linux only
#ifdef LINUX

#include <stdio.h>
#include <string.h>
#include <fcntl.h>              /* low-level i/o */
#include <unistd.h>
#include <errno.h>
#include <malloc.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/time.h>
#include <sys/mman.h>
#include <sys/ioctl.h>
#include <dirent.h>

#include "ovrvision_v4l.h"

#define OVRVISIONPRO	"OvrvisionPro"
#define USE_MMAP

#define CLEAR(x) memset (&(x), 0, sizeof (x))

typedef struct {
	unsigned int flag;
	char *name;
} V4L2_CAPABILITY_MAP;


static int xioctl(int fd, int request, void *arg)
{
	int result;
	do {
		result = ioctl(fd, request, arg);
	} while(-1 == result && EINTR == errno);
	return result;
}

//Group
namespace OVR
{
	OvrvisionVideo4Linux::OvrvisionVideo4Linux()
	{
		_n_buffers = 0;
		_cropVertical = _cropHorizontal = false;
	}

	OvrvisionVideo4Linux::~OvrvisionVideo4Linux()
	{
	}

	int OvrvisionVideo4Linux::OpenDevice(int num, int width, int height, int frame_rate)
	{
		if (SearchDevice(OVRVISIONPRO) != 0)
			return -1;

		_width = width;
		_height = height;
#ifdef _DEBUG
		QueryCapability();
#endif
		return Init();
	}

	//Delete device
	int OvrvisionVideo4Linux::DeleteDevice()
	{
#ifdef USE_MMAP
		for(uint i = 0; i < _n_buffers; ++i)
		{
			if(-1 == munmap(_buffers[i].start, _buffers[i].length))
			{
				fprintf(stderr, "munmap");
			}
		}
		free(_buffers);
#else	// USE_USERPTR
		for (uint i = 0; i < _n_buffers; ++i)
		{
			free(_buffers[i].start);
		}
#endif // USE_MMAP

		return close(_fd);
	}

	//Transfer status
	int OvrvisionVideo4Linux::StartTransfer()
	{
		unsigned int i;
		enum v4l2_buf_type type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
#ifdef USE_MMAP
		for(i = 0; i < _n_buffers; ++i)
		{
			struct v4l2_buffer buf;
			CLEAR(buf);
			buf.type        = V4L2_BUF_TYPE_VIDEO_CAPTURE;
			buf.memory      = V4L2_MEMORY_MMAP;
			buf.index       = i;

			if(-1 == xioctl(_fd, VIDIOC_QBUF, &buf))
				return -1;
		}
#else	// USE_USERPTR
		for (i = 0; i < _n_buffers; ++i)
		{
			struct v4l2_buffer buf;

			CLEAR(buf);
			buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
			buf.memory = V4L2_MEMORY_USERPTR;
			buf.index = i;
			buf.m.userptr = (unsigned long)_buffers[i].start;
			buf.length = _buffers[i].length;

			if (-1 == xioctl(_fd, VIDIOC_QBUF, &buf))
			{
				//errno_exit("VIDIOC_QBUF");
				return -1;
			}
		}
#endif // USE_MMAP
		return xioctl(_fd, VIDIOC_STREAMON, &type);
	}
	
	int OvrvisionVideo4Linux::StopTransfer()
	{
		enum v4l2_buf_type type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
		return xioctl(_fd, VIDIOC_STREAMOFF, &type);
	}

	//Get pixel data
	//In non blocking, when data cannot be acquired, RESULT_FAILED returns. 
	int OvrvisionVideo4Linux::GetBayer16Image(unsigned char* pimage, bool nonblocking)
	{
		struct v4l2_buffer buf;

		for (bool wait = true; wait; )
		{
			fd_set fds;
			struct timeval tv;
			int r;

			FD_ZERO (&fds);
			FD_SET (_fd, &fds);

			/* Timeout. */
			tv.tv_sec = 1;
			tv.tv_usec = 0;

			r = select(_fd + 1, &fds, NULL, NULL, &tv);
			if (r > 0)	// timeout
				wait = false;
		}
#ifdef USE_MMAP
		CLEAR(buf);
		buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
		buf.memory = V4L2_MEMORY_MMAP;
		if (-1 == xioctl(_fd, VIDIOC_DQBUF, &buf))
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
		// Copy data from _buffer[buf.index] to pimage with crop
		if (_cropHorizontal)
		{
			if (_cropVertical)
			{

			}
			else
			{

			}
		}
		else if (_cropVertical)
		{
			int offset = (_format.fmt.pix.height - _height) / 2;
			if (0 < offset)
			{
				unsigned char *addr = (unsigned char *)(_buffers[buf.index].start) + _format.fmt.pix.bytesperline * offset;
				memcpy(pimage, addr, _format.fmt.pix.bytesperline * _height);
			}
			else
			{
				memcpy(pimage + _format.fmt.pix.bytesperline * offset, _buffers[buf.index].start, buf.bytesused);
			}
		}
		else
		{
			memcpy(pimage, _buffers[buf.index].start, buf.bytesused);
		}
#else	// USE_USERPTR
#endif // USE_MMAP

		return xioctl(_fd, VIDIOC_QBUF, &buf);
	}

	int OvrvisionVideo4Linux::GetBayer16Image(unsigned char* pimage, size_t step, bool nonblocking)
	{
		struct v4l2_buffer buf;

		for (bool wait = true; wait; )
		{
			fd_set fds;
			struct timeval tv;
			int r;

			FD_ZERO (&fds);
			FD_SET (_fd, &fds);

			/* Timeout. */
			tv.tv_sec = 1;
			tv.tv_usec = 0;

			r = select(_fd + 1, &fds, NULL, NULL, &tv);
			if (r > 0)	// timeout
				wait = false;
		}
#ifdef USE_MMAP
		CLEAR(buf);
		buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
		buf.memory = V4L2_MEMORY_MMAP;
		if (-1 == xioctl(_fd, VIDIOC_DQBUF, &buf))
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
		// Copy data from _buffer[buf.index] to pimage with crop
		if (_cropHorizontal)
		{
			if (_cropVertical)
			{

			}
			else
			{

			}
		}
		else if (_cropVertical)
		{
			int offset = (_format.fmt.pix.height - _height) / 2;
			if (0 < offset)
			{
				unsigned char *addr = (unsigned char *)(_buffers[buf.index].start) + _format.fmt.pix.bytesperline * offset;
				memcpy(pimage, addr, _format.fmt.pix.bytesperline * _height);
			}
			else
			{
				memcpy(pimage + _format.fmt.pix.bytesperline * offset, _buffers[buf.index].start, buf.bytesused);
			}
		}
		else
		{
			unsigned char *addr = (unsigned char *)(_buffers[buf.index].start);
			for (int y = 0; y < _format.fmt.pix.height; y++)
			{
				memcpy(pimage, addr, _format.fmt.pix.bytesperline);
				pimage += step;
				addr += _format.fmt.pix.bytesperline;
			}
		}
#else	// USE_USERPTR
#endif // USE_MMAP

		return xioctl(_fd, VIDIOC_QBUF, &buf);
	}

	void OvrvisionVideo4Linux::EnumFormats()
	{
		int i;
		struct v4l2_fmtdesc fmt;
		fmt.index = i = 0;
		fmt.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;

		while(-1 != xioctl(_fd, VIDIOC_ENUM_FMT, &fmt)) {
			printf("%i: %c%c%c%c (%s)\n", fmt.index,
				fmt.pixelformat >> 0, fmt.pixelformat >> 8,
				fmt.pixelformat >> 16, fmt.pixelformat >> 24, fmt.description);
			//memset(&fmt, 0, sizeof(struct v4l2_fmtdesc));
			fmt.index = ++i;
			fmt.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
		}
	}

	int OvrvisionVideo4Linux::Init()
	{
		struct v4l2_requestbuffers req;

		CLEAR(_format);

		_format.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
		_format.fmt.pix.width = _width;
		_format.fmt.pix.height = _height;
		_format.fmt.pix.pixelformat = V4L2_PIX_FMT_YUYV;	// Gray scale 16bit depth
		_format.fmt.pix.field = V4L2_FIELD_NONE;		// or V4L2_FIELD_ANY

		if (0 == xioctl(_fd, VIDIOC_S_FMT, &_format))
		{
			/* Note VIDIOC_S_FMT may change width and height. */
#ifdef	DEBUG
			printf("%d:%d x %d:%d SIZE:%d\n", _width, _format.fmt.pix.width, _height, _format.fmt.pix.height, _format.fmt.pix.sizeimage);
#endif
			if (_width != _format.fmt.pix.width)
			{
				_cropHorizontal = true;
			}
			if (_height != _format.fmt.pix.height)
			{
				_cropVertical = true;
			}
			//_width = _format.fmt.pix.width;
			//_height = _format.fmt.pix.height;
		}
		else  
		{
			return -1;
		}

		CLEAR(req);
#ifdef USE_MMAP
		req.count = 4;
		req.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
		req.memory = V4L2_MEMORY_MMAP;

		if (-1 == xioctl(_fd, VIDIOC_REQBUFS, &req)) {
			if (EINVAL == errno) {
				fprintf(stderr, "%s does not support memory mapping\n", _device_name);
				//exit(EXIT_FAILURE);
			} else {
				//errno_exit("VIDIOC_REQBUFS");
			}
		}

		if (req.count < 2) {
			fprintf(stderr, "Insufficient buffer memory on %s\n", _device_name);
			//exit(EXIT_FAILURE);
		}

		_buffers = (V4L_BUFFER *)calloc(req.count, sizeof(V4L_BUFFER));

		if (!_buffers) {
			fprintf(stderr, "Out of memory\n");
			//exit(EXIT_FAILURE);
		}

		for (_n_buffers = 0; _n_buffers < req.count; ++_n_buffers) {
			struct v4l2_buffer buf;

			CLEAR(buf);

			buf.type        = V4L2_BUF_TYPE_VIDEO_CAPTURE;
			buf.memory      = V4L2_MEMORY_MMAP;
			buf.index       = _n_buffers;

			if (-1 == xioctl(_fd, VIDIOC_QUERYBUF, &buf))
			{
				//errno_exit("VIDIOC_QUERYBUF");
			}
			_buffers[_n_buffers].length = buf.length;
			_buffers[_n_buffers].start =
				mmap(NULL /* start anywhere */,
				buf.length,
				PROT_READ | PROT_WRITE /* required */,
				MAP_SHARED /* recommended */,
				_fd, buf.m.offset);

			if (MAP_FAILED == _buffers[_n_buffers].start)
			{
				//errno_exit("mmap");
			}
		}
#else	// USE_USERPTR
		req.count  = 4;
		req.type   = V4L2_BUF_TYPE_VIDEO_CAPTURE;
		req.memory = V4L2_MEMORY_USERPTR;

		if (-1 == xioctl(_fd, VIDIOC_REQBUFS, &req)) {
			if (EINVAL == errno) {
				//fprintf(stderr, "%s does not support user pointer i/o\n", dev_name);
				//exit(EXIT_FAILURE);
			} else {
				//errno_exit("VIDIOC_REQBUFS");
			}
		}

		_buffers = (V4L_BUFFER *)calloc(4, sizeof(V4L_BUFFER));

		if (!_buffers) {
			//fprintf(stderr, "Out of memory\n");
			//exit(EXIT_FAILURE);
		}

		for (_n_buffers = 0; _n_buffers < 4; ++_n_buffers) {
			_buffers[_n_buffers].length = _format.fmt.pix.sizeimage;
			_buffers[_n_buffers].start = malloc(_format.fmt.pix.sizeimage);

			if (!_buffers[_n_buffers].start) {
				//fprintf(stderr, "Out of memory\n");
				//exit(EXIT_FAILURE);
			}
		}
#endif // USE_MMAP
		return 0;
	}

	int OvrvisionVideo4Linux::SearchDevice(const char *name)
	{
		DIR *dir = opendir("/dev");
		if (dir == NULL)
			return -1;
		struct dirent *entry;
		while ((entry = readdir(dir)) != NULL)
		{
			if (strncmp(entry->d_name, "video", 5) == 0)
			{
				char path[256];
				sprintf(path, "/dev/%s", entry->d_name);
				int fd = open(path, O_RDWR | O_NONBLOCK, 0);
				struct v4l2_capability cap;
				if(-1 != xioctl(fd, VIDIOC_QUERYCAP, &cap))
				{
					if (name != NULL && 0 ==strcmp(name, (const char *)(cap.card)))
					{
						_fd = fd;
						return 0;
					}
				}
				close(fd);
			}
		}
		closedir(dir);
		return -1;
	}

	int OvrvisionVideo4Linux::CheckCapability()
	{
#if 0
		struct v4l2_capability cap;
		struct v4l2_cropcap cropcap;
		struct v4l2_crop crop;
		unsigned int min;

		if (-1 == xioctl(_fd, VIDIOC_QUERYCAP, &cap))
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

		if (0 == xioctl(_fd, VIDIOC_CROPCAP, &cropcap))
		{
			crop.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
			crop.c = cropcap.defrect; /* reset to default */

			if (-1 == xioctl(_fd, VIDIOC_S_CROP, &crop))
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
#endif

		CLEAR(_format);

		_format.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
		_format.fmt.pix.width = _width;
		_format.fmt.pix.height = _height;
		_format.fmt.pix.pixelformat = V4L2_PIX_FMT_Y16;	// Gray scale 16bit depth
		_format.fmt.pix.field = V4L2_FIELD_NONE;		// or V4L2_FIELD_ANY

		if (0 == xioctl(_fd, VIDIOC_S_FMT, &_format))
		{
			/* Note VIDIOC_S_FMT may change width and height. */
			_width = _format.fmt.pix.width;
			_height = _format.fmt.pix.height;
			return 0;
		}
		else  
		{
			return -1;
		}
	}

	static V4L2_CAPABILITY_MAP capabilities[] = {
		{V4L2_CAP_VIDEO_CAPTURE,		"V4L2_CAP_VIDEO_CAPTURE (Video Capture)"},
		{V4L2_CAP_VIDEO_OUTPUT,			"V4L2_CAP_VIDEO_OUTPUT (Video Output)"},
		{V4L2_CAP_VIDEO_OVERLAY,		"V4L2_CAP_VIDEO_OVERLAY (Video Overlay)"},
		{V4L2_CAP_VBI_CAPTURE,			"V4L2_CAP_VBI_CAPTURE (Raw VBI Capture)"},
		{V4L2_CAP_VBI_OUTPUT,			"V4L2_CAP_VBI_OUTPUT (Raw VBI Output)"},
		{V4L2_CAP_SLICED_VBI_CAPTURE,	"V4L2_CAP_SLICED_VBI_CAPTURE (Sliced VBI Capture)"},
		{V4L2_CAP_SLICED_VBI_OUTPUT,	"V4L2_CAP_SLICED_VBI_OUTPUT (Sliced VBI Output)"},
		{V4L2_CAP_RDS_CAPTURE,			"V4L2_CAP_RDS_CAPTURE (Undefined.[to be defined])"},
		{V4L2_CAP_VIDEO_OUTPUT_OVERLAY,	"V4L2_CAP_VIDEO_OUTPUT_OVERLAY (Video Output Overlay (OSD))"},
		{V4L2_CAP_TUNER,				"V4L2_CAP_TUNER (Tuner)"},
		{V4L2_CAP_AUDIO,				"V4L2_CAP_AUDIO (Audio inputs or outputs)"},
		{V4L2_CAP_RADIO,				"V4L2_CAP_RADIO (Radio receiver)"},
		{V4L2_CAP_READWRITE,			"V4L2_CAP_READWRITE (Read/write() I/O method)"},
		{V4L2_CAP_ASYNCIO,				"V4L2_CAP_ASYNCIO (Asynchronous I/O method)"},
		{V4L2_CAP_STREAMING,			"V4L2_CAP_STREAMING (Streaming I/O method)"},
		{0,NULL}
	};

	void OvrvisionVideo4Linux::QueryCapability()
	{
		struct v4l2_capability fmt;
		if(-1 != xioctl(_fd, VIDIOC_QUERYCAP, &fmt))
		{
			printf("Driver name     : %s\n", fmt.driver);
			printf("Driver Version  : %u.%u.%u\n",
				(fmt.version >> 16) & 0xFF,
				(fmt.version >> 8) & 0xFF,
				fmt.version & 0xFF);
			printf("Device name     : %s\n", fmt.card);	// MUST TO BE 'OvrvisionPro'
			printf("Bus information : %s\n", fmt.bus_info);
			printf("Capabilities    : %08xh\n", fmt.capabilities);	// MUST TO BE V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING
			
			for (size_t i = 0; i < sizeof(capabilities) / sizeof(V4L2_CAPABILITY_MAP); i++)
			{
				if (fmt.capabilities & capabilities[i].flag)
				{
					puts(capabilities[i].name);
				}
			}
			printf("\n");
		}
	}

	//Set camera setting
	int OvrvisionVideo4Linux::SetCameraSetting(CamSetting proc, int value, bool automode)
	{
		struct v4l2_control ctrl;

		//set
		switch(proc) {
			case OV_CAMSET_EXPOSURE: ctrl.id = V4L2_CID_BRIGHTNESS;
				break;
			case OV_CAMSET_GAIN: ctrl.id = V4L2_CID_GAIN;
				break;
			case OV_CAMSET_WHITEBALANCER: ctrl.id = V4L2_CID_SHARPNESS;
				break;
			case OV_CAMSET_WHITEBALANCEG: ctrl.id = V4L2_CID_GAMMA;
				break;
			case OV_CAMSET_WHITEBALANCEB: ctrl.id = V4L2_CID_DO_WHITE_BALANCE;
				break;
			case OV_CAMSET_BLC: ctrl.id = V4L2_CID_BACKLIGHT_COMPENSATION;
				break;
			case OV_CAMSET_DATA: ctrl.id = V4L2_CID_CONTRAST;
				break;
			default:
				return RESULT_FAILED;
				break;
		};

		ctrl.value = value;
		if (xioctl(_fd,  VIDIOC_S_CTRL, &ctrl) != 0) {
			return RESULT_FAILED;
		}

		usleep(5000);	//wait

		return RESULT_OK;

	}

	//Get camera setting
	int OvrvisionVideo4Linux::GetCameraSetting(CamSetting proc, int* value, bool* automode)
	{
		struct v4l2_control ctrl;

		//set
		switch(proc) {
			case OV_CAMSET_EXPOSURE: ctrl.id = V4L2_CID_BRIGHTNESS;
				break;
			case OV_CAMSET_GAIN: ctrl.id = V4L2_CID_GAIN;
				break;
			case OV_CAMSET_WHITEBALANCER: ctrl.id = V4L2_CID_SHARPNESS;
				break;
			case OV_CAMSET_WHITEBALANCEG: ctrl.id = V4L2_CID_GAMMA;
				break;
			case OV_CAMSET_WHITEBALANCEB: ctrl.id = V4L2_CID_DO_WHITE_BALANCE;
				break;
			case OV_CAMSET_BLC: ctrl.id = V4L2_CID_BACKLIGHT_COMPENSATION;
				break;
			case OV_CAMSET_DATA: ctrl.id = V4L2_CID_CONTRAST;
				break;
			default:
				return RESULT_FAILED;
				break;
		};

		if (xioctl(_fd,  VIDIOC_G_CTRL, &ctrl) != 0) {
			return RESULT_FAILED;
		}
		(*value) = ctrl.value;

		usleep(5000);	//wait

		return RESULT_OK;
	}


	//Callback
	void OvrvisionVideo4Linux::SetCallback(void(*func)())
	{
		m_get_callback = func;
	}
};

#endif // LINUX
