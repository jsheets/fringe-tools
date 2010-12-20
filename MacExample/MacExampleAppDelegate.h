//
//  MacExampleAppDelegate.h
//  MacExample
//
//  Created by John Sheets on 12/19/10.
//  Copyright 2010 $@. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MacExampleAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
}

@property (assign) IBOutlet NSWindow *window;

@end
