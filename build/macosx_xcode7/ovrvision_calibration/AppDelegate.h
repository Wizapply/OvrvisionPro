//
//  AppDelegate.h
//  OvrvisionCalibration
//
//  Created by WizapplyOSX on 2015/12/24.
//  Copyright (c) 2015 Wizapply. All rights reserved.
//

#import <Cocoa/Cocoa.h>

// C lang functions : ovrvision.bundle
//ovrvision_csharp.cpp
////////////// Main Ovrvision System //////////////
typedef int  (*ovOpen_ptr)(int, float, int);
typedef int  (*ovClose_ptr)();
typedef void (*ovRelease_ptr)();
typedef void (*ovPreStoreCamData_ptr)(int qt);
typedef void (*ovGetCamImageBGRA_ptr)(unsigned char*, int);
typedef void (*ovGetCamImageRGB_ptr)(unsigned char*, int);

typedef void (*ovGetCamImageBGR_ptr)(unsigned char*, int);
typedef void (*ovGetCamImageForUnity_ptr)(unsigned char*, unsigned char*);

typedef void (*ovGetCamImageForUnityNative_ptr)(unsigned char*, unsigned char*);

typedef int (*ovGetImageWidth_ptr)();
typedef int (*ovGetImageHeight_ptr)();
typedef int (*ovGetImageRate_ptr)();
typedef int (*ovGetBufferSize_ptr)();
typedef int (*ovGetPixelSize_ptr)();

//Set camera properties
typedef void (*ovSetExposure_ptr)(int);
typedef void (*ovSetGain_ptr)(int);
typedef void (*ovSetBLC_ptr)(int);
typedef void (*ovSetWhiteBalanceR_ptr)(int);
typedef void (*ovSetWhiteBalanceG_ptr)(int);
typedef void (*ovSetWhiteBalanceB_ptr)(int);
typedef void (*ovSetWhiteBalanceAuto_ptr)(bool);
//Get camera properties
typedef int (*ovGetExposure_ptr)();
typedef int (*ovGetGain_ptr)();
typedef int (*ovGetBLC_ptr)();
typedef int (*ovGetWhiteBalanceR_ptr)();
typedef int (*ovGetWhiteBalanceG_ptr)();
typedef int (*ovGetWhiteBalanceB_ptr)();
typedef bool (*ovGetWhiteBalanceAuto_ptr)();
typedef float (*ovGetFocalPoint_ptr)();
typedef float (*ovGetHMDRightGap_ptr)(int);

typedef float (*ovSetCamSyncMode_ptr)(bool);

////////////// Ovrvision AR System //////////////
typedef void (*ovARRender_ptr)();
typedef int (*ovARGetData_ptr)(float*, int);
typedef void (*ovARSetMarkerSize_ptr)(int);
typedef int (*ovARGetMarkerSize_ptr)();

////////////// Ovrvision Tracking System //////////////
//testing
typedef void (*ovTrackRender_ptr)(bool, bool);
typedef int (*ovGetTrackData_ptr)(float*);
typedef void (*ovTrackingCalibReset_ptr)();

////////////// Ovrvision Calibration //////////////
typedef void (*ovCalibInitialize_ptr)(int, int, double);
typedef int (*ovCalibClose_ptr)();
typedef int (*ovCalibFindChess_ptr)();
typedef void (*ovCalibSolveStereoParameter_ptr)();
typedef int (*ovCalibGetImageCount_ptr)();

//Ovrvision config save status
typedef bool (*ovSaveCamStatusToEEPROM_ptr)();

//////////////////////////////////////////////

//camera type select define
#define OV_CAM5MP_FULL  (0)     //2560x1920 @15fps x2
#define OV_CAM5MP_FHD   (1)		//1920x1080 @30fps x2
#define OV_CAMHD_FULL   (2)		//1280x960  @45fps x2
#define OV_CAMVR_FULL   (3) 	//960x950   @60fps x2
#define OV_CAMVR_WIDE   (4)		//1280x800  @60fps x2
#define OV_CAMVR_VGA    (5)		//640x480   @90fps x2
#define OV_CAMVR_QVGA   (6)		//320x240   @120fps x2
//camera select define
#define OV_CAMEYE_LEFT  (0)
#define OV_CAMEYE_RIGHT (1)
//renderer quality
#define OV_CAMQT_DMSRMP (0)     //Demosaic&remap Processing quality
#define OV_CAMQT_DMS    (1)		//Demosaic Processing quality
#define OV_CAMQT_NONE   (2)		//None Processing quality
//Ar Macro define
#define MARKERGET_MAXNUM10  (100) //max marker is 10
#define MARKERGET_ARG10     (10)
#define MARKERGET_RECONFIGURE_NUM   (10)

