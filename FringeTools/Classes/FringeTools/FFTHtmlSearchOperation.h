//
//  MMQSearchHtml.h
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

#import <libxml/HTMLParser.h>
#import <libxml/xpath.h>

#import <FringeTools/FFTBaseOperation.h>
#import <FringeTools/FFTDownloadDelegate.h>

@interface FFTHtmlSearchOperation : FFTBaseOperation
{
    id<FFTDownloadDelegate> _delegate;
    
    NSString *_nextPageXpath;
    NSString *_photoBaseXpath;
    NSDictionary *_urlMap;
    NSString *_defaultUrlRoot;
    NSArray *_validFileExtensions;
    
    NSURL *_pageUrl;
    NSString *_currentPage;
    NSString *_nextPage;
    
    // The URL currently downloading; refers to responseData.
    NSString *_currentLoadingUrl;
    
    // Image data for a single download at a time.
    NSMutableData *_responseData;
}

@property (nonatomic, assign) id<FFTDownloadDelegate> delegate;

@property (nonatomic, copy) NSString *nextPageXpath;
@property (nonatomic, copy) NSString *photoBaseXpath;
@property (nonatomic, copy) NSDictionary *urlMap;
@property (nonatomic, copy) NSString *defaultUrlRoot;
@property (nonatomic, copy) NSArray *validFileExtensions;
@property (nonatomic, copy) NSURL *pageUrl;
@property (nonatomic, copy) NSString *currentPage;
@property (nonatomic, copy) NSString *nextPage;
@property (nonatomic, copy) NSString *currentLoadingUrl;
@property (nonatomic, copy) NSMutableData *responseData;

- (NSURL*)xmlFindNextPage:(htmlDocPtr)doc;
- (NSMutableArray*)xmlLoadUrls:(NSURL*)page;

@end
