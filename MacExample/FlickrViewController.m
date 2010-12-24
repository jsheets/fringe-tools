//
//  FlickrViewController.m
//  MacExample
//
//  Created by John Sheets on 12/24/10.
//  Copyright 2010 MobileMethod, LLC. All rights reserved.
//

#import "FlickrViewController.h"

@implementation FlickrViewController

@synthesize textView = _textView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
    {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc
{
    // Clean-up code here.
    
    [super dealloc];
}

@end
