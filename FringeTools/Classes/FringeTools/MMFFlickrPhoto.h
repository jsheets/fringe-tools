//
//  MMFFlickrPhoto.h
//  FringeTools-iOS
//
//  Created by John Sheets on 4/10/11.
//  Copyright 2011 MobileMethod, LLC. All rights reserved.
//

#import "ObjectiveFlickr.h"

@interface MMFFlickrPhoto : NSObject
{
    OFFlickrAPIContext *_context;
    NSDictionary *_flickrDictionary;
}

@property (nonatomic, readonly) NSDictionary *flickrDictionary;

- (id)initWithFlickrContext:(OFFlickrAPIContext *)context data:(NSDictionary *)flickrDictionary;
- (NSString *)title;
- (NSURL *)largeURL;
- (NSURL *)mediumURL;
- (NSURL *)smallURL;
- (NSURL *)thumbnailURL;

@end
