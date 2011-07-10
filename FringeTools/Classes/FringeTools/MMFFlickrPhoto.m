//
//  MMFFlickrPhoto.m
//  FringeTools-iOS
//
//  Created by John Sheets on 4/10/11.
//  Copyright 2011 MobileMethod, LLC. All rights reserved.
//

#import "MMFFlickrPhoto.h"

@implementation MMFFlickrPhoto

@synthesize flickrDictionary = _flickrDictionary;

- (id)initWithFlickrContext:(OFFlickrAPIContext *)context data:(NSDictionary *)flickrDictionary
{
    if ((self = [super init]))
    {
        // Initialization.
        _context = context;
        _flickrDictionary = [flickrDictionary retain];
    }
    
    return self;
}

- (NSString *)title
{
    return [self.flickrDictionary objectForKey:@"title"];
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

- (NSURL *)thumbnailURL
{
    return [_context photoSourceURLFromDictionary:_flickrDictionary size:OFFlickrThumbnailSize];
}

@end
