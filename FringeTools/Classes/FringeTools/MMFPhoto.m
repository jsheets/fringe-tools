//
//  MMFPhoto.m
//  FringeTools-iOS
//
//  Created by John Sheets on 7/23/11.
//  Copyright 2011 MobileMethod, LLC. All rights reserved.
//

#import "MMFPhoto.h"

@implementation MMFPhoto

@synthesize photoId = _photoId;
@synthesize title = _title;
@synthesize author = _author;
@synthesize description = _description;
@synthesize photoURL = _photoURL;
@synthesize thumbnailURL = _thumbnailURL;

- (id)init
{
    if ((self = [super init]))
    {
        // Initialization.
        
    }
    
    return self;
}

- (void)dealloc
{
    [_photoId release], _photoId = nil;
    [_title release], _title = nil;
    [_author release], _author = nil;
    [_description release], _description = nil;
    [_photoURL release], _photoURL = nil;
    [_thumbnailURL release], _thumbnailURL = nil;
    
    [super dealloc];
}

@end
