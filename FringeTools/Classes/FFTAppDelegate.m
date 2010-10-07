//
//  FringeAppDelegate.m
//  FringeTools
//
//  Created by John Sheets on 10/6/10.
//  Copyright 2010 FourFringe. All rights reserved.
//

#import "FFTAppDelegate.h"


@implementation FFTAppDelegate

@synthesize window = _window;

- (BOOL)isIPad
{
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}

- (CGSize)appScreenSize:(BOOL)isPortrait
{
    //    CGRect frame = [[UIScreen mainScreen] applicationFrame];
    //    CGSize size = [[UIScreen mainScreen] applicationFrame].size;
    CGSize size = [[UIScreen mainScreen] bounds].size;
    if ((isPortrait && size.width > size.height) || (!isPortrait && size.height > size.width))
    {
        size = CGSizeMake(size.height, size.width);
    }
    return size;
}


#pragma mark -
#pragma mark Application directories


/**
 Returns the path to the application's documents directory.
 */
- (NSString *)applicationDocumentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

@end
