//
//  MMFFlickrPhoto.h
//  FringeTools-iOS
//
//  Created by John Sheets on 4/10/11.
//  Copyright 2011 MobileMethod, LLC. All rights reserved.
//

#import "MMFPhoto.h"
#import "ObjectiveFlickr.h"

@class MMFFlickrPhoto;

typedef void (^MMFFlickrPhotoCompletionBlock)(MMFFlickrPhoto *photo);
typedef void (^MMFFlickrPhotoFailureBlock)(MMFFlickrPhoto *photo, NSError *error);

@interface MMFFlickrPhoto : MMFPhoto <OFFlickrAPIRequestDelegate>
{
    MMFFlickrPhotoCompletionBlock _completionBlock;
    MMFFlickrPhotoFailureBlock _failureBlock;
    OFFlickrAPIContext *_context;
    NSDictionary *_flickrDictionary;
    NSDictionary *_infoDictionary;
}

@property (nonatomic, readonly) NSDictionary *flickrDictionary;
@property (copy) NSDictionary *infoDictionary;

- (id)initWithFlickrContext:(OFFlickrAPIContext *)context data:(NSDictionary *)flickrDictionary;

- (NSURL *)largeURL;
- (NSURL *)mediumURL;
- (NSURL *)smallURL;

// Look up photo metadata with block.
- (void)fetchPhotoDetail:(MMFFlickrPhotoCompletionBlock)completionBlock failure:(MMFFlickrPhotoFailureBlock)failureBlock;

@end
