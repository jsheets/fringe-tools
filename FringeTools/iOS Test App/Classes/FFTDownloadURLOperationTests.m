//
//  FFTDownloadURLOperationTests.m
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

@interface FFTDownloadURLOperationTests : FFTBaseTestCase {}
@end


@implementation FFTDownloadURLOperationTests

- (NSURL *)localFileUrl:(NSString *)fileName
{
    return [[NSBundle mainBundle] URLForResource:fileName withExtension:@"txt"];
}

- (FFTDownloadURLOperation *)downloadUrl:(NSURL *)url
{
    FFTDebug(@"Downloading local file: %@", url);
    FFTDownloadURLOperation *op = [[FFTDownloadURLOperation alloc] initWithURL:url];
    [self runSynchronousOperation:op];
    
    return op;
}

- (void)testDownloadLocalFile
{
    NSURL *url = [self localFileUrl:@"test-data"];
    FFTDownloadURLOperation *op = [self downloadUrl:url];
    
    GHAssertNotNil(op.responseData, @"Response data should not be nil");
    GHAssertEquals((NSInteger)[op.responseData length], (NSInteger)10, @"Response data should be the full length");
    NSString *downloadedContent = [[NSString alloc] initWithData:op.responseData encoding:NSUTF8StringEncoding];
    NSString *actualContent = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:NULL];
    GHAssertEqualStrings(downloadedContent, actualContent, @"Downloaded content should match real content");
}

- (void)testNoFileExists
{
    // <#methodbody#>
}

- (void)testTimeout
{
    // <#methodbody#>
}

- (void)testCancel
{
    // <#methodbody#>
}

- (void)testHostError
{
    // <#methodbody#>
}


@end
