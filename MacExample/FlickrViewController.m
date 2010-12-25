//
//  FlickrViewController.m
//  MacExample
//
//  Created by John Sheets on 12/24/10.
//  Copyright 2010 MobileMethod, LLC. All rights reserved.
//

#import "FlickrViewController.h"

@implementation FlickrViewController

@synthesize textView = _textView;
@synthesize queue = _queue;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
    {
        // Initialization code here.
        FFTInfo(@"Initializing FlickrViewController.");
        _queue = [[NSOperationQueue alloc] init];
    }
    
    return self;
}

- (void)dealloc
{
    [_queue release], _queue = nil;
    
    [super dealloc];
}

#define OBJECTIVE_FLICKR_API_KEY             @"59e46f94de1d538c5d3a0eea8191e797"
#define OBJECTIVE_FLICKR_API_SHARED_SECRET   @"77e733718d0215a9"

- (void)loadView
{
    [super loadView];
    
    FFTInfo(@"Loading view.");
    
    FFTFlickrSearchOperation *flickrOp = [[FFTFlickrSearchOperation alloc] initWithUsername:nil keyword:nil apiKey:OBJECTIVE_FLICKR_API_KEY sharedSecret:OBJECTIVE_FLICKR_API_SHARED_SECRET];
    flickrOp.delegate = self;
    
    [self.queue addOperation:flickrOp];
}


#pragma mark -
#pragma mark Flickr Delegate


- (void)downloadSucceeded:(NSData *)downloadData
{
    FFTInfo(@"Flickr Download Succeeded");
}

- (void)downloadFailedWithError:(NSError *)downloadError
{
    FFTInfo(@"Flickr Download Fails: %@", downloadError);
}

- (void)foundUrls:(NSArray *)urls
{
    FFTInfo(@"Found Flickr URLs: %@", urls);
}

@end
