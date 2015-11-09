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

/////////// VARS AND DEFS ///////////

//UVC Control
const uvc_controls_t uvc_controls = {
	.autoExposure = {
		.unit = UVC_INPUT_TERMINAL_ID,
		.selector = 0x02,
		.size = 1,
	},
	.exposure = {
		.unit = UVC_INPUT_TERMINAL_ID,
		.selector = 0x04,
		.size = 4,
	},
	.brightness = {
		.unit = UVC_PROCESSING_UNIT_ID,
		.selector = 0x02,
		.size = 2,
	},
	.contrast = {
		.unit = UVC_PROCESSING_UNIT_ID,
		.selector = 0x03,
		.size = 2,
	},
	.saturation = {
		.unit = UVC_PROCESSING_UNIT_ID,
		.selector = 0x07,
		.size = 2,
	},
	.sharpness = {
		.unit = UVC_PROCESSING_UNIT_ID,
		.selector = 0x08,
		.size = 2,
	},
    .gamma = {
        .unit = UVC_PROCESSING_UNIT_ID,
		.selector = 0x09,
		.size = 2,
    },
	.whiteBalance = {
		.unit = UVC_PROCESSING_UNIT_ID,
		.selector = 0x0A,
		.size = 2,
	},
	.autoWhiteBalance = {
		.unit = UVC_PROCESSING_UNIT_ID,
		.selector = 0x0B,
		.size = 1,
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
        m_pPixelsQueue = NULL;
        
        //Pixel Size
        m_width = 0;
        m_height = 0;
        m_rate = 0;
        m_latestPixelDataSize = 0;
        m_maxPixelDataSize = 0;
        
        //Mac OSX AVFoundation
        m_device = nil;
        m_session = nil;
        m_output = nil;
        m_deviceInput = nil;
        
        //waitforsignal
        m_cond = [[NSCondition alloc] init];
        m_captureOutputTime = mach_absolute_time();
        mach_timebase_info(&m_timebase);
        
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
	
	if( usbInterface = IOIteratorNext(interfaceIterator) ) {
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
            if(kCMVideoCodecType_JPEG_OpenDML == code && dimensions.width == m_width && dimensions.height == m_height) {
                selectedFormat = format;
                frameRateRange = range;
                break;
            }
        }
    }
    
    if(selectedFormat) {
        if([m_device lockForConfiguration:nil]) {
            m_device.activeFormat = selectedFormat;
            m_device.activeVideoMinFrameDuration = CMTimeMake(1000000, 30000030);
            [m_device unlockForConfiguration];
        }
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
                                    [NSNumber numberWithDouble:m_width], (id)kCVPixelBufferWidthKey,
                                    [NSNumber numberWithDouble:m_height], (id)kCVPixelBufferHeightKey,
                                    [NSNumber numberWithInt:'dmb1'], (id)kCVPixelBufferPixelFormatTypeKey,
                                    nil];
    [m_output setVideoSettings:outputSettings];
    
    //session
    if(m_session) [m_session release];
    m_session = [[AVCaptureSession alloc] init];
    if([m_session canAddInput:m_deviceInput]) {
        [m_session addInput:m_deviceInput];
    }
    
    if([m_session canAddOutput:m_output]) {
        [m_session addOutput:m_output];
    }
    
    m_latestPixelDataSize = m_maxPixelDataSize =  m_width * m_height * OV_RGB_COLOR;
    m_pPixels = (unsigned char*)malloc(sizeof(unsigned char) * m_maxPixelDataSize);
    m_pPixelsQueue = (unsigned char*)malloc(sizeof(unsigned char) * m_maxPixelDataSize);
    
    //USBIO
    [self createUSBInterface:vid pid:pid];
    
    //time restart
    m_captureOutputTime = mach_absolute_time();
    mach_timebase_info(&m_timebase);
    
    //start
    [m_session startRunning];
    
    //Running wait
    while(m_pPixels == NULL) {
        [m_cond lock];
        [m_cond wait];
        [m_cond unlock];
    }
    
    m_devstatus = OV_DEVRUNNING;    //running
    
    return RESULT_OK;
}

