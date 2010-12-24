//
//  MacExampleAppDelegate.m
//  MacExample
//
//  Created by John Sheets on 12/19/10.
//  Copyright 2010 MobileMethod, LLC. All rights reserved.
//

#import "MacExampleAppDelegate.h"

@implementation MacExampleAppDelegate

@synthesize window = _window;
@synthesize flickrViewController = _flickrViewController;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    FFTInfo(@"Application starting");
    NSView *contentView = [self.window contentView];
    [contentView addSubview:[self.flickrViewController view]];
}

@end
