//
//  ChessSizeFormDelegate.m
//  OvrvisionCalibration
//
//  Created by WizapplyOSX on 2014/11/25.
//  Copyright (c) 2014年 Wizapply. All rights reserved.
//

#import "ChessSizeFormDelegate.h"


@implementation ChessSizeFormDelegate

- (id)initWithWindowNibName:(NSString *)nibNameOrNil
{
    self = [super initWithWindowNibName:nibNameOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (IBAction)okButton:(id)sender {
    [[NSApplication sharedApplication] stopModalWithCode:1];
}

-(float) getSize
{
    return _TileSize.floatValue;
}

@end
