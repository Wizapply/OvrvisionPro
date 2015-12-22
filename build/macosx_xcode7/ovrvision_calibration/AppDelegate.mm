//
//  AppDelegate.m
//  OvrvisionCalibration
//
//  Created by WizapplyOSX on 2015/12/22.
//  Copyright (c) 2015 Wizapply. All rights reserved.
//

#import "AppDelegate.h"
#import "ChessSizeFormDelegate.h"
#import "HowToUseDelegate.h"

#define OV_PSQT_NONE 0		//No Processing quality
#define OV_PSQT_LOW 1		//Low Processing quality
#define OV_PSQT_HIGH 2		//High Processing quality
#define OV_PSQT_REFSET 3		//RefOnly Processing quality

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Use the classes and functions in the bundle.
    NSBundle *thisBundle = [NSBundle mainBundle];
    NSString *bundlePath= [thisBundle pathForResource:@"ovrvision" ofType:@"bundle"];
    NSURL* bundleURL = [NSURL fileURLWithPath:bundlePath];
    
    cfBundle = CFBundleCreate(kCFAllocatorDefault, (__bridge CFURLRef)bundleURL);
    
    if(cfBundle) {
        ovOpen = (ovOpenPtr)CFBundleGetFunctionPointerForName(cfBundle, CFSTR("ovOpen"));
        ovClose = (ovClosePtr)CFBundleGetFunctionPointerForName(cfBundle, CFSTR("ovClose"));
        ovPreStoreCamData = (ovPreStoreCamDataPtr)CFBundleGetFunctionPointerForName(cfBundle, CFSTR("ovPreStoreCamData"));
        ovGetCamImage = (ovGetCamImagePtr)CFBundleGetFunctionPointerForName(cfBundle, CFSTR("ovGetCamImage"));
        ovGetCamImageBGR = (ovGetCamImageBGRPtr)CFBundleGetFunctionPointerForName(cfBundle, CFSTR("ovGetCamImageBGR"));
        ovGetImageWidth = (ovGetImageWidthPtr)CFBundleGetFunctionPointerForName(cfBundle, CFSTR("ovGetImageWidth"));
        ovGetImageHeight = (ovGetImageHeightPtr)CFBundleGetFunctionPointerForName(cfBundle, CFSTR("ovGetImageHeight"));
        ovGetImageRate = (ovGetImageRatePtr)CFBundleGetFunctionPointerForName(cfBundle, CFSTR("ovGetImageRate"));
        ovGetBufferSize = (ovGetBufferSizePtr)CFBundleGetFunctionPointerForName(cfBundle, CFSTR("ovGetBufferSize"));
        ovCalibInitialize = (ovCalibInitializePtr)CFBundleGetFunctionPointerForName(cfBundle, CFSTR("ovCalibInitialize"));
        ovCalibFindChess = (ovCalibFindChessPtr)CFBundleGetFunctionPointerForName(cfBundle, CFSTR("ovCalibFindChess"));
        ovCalibSolveStereoParameter = (ovCalibSolveStereoParameterPtr)CFBundleGetFunctionPointerForName(cfBundle, CFSTR("ovCalibSolveStereoParameter"));
        ovCalibGetImageCount = (ovCalibGetImageCountPtr)CFBundleGetFunctionPointerForName(cfBundle, CFSTR("ovCalibGetImageCount"));
    
        NSLog(@"[OK] Loaded the ovrvision.bundle.");
    }
    
    // ボードを表示するためにNSImageを作成
    NSString *chessboradPath= [thisBundle pathForResource:@"chess4x7" ofType:@"bmp"];
    NSImage *image = [[NSImage alloc] initByReferencingFile:chessboradPath];
    // Image Wellに設定
    [self.imageView setImage:image];
    
    [_OvrvisionHMDTypeButton itemAtIndex:0];
    
    endThread = false;

}

- (void)dealloc {

    if([[_OvrvisionCtrl title] isEqualToString:@"Close Ovrvision"]) {
        endThread = false;
        if(ovClose()==0) {
            NSLog(@"Ovrvision was closed.");
        }
    }
    
    //close
    CFRelease(cfBundle);
}

