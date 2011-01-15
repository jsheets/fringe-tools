//
//  FFTBaseTestCase.h
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

@interface FFTBaseTestCase : GHTestCase
{
    NSOperationQueue *_queue;
}

@property (nonatomic, readonly) NSOperationQueue *queue;

- (void)assertString:(NSString *)string containsText:(NSString *)fragment description:(NSString *)description;
- (void)assertString:(NSString *)string doesNotContainText:(NSString *)fragment description:(NSString *)description;

- (void)assertArray:(NSArray *)array hasCount:(NSInteger)count description:(NSString *)description;
- (void)assertArray:(NSArray *)array containsObject:(id)object atIndex:(NSInteger)index description:(NSString *)description;
- (void)assertArray:(NSArray *)array hasOnlyClass:(Class)elementClass description:(NSString *)description;

- (NSString *)tempFile;
- (void)assertFile:(NSString *)filePath exists:(BOOL)fileExists description:(NSString *)description;
- (void)assertFile:(NSString *)filePath contains:(BOOL)shouldContain searchText:(NSString *)text description:(NSString *)description;

- (NSURL *)urlForResource:(NSString *)resourceName extension:(NSString *)extension;
- (NSData *)loadResource:(NSString *)resourceName extension:(NSString *)extension;
- (NSString *)loadStringResource:(NSString *)resourceName extension:(NSString *)extension;

- (void)runSynchronousOperation:(NSOperation *)op;

@end
