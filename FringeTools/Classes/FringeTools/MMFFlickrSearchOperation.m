//
//  MMQSearchFlickr.m
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

#import <FringeTools/MMFFlickrSearchOperation.h>
#import <FringeTools/MMFLogging.h>
#import <FringeTools/MMFFlickrPhoto.h>

@implementation MMFFlickrSearchOperation

// Flickr session constants.
static NSString *kQFlickrSearchPhotosKeyName = @"FlickrSearchPhotosKeyName";
static NSString *kQFlickrLookupUserKeyName = @"FlickrLookupUserKeyName";

@synthesize context = _context;
@synthesize request = _request;
@synthesize username = _username;
@synthesize keyword = _keyword;
@synthesize searchText = _searchText;
@synthesize searchWords = _searchWords;

- (id)initWithUsername:(NSString*)username
               keyword:(NSString*)keyword
                apiKey:(NSString *)flickrApiKey
          sharedSecret:(NSString *)flickrSharedSecret;
{	
    if ((self = [super init]))
    {
        // Initialization.
        self.username = username;
        self.keyword = keyword;
        
        // Default to 100 photos per request.
        self.resultsPerPage = 100;
        
        MMFInfo(@"Initializing Flickr op with user '%@' and keyword '%@'", username, keyword);
        _context = [[OFFlickrAPIContext alloc] initWithAPIKey:flickrApiKey
                    sharedSecret:flickrSharedSecret];
        _request = [[OFFlickrAPIRequest alloc] initWithAPIContext:_context];
        [_request setDelegate:self];
    }
    
    return self;
}

- (void)dealloc
{
    MMFTrace(@"Cleaning up Flickr op.");
    
    if ([_request isRunning])
    {
        MMFDebug(@"Shutting down running Flickr request");
        [_request cancel];
    }
    
    [_context release], _context = nil;
    [_request release], _request = nil;
    [_username release], _username = nil;
    [_keyword release], _keyword = nil;
    [_searchText release], _searchText = nil;
    [_searchWords release], _searchWords = nil;

    [super dealloc];
}

- (BOOL)isConcurrent
{
    // Create our own thread.
    MMFDebug(@"Flickr is concurrent.");
    return YES;
}


#pragma mark Private Service Implementation


- (void)flickrGetAny
{
    MMFInfo(@"Running flickr.photos.getRecent");
    _request.sessionInfo = kQFlickrSearchPhotosKeyName;
    
    NSString *pageSize = [NSString stringWithFormat:@"%li", self.resultsPerPage];
    NSDictionary *args = [NSDictionary dictionaryWithObjectsAndKeys:pageSize, @"per_page", nil];
    MMFDebug(@"Flickr search args: %@", args);
    [_request callAPIMethodWithGET:@"flickr.photos.getRecent" arguments:args];
}

- (void)flickrLookupUser
{
    MMFInfo(@"Running flickr.people.findByUsername (username=%@; tags=%@)", self.username, self.keyword);
    _request.sessionInfo = kQFlickrLookupUserKeyName;
    
    // FIXME: Include keywords in search.
    NSString *pageSize = [NSString stringWithFormat:@"%li", self.resultsPerPage];
    NSDictionary *args = [NSDictionary dictionaryWithObjectsAndKeys:pageSize, @"per_page",
                          self.username, @"username", nil];
    [_request callAPIMethodWithGET:@"flickr.people.findByUsername" arguments:args];
}

- (void)flickrSearch:(NSString*)userId
{
    MMFInfo(@"Running flickr.photos.search with user_id: %@", userId);
    _request.sessionInfo = kQFlickrSearchPhotosKeyName;
    
    NSString *pageSize = [NSString stringWithFormat:@"%li", self.resultsPerPage];
    NSMutableDictionary *args = [NSMutableDictionary dictionaryWithObjectsAndKeys:pageSize, @"per_page", nil];
    if ([userId length] > 0)
    {
        [args setValue:userId forKey:@"user_id"];
    }
    if ([self.keyword length] > 0)
    {
        [args setValue:self.keyword forKey:@"tags"];
    }
    MMFInfo(@"Searching Flickr with params %@", args);
    [_request callAPIMethodWithGET:@"flickr.photos.search" arguments:args];
    
    self.username = nil;
    self.keyword = nil;
}

