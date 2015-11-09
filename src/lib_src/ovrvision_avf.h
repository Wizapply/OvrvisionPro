// ovrvision_avf.h
// Version 0.3 : 03/Apr/2014
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

//Mac OSX only
#ifdef MACOSX

/////////// INCLUDE ///////////

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <IOKit/IOKitLib.h>
#import <IOKit/IOMessage.h>
#import <IOKit/IOCFPlugIn.h>
#import <IOKit/usb/IOUSBLib.h>

#import <mach/mach_time.h>
#import "jpeglib.h"

/////////// VARS AND DEFS ///////////

//Function status
#define RESULT_OK		(0)
#define RESULT_FAILED	(1)

//RGB color data pixel byte
#define OV_RGB_COLOR	(3)

//Device name buffer size
#define OV_DEVICENAMENUM	(256)

//Blocking timeout
#define OV_BLOCKTIMEOUT		(3)	//3s

//IOKIT
#define UVC_INPUT_TERMINAL_ID 0x01
#define UVC_PROCESSING_UNIT_ID 0x03

#define UVC_CONTROL_INTERFACE_CLASS 14
#define UVC_CONTROL_INTERFACE_SUBCLASS 1

#define UVC_SET_CUR	0x01
#define UVC_GET_CUR	0x81
#define UVC_GET_MIN	0x82
#define UVC_GET_MAX	0x83

typedef struct {
	int min, max;
} uvc_range_t;

typedef struct {
	int unit;
	int selector;
	int size;
} uvc_control_info_t;

typedef struct {
	uvc_control_info_t autoExposure;
	uvc_control_info_t exposure;
	uvc_control_info_t brightness;
	uvc_control_info_t contrast;
	uvc_control_info_t saturation;
	uvc_control_info_t sharpness;
    uvc_control_info_t gamma;
	uvc_control_info_t whiteBalance;
	uvc_control_info_t autoWhiteBalance;
} uvc_controls_t ;

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
	OV_CAMSET_EXPOSURE = 0,	//Exposure
	OV_CAMSET_CONTRAST,		//Contrast
	OV_CAMSET_SATURATION,	//Saturation
	OV_CAMSET_BRIGHTNESS,	//Brightness
	OV_CAMSET_SHARPNESS,	//Sharpness
	OV_CAMSET_GAMMA,		//Gamma
	OV_CAMSET_WHITEBALANCE,	//White balance
} CamSetting;

//JmpBuffer
//static jmp_buf g_ov_jmpbuf;

//PixelBufferQueue Array Num
#define PBQARRAY_MAX    (64)

/////////// CLASS ///////////

@interface OvrvisionAVFoundation : NSObject<AVCaptureVideoDataOutputSampleBufferDelegate> {
@private
    //Device status
	DevStatus		m_devstatus;
	char			m_nDeviceName[OV_DEVICENAMENUM];
    
	//Pixel Data
	unsigned char*	m_pPixels;
    unsigned char*  m_pPixelsQueue; //Queue
    
	//Pixel Size
	int				m_width;
	int				m_height;
	int				m_rate;
	int				m_latestPixelDataSize;
	int				m_maxPixelDataSize;
    
    //Mac OSX AVFoundation
    AVCaptureDevice* m_device;
    AVCaptureSession* m_session;
    AVCaptureVideoDataOutput* m_output;
    AVCaptureDeviceInput* m_deviceInput;
    int             m_datasize;
    
    //USB IOKit
    long iodataBuffer;
	IOUSBInterfaceInterface190 **interface;
    
    //Thread wait object
    NSCondition*    m_cond;
    uint64_t        m_captureOutputTime;
    mach_timebase_info_data_t m_timebase;
    
    NSThread*       m_queueThread;
    uint64_t        m_queueThreadPreTime;
}

//initialize
- (id)init;
- (void)dealloc;

//Create / Delete Device
- (int)createDevice:(usb_id)vid pid:(usb_id)pid cam_w:(int)cam_w cam_h:(int)cam_h rate:(int)rate locate:(int)lot;
- (int)deleteDevice;

//Transfer status
- (int)startTransfer;
- (int)stopTransfer;

//Get pixel data
//In non blocking, when data cannot be acquired, RESULT_FAILED returns.
-(int) getRGBImage:(unsigned char*)image blocking:(bool)nonblocking;
-(int) getMJPEGImage:(unsigned char*)image blocking:(bool)nonblocking;

//MJPEG -> RGB(24bit) Decoder
- (int)MJPEGToR8G8B8:(unsigned char*)pImageDest imageSrc:(unsigned char*)pImageSrc imagesize:(int)srcSize;

//Property
-(DevStatus)getDeviceStatus;
-(int)getLatestPixelDataSize;
-(int)getMaxPixelDataSize;

//Set camera setting
-(int)setCameraSetting:(CamSetting)proc value:(int)value automode:(bool)automode;
//Get camera setting
-(int)getCameraSetting:(CamSetting)proc valueout:(int*)value automodeout:(bool*)automode;

//private

//AVCaptureVideoDataOutputSampleBufferDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection;

@end

#endif
