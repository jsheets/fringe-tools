//
//  FFTBaseTestCase.m
//  FringeTools-iOS
//
//  Created by John Sheets on 1/14/11.
//  Copyright 2011 MobileMethod, LLC. All rights reserved.
//

#import "FFTBaseTestCase.h"

@implementation FFTBaseTestCase

@synthesize queue = _queue;

- (void)dealloc
{
    [_queue release], _queue = nil;
    
    [super dealloc];
}


#pragma mark -
#pragma mark String Assertions


- (void)assertString:(NSString *)string containsText:(NSString *)fragment description:(NSString *)description
{
    GHAssertNotNil(string, @"String should not be nil");
    NSInteger index = [string rangeOfString:fragment].location;
    GHAssertTrue(index != NSNotFound, @"Should find '%@' in string '%@'", fragment, string);
}

- (void)assertString:(NSString *)string doesNotContainText:(NSString *)fragment description:(NSString *)description
{
    GHAssertNotNil(string, @"String should not be nil");
    NSInteger index = [string rangeOfString:fragment].location;
    GHAssertTrue(index == NSNotFound, @"Should not find '%@' in string '%@'", fragment, string);
}


#pragma mark Array Assertions


- (void)assertArray:(NSArray *)array hasCount:(NSInteger)count description:(NSString *)description
{
    GHAssertEquals((NSInteger)[array count], (NSInteger)count, @"Array %@ count", description);
}

- (void)assertArray:(NSArray *)array containsObject:(id)object atIndex:(NSInteger)index description:(NSString *)description
{
    if ([object isKindOfClass:[NSString class]])
    {
        // If objct is a string, use the more informative comparison here.
        GHAssertEqualStrings([array objectAtIndex:index], (NSString *)object,
                             @"Array %@ should match string at index %i", description, index);
    }
    else
    {
        GHAssertEquals([array objectAtIndex:index], object,
                       @"Array %@ should match object at index %i", description, index);
    }
}

- (void)assertArray:(NSArray *)array hasOnlyClass:(Class)elementClass description:(NSString *)description
{
    GHAssertNotNil(array, @"%@ array should not be nil", description);
    for (int i = 0; i < [array count]; i++)
    {
        id element = [array objectAtIndex:i];
        GHAssertEquals([element class], [elementClass class], @"%@ object %i should be a %@ object", description, i, elementClass);
    }
}


#pragma mark File Assertions


// Generate a unique /tmp file but don't create the file yet.
// http://cocoawithlove.com/2009/07/temporary-files-and-folders-in-cocoa.html
- (NSString *)tempFile
{
    NSString *tempFileTemplate = [NSTemporaryDirectory() stringByAppendingPathComponent:@"fringetools.test.XXXXXX"];
    
    const char *tempFileTemplateCString = [tempFileTemplate fileSystemRepresentation];
    char *tempFileNameCString = (char *)malloc(strlen(tempFileTemplateCString) + 1);
    strcpy(tempFileNameCString, tempFileTemplateCString);
    mktemp(tempFileNameCString);
    
    NSString *tempFileName =[[NSFileManager defaultManager]
                             stringWithFileSystemRepresentation:tempFileNameCString
                             length:strlen(tempFileNameCString)];
    free(tempFileNameCString);
    
    FFTInfo(@"Created log file: %@", tempFileName);
    return tempFileName;
}


- (void)assertFile:(NSString *)filePath exists:(BOOL)fileExists description:(NSString *)description
{
    BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    if (fileExists)
    {
        GHAssertTrue(exists, @"%@ (File should exist: %@)", description, filePath);
    }
    else
    {
        GHAssertFalse(exists, @"%@ (File should not exist: %@)", description, filePath);
    }
}

- (void)assertFile:(NSString *)filePath contains:(BOOL)shouldContain searchText:(NSString *)text description:(NSString *)description
{
    NSString *contents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    NSInteger index = [contents rangeOfString:text].location;
    if (shouldContain)
    {
        GHAssertTrue(index != NSNotFound, @"%@ (Should find '%@' in log file %@)", description, text, filePath);
    }
    else
    {
        GHAssertEquals(index, (NSInteger)NSNotFound,
                       @"%@ (Should not find '%@' in log file %@)", description, text, filePath);
    }
}


#pragma mark Resource Helpers


- (NSURL *)urlForResource:(NSString *)resourceName extension:(NSString *)extension
{
    NSURL *url = [[NSBundle mainBundle] URLForResource:resourceName withExtension:extension];
    GHAssertNotNil(url, @"Should find %@.%@ in app bundle", resourceName, extension);
    
    return url;
}

- (NSData *)loadResource:(NSString *)resourceName extension:(NSString *)extension
{
    NSURL *url = [self urlForResource:resourceName extension:extension];
    
    NSError *error = nil;
    NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
    GHAssertNil(error, @"Should not throw error on resource data load: %@", [error localizedDescription]);
    GHAssertNotNil(data, @"Resource data should not be nil");
    
    return data;
}

- (NSString *)loadStringResource:(NSString *)resourceName extension:(NSString *)extension
{
    NSURL *url = [self urlForResource:resourceName extension:extension];
    
    NSError *error = nil;
    NSString *string = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    GHAssertNil(error, @"Should not throw error on resource string data load: %@", [error localizedDescription]);
    GHAssertNotNil(string, @"Resource string data should not be nil");
    
    return string;
}


#pragma mark Asynchronous Operations


- (NSOperationQueue *)queue
{
    if (_queue == nil)
    {
        _queue = [[NSOperationQueue alloc] init];
    }
    
    return _queue;
}

- (void)runSynchronousOperation:(NSOperation *)op
{
    [self.queue addOperations:[NSArray arrayWithObject:op] waitUntilFinished:YES];
}


@end