const static int CalibrationImageNum = 25;

//app delegate
@interface AppDelegate : NSObject <NSApplicationDelegate>
{
    CFBundleRef cfBundle;
    
    //ovrvision.bundle
    // C lang functions : ovrvision.bundle
    //ovrvision_csharp.cpp
    ////////////// Main Ovrvision System //////////////
    ovOpen_ptr ovOpen;
    ovClose_ptr ovClose;
    ovRelease_ptr ovRelease;
    ovPreStoreCamData_ptr ovPreStoreCamData;
    ovGetCamImageBGRA_ptr ovGetCamImageBGRA;
    ovGetCamImageRGB_ptr ovGetCamImageRGB;
    
    ovGetCamImageBGR_ptr ovGetCamImageBGR;
    ovGetCamImageForUnity_ptr ovGetCamImageForUnity;
    
    ovGetCamImageForUnityNative_ptr ovGetCamImageForUnityNative;
    
    ovGetImageWidth_ptr ovGetImageWidth;
    ovGetImageHeight_ptr ovGetImageHeight;
    ovGetImageRate_ptr ovGetImageRate;
    ovGetBufferSize_ptr ovGetBufferSize;
    ovGetPixelSize_ptr ovGetPixelSize;
    
    //Set camera properties
    ovSetExposure_ptr ovSetExposure;
    ovSetGain_ptr ovSetGain;
    ovSetBLC_ptr ovSetBLC;
    ovSetWhiteBalanceR_ptr ovSetWhiteBalanceR;
    ovSetWhiteBalanceG_ptr ovSetWhiteBalanceG;
    ovSetWhiteBalanceB_ptr ovSetWhiteBalanceB;
    ovSetWhiteBalanceAuto_ptr ovSetWhiteBalanceAuto;
    //Get camera properties
    ovGetExposure_ptr ovGetExposure;
    ovGetGain_ptr ovGetGain;
    ovGetBLC_ptr ovGetBLC;
    ovGetWhiteBalanceR_ptr ovGetWhiteBalanceR;
    ovGetWhiteBalanceG_ptr ovGetWhiteBalanceG;
    ovGetWhiteBalanceB_ptr ovGetWhiteBalanceB;
    ovGetWhiteBalanceAuto_ptr ovGetWhiteBalanceAuto;
    ovGetFocalPoint_ptr ovGetFocalPoint;
    ovGetHMDRightGap_ptr ovGetHMDRightGap;
    
    ovSetCamSyncMode_ptr ovSetCamSyncMode;
    
    ////////////// Ovrvision AR System //////////////
    ovARRender_ptr ovARRender;
    ovARGetData_ptr ovARGetData;
    ovARSetMarkerSize_ptr ovARSetMarkerSize;
    ovARGetMarkerSize_ptr ovARGetMarkerSize;
    
    ////////////// Ovrvision Tracking System //////////////
    //testing
    ovTrackRender_ptr ovTrackRender;
    ovGetTrackData_ptr ovGetTrackData;
    ovTrackingCalibReset_ptr ovTrackingCalibReset;
    
    ////////////// Ovrvision Calibration //////////////
    ovCalibInitialize_ptr ovCalibInitialize;
    ovCalibClose_ptr ovCalibClose;
    ovCalibFindChess_ptr ovCalibFindChess;
    ovCalibSolveStereoParameter_ptr ovCalibSolveStereoParameter;
    ovCalibGetImageCount_ptr ovCalibGetImageCount;
    
    ovSaveCamStatusToEEPROM_ptr ovSaveCamStatusToEEPROM;
    /////////////////////////////////////////////////
    
    NSBitmapImageRep *left_bitmap;
    NSBitmapImageRep *right_bitmap;
    int hmdtype;
    
    volatile bool endThread;
}
- (void)dealloc;

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSImageView *imageView;
@property (weak) IBOutlet NSScrollView *outputView;
@property (unsafe_unretained) IBOutlet NSTextView *outputTextView;

@property (weak) IBOutlet NSImageView *leftCameraView;
@property (weak) IBOutlet NSImageView *rightCameraView;

@property (weak) IBOutlet NSButton *OvrvisionCtrl;
@property (weak) IBOutlet NSButton *OvrvisionCalib;

-(void)appendText:(NSString*)text;

@end
