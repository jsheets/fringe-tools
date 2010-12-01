//
//  iOS_Test_AppAppDelegate.m
//  iOS Test App
//
//  Created by John Sheets on 11/1/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import "iOS_Test_AppAppDelegate.h"

#import "iOS_Test_AppViewController.h"

@implementation iOS_Test_AppAppDelegate


@synthesize window;

@synthesize viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // Override point for customization after application launch.
     
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {

    // Save data if appropriate.
}

- (void)dealloc {

    [window release];
    [viewController release];
    [super dealloc];
}

@end
