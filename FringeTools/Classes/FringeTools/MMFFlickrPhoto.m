//
//  MMFFlickrPhoto.m
//  FringeTools-iOS
//
//  Created by John Sheets on 4/10/11.
//  Copyright 2011 MobileMethod, LLC. All rights reserved.
//

#import <FringeTools/MMFFlickrPhoto.h>
#import <FringeTools/MMFLogging.h>


@implementation MMFFlickrPhoto

@synthesize flickrDictionary = _flickrDictionary;
@synthesize infoDictionary = _infoDictionary;

- (id)initWithFlickrContext:(OFFlickrAPIContext *)context data:(NSDictionary *)flickrDictionary
{
    if ((self = [super init]))
    {
        // Initialization.
        _context = [context retain];
        _flickrDictionary = [flickrDictionary retain];
        
        // Populate the default MMFPhoto properties from the Flickr metadata.
        self.photoId = [self.flickrDictionary objectForKey:@"id"];
        self.title = [self.flickrDictionary objectForKey:@"title"];
        self.photoURL = [_context photoSourceURLFromDictionary:_flickrDictionary size:OFFlickrMediumSize];
        self.thumbnailURL = [_context photoSourceURLFromDictionary:_flickrDictionary size:OFFlickrThumbnailSize];
    }
    
    return self;
}

- (void)dealloc
{
    [_completionBlock release], _completionBlock = nil;
    [_context release], _context = nil;
    [_flickrDictionary release], _flickrDictionary = nil;
    [_infoDictionary release], _infoDictionary = nil;
      
    [super dealloc];
}

- (NSURL *)largeURL
{
    return [_context photoSourceURLFromDictionary:_flickrDictionary size:OFFlickrLargeSize];
}

- (NSURL *)mediumURL
{
    return [_context photoSourceURLFromDictionary:_flickrDictionary size:OFFlickrMediumSize];
}

- (NSURL *)smallURL
{
    return [_context photoSourceURLFromDictionary:_flickrDictionary size:OFFlickrSmallSize];
}

- (void)fetchPhotoDetail:(MMFFlickrPhotoCompletionBlock)completionBlock failure:(MMFFlickrPhotoFailureBlock)failureBlock
{
    if (_completionBlock)
    {
        MMFDebug(@"Photo detail fetch already in progress, skipping...");
        return;
    }
    
    // Send async request to fetch full metadata for this Flickr photo, then call completion
    // block when done.
    _completionBlock = [completionBlock copy];
    _failureBlock = [failureBlock copy];
    
    OFFlickrAPIRequest *request = [[OFFlickrAPIRequest alloc] initWithAPIContext:_context];
    [request setDelegate:self];
    NSDictionary *args = [NSDictionary dictionaryWithObjectsAndKeys:self.photoId, @"photo_id", nil];
    MMFDebug(@"Sending Flickr request for photo data (flickr.photos.getinfo): %@", args);
    MMFDebug(@"Flickr search args: %@", args);
    [request callAPIMethodWithGET:@"flickr.photos.getinfo" arguments:args];
    
    // Now it goes async from here and notifies the delegate methods when completed.
}


#pragma mark Flickr Protocol


- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest
 didCompleteWithResponse:(NSDictionary *)inResponseDictionary
{
    MMFTrace(@"Photo detail response dictionary: %@", inResponseDictionary);
    MMFInfo(@"Completed photo detail request");
    self.infoDictionary = inResponseDictionary;
    
    // Fire completion block on main thread.
    dispatch_async(dispatch_get_main_queue(), ^{
        _completionBlock(self);
    });
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest
        didFailWithError:(NSError *)inError
{
    MMFError(@"FLICKR ERROR: failed request %@", inError);
    
    // Fire failure block on main thread.
    dispatch_async(dispatch_get_main_queue(), ^{
        _failureBlock(self, inError);
    });
}

@end
