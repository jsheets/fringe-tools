//
//  FFTBaseOperationTests.m
//  FringeTools-iOS
//
//  Created by John Sheets on 1/14/11.
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

#import "FFTBaseTestCase.h"
#import "FFTMockObserver.h"


#pragma mark -
#pragma mark Fake Operation Class


@interface FakeOperation : FFTBaseOperation
{
    BOOL _ranOp;
}
@property (nonatomic, getter=isRanOp) BOOL ranOp;
@end

@implementation FakeOperation

@synthesize ranOp = _ranOp;

- (void)performOperation
{
    self.ranOp = YES;
}

@end


#pragma mark -
#pragma mark Tests


@interface FFTBaseOperationTests : FFTBaseTestCase
{
    FakeOperation *_op;
}
@end


@implementation FFTBaseOperationTests

- (void)setUp
{
    [super setUp];
    
    _op = [[FakeOperation alloc] init];
}

- (void)tearDown
{
    [super tearDown];
    
    [_op release], _op = nil;
}

- (void)testKVO
{
    FFTMockObserver *mock = [[[FFTMockObserver alloc] initWithTarget:_op] autorelease];
    [mock expectKeyPath:@"isFinished"];
    [mock expectKeyPath:@"isExecuting"];
    
    [_op completeOperation];
    
    NSString *errorMessage = [mock checkForError];
    GHAssertNil(errorMessage, @"Should have received all KVO notifications: %@", errorMessage);
}

- (void)testExecute_Pass
{
    GHAssertFalse(_op.isExecuting, @"Should not set isExecuting before execute");
    GHAssertFalse(_op.isFinished, @"Should not set isFinished before execute");
    GHAssertFalse(_op.ranOp, @"Should not have run op before execute");
    
    [_op execute];
    
    GHAssertTrue(_op.isExecuting, @"Should set isExecuting after execute");
    GHAssertTrue(_op.ranOp, @"Should run op after execute");
}

- (void)testExecute_EarlyFinish
{
    _op.isFinished = YES;
    [_op execute];
    
    GHAssertFalse(_op.isExecuting, @"Should skip setting isExecuting if finished early");
    GHAssertFalse(_op.ranOp, @"Should skip performOperation if finished early");
}

- (void)testExecute_EarlyCancel
{
    [_op cancel];
    [_op execute];
    
    GHAssertFalse(_op.isExecuting, @"Should skip setting isExecuting if canceled");
    GHAssertFalse(_op.ranOp, @"Should skip performOperation if canceled");
}

- (void)testQueue
{
    NSOperationQueue *queue = [[[NSOperationQueue alloc] init] autorelease];
    [queue addOperation:_op];
    [queue waitUntilAllOperationsAreFinished];
    
    GHAssertFalse(_op.isExecuting, @"Should set isExecuting");
    GHAssertTrue(_op.isFinished, @"Should set isFinished");
    GHAssertTrue(_op.ranOp, @"Should run op");
}

@end