// Google-like searching on flickr.
- (void)flickrSearchText:(NSString *)searchText
{
    // Break the free-form search string into words.  Look up each one to
    // see if it's a username.  If we find a user name, use that.  Otherwise
    // treat all words as keywords.
    NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:@" ,"];
    self.searchWords = [searchText componentsSeparatedByCharactersInSet:charSet];
    MMFInfo(@"FLICKR SEARCH WORDS: %@", self.searchWords);
}


#pragma mark Handle Operation


- (void)startOperation
{
    // If we have any search args, use them with:
    //   flickr.photos.search
    //
    // If we have no search args, do a global search with:
    //   flickr.photos.getRecent
    //
    // Other useful detail methods (maybe already covered?):
    //   flickr.photos.getInfo
    //   flickr.photos.getSizes
    
    MMFInfo(@"Running Flickr search with searchText='%@' username='%@', keyword='%@'",
           self.searchText, self.username, self.keyword);
    if ([self.searchText length] > 0)
    {
        NSString *trimmed = [self.searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        [self flickrSearchText:trimmed];
    }
    else if ([self.username length] == 0 && [self.keyword length] == 0)
    {
        // Username and keyword fields are both empty.
        [self flickrGetAny];
    }
    else if ([self.username length] == 0)
    {
        // Have something in keyword field; username is blank.
        [self flickrSearch:@""];
    }
    else
    {
        // Have something in username field; might also have keyword.
        [self flickrLookupUser];
    }
    MMFDebug(@"Completed Flickr search request.");
}

- (NSArray *)extractUrls:(NSArray *)flickrResults
{
    NSMutableArray *photos = [[[NSMutableArray alloc] init] autorelease];
    
    for (NSDictionary *flickrDict in flickrResults)
    {
        MMFTrace(@"Photo metadata: %@", flickrDict);
        MMFFlickrPhoto *flickrPhoto = [[MMFFlickrPhoto alloc] initWithFlickrContext:_context data:flickrDict];
        
        // Have the search results dictionary; send another query to Flickr to retrieve the photo details.
//        MMFDebug(@"Loading Flickr photo detail...");
//        [flickrPhoto fetchPhotoDetail: ^(MMFFlickrPhoto *photo) {
//            photo.author = [photo.infoDictionary valueForKeyPath:@"photo.owner.username"];
//            MMFDebug(@"Retrieved photo author = %@ (%@)", photo.author, photo.photoURL);
//        } failure: ^(MMFFlickrPhoto *photo, NSError *error) {
//            photo.author = @"Unknown";
//        }];
        
        [photos addObject:flickrPhoto];
    }
    
    return photos;
}


#pragma mark Flickr Protocol


- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest
 didCompleteWithResponse:(NSDictionary *)inResponseDictionary
{
    MMFDebug(@"Completed request: %@", inRequest.sessionInfo);
    MMFTrace(@"Completed request: %@", inResponseDictionary);
    MMFInfo(@"Completed request");
    
    if (inRequest.sessionInfo == kQFlickrLookupUserKeyName)
    {
        // Looked up user id. Not done yet.
        NSString *userId = [inResponseDictionary valueForKeyPath:@"user.id"];
        [self flickrSearch:userId];
    }
    else
    {
        // Got the result. Close out the operation.
        NSArray *flickrPhotos = [inResponseDictionary valueForKeyPath:@"photos.photo"];
        [self.searchDelegate foundUrls:[self extractUrls:flickrPhotos]];
        
        [self completeOperation];
    }
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest
        didFailWithError:(NSError *)inError
{
    MMFError(@"FLICKR ERROR: failed request %@", inError);
    [self.searchDelegate searchFailedWithError:inError];
    
    [self completeOperation];
}

@end
