//
//  IOSExampleAppDelegate.h
//  IOSExample
//
//  Created by John Sheets on 12/19/10.
//  Copyright 2010 $@. All rights reserved.
//

#import "FringeTools.h"

@interface IOSExampleAppDelegate : FFTAppDelegate <UIApplicationDelegate, UITabBarControllerDelegate>
{
    UIWindow *window;
    UITabBarController *tabBarController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@end
