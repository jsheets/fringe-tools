//
//  MMFMockObserverTests.m
//  FringeTools-iOS
//
//  Created by John Sheets on 1/22/11.
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

#import "MMFBaseTestCase.h"
#import "MMFMockObserver.h"


#pragma mark -
#pragma mark Fake Class with KVO


@interface FakeThing : NSObject
{
    NSString *_name;
    NSString *_title;
    NSString *_secret;  // You shouldn't trust me with secrets...
}

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *secret;

@end

@implementation FakeThing

@synthesize name = _name;
@synthesize title = _title;
@synthesize secret = _secret;

- (void)dealloc
{
    [_name release], _name = nil;
    [_title release], _title = nil;
    [_secret release], _secret = nil;
    
    [super dealloc];
}

@end


#pragma mark -
#pragma mark Test implementation


@interface MMFMockObserverTests : MMFBaseTestCase
{
    MMFMockObserver *_mock;
    FakeThing *_thing;
}
@end

@implementation MMFMockObserverTests

- (void)setUp
{
    _thing = [[FakeThing alloc] init];
    
    // Observe FakeThing and make sure the mock is tracking KVO access properly.
    // We are listening on all three properties, but for success, only name
    // and title should be called.
    _mock = [[MMFMockObserver alloc] initWithTarget:_thing];
    [_mock expectKeyPath:@"name"];
    [_mock expectKeyPath:@"title"];
    [_mock rejectKeyPath:@"secret"];
}

- (void)tearDown
{
    [_thing release], _thing = nil;
    [_mock release], _mock = nil;
}

- (void)testExpect_All
{
    // Trigger the KVO.
    _thing.name = @"Thing One";
    _thing.title = @"Thingus Prime";
    
    NSString *errorMessage = [_mock checkForError];
    GHAssertNil(errorMessage, @"Error message should still be nil");
}

- (void)testExpect_MissingTitle
{
    // Trigger the KVO.
    _thing.name = @"Thing One";
//    _thing.title = @"Thingus Prime";
    
    NSString *errorMessage = [_mock checkForError];
    [self assertString:errorMessage containsText:@"title" description:@"Error message should complain about missing title"];
    [self assertString:errorMessage doesNotContainText:@"name" description:@"Error message should not complain about name"];
}

- (void)testReject_SecretAssigned
{
    // Trigger the KVO.
    _thing.name = @"Thing One";
    _thing.title = @"Thingus Prime";
    _thing.secret = @"Something freaky is comin'...";
    
    NSString *errorMessage = [_mock checkForError];
    [self assertString:errorMessage containsText:@"secret" description:@"Error message should complain about missing title"];
}

@end
