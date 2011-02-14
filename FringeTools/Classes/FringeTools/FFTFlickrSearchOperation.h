//
//  MMQSearchFlickr.h
//  PhotoFrame
//
//  Created by John Sheets on 12/6/09.
//  Copyright 2009 MobileMethod, LLC. All rights reserved.
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

#import "ObjectiveFlickr.h"

#import <FringeTools/FFTThreadedOperation.h>
#import <FringeTools/FFTURLSearchDelegate.h>

@interface FFTFlickrSearchOperation : FFTThreadedOperation <OFFlickrAPIRequestDelegate>
{
    id<FFTURLSearchDelegate> _downloadDelegate;
    
    OFFlickrAPIContext *_context;
    OFFlickrAPIRequest *_request;
    NSString *_username;
    NSString *_keyword;
    NSString *_searchText;
    NSArray *_searchWords;
    NSInteger _resultsPerPage;
}

@property (nonatomic, assign) id<FFTURLSearchDelegate> downloadDelegate;

@property (nonatomic, retain) OFFlickrAPIContext *context;
@property (nonatomic, retain) OFFlickrAPIRequest *request;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *keyword;
@property (nonatomic, copy) NSString *searchText;
@property (nonatomic, copy) NSArray *searchWords;
@property (nonatomic) NSInteger resultsPerPage;

- (id)initWithUsername:(NSString*)username
               keyword:(NSString*)keyword
                apiKey:(NSString *)flickrApiKey
          sharedSecret:(NSString *)flickrSharedSecret;

@end
