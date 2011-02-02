//
//  FFTDownloadURLOperation.m
//  FringeTools
//
//  Created by John Sheets on 9/25/10.
//  Copyright 2010 MobileMethod, LLC. All rights reserved.
//
// MIT License
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <FringeTools/FFTDownloadURLOperation.h>
#import <FringeTools/FFTLogging.h>

@implementation FFTDownloadURLOperation

@synthesize downloadDelegate = _downloadDelegate;
@synthesize url = _url;
@synthesize responseData = _responseData;

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
    _downloadDelegate = nil;
    [_url release], _url = nil;
    [_responseData release], _responseData = nil;
    
    [super dealloc];
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
    
    // Wait until done.
    while (![self isCancelled] && !self.isFinished)
    {
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        [runLoop runMode:[runLoop currentMode] beforeDate:[NSDate distantFuture]];
    }
}


#pragma mark -
#pragma mark URL Delegates


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if ([self checkCancel:connection])
    {
        FFTInfo(@"Canceling before any response received");
        return;
    }
    
    FFTDebug(@"Received response");
    [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if ([self checkCancel:connection])
    {
        FFTInfo(@"Canceling after receiving some data");
        return;
    }
    
    FFTDebug(@"Received %i bytes of data", [data length]);
    [self.responseData appendData:data];
    FFTDebug(@"Total %i bytes of data", [self.responseData length]);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if ([self checkCancel:connection])
    {
        FFTInfo(@"Canceling just before error response");
        return;
    }
    FFTError(@"Error downloading URL: %@", [error localizedDescription]);
    
    // Notify the delegate of our failure.
    [self.downloadDelegate downloadFailedWithError:error];
    
    self.responseData = nil;
    [self completeOperation];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if ([self checkCancel:connection])
    {
        FFTInfo(@"Canceling before response completed");
        return;
    }
    FFTDebug(@"Completed download");
    
    // Notify the delegate of our success!
    [self.downloadDelegate downloadSucceeded:self.responseData];
    
    self.responseData = nil;
    [self completeOperation];
}

@end
