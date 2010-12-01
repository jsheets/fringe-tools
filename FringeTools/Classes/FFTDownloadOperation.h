//
//  FFTDownloadOperation.h
//  FringeTools
//
//  Created by John Sheets on 9/25/10.
//  Copyright 2010 FourFringe. All rights reserved.
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

// Operation to download a a single file.
@interface FFTDownloadOperation : FFTBaseOperation
{
    NSURL *_url;
    NSMutableData *_responseData;
    
    id _target;
    SEL _didFailSelector;
    SEL _didLoadSelector;
}

@property (nonatomic, copy) NSURL *url;
@property (nonatomic, retain) NSMutableData *responseData;
@property (nonatomic, retain) id target;
@property (nonatomic) SEL didFailSelector;
@property (nonatomic) SEL didLoadSelector;

- (id)initWithURL:(NSURL *)url;
- (BOOL)checkCancel:(NSURLConnection *)connection;

@end
