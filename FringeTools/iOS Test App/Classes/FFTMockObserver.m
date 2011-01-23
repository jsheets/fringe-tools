//
//  FFTMockObserver.m
//  FringeTools-iOS
//
//  Created by John Sheets on 1/16/11.
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

#import "FFTMockObserver.h"

@implementation FFTMockObserver

@synthesize goodKeyPaths = _goodKeyPaths;
@synthesize badKeyPaths = _badKeyPaths;
@synthesize foundKeyPaths = _foundKeyPaths;

- (id)init
{
    if ((self = [super init]))
    {
        // Initialization.
        _goodKeyPaths = [[NSMutableArray  alloc] init];
        _badKeyPaths = [[NSMutableArray  alloc] init];
        _foundKeyPaths = [[NSMutableArray  alloc] init];
    }
    
    return self;
}

- (void)dealloc
{
    [_goodKeyPaths release], _goodKeyPaths = nil;
    [_badKeyPaths release], _badKeyPaths = nil;
    [_foundKeyPaths release], _foundKeyPaths = nil;
    
    [super dealloc];
}


- (void)expectKeyPath:(NSString *)keyPath
{
    [self.goodKeyPaths addObject:keyPath];
}

- (void)rejectKeyPath:(NSString *)keyPath
{
    [self.badKeyPaths addObject:keyPath];
}

- (BOOL)checkForError:(NSString **)returnErrorString
{
    NSMutableArray *errors = [NSMutableArray array];
    
    // Make sure we got all keypaths we expected.
    for (NSString *keyPath in self.goodKeyPaths)
    {
        if (![self.foundKeyPaths containsObject:keyPath])
        {
            [errors addObject:[NSString stringWithFormat:@"Failed to set KVO property '%@'", keyPath]];
        }
    }
    
    // Make sure we didn't get any keypaths we rejected.
    for (NSString *keyPath in self.badKeyPaths)
    {
        if ([self.foundKeyPaths containsObject:keyPath])
        {
            [errors addObject:[NSString stringWithFormat:@"Wrongly set KVO property '%@'", keyPath]];
        }
    }
    
    BOOL success = ([errors count] == 0);
    
    if (!success && returnErrorString)
    {
        *returnErrorString = [errors componentsJoinedByString:@", "];
        FFTDebug(@"Returning error string: %@", *returnErrorString);
    }
    
    return !success;
}

- (void)clearResults
{
    [self.foundKeyPaths removeAllObjects];
}

-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary *)change
                      context:(void *)context
{
    FFTInfo(@"Observed keyPath: %@", keyPath);
    [self.foundKeyPaths addObject:keyPath];
}

@end
