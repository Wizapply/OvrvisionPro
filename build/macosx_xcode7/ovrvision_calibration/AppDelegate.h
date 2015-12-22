//
//  AppDelegate.h
//  OvrvisionCalibration
//
//  Created by WizapplyOSX on 2014/11/24.
//  Copyright (c) 2014年 Wizapply. All rights reserved.
//

#import <Cocoa/Cocoa.h>

// C lang functions : ovrvision.bundle
typedef int (*ovOpenPtr)(int, float, int);
typedef int (*ovClosePtr)(void);
typedef void (*ovPreStoreCamDataPtr)();
typedef void (*ovGetCamImagePtr)(unsigned char*, int, int);
typedef void (*ovGetCamImageBGRPtr)(unsigned char*, int, int);
typedef int (*ovGetImageWidthPtr)();
typedef int (*ovGetImageHeightPtr)();
typedef int (*ovGetImageRatePtr)();
typedef int (*ovGetBufferSizePtr)();
typedef void (*ovCalibInitializePtr)(int, int, double);
typedef int (*ovCalibFindChessPtr)();
typedef void (*ovCalibSolveStereoParameterPtr)();
typedef int (*ovCalibGetImageCountPtr)();

const static int CalibrationImageNum = 25;

//app delegate
@interface AppDelegate : NSObject <NSApplicationDelegate>
{
    CFBundleRef cfBundle;
    
    //ovrvision.bundle
    ovOpenPtr ovOpen;
    ovClosePtr ovClose;
    ovPreStoreCamDataPtr ovPreStoreCamData;
    ovGetCamImagePtr ovGetCamImage;
    ovGetCamImageBGRPtr ovGetCamImageBGR;
    ovGetImageWidthPtr ovGetImageWidth;
    ovGetImageHeightPtr ovGetImageHeight;
    ovGetImageRatePtr ovGetImageRate;
    ovGetBufferSizePtr ovGetBufferSize;
    ovCalibInitializePtr ovCalibInitialize;
    ovCalibFindChessPtr ovCalibFindChess;
    ovCalibSolveStereoParameterPtr ovCalibSolveStereoParameter;
    ovCalibGetImageCountPtr ovCalibGetImageCount;
    
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
@property (weak) IBOutlet NSMenuItem *OvrvisionHMDTypeDK2;
@property (weak) IBOutlet NSMenuItem *OvrvisionHMDTypeDK1;
@property (weak) IBOutlet NSMenuItem *OvrvisionHMDTypeOther;
@property (weak) IBOutlet NSPopUpButton *OvrvisionHMDTypeButton;

-(void)appendText:(NSString*)text;

@end
