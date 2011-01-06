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

#import "FFTBaseOperation.h"
#import "FFTLogging.h"

@implementation FFTBaseOperation

- (id)init
{	
    if ((self = [super init]))
    {
        // Initialization.
        _executing = NO;
        _finished = NO;
    }
    
    return self;
}

- (BOOL)isConcurrent
{
    // Let NSOperationQueue create the thread for us.
    FFTTrace(@"Op is not concurrent.");
    return NO;
}

- (BOOL)isExecuting
{
    return _executing;
}

- (BOOL)isFinished
{
    return _finished;
}

- (void)updateFinished:(BOOL)finished
{
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
}

- (void)updateExecuting:(BOOL)executing
{
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
}

-(void)start
{
    if (![NSThread isMainThread])
    {
        [self performSelectorOnMainThread:@selector(start) withObject:nil waitUntilDone:NO];
        return;
    }
    
    FFTDebug(@"Starting %@ operation", [self class]);
    if (_finished || [self isCancelled])
    {
        [self completeOperation];
        return;
    }
    
    FFTTrace(@"Starting execution");
    [self updateExecuting:YES];
    FFTTrace(@"Performing Operation");
    [self performOperation];
    [self completeOperation];
    FFTTrace(@"Operation Completed");
}

- (void)completeOperation
{
    FFTDebug(@"Completing %@ operation", [self class]);
    [self updateExecuting:NO];
    [self updateFinished:YES];
}

- (void)performOperation
{
    FFTError(@"ERROR: Should implement performOperation in subclass");
}

// Call -main to run the operation directly.  For synchronous ops.
// Queue always calls -start.
- (void)main
{
    if (![NSThread isMainThread])
    {
        [self performSelectorOnMainThread:@selector(main) withObject:nil waitUntilDone:NO];
        return;
    }
    
    FFTDebug(@"Starting %@ operation", [self class]);
    if (_finished || [self isCancelled])
    {
        [self completeOperation];
        return;
    }
    
    @try
    {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        
        // Main Loop.
        FFTTrace(@"Starting execution");
        [self updateExecuting:YES];
        FFTTrace(@"Performing Operation");
        [self performOperation];
        [self completeOperation];
        FFTTrace(@"Operation Completed");
        
        [pool release];
    }
    @catch (NSException *e)
    {
        FFTError(@"FATAL ERROR in operation: %@", e);
    }
}

@end
