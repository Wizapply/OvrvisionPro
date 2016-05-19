// ovrvision_avf.m
// Version 0.5 : 21/Apr/2014
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

#import "ovrvision_avf.h"

//Buffer max size
#define OV_MAX_BUFFERNUMBYTE	(10240000)	//10MB

/////////// VARS AND DEFS ///////////

//UVC Control
const uvc_controls_t uvc_controls = {
	.exposure = {
		.unit = UVC_PROCESSING_UNIT_ID,  //brightness
		.selector = 0x02,
		.size = 2,
	},
	.gain = {
		.unit = UVC_PROCESSING_UNIT_ID, //gain
		.selector = 0x04,
		.size = 2,
	},
	.whitebalance_r = {
		.unit = UVC_PROCESSING_UNIT_ID, //sharpness
		.selector = 0x08,
		.size = 2,
	},
	.whitebalance_g = {
		.unit = UVC_PROCESSING_UNIT_ID, //gamma
		.selector = 0x09,
		.size = 2,
	},
	.whitebalance_b = {
		.unit = UVC_PROCESSING_UNIT_ID, //whitebalance
		.selector = 0x0A,
		.size = 2,
	},
    .whitebalance_auto = {
        .unit = UVC_PROCESSING_UNIT_ID, //whitebalance auto
        .selector = 0x0B,
        .size = 1,
    },
    .blc = {
        .unit = UVC_PROCESSING_UNIT_ID, //blc
		.selector = 0x01,
		.size = 2,
    },
	.data = {
		.unit = UVC_PROCESSING_UNIT_ID, //contrast
		.selector = 0x03,
		.size = 2,
	},
};

/////////// CLASS ///////////

@implementation OvrvisionAVFoundation

- (id)init {
    self = [super init];
    if (self != nil) {
        //initilize
        m_devstatus = OV_DEVNONE;
        memset(m_nDeviceName,0x00,sizeof(m_nDeviceName));
        
        //Pixel Data
        m_pPixels = NULL;
        
        //Pixel Size
        m_width = 0;
        m_height = 0;
        m_rate = 0;
        m_latestPixelDataSize = 0;
        
        //Mac OSX AVFoundation
        m_device = nil;
        m_session = nil;
        m_output = nil;
        m_deviceInput = nil;
        
        //waitforsignal
        m_cond = [[NSCondition alloc] init];
        
        //callback
        m_imageFunc = NULL;
        
        iodataBuffer = 0;
        interface = nil;
    }
    return self;
}

- (void)dealloc {
    
    //delete
    [self deleteDevice];
    
    //NSCondtion
    [m_cond release];
    
    [super dealloc];
}

////////////Private/////////////

