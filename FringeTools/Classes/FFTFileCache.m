//
//  FFTFileCache.m
//  FringeTools
//
//  Created by John Sheets on 9/27/10.
//  Copyright 2010 FourFringe. All rights reserved.
//

#import "FFTFileCache.h"

@implementation FFTFileCache

@synthesize expirationSeconds = _expirationSeconds;
@synthesize path = _path;


#pragma mark -
#pragma mark Lifecycle


// Initialize cache with 10 minute expiration.
- (id)init
{
    return [self initWithPath:nil expiration:10 * 60];
}

- (id)initWithExpiration:(NSTimeInterval)expirationSeconds
{
    return [self initWithPath:nil expiration:expirationSeconds];
}

- (id)initWithPath:(NSString *)path expiration:(NSTimeInterval)expirationSeconds
{	
    if ((self = [super init]))
    {
        // Initialization.
        self.path = path;
        _expirationSeconds = expirationSeconds;
    }
    
    return self;
}


- (void)dealloc
{
    [_cacheDirectory release], _cacheDirectory = nil;
    [_path release], _path = nil;
    
    [super dealloc];
}


#pragma mark -
#pragma mark Cache Operations


- (NSString *)cacheDirectory
{
    if (_cacheDirectory == nil)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        if ([paths count] == 0)
        {
            return nil;
        }
        
        NSString *basePath = [paths objectAtIndex:0];
        _cacheDirectory = (_path == nil) ? basePath : [basePath stringByAppendingPathComponent:_path];
        [_cacheDirectory retain];
    }
    
    return _cacheDirectory;
}

- (NSString *)cacheFile:(NSString *)fileName
{
    return [NSString stringWithFormat:@"%@/%@", self.cacheDirectory, fileName];
}

- (BOOL)cacheFileExists:(NSString *)fileName
{
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    NSString *cacheFile = [self cacheFile:fileName];
    if (![fileMgr fileExistsAtPath:cacheFile])
    {
        return NO;
    }
    
    NSTimeInterval span = _expirationSeconds;  // Fall back on "expired" if no file info below.
    
    // Check date stamp and if the cached file is too old, pretend it doesn't
    // really exist.
    NSDictionary *attr = [fileMgr attributesOfItemAtPath:cacheFile error:NULL];
    NSDate *timeStamp = [attr objectForKey:NSFileCreationDate];
    if (timeStamp)
    {
        span = [[NSDate date] timeIntervalSinceDate:timeStamp];
    }
    
    return (span < _expirationSeconds);
}

@end
