//
//  FFTFileCache.h
//  FringeTools
//
//  Created by John Sheets on 9/27/10.
//  Copyright 2010 FourFringe. All rights reserved.
//

@interface FFTFileCache : NSObject
{
    NSTimeInterval _expirationSeconds;
    NSString *_cacheDirectory;
    NSString *_path;
}

@property (nonatomic) NSTimeInterval expirationSeconds;
@property (nonatomic, copy) NSString *path;
@property (nonatomic, readonly) NSString *cacheDirectory;

- (id)init;
- (id)initWithExpiration:(NSTimeInterval)expirationSeconds;
- (id)initWithPath:(NSString *)path expiration:(NSTimeInterval)expirationSeconds;
- (NSString *)cacheFile:(NSString *)fileName;
- (BOOL)cacheFileExists:(NSString *)fileName;

@end
