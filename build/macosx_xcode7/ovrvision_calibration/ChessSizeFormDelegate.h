//
//  ChessSizeFormDelegateWindowController.h
//  OvrvisionCalibration
//
//  Created by WizapplyOSX on 2014/11/25.
//  Copyright (c) 2014年 Wizapply. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ChessSizeFormDelegate : NSWindowController

@property (weak) IBOutlet NSButton *OKButton;
@property (weak) IBOutlet NSTextField *TileSize;

-(float) getSize;

@end
