//
//  FringeAppDelegate.m
//  FringeTools
//
//  Created by John Sheets on 10/6/10.
//  Copyright 2010 MobileMethod, LLC. All rights reserved.
//
// MIT License
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <FringeTools/FFTAppDelegate.h>
#import <FringeTools/FFTLogging.h>

@implementation FFTAppDelegate

- (BOOL)isIPad
{
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}

- (CGSize)devicePixelSize
{
    UIScreen *screen = [UIScreen mainScreen];
    CGSize size = [screen bounds].size;
    if ([screen respondsToSelector:@selector(scale)])
    {
        size = CGSizeMake(size.width * screen.scale, size.height * screen.scale);
    }
    
    return size;
}

// Available screen space for the application to draw in.
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

- (BOOL)isRetinaDisplay
{
    BOOL hasRetinaScreen = NO;
    
    // Safe on older versions of iOS.
    UIScreen *screen = [UIScreen mainScreen];
    if ([screen respondsToSelector:@selector(currentMode)])
    {
        CGSize size = [[screen currentMode] size];
        FFTDebug(@"Screen size: %@", NSStringFromCGSize(size));
        
        // This is really fragile. Need a better test.
        hasRetinaScreen = size.width == 640;
    }
    
    return hasRetinaScreen;
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
