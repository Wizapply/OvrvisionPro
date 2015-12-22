//
//  HowToUseDelegate.m
//  OvrvisionCalibration
//
//  Created by WizapplyOSX on 2014/11/25.
//  Copyright (c) 2014年 Wizapply. All rights reserved.
//

#import "HowToUseDelegate.h"

@interface HowToUseDelegate ()

@end

@implementation HowToUseDelegate

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
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

- (IBAction)OKButton:(id)sender {
    [[NSApplication sharedApplication] stopModalWithCode:1];
}

@end
