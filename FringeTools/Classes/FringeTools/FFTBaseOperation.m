//
//  BaseOperation.m
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

#import <FringeTools/FFTBaseOperation.h>
#import <FringeTools/FFTLogging.h>

@implementation FFTBaseOperation

@synthesize isExecuting = _isExecuting;
@synthesize isFinished = _isFinished;

- (id)init
{	
    if ((self = [super init]))
    {
        // Initialization.
        _isExecuting = NO;
        _isFinished = NO;
    }
    
    return self;
}

- (void)setIsExecuting:(BOOL)executing
{
    [self willChangeValueForKey:@"isExecuting"];
    _isExecuting = executing;
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)setIsFinished:(BOOL)finished
{
    [self willChangeValueForKey:@"isFinished"];
    _isFinished = finished;
    [self didChangeValueForKey:@"isFinished"];
}

- (void)completeOperation
{
    FFTDebug(@"Completing %@ operation", [self class]);
    self.isExecuting = NO;
    self.isFinished = YES;
}

- (void)performOperation
{
    FFTError(@"ERROR: Should implement performOperation in subclass");
}

- (void)execute
{
    FFTDebug(@"Starting %@ operation", [self class]);
    if (![self isFinished] && ![self isCancelled])
    {
        @try
        {
            // Wrap in autorelease pool in case called from a thread.
            NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
            
            // Main Loop.
            FFTTrace(@"Starting execution");
            self.isExecuting = YES;
            FFTTrace(@"Performing Operation");
            [self performOperation];
            
            [pool release];
        }
        @catch (NSException *e)
        {
            FFTError(@"FATAL ERROR in operation: %@", e);
        }
    }
}

- (BOOL)isConcurrent
{
    // Always let NSOperationQueue create the thread for us. Returning NO here
    // Will keep 10.5 behavior similar to 10.6 behavior.
    FFTTrace(@"Op is not concurrent.");
    return NO;
}

// Call -main to run the operation directly.  For synchronous ops.
- (void)main
{
    if (![NSThread isMainThread])
    {
        [self performSelectorOnMainThread:@selector(main) withObject:nil waitUntilDone:NO];
        return;
    }
    
    [self execute];
    [self completeOperation];
}

@end
