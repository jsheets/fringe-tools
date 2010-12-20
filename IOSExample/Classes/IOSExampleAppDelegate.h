//
//  IOSExampleAppDelegate.h
//  IOSExample
//
//  Created by John Sheets on 12/19/10.
//  Copyright 2010 MobileMethod, LLC. All rights reserved.
//

#import "FringeTools.h"

@interface IOSExampleAppDelegate : FFTAppDelegate <UIApplicationDelegate, UITabBarControllerDelegate>
{
    UIWindow *_window;
    UITabBarController *_tabBarController;
    NSOperationQueue *_queue;
}

@property (nonatomic, assign) IBOutlet UIWindow *window;
@property (nonatomic, assign) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) NSOperationQueue *queue;

@end
