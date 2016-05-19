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

/////////// VARS AND DEFS ///////////

//Function status
#define RESULT_OK		(0)
#define RESULT_FAILED	(1)

//RGB color data pixel byte
#define OV_RGB_COLOR	(3)

//Device name buffer size
#define OV_DEVICENAMENUM	(256)

//Blocking timeout
#define OV_BLOCKTIMEOUT		(1)	//3s

//IOKIT
#define UVC_INPUT_TERMINAL_ID 0x01
#define UVC_PROCESSING_UNIT_ID 0x02

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
	uvc_control_info_t exposure;
	uvc_control_info_t gain;
	uvc_control_info_t whitebalance_r;
	uvc_control_info_t whitebalance_g;
	uvc_control_info_t whitebalance_b;
	uvc_control_info_t whitebalance_auto;
	uvc_control_info_t blc;
    uvc_control_info_t data;
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
    OV_CAMSET_EXPOSURE = 0,		//Exposure
    OV_CAMSET_GAIN,				//Gain
    OV_CAMSET_WHITEBALANCER,	//Saturation
    OV_CAMSET_WHITEBALANCEG,	//Brightness
    OV_CAMSET_WHITEBALANCEB,	//Sharpness
    OV_CAMSET_BLC,				//Backlight Compensation
    OV_CAMSET_DATA,				//EEPROM Data Access
} CamSetting;

//PixelBufferQueue Array Num
#define PBQARRAY_MAX    (64)

typedef void *(CALLBACK_FUNC)(void);

/////////// CLASS ///////////

@interface OvrvisionAVFoundation : NSObject<AVCaptureVideoDataOutputSampleBufferDelegate> {
@private
    //Device status
	DevStatus		m_devstatus;
	char			m_nDeviceName[OV_DEVICENAMENUM];
    
	//Pixel Data
	unsigned char*	m_pPixels;
    
	//Pixel Size
	int				m_width;
	int				m_height;
	int				m_rate;
	int				m_latestPixelDataSize;
    
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
    
    //Callback Function
    CALLBACK_FUNC* m_imageFunc;
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
-(int) getBayer16Image:(unsigned char*)image blocking:(bool)nonblocking;

//Property
-(DevStatus)getDeviceStatus;
-(int)getLatestPixelDataSize;

//Set camera setting
-(int)setCameraSetting:(CamSetting)proc value:(int)value automode:(bool)automode;
//Get camera setting
-(int)getCameraSetting:(CamSetting)proc value:(int*)value automode:(bool*)automode;

-(void)setCallback:(CALLBACK_FUNC*)func;

//private

//AVCaptureVideoDataOutputSampleBufferDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection;

@end

#endif