- (int)deleteDevice {
    
    if(m_devstatus == OV_DEVNONE) {
        // Can't delete
        return RESULT_FAILED;
    }
    
    [self stopTransfer];
    
    //[m_session release];
    [m_deviceInput release];
    [m_device release];
    [m_output release];
    
    m_device = nil;
    m_session = nil;
    m_output = nil;
    m_deviceInput = nil;
    
    m_width = 0;
    m_height = 0;
    m_rate = 0;
    m_latestPixelDataSize = 0;
    m_maxPixelDataSize = 0;
    memset(m_nDeviceName,0x00,sizeof(m_nDeviceName));
    free(m_pPixels);
    free(m_pPixelsQueue);

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
-(int) getRGBImage:(unsigned char*)image blocking:(bool)nonblocking {

    if(m_devstatus != OV_DEVRUNNING)
        return RESULT_FAILED;

    //sync
    [m_cond lock];
    
    if(!nonblocking) {
        if([m_cond waitUntilDate:[NSDate dateWithTimeIntervalSinceNow:OV_BLOCKTIMEOUT]]==NO)
            return RESULT_FAILED;
    }

    if(image && m_pPixels[0] != 0x00)
    {
        m_latestPixelDataSize = m_datasize;
        [self MJPEGToR8G8B8:image imageSrc:m_pPixels imagesize:m_latestPixelDataSize];
    }

    [m_cond unlock];
    
    return RESULT_OK;
}
       
-(int) getMJPEGImage:(unsigned char*)image blocking:(bool)nonblocking {
    
    if(m_devstatus != OV_DEVRUNNING)
        return RESULT_FAILED;
    
    //sync
    [m_cond lock];
    
    if(!nonblocking) {
        if([m_cond waitUntilDate:[NSDate dateWithTimeIntervalSinceNow:OV_BLOCKTIMEOUT]]==NO)
            return RESULT_FAILED;
    }
    
    if(image && m_pPixels[0] != 0x00)
    {
        m_latestPixelDataSize = m_datasize;
        memcpy(image, m_pPixels, m_latestPixelDataSize);    //raw
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
-(int)getMaxPixelDataSize {
    return m_maxPixelDataSize;
}

//Set camera setting
-(int)setCameraSetting:(CamSetting)proc value:(int)value automode:(bool)automode {
    
    if(m_devstatus != OV_DEVRUNNING)
        return RESULT_FAILED;

    switch(proc)
    {
        case OV_CAMSET_EXPOSURE:
            [self setData:(automode ? 0x08 : 0x01)
               withLength:uvc_controls.autoExposure.size
              forSelector:uvc_controls.autoExposure.selector
                       at:uvc_controls.autoExposure.unit];  //Automode
            if(!automode) {
                //manual
                [self setData:value
                    withLength:uvc_controls.exposure.size
                   forSelector:uvc_controls.exposure.selector
                            at:uvc_controls.exposure.unit];
            }
            break;
        case OV_CAMSET_WHITEBALANCE:
            [self setData:(automode ? 0x01 : 0x00)
               withLength:uvc_controls.autoWhiteBalance.size
              forSelector:uvc_controls.autoWhiteBalance.selector
                       at:uvc_controls.autoWhiteBalance.unit];  //Automode
            if(!automode) {
                //manual
                [self setData:value
                   withLength:uvc_controls.whiteBalance.size
                  forSelector:uvc_controls.whiteBalance.selector
                           at:uvc_controls.whiteBalance.unit];
            }
            break;
        case OV_CAMSET_CONTRAST:
            [self setData:value
               withLength:uvc_controls.contrast.size
              forSelector:uvc_controls.contrast.selector
                       at:uvc_controls.contrast.unit];
            break;
        case OV_CAMSET_SATURATION:
            [self setData:value
               withLength:uvc_controls.saturation.size
              forSelector:uvc_controls.saturation.selector
                       at:uvc_controls.saturation.unit];
            break;
        case OV_CAMSET_BRIGHTNESS:
            [self setData:value
               withLength:uvc_controls.brightness.size
              forSelector:uvc_controls.brightness.selector
                       at:uvc_controls.brightness.unit];
            break;
        case OV_CAMSET_SHARPNESS:
            [self setData:value
               withLength:uvc_controls.sharpness.size
              forSelector:uvc_controls.sharpness.selector
                       at:uvc_controls.sharpness.unit];
            break;
        case OV_CAMSET_GAMMA:
            [self setData:value
               withLength:uvc_controls.gamma.size
              forSelector:uvc_controls.gamma.selector
                       at:uvc_controls.gamma.unit];
            break;
        default:
            return RESULT_FAILED;
            break;
    }
    
    return RESULT_OK;
}
//Get camera setting
-(int)getCameraSetting:(CamSetting)proc valueout:(int*)value automodeout:(bool*)automode {
    
    if(m_devstatus != OV_DEVRUNNING)
        return RESULT_FAILED;
    
    switch(proc)
    {
        case OV_CAMSET_EXPOSURE:
            (*automode) = (bool)[self getDataFor:UVC_GET_CUR
                                      withLength:uvc_controls.autoExposure.size
                                    fromSelector:uvc_controls.autoExposure.selector
                                              at:uvc_controls.autoExposure.unit];
                //manual
            (*value) = (int)[self getDataFor:UVC_GET_CUR
                                    withLength:uvc_controls.exposure.size
                                    fromSelector:uvc_controls.exposure.selector
                                    at:uvc_controls.exposure.unit];
            break;
        case OV_CAMSET_WHITEBALANCE:
            (*automode) = (bool)[self getDataFor:UVC_GET_CUR
                                      withLength:uvc_controls.autoWhiteBalance.size
                                    fromSelector:uvc_controls.autoWhiteBalance.selector
                                              at:uvc_controls.autoWhiteBalance.unit];
            //manual
            (*value) = (int)[self getDataFor:UVC_GET_CUR
                                  withLength:uvc_controls.whiteBalance.size
                                fromSelector:uvc_controls.whiteBalance.selector
                                          at:uvc_controls.whiteBalance.unit];
            break;
        case OV_CAMSET_CONTRAST:
            (*value) = (int)[self getDataFor:UVC_GET_CUR
                                  withLength:uvc_controls.contrast.size
                                fromSelector:uvc_controls.contrast.selector
                                          at:uvc_controls.contrast.unit];
            break;
        case OV_CAMSET_SATURATION:
            (*value) = (int)[self getDataFor:UVC_GET_CUR
                                  withLength:uvc_controls.saturation.size
                                fromSelector:uvc_controls.saturation.selector
                                          at:uvc_controls.saturation.unit];
            break;
        case OV_CAMSET_BRIGHTNESS:
            (*value) = (int)[self getDataFor:UVC_GET_CUR
                                  withLength:uvc_controls.brightness.size
                                fromSelector:uvc_controls.brightness.selector
                                          at:uvc_controls.brightness.unit];
            break;
        case OV_CAMSET_SHARPNESS:
            (*value) = (int)[self getDataFor:UVC_GET_CUR
                                  withLength:uvc_controls.sharpness.size
                                fromSelector:uvc_controls.sharpness.selector
                                          at:uvc_controls.sharpness.unit];
            break;
        case OV_CAMSET_GAMMA:
            (*value) = (int)[self getDataFor:UVC_GET_CUR
                                  withLength:uvc_controls.gamma.size
                                fromSelector:uvc_controls.gamma.selector
                                          at:uvc_controls.gamma.unit];
            break;
        default:
            return RESULT_FAILED;
            break;
    }
    return RESULT_OK;
}

//Private

//MJPEG -> RGB(24bit) Decoder
- (int)MJPEGToR8G8B8:(unsigned char*)pImageDest imageSrc:(unsigned char*)pImageSrc imagesize:(int)srcSize
{
    struct jpeg_decompress_struct cinfo;
    struct jpeg_error_mgr jerr;
    int offset = 0;
    
    // Initialize JPEG Encoder
    jpeg_std_error(&jerr);
    cinfo.err = &jerr;
    jpeg_create_decompress(&cinfo);
    
    jpeg_mem_src(&cinfo, (unsigned char*)pImageSrc, srcSize);
    jpeg_read_header(&cinfo, TRUE);
    jpeg_start_decompress(&cinfo);
    
    // Get all image datas.
    while(cinfo.output_scanline < cinfo.output_height) {
        JSAMPROW img_array = (JSAMPROW)malloc(sizeof(JSAMPLE) * OV_RGB_COLOR * cinfo.output_width);
        jpeg_read_scanlines(&cinfo, (JSAMPARRAY)&img_array, 1);
        
        memcpy(&pImageDest[offset],img_array,(int)cinfo.output_width*OV_RGB_COLOR);
        offset += (int)cinfo.output_width * OV_RGB_COLOR;
        free(img_array);
    }

    jpeg_finish_decompress(&cinfo);
    jpeg_destroy_decompress(&cinfo);
    
    return RESULT_OK;
}

//AVCaptureVideoDataOutputSampleBufferDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    uint64_t nsec = (mach_absolute_time() - m_captureOutputTime) * m_timebase.numer / m_timebase.denom;
    m_captureOutputTime = mach_absolute_time();

    if( !CMSampleBufferDataIsReady(sampleBuffer) ) {
        NSLog(@"sample buffer is not ready. Skipping sample");
        return;
    }
    
    CMBlockBufferRef imageBuffer = CMSampleBufferGetDataBuffer(sampleBuffer);
    
    size_t datasize;
    char* databuffer;
    
    CMBlockBufferGetDataPointer(imageBuffer,0,NULL,&datasize,&databuffer);
    
    //16.6ms = 60fps
    if(nsec > 16600000) {
        [m_cond lock];  //LOCK!
    
        memcpy(m_pPixels,databuffer,(int)datasize / 3);
        m_datasize = (int)datasize / 3;
        
        [m_cond signal];
        [m_cond unlock];
    } else {
        memcpy(m_pPixelsQueue,databuffer,(int)datasize / 3);
        //Create Thread
        m_queueThreadPreTime = nsec;
        m_queueThread = [[NSThread alloc] initWithTarget:self selector:@selector(queueImageGetThread:) object:nil];
        [m_queueThread start];
    }
}

- (void)queueImageGetThread:(id)object
{
    //60fps
    double nsecf = 15666666.0 - (double)m_queueThreadPreTime;
    if(nsecf < 100000.0)
        return;
    nsecf *= 0.000000001;
    [NSThread sleepForTimeInterval:nsecf];  //Wait
    
    [m_cond lock];  //LOCK!
    
    memcpy(m_pPixels,m_pPixelsQueue,m_datasize);
    
    [m_cond signal];
    [m_cond unlock];
}


@end
         
