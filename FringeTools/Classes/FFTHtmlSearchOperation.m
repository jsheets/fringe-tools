//
//  MMQSearchHtml.m
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

#import "FFTHtmlSearchOperation.h"
#import "FFTLogging.h"

//#define MIN_IMAGE_COUNT 200
#define MIN_IMAGE_COUNT 50
//#define MIN_IMAGE_COUNT 25
#define MAX_PAGE_COUNT 15

@implementation FFTHtmlSearchOperation

static NSString *kNoMorePagesFound = @"<END_OF_PAGES>";

@synthesize delegate = _delegate;
@synthesize nextPageXpath = _nextPageXpath;
@synthesize photoBaseXpath = _photoBaseXpath;
@synthesize urlMap = _urlMap;
@synthesize defaultUrlRoot = _defaultUrlRoot;
@synthesize validFileExtensions = _validFileExtensions;
@synthesize pageUrl = _pageUrl;
@synthesize currentPage = _currentPage;
@synthesize nextPage = _nextPage;
@synthesize currentLoadingUrl = _currentLoadingUrl;
@synthesize responseData = _responseData;

- (id)init
{	
    if ((self = [super init]))
    {
        // Initialization.
        self.urlMap = [NSDictionary dictionary];
        
        // Default to common image files.
        self.validFileExtensions = [NSArray arrayWithObjects:@"png", @"gif", @"jpg", @"jpeg", @"tif", @"bmp", nil];
        
        // translate(.,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')
        self.nextPageXpath = @"//a[starts-with(text(), 'Next') or starts-with(text(), 'next') or contains(text(), 'Older Posts') or contains(text(), 'Older Entries')]/@href";
        self.photoBaseXpath = @"//img/@src | //a/@href";
    }
    
    return self;
}

- (void) dealloc
{
    _delegate = nil;
    [_nextPageXpath release], _nextPageXpath = nil;
    [_photoBaseXpath release], _photoBaseXpath = nil;
    [_urlMap release], _urlMap = nil;
    [_defaultUrlRoot release], _defaultUrlRoot = nil;
    [_validFileExtensions release], _validFileExtensions = nil;
    [_pageUrl release], _pageUrl = nil;
    [_currentPage release], _currentPage = nil;
    [_nextPage release], _nextPage = nil;
    [_currentLoadingUrl release], _currentLoadingUrl = nil;
    [_responseData release], _responseData = nil;

    [super dealloc];
}

// FIXME: Find next page.
- (NSURL*)pageUrl
{
    if (_pageUrl == nil)
    {
        // Use stored nextPage, if set; this means we paused in the middle
        // of a longer search.
        if ([self.nextPage isEqualToString:kNoMorePagesFound])
        {
            FFTInfo(@"No more search pages found; bailing out of HTML search: %@", kNoMorePagesFound);
        }
        else
        {
            // FIXME
            NSString *url = nil;//(self.nextPage != nil) ? self.nextPage : nextUrl;
            _pageUrl = [[NSURL URLWithString:url] retain];
            FFTInfo(@"Starting new HTML download operation for base URL: %@", _pageUrl);
        }
    }
    return _pageUrl;
}

// Check image metadata to see if we should download it.  Too big?  Too small?
// (But won't know image size until we start to download it.)
- (BOOL)shouldDownloadURL:(NSURL*)imageUrl
{
    // Check file extension.
    NSString *extension = [[[imageUrl path] pathExtension] lowercaseString];
    if (![self.validFileExtensions containsObject:extension])
    {
        FFTDebug(@"Rejecting non-valid file extension: '%@'", imageUrl);
        return NO;
    }
    
    return YES;
}

#pragma mark -
#pragma mark XML Parsing Methods
#pragma mark -


- (NSURL *)mapSpecialUrls:(NSURL *)url
{
    // TODO: Detect special sites and trigger full custom key sets (?), including
    //       mapped URL and nextPageXpath.
    
    NSString *mappedUrlString = [self.urlMap valueForKey:[url absoluteString]];
    if (mappedUrlString)
    {
        FFTInfo(@"Overriding URL %@ with mapped URL: %@", url, mappedUrlString);
        url = [NSURL URLWithString:mappedUrlString];
    }
    
    return url;
}


