//
//  MacExampleAppDelegate.h
//  MacExample
//
//  Created by John Sheets on 12/19/10.
//  Copyright 2010 MobileMethod, LLC. All rights reserved.
//

#import "FlickrViewController.h"

@interface MacExampleAppDelegate : NSObject <NSApplicationDelegate>
{
    NSWindow *_window;
    FlickrViewController *_flickrViewController;
}

@property (assign) IBOutlet NSWindow *window;
@property (nonatomic, retain) IBOutlet FlickrViewController *flickrViewController;

@end