//USBKit
- (void)createUSBInterface:(usb_id)vid pid:(usb_id)pid
{
    iodataBuffer = 0;
    interface = nil;
    IOUSBInterfaceInterface190 **controlInterface = nil;
	
	io_iterator_t interfaceIterator;
	IOUSBFindInterfaceRequest interfaceRequest;
	interfaceRequest.bInterfaceClass = UVC_CONTROL_INTERFACE_CLASS;
	interfaceRequest.bInterfaceSubClass = UVC_CONTROL_INTERFACE_SUBCLASS;
	interfaceRequest.bInterfaceProtocol = kIOUSBFindInterfaceDontCare;
	interfaceRequest.bAlternateSetting = kIOUSBFindInterfaceDontCare;
    
    // Find USB Device
    CFMutableDictionaryRef matchingDict = IOServiceMatching(kIOUSBDeviceClassName);
    CFNumberRef numberRef;
    
    numberRef = CFNumberCreate(kCFAllocatorDefault, kCFNumberShortType, &vid);
    CFDictionarySetValue( matchingDict, CFSTR(kUSBVendorID), numberRef );
    CFRelease(numberRef);
    
    numberRef = CFNumberCreate(kCFAllocatorDefault, kCFNumberShortType, &pid);
    CFDictionarySetValue( matchingDict, CFSTR(kUSBProductID), numberRef );
    CFRelease(numberRef);
    io_service_t camera = IOServiceGetMatchingService( kIOMasterPortDefault, matchingDict );
    
    // Get DeviceInterface
    IOUSBDeviceInterface **deviceInterface = NULL;
    IOCFPlugInInterface	**plugInInterface = NULL;
    SInt32 score;
    kern_return_t kr = IOCreatePlugInInterfaceForService(camera, kIOUSBDeviceUserClientTypeID, kIOCFPlugInInterfaceID, &plugInInterface, &score);
    
    if( (kIOReturnSuccess != kr) || !plugInInterface ) {
        NSLog( @"CameraControl Error: IOCreatePlugInInterfaceForService returned 0x%08x.", kr );
        return;
    }
    
    HRESULT res = (*plugInInterface)->QueryInterface(plugInInterface, CFUUIDGetUUIDBytes(kIOUSBDeviceInterfaceID), (LPVOID*) &deviceInterface );
    (*plugInInterface)->Release(plugInInterface);
    if( res || deviceInterface == NULL ) {
        NSLog( @"CameraControl Error: QueryInterface returned %d.\n", (int)res );
        return;
    }

    IOReturn success = (*deviceInterface)->CreateInterfaceIterator(deviceInterface, &interfaceRequest, &interfaceIterator);
	if( success != kIOReturnSuccess ) {
		return;
	}
	
	io_service_t usbInterface;
	HRESULT result;
	
    usbInterface = IOIteratorNext(interfaceIterator);
	if( usbInterface ) {
		IOCFPlugInInterface **plugInInterface = NULL;
		
		//Create an intermediate plug-in
		SInt32 score;
		kern_return_t kr = IOCreatePlugInInterfaceForService( usbInterface, kIOUSBInterfaceUserClientTypeID, kIOCFPlugInInterfaceID, &plugInInterface, &score );
		
		//Release the usbInterface object after getting the plug-in
		kr = IOObjectRelease(usbInterface);
		if( (kr != kIOReturnSuccess) || !plugInInterface ) {
			NSLog( @"CameraControl Error: Unable to create a plug-in (%08x)\n", kr );
			return;
		}
		
		//Now create the device interface for the interface
		result = (*plugInInterface)->QueryInterface( plugInInterface, CFUUIDGetUUIDBytes(kIOUSBInterfaceInterfaceID), (LPVOID *) &controlInterface );
		
		//No longer need the intermediate plug-in
		(*plugInInterface)->Release(plugInInterface);
		
		if( result || !controlInterface ) {
			NSLog( @"CameraControl Error: Couldn’t create a device interface for the interface (%08x)", (int) result );
			return;
		}
    }

    interface = controlInterface;
}

- (BOOL)sendControlRequest:(IOUSBDevRequest)controlRequest {
	if( !interface ){
		NSLog( @"CameraControl Error: No interface to send request" );
		return NO;
	}
	
	//Now open the interface. This will cause the pipes associated with
	//the endpoints in the interface descriptor to be instantiated
	kern_return_t kr = (*interface)->USBInterfaceOpen(interface);
	if (kr != kIOReturnSuccess)	{
		NSLog( @"CameraControl Error: Unable to open interface (%08x)\n", kr );
		return NO;
	}
	
	kr = (*interface)->ControlRequest( interface, 0, &controlRequest );
	if( kr != kIOReturnSuccess ) {
		kr = (*interface)->USBInterfaceClose(interface);
		NSLog( @"CameraControl Error: Control request failed: %08x", kr );
		return NO;
	}
	
	kr = (*interface)->USBInterfaceClose(interface);
	
	return YES;
}

- (BOOL)setData:(long)value withLength:(int)length forSelector:(int)selector at:(int)unitId {
	IOUSBDevRequest controlRequest;
	controlRequest.bmRequestType = USBmakebmRequestType( kUSBOut, kUSBClass, kUSBInterface );
	controlRequest.bRequest = UVC_SET_CUR;
	controlRequest.wValue = (selector << 8) | 0x00;
	controlRequest.wIndex = (unitId << 8) | 0x00;
	controlRequest.wLength = length;
	controlRequest.wLenDone = 0;
	controlRequest.pData = &value;
	return [self sendControlRequest:controlRequest];
}


- (long)getDataFor:(int)type withLength:(int)length fromSelector:(int)selector at:(int)unitId {
	long value = 0;
	IOUSBDevRequest controlRequest;
	controlRequest.bmRequestType = USBmakebmRequestType( kUSBIn, kUSBClass, kUSBInterface );
	controlRequest.bRequest = type;
	controlRequest.wValue = (selector << 8) | 0x00;
	controlRequest.wIndex = (unitId << 8) | 0x00;
	controlRequest.wLength = length;
	controlRequest.wLenDone = 0;
	controlRequest.pData = &value;
	BOOL success = [self sendControlRequest:controlRequest];
    return ( success ? value : 0 );
}

