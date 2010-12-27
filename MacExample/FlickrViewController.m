//
//  FlickrViewController.m
//  MacExample
//
//  Created by John Sheets on 12/24/10.
//  Copyright 2010 MobileMethod, LLC. All rights reserved.
//

#import "FlickrViewController.h"
#import "SampleAPIKey.h"

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
    FFTDebug(@"Closing down operation queue.");
    [_queue release], _queue = nil;
    
    [super dealloc];
}

- (void)loadView
{
    [super loadView];
    
    FFTInfo(@"Loading view");
    
    FFTFlickrSearchOperation *op = [[FFTFlickrSearchOperation alloc] initWithUsername:@"" keyword:@"" apiKey:OBJECTIVE_FLICKR_SAMPLE_API_KEY sharedSecret:OBJECTIVE_FLICKR_SAMPLE_API_SHARED_SECRET];
    op.resultsPerPage = 5;
    
    op.delegate = self;
    [self.queue addOperation:op];
//    [self.queue addOperations:[NSArray arrayWithObject:op] waitUntilFinished:YES];
//    [op main];
    
    FFTDebug(@"Done loading view");
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
