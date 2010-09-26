//
//  WebCacheOperation.m
//  FringeTools
//
//  Created by John Sheets on 9/25/10.
//  Copyright 2010 FourFringe. All rights reserved.
//

#import "FFTDownloadOperation.h"
#import "FFTGlobal.h"

@implementation FFTDownloadOperation

@synthesize url = _url;
@synthesize responseData = _responseData;
@synthesize target = _target;
@synthesize didFailSelector = _didFailSelector;
@synthesize didLoadSelector = _didLoadSelector;

- (id)initWithURL:(NSURL *)url
{	
    if ((self = [super init]))
    {
        // Initialization.
        self.url = url;
        self.responseData = [NSMutableData dataWithLength:0];
    }
    
    return self;
}

- (void)dealloc
{
    [_url release], _url = nil;
    [_responseData release], _responseData = nil;
    [_target release], _target = nil;
    
    [super dealloc];
}

- (BOOL)isConcurrent
{
    // Create our own thread, via NSURLConnection.
    return YES;
}

// Catch for cancelled operation and bail out of download if so.
- (BOOL)checkCancel:(NSURLConnection *)connection
{
    if ([self isCancelled])
    {
        FFTDebug(@"Bailing out of cancelled download operation");
        [connection cancel];
        [self completeOperation];
        return YES;
    }
    return NO;
}

- (void)performOperation
{
    FFTDebug(@"Downloading URL: %@", self.url);
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:self.url];
    [NSURLConnection connectionWithRequest:urlRequest delegate:self];
}


#pragma mark -
#pragma mark URL Delegates


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if ([self checkCancel:connection]) { return; }
    
    [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if ([self checkCancel:connection]) { return; }
    
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if ([self checkCancel:connection]) { return; }
    
    if (self.didFailSelector && [self.target respondsToSelector:self.didFailSelector])
    {
        [self.target performSelector:self.didFailSelector withObject:error];
    }
    
    self.responseData = nil;
    [self completeOperation];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if ([self checkCancel:connection]) { return; }
    
    if (self.didLoadSelector && [self.target respondsToSelector:self.didLoadSelector])
    {
        [self.target performSelector:self.didLoadSelector withObject:self.responseData];
    }
    
    self.responseData = nil;
    [self completeOperation];
}

@end