////////////////////////////////////////////

//Create / Delete Device
- (int)createDevice:(usb_id)vid pid:(usb_id)pid cam_w:(int)cam_w cam_h:(int)cam_h rate:(int)rate locate:(int)lot {
    
    if(m_devstatus != OV_DEVNONE) {
        return RESULT_FAILED;
    }
    m_devstatus = OV_DEVCREATTING;
    
    //default select
    m_width = cam_w;
    m_height = cam_h;
    m_rate = rate;
    
    // Insert code here to initialize your application
    NSError* error = nil;
    int skip = 0;
    
    //device select open
    m_device = nil;
    NSArray *devicelist = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for(AVCaptureDevice *seldv in devicelist) {
        NSString* uniqueID = [seldv uniqueID];
        NSString* vpid = [uniqueID substringFromIndex:[uniqueID length] - 8];   //get id
        
        NSString* vidstr = [vpid substringToIndex:4];    //begin 4 chars
        NSString* pidstr = [vpid substringFromIndex:4];  //end 4 chars
        if([vidstr isEqualToString:[NSString stringWithFormat:@"%04x",vid]] &&
           [pidstr isEqualToString:[NSString stringWithFormat:@"%04x",pid]]) {
            m_device = seldv;
            
            if(skip >= lot) break;
            skip++;
        }
    }
    
    //ERROR
    if(m_device == nil) {
        m_devstatus = OV_DEVNONE;
        return RESULT_FAILED;
    }

    //device setting
    AVCaptureDeviceFormat* selectedFormat = nil;
    AVFrameRateRange* frameRateRange = nil;
    for(AVCaptureDeviceFormat* format in [m_device formats]) {
        CMFormatDescriptionRef desc = format.formatDescription;
        FourCharCode code = CMFormatDescriptionGetMediaSubType(desc);
        CMVideoDimensions dimensions = CMVideoFormatDescriptionGetDimensions(desc);
        for(AVFrameRateRange* range in format.videoSupportedFrameRateRanges) {
            if(code == 'yuvs' && dimensions.width == m_width && dimensions.height == m_height) {
                selectedFormat = format;
                frameRateRange = range;
                break;
            }
        }
    }
    
    //ERROR
    if(selectedFormat == nil) {
        m_devstatus = OV_DEVNONE;
        return RESULT_FAILED;
    }
    
    if([m_device lockForConfiguration:nil]) {
        m_device.activeFormat = selectedFormat;
        m_device.activeVideoMinFrameDuration = frameRateRange.minFrameDuration;
        m_device.activeVideoMaxFrameDuration = frameRateRange.maxFrameDuration;
        [m_device unlockForConfiguration];
    }
    
    //input session
    m_deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:m_device error:&error];

    //output session
    m_output = [[AVCaptureVideoDataOutput alloc] init];
    dispatch_queue_t queue = dispatch_queue_create([[m_device uniqueID] UTF8String], NULL);
    [m_output setAlwaysDiscardsLateVideoFrames:NO];
    [m_output setSampleBufferDelegate:self queue:queue];
    dispatch_release(queue);
    
    NSDictionary* outputSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt:m_width], kCVPixelBufferWidthKey,
                                    [NSNumber numberWithInt:m_height], kCVPixelBufferHeightKey,
                                    [NSNumber numberWithInt:'yuvs'], kCVPixelBufferPixelFormatTypeKey,
                                    @YES, kCVPixelBufferCGImageCompatibilityKey,
                                    @YES, kCVPixelBufferCGBitmapContextCompatibilityKey,
                                    kCFAllocatorDefault, kCVPixelBufferMemoryAllocatorKey,
                                    //[NSNumber numberWithInt:2], kCVPixelBufferBytesPerRowAlignmentKey,
                                    nil];
    [m_output setVideoSettings:outputSettings];
    
    //session
    m_session = [[AVCaptureSession alloc] init];
    [m_session beginConfiguration];
    if([m_session canAddInput:m_deviceInput]) {
        [m_session addInput:m_deviceInput];
    }
    
    if([m_session canAddOutput:m_output]) {
        [m_session addOutput:m_output];
    }
    [m_session commitConfiguration];
    
    m_latestPixelDataSize =  m_width * 2 * m_height;
    m_pPixels = (unsigned char*)malloc(OV_MAX_BUFFERNUMBYTE);
    
    //USBIO
    [self createUSBInterface:vid pid:pid];
    
    m_devstatus = OV_DEVSTOP;    //running
    
    return RESULT_OK;
}

