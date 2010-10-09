//
//  FringeAppDelegate.h
//  FringeTools
//
//  Created by John Sheets on 10/6/10.
//  Copyright 2010 FourFringe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFTAppDelegate : NSObject <UIApplicationDelegate>
{
}

@property (nonatomic, readonly) NSString *applicationDocumentsDirectory;
@property (nonatomic, readonly) BOOL isIPad;

- (CGSize)appScreenSize:(BOOL)isPortrait;

@end
