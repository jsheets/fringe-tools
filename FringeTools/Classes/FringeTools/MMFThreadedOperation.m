//
//  MMFThreadedOperation.m
//  FringeTools-iOS
//
//  Created by John Sheets on 1/23/11.
//  Copyright 2011 MobileMethod, LLC. All rights reserved.
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

#import <FringeTools/MMFThreadedOperation.h>
#import <FringeTools/MMFLogging.h>

@implementation MMFThreadedOperation

- (BOOL)isConcurrent
{
    MMFTrace(@"Op is concurrent, and should create its own thread.");
    return YES;
}

// Kick of asynchronous operation. Runs this then waits until the operation completes
// or times out.
- (void)startOperation
{
    MMFError(@"Performing empty concurrent operation; you should overload startOperation in your subclass!");
    [self completeOperation];
}

- (BOOL)timeExpired
{
    // TODO: Set a default timeout.
    return NO;
}

- (void)performOperation
{
    [self startOperation];
    MMFInfo(@"Threaded %@ operation started; polling run loop until completed", [self class]);
    
    // Wait until done.
    while (!self.timeExpired && ![self isCancelled] && !self.isFinished)
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
}

// Only for concurrent operations (explicitly create our own thread).
-(void)start
{
    [self execute];
    [self completeOperation];
}

@end