- (int)deleteDevice {
    
    if(m_devstatus == OV_DEVNONE) {
        // Can't delete
        return RESULT_FAILED;
    }
    
    [self stopTransfer];
    
    [m_session removeInput:m_deviceInput];
    [m_session removeOutput:m_output];
    
    [m_session release];
    
    m_device = nil;
    m_session = nil;
    m_output = nil;
    m_deviceInput = nil;

    m_width = 0;
    m_height = 0;
    m_rate = 0;
    m_latestPixelDataSize = 0;

    memset(m_nDeviceName,0x00,sizeof(char)*OV_DEVICENAMENUM);
    free(m_pPixels);

    if(interface) {
		(*interface)->USBInterfaceClose(interface);
		(*interface)->Release(interface);
	}
    interface = nil;
    
    m_devstatus = OV_DEVNONE;
    return RESULT_OK;
}

//Transfer status
- (int)startTransfer {
    
    if(m_devstatus != OV_DEVSTOP) {
        //Can't start
        return RESULT_FAILED;
    }
    
    //running
    [m_session startRunning];
	[NSThread sleepForTimeInterval:0.02];	//20ms wait

    m_devstatus = OV_DEVRUNNING;

    return RESULT_OK;
}

- (int)stopTransfer {

    if(m_devstatus != OV_DEVRUNNING) {
        //Can't stop
        return RESULT_FAILED;
    }
    
    //sync
    [m_cond lock];
    [m_cond waitUntilDate:[NSDate dateWithTimeIntervalSinceNow:OV_BLOCKTIMEOUT]];
    [m_cond unlock];
    
    //stop
    [m_session stopRunning];
    m_devstatus = OV_DEVSTOP;
    
    return RESULT_OK;
}

//Get pixel data
//In non blocking, when data cannot be acquired, RESULT_FAILED returns.
-(int) getBayer16Image:(unsigned char*)image blocking:(bool)nonblocking {

    if(m_devstatus != OV_DEVRUNNING)
        return RESULT_FAILED;

    //sync
    [m_cond lock];
    
    //if(!nonblocking) {
        if([m_cond waitUntilDate:[NSDate dateWithTimeIntervalSinceNow:OV_BLOCKTIMEOUT]]==NO)
            return RESULT_FAILED;
    //}

    if(image)
    {
        m_latestPixelDataSize = m_datasize;
        memcpy(image, m_pPixels, m_latestPixelDataSize);
    }

    [m_cond unlock];
    
    return RESULT_OK;
}

//Property
-(DevStatus)getDeviceStatus {
    return m_devstatus;
}
-(int)getLatestPixelDataSize {
    return m_latestPixelDataSize;
}

