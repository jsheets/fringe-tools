//
//  FlickrViewController.h
//  IOSExample
//
//  Created by John Sheets on 12/19/10.
//  Copyright 2010 MobileMethod, LLC. All rights reserved.
//

#import "FringeTools.h"
#import "IOSExampleAppDelegate.h"

@interface FlickrViewController : UITableViewController <FFTDownloadDelegate>
{
    FFTFlickrSearchOperation *_op;
}

@property (nonatomic, readonly) IOSExampleAppDelegate* appDelegate;
@property (nonatomic, retain) FFTFlickrSearchOperation *op;

@end
