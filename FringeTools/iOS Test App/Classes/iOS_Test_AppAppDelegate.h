//
//  iOS_Test_AppAppDelegate.h
//  iOS Test App
//
//  Created by John Sheets on 11/1/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class iOS_Test_AppViewController;

@interface iOS_Test_AppAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    iOS_Test_AppViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet iOS_Test_AppViewController *viewController;

@end
