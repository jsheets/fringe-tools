//
//  FlickrViewController.m
//  IOSExample
//
//  Created by John Sheets on 12/19/10.
//  Copyright 2010 MobileMethod, LLC. All rights reserved.
//

#import "FlickrViewController.h"

#define FLICKR_KEY      @"59e46f94de1d538c5d3a0eea8191e797"
#define FLICKR_SECRET   @"77e733718d0215a9"

@implementation FlickrViewController

@synthesize op = _op;

- (IOSExampleAppDelegate *)appDelegate
{
    return (IOSExampleAppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)dealloc
{
    [_op release], _op = nil;
    
    [super dealloc];
}


#pragma mark -
#pragma mark View lifecycle


// Called once, just after loadView.
- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // Start the Flickr search.
    self.op = [[FFTFlickrSearchOperation alloc] initWithUsername:nil keyword:nil apiKey:FLICKR_KEY sharedSecret:FLICKR_SECRET];
    self.op.delegate = self;
    
    [self.appDelegate.queue addOperation:self.op];
}

- (void)viewDidUnload
{
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


#pragma mark -
#pragma mark Memory management


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}



#pragma mark -
#pragma mark View lifecycle


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations.
    return YES;//(interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -
#pragma mark Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    
    return cell;
}


#pragma mark -
#pragma mark Table view delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    */
}



#pragma mark -
#pragma mark Flickr delegate


- (void)downloadSucceeded:(NSData *)downloadData
{
    FFTInfo(@"Flickr Succeeded");
}

- (void)downloadFailedWithError:(NSError *)downloadError
{
    FFTInfo(@"Flickr failed: %@", [downloadError localizedDescription]);
}

- (void)foundUrls:(NSArray *)urls
{
    FFTInfo(@"Flickr URLS: %@", urls);
}

@end

