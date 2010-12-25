//
//  FlickrViewController.h
//  MacExample
//
//  Created by John Sheets on 12/24/10.
//  Copyright 2010 MobileMethod, LLC. All rights reserved.
//

@interface FlickrViewController : NSViewController <FFTDownloadDelegate>
{
    NSTextView *_textView;
    NSOperationQueue *_queue;
}

@property (nonatomic, assign) IBOutlet NSTextView *textView;
@property (nonatomic, retain) NSOperationQueue *queue;

@end