//Set camera setting
-(int)setCameraSetting:(CamSetting)proc value:(int)value automode:(bool)automode {

    if(m_devstatus != OV_DEVRUNNING)
        return RESULT_FAILED;
    
    switch(proc)
    {
        case OV_CAMSET_EXPOSURE:
            [self setData:value
               withLength:uvc_controls.exposure.size
              forSelector:uvc_controls.exposure.selector
                       at:uvc_controls.exposure.unit];
            break;
        case OV_CAMSET_GAIN:
            [self setData:value
               withLength:uvc_controls.gain.size
              forSelector:uvc_controls.gain.selector
                       at:uvc_controls.gain.unit];
            break;
        case OV_CAMSET_WHITEBALANCER:
            [self setData:value
               withLength:uvc_controls.whitebalance_r.size
              forSelector:uvc_controls.whitebalance_r.selector
                       at:uvc_controls.whitebalance_r.unit];
            break;
        case OV_CAMSET_WHITEBALANCEG:
            [self setData:value
               withLength:uvc_controls.whitebalance_g.size
              forSelector:uvc_controls.whitebalance_g.selector
                       at:uvc_controls.whitebalance_g.unit];
            break;
        case OV_CAMSET_WHITEBALANCEB:
            [self setData:(automode ? 0x01 : 0x00)
                withLength:uvc_controls.whitebalance_auto.size
              forSelector:uvc_controls.whitebalance_auto.selector
                       at:uvc_controls.whitebalance_auto.unit];
            if(!automode) { //manual
                [self setData:value
                   withLength:uvc_controls.whitebalance_b.size
                  forSelector:uvc_controls.whitebalance_b.selector
                           at:uvc_controls.whitebalance_b.unit];
            }
            break;
        case OV_CAMSET_BLC:
            [self setData:value
               withLength:uvc_controls.blc.size
              forSelector:uvc_controls.blc.selector
                       at:uvc_controls.blc.unit];
            break;
        case OV_CAMSET_DATA:
            [self setData:value
               withLength:uvc_controls.data.size
              forSelector:uvc_controls.data.selector
                       at:uvc_controls.data.unit];
            break;
        default:
            return RESULT_FAILED;
            break;
    }

	[NSThread sleepForTimeInterval:0.005];	//5ms
    
    return RESULT_OK;
}
//Get camera setting
-(int)getCameraSetting:(CamSetting)proc value:(int*)value automode:(bool*)automode {

    if(m_devstatus != OV_DEVRUNNING)
        return RESULT_FAILED;
    
    (*automode) = false;

    switch(proc)
    {
        case OV_CAMSET_EXPOSURE:
            (*value) = (int)[self getDataFor:UVC_GET_CUR
                                  withLength:uvc_controls.exposure.size
                                fromSelector:uvc_controls.exposure.selector
                                          at:uvc_controls.exposure.unit];
            break;
        case OV_CAMSET_GAIN:
            (*value) = (int)[self getDataFor:UVC_GET_CUR
                                  withLength:uvc_controls.gain.size
                                fromSelector:uvc_controls.gain.selector
                                          at:uvc_controls.gain.unit];
            break;
        case OV_CAMSET_WHITEBALANCER:
            (*value) = (int)[self getDataFor:UVC_GET_CUR
                                  withLength:uvc_controls.whitebalance_r.size
                                fromSelector:uvc_controls.whitebalance_r.selector
                                          at:uvc_controls.whitebalance_r.unit];
            break;
        case OV_CAMSET_WHITEBALANCEG:
            (*value) = (int)[self getDataFor:UVC_GET_CUR
                                  withLength:uvc_controls.whitebalance_g.size
                                fromSelector:uvc_controls.whitebalance_g.selector
                                          at:uvc_controls.whitebalance_g.unit];
            break;
        case OV_CAMSET_WHITEBALANCEB:
            (*automode) = (bool)[self getDataFor:UVC_GET_CUR
                                  withLength:uvc_controls.whitebalance_auto.size
                                fromSelector:uvc_controls.whitebalance_auto.selector
                                          at:uvc_controls.whitebalance_auto.unit];
            (*value) = (int)[self getDataFor:UVC_GET_CUR
                                  withLength:uvc_controls.whitebalance_b.size
                                fromSelector:uvc_controls.whitebalance_b.selector
                                          at:uvc_controls.whitebalance_b.unit];
            break;
        case OV_CAMSET_BLC:
            (*value) = (int)[self getDataFor:UVC_GET_CUR
                                  withLength:uvc_controls.blc.size
                                fromSelector:uvc_controls.blc.selector
                                          at:uvc_controls.blc.unit];
            break;
        case OV_CAMSET_DATA:
            (*value) = (int)[self getDataFor:UVC_GET_CUR
                                  withLength:uvc_controls.data.size
                                fromSelector:uvc_controls.data.selector
                                          at:uvc_controls.data.unit];
            break;
        default:
            return RESULT_FAILED;
            break;
    }

	[NSThread sleepForTimeInterval:0.005];	//5ms

    return RESULT_OK;
}

-(void)setCallback:(CALLBACK_FUNC*)func;
{
    m_imageFunc = func;
}

//Private

//AVCaptureVideoDataOutputSampleBufferDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    
    if(CVPixelBufferLockBaseAddress(imageBuffer, 0) == kCVReturnSuccess) {
        unsigned char* databuffer = (unsigned char*)CVPixelBufferGetBaseAddress(imageBuffer);
        size_t datasize = CVPixelBufferGetDataSize(imageBuffer);
        
        [m_cond lock];  //LOCK!
            m_datasize = (int)datasize - 32;
            memcpy(m_pPixels, databuffer ,m_datasize);
        [m_cond signal];
        [m_cond unlock];

        CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    }
    
    if(m_imageFunc != NULL)
        m_imageFunc();
    
}


@end
         