// Scan the HTML document and return an array of NSURLs for all matching images.
- (NSArray*)xmlRunXPathOnDoc:(htmlDocPtr)doc withXpath:(NSString *)targetXpath withFilter:(BOOL)filtered
{
    FFTInfo(@"Scanning HTML document for elements at '%@'", targetXpath);
    
    xmlXPathContextPtr xpathCtx;
    xmlXPathObjectPtr xpathObj;
    
    // Create xpath evaluation context.
    xpathCtx = xmlXPathNewContext(doc);
    if(xpathCtx == NULL)
    {
        FFTError(@"HTML ERROR: Unable to create XPath context from HTML doc.");
        return nil;
    }
    
    // Evaluate xpath expression.
    xmlChar *xpath = (xmlChar *)[targetXpath cStringUsingEncoding:NSUTF8StringEncoding];
    xpathObj = xmlXPathEvalExpression(xpath, xpathCtx);
    if(xpathObj == NULL)
    {
        FFTError(@"HTML ERROR: Unable to evaluate XPath: '%@'", targetXpath);
        return nil;
    }
    
    xmlNodeSetPtr nodes = xpathObj->nodesetval;
    if (!nodes)
    {
        FFTError(@"HTML ERROR: Failed to find any xpath matches for '%@'", targetXpath);
        return nil;
    }
    
    // Extract <img src=""> or <a href=""> from each XPath result node.
    NSMutableArray *urls = [NSMutableArray array];
    for (NSInteger i = 0; i < nodes->nodeNr; i++)
    {
        xmlNodePtr currentNode = nodes->nodeTab[i];
        if (currentNode->children != NULL && currentNode->children->type == XML_TEXT_NODE)
        {
            // Text content of the found element.
            NSString *imagePath = [NSString stringWithCString:(const char*)currentNode->children->content encoding:NSUTF8StringEncoding];
            NSURL *url = [NSURL URLWithString:imagePath];
            
            // If a relative URL, prepend with defaultUrlRoot.
            if ([url host] == nil)
            {
                if (self.defaultUrlRoot)
                {
                    imagePath = [NSString stringWithFormat:@"%@%@", self.defaultUrlRoot, imagePath];
                }
                url = [NSURL URLWithString:imagePath];
            }
            
            FFTTrace(@"Found match at path: %@", url);
            if (filtered && ![self shouldDownloadURL:url])
            {
                FFTTrace(@"Skipping rejected URL: %@", url);
                continue;
            }

            [urls addObject:url];
        }
    }
    
    // Clean up.
    xmlXPathFreeObject(xpathObj);
    xmlXPathFreeContext(xpathCtx);
    
    return urls;
}

- (NSURL*)xmlFindNextPage:(htmlDocPtr)doc
{
    FFTInfo(@"Searching HTML doc for NEXT PAGES");
    
    NSArray *nextPages = [self xmlRunXPathOnDoc:doc withXpath:self.nextPageXpath withFilter:NO];
    
    FFTDebug(@"Found NEXT PAGES: %@", nextPages);
    return ([nextPages count] > 0) ? [nextPages objectAtIndex:0] : nil;
}

// Load URLs from one or more pages at the given site.
// The first element is always the URL of the next page.  If the result
// array is empty, the HTML doc was bad or unloadable.
- (NSMutableArray*)xmlLoadUrls:(NSURL*)page
{
    // Load HTML document with HTML-friendly libxml2 parser.
    FFTInfo(@"Loading content from page URL: '%@'", page);
    NSData *rawData = [NSData dataWithContentsOfURL:page];
    htmlDocPtr doc = htmlReadMemory([rawData bytes], [rawData length], "", NULL,
                                    HTML_PARSE_NOWARNING | HTML_PARSE_NOERROR);
    if (doc == NULL)
    {
        FFTError(@"HTML ERROR: Unable to parse HTML document: '%@'", page);
        return [NSArray array];
    }
    
    // Run xpath on HTML document.
    NSURL *nextPage = [self xmlFindNextPage:doc];
    if (nextPage == nil)
    {
        self.nextPage = kNoMorePagesFound;
    }
    
    NSArray *newUrls = [self xmlRunXPathOnDoc:doc withXpath:self.photoBaseXpath withFilter:YES];
    FFTInfo(@"Found %i images on page %@", [newUrls count], page);
    FFTTrace(@"%@", newUrls);
    
    // Clean up.
    xmlFreeDoc(doc);
    
    NSMutableArray *results = [NSMutableArray arrayWithArray:newUrls];
    
    // Push nextPage to head of array.
    id pageObj = (nextPage == nil) ? (id)[NSNull null] : (id)nextPage;
    [results insertObject:pageObj atIndex:0];
    
    return results;
}

- (NSArray*)loadAllUrls
{
    FFTInfo(@"Loading all URLs from HTML source...");
    NSInteger pageCount = 0;
    NSMutableArray *urls = [NSMutableArray array];
    
    // Keep scanning pages until we have 100 URLs, but give up after MAX_PAGE_COUNT pages.
    id nextUrl = [self mapSpecialUrls:self.pageUrl];
    while ([urls count] < MIN_IMAGE_COUNT && pageCount < MAX_PAGE_COUNT)
    {
        FFTInfo(@"Loading from next page: %@", nextUrl);
        NSMutableArray *moreUrls = [self xmlLoadUrls:nextUrl];
        if ([moreUrls count] > 0)
        {
            // Pull off first object as next page URL.
            nextUrl = [moreUrls objectAtIndex:0];
            [moreUrls removeObjectAtIndex:0];
            
//            [images addObjectsFromArray:moreUrls];
            for (id url in moreUrls)
            {
                if ([urls indexOfObject:url] == NSNotFound)
                {
                    FFTDebug(@"ADDING: %@", url);
                    [urls addObject:url];
                }
                else
                {
                    FFTTrace(@"DUPLICATE: %@", url);
                }
            }
        }
        else
        {
            FFTInfo(@"No urls found for page %@", nextUrl);
            nextUrl = [NSNull null];
        }
        
        pageCount++;
        FFTCritical(@"Total %i urls after page %i", [urls count], pageCount);
        
        if (nextUrl == [NSNull null])
        {
            FFTInfo(@"No urls found in next page; bailing out");
            break;
        }
    }

    return urls;
}


#pragma mark -
#pragma mark Service API Methods
#pragma mark -


- (void)performOperation
{
    NSArray *urls = [self loadAllUrls];
    [self.delegate foundUrls:urls];
    
    [self completeOperation];
}

@end
