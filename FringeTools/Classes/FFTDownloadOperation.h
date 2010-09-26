//
//  FFTDownloadOperation.h
//  FringeTools
//
//  Created by John Sheets on 9/25/10.
//  Copyright 2010 FourFringe. All rights reserved.
//

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
