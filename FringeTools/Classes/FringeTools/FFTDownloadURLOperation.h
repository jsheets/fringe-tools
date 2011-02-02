//
//  FFTDownloadOperation.h
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

#import <FringeTools/FFTThreadedOperation.h>
#import <FringeTools/FFTDownloadDelegate.h>

// Operation to download a a single file from a URL.
@interface FFTDownloadURLOperation : FFTThreadedOperation
{
    id<FFTDownloadDelegate> _downloadDelegate;
    
    NSURL *_url;
    NSMutableData *_responseData;
}

@property (nonatomic, assign) id<FFTDownloadDelegate> downloadDelegate;
@property (nonatomic, copy) NSURL *url;
@property (nonatomic, retain) NSMutableData *responseData;

- (id)initWithURL:(NSURL *)url;

@end