- (IBAction)OvrvisionCtrlButton:(id)sender {
    
    if([[_OvrvisionCtrl title] isEqualToString:@"Open Ovrvision"])
    {
        hmdtype = 2;
        if([_OvrvisionHMDTypeDK2 state]) {
            hmdtype = 2;
        }
        else if([_OvrvisionHMDTypeDK1 state]) {
            hmdtype = 1;
        }
        else if([_OvrvisionHMDTypeOther state]) {
            hmdtype = 0;
        }
        
        if(ovOpen(0, 0.15f, hmdtype)==0)
        {
            [_OvrvisionCtrl setTitle:@"Close Ovrvision"];
            [_OvrvisionCalib setEnabled: YES];
            [_OvrvisionHMDTypeButton setEnabled: NO];
            
            [_outputTextView setString:@"Ovrvision was opened.\n"]; //initialize text

            //camera image
            left_bitmap = [[NSBitmapImageRep alloc]
                                        initWithBitmapDataPlanes:NULL
                                        pixelsWide:640
                                        pixelsHigh:480
                                        bitsPerSample:8
                                        samplesPerPixel:3
                                        hasAlpha:NO
                                        isPlanar:NO
                                        colorSpaceName:NSCalibratedRGBColorSpace
                                        bytesPerRow:640*3
                                        bitsPerPixel:24];
        
            right_bitmap = [[NSBitmapImageRep alloc]
                           initWithBitmapDataPlanes:NULL
                           pixelsWide:640
                           pixelsHigh:480
                           bitsPerSample:8
                           samplesPerPixel:3
                           hasAlpha:NO
                           isPlanar:NO
                           colorSpaceName:NSCalibratedRGBColorSpace
                           bytesPerRow:640*3
                           bitsPerPixel:24];
            
            endThread = true;
            [NSThread detachNewThreadSelector:@selector(updateThread)
                                     toTarget:self
                                   withObject:nil];
        }
        
    }
    else if([[_OvrvisionCtrl title] isEqualToString:@"Close Ovrvision"])
    {
        endThread = false;
        if(ovClose()==0)
        {
            [_OvrvisionCtrl setTitle:@"Open Ovrvision"];
            [_OvrvisionCalib setTitle:@"Start Calibration"];
            [_OvrvisionCalib setEnabled: NO];
            [_OvrvisionHMDTypeButton setEnabled: YES];
            
            [self.leftCameraView setImage:NULL];
            [self.rightCameraView setImage:NULL];
        }
    }

}

- (IBAction)OvrvisionCalibButton:(id)sender {

    if ([[_OvrvisionCalib title] isEqualToString:@"Start Calibration"])
    {
        float tilesize = 0;
        
        ChessSizeFormDelegate* chesssizeform = [[ChessSizeFormDelegate alloc] initWithWindowNibName:@"ChessSizeForm"];
        int result = (int)[[NSApplication sharedApplication] runModalForWindow:[chesssizeform window]];
        [[chesssizeform window] orderOut:nil];
        
        if(result == 1) {
            tilesize = [chesssizeform getSize];
            
            if(tilesize > 5) {
                
                HowToUseDelegate* howtouse = [[HowToUseDelegate alloc] initWithWindowNibName:@"HowToUse"];
                int result = (int)[[NSApplication sharedApplication] runModalForWindow:[howtouse window]];
                [[howtouse window] orderOut:nil];
                
                ovCalibInitialize(7, 4, tilesize);
                [_OvrvisionCalib setTitle:@"Find Chessboard"];
        
                [self appendText:[NSString stringWithFormat:@"Start calibration.... tile size is %f.2mm\n", tilesize]];
            }
        }
    }
    else if ([[_OvrvisionCalib title] isEqualToString:@"Find Chessboard"])
    {
        if(ovCalibFindChess() != 0)
            [self appendText:[NSString stringWithFormat:@"[Success]Chess board was found: No.%d/%d\n", ovCalibGetImageCount(), CalibrationImageNum]];
        else
            [self appendText:@"[Failure]Can not find the chess board.\n"];
        
        if (ovCalibGetImageCount() >= CalibrationImageNum)
        {
            [_OvrvisionCalib setTitle:@"Create Parameters"];
        }
    }
    else if ([[_OvrvisionCalib title] isEqualToString:@"Create Parameters"])
    {
        [self appendText:@"Setup in the data..... "];
        ovCalibSolveStereoParameter();
        [self appendText:@"Success.\n"];
        [NSThread sleepForTimeInterval:1.0]; //1s wait
        [self appendText:@"Calibration params has been saved.\n"];
        
        //Close
        endThread = false;
        if (ovClose() == 0)
        {
            [_OvrvisionCtrl setTitle:@"Open Ovrvision"];
            [_OvrvisionCalib setTitle:@"Start Calibration"];
            [_OvrvisionCalib setEnabled: NO];
            
            [self.leftCameraView setImage:NULL];
            [self.rightCameraView setImage:NULL];
        }
        
        [self appendText:@"Ovrvision calibration is done.\n"];
    }
    
}

- (void)updateThread
{
    //update view
    while(endThread)
    {
        NSImage *left_image = [[NSImage alloc] init];
        NSImage *right_image = [[NSImage alloc] init];
        
        ovPreStoreCamData();
        if(hmdtype==2) {
            ovGetCamImage([left_bitmap bitmapData],0,OV_PSQT_REFSET);    //Ref
            ovGetCamImage([right_bitmap bitmapData],1,OV_PSQT_REFSET);
        } else {
            ovGetCamImage([left_bitmap bitmapData],0,OV_PSQT_NONE);    //Ref
            ovGetCamImage([right_bitmap bitmapData],1,OV_PSQT_NONE);
        }
        
        [left_image addRepresentation:left_bitmap];
        [right_image addRepresentation:right_bitmap];

        [self.leftCameraView setImage:left_image];
        [self.rightCameraView setImage:right_image];
        
        [NSThread sleepForTimeInterval:0.05];
    }
    
}

-(void)appendText:(NSString*)text;
{
    //描画を一時的に止める
    [_outputTextView.textStorage beginEditing];
    
    //テキストを追加
    NSAttributedString* atrstr = [[NSAttributedString alloc] initWithString:text];
    [_outputTextView.textStorage appendAttributedString: atrstr];
    
    //描画再開
    [_outputTextView.textStorage endEditing];
    
    //最終行へスクロール
    [_outputTextView autoscroll:nil];
}

- (IBAction)QuitTool:(id)sender {
    [[NSApplication sharedApplication] terminate:self];
}

@end
