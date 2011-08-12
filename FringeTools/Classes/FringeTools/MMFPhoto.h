//
//  MMFPhoto.h
//  FringeTools-iOS
//
//  Created by John Sheets on 7/23/11.
//  Copyright 2011 MobileMethod, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMFPhoto : NSObject
{
    NSString *_photoId;
    NSString *_title;
    NSString *_author;
    NSString *_story;
    
    NSURL *_photoURL;
    NSURL *_thumbnailURL;
}

@property (nonatomic, copy) NSString *photoId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *story;
@property (nonatomic, copy) NSURL *photoURL;
@property (nonatomic, copy) NSURL *thumbnailURL;

@end
