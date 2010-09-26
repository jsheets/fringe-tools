//
//  BaseOperation.m
//  FringeTools
//
//  Created by John Sheets on 9/25/10.
//  Copyright 2010 FourFringe. All rights reserved.
//

#import "FFTBaseOperation.h"
#import "FFTGlobal.h"

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

-(void) start
{
    if (_finished || [self isCancelled])
    {
        [self completeOperation];
        return;
    }
    
    [self updateExecuting:YES];
    [self performOperation];
}

- (void)completeOperation
{
    [self updateExecuting:NO];
    [self updateFinished:YES];
}

- (void)performOperation
{
    FFTError(@"ERROR: Should implement performOperation in subclass!!");
}

// Call -main to run the operation directly.  For synchronous ops.
// Queue always calls -start.
- (void)main
{
    if (_finished || [self isCancelled]) return;
    
    @try
    {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        
        // Main Loop.
        [self updateExecuting:YES];
        [self performOperation];
        [self completeOperation];
        
        [pool release];
    }
    @catch (NSException *e)
    {
        FFTError(@"FATAL ERROR in operation: %@", e);
    }
}

@end
