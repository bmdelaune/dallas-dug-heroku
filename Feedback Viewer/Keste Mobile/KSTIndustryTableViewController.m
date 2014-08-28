//
//  KSTIndustryTableViewController.m
//  Keste Mobile
//
//  Created by Bradley Delaune on 8/25/14.
//  Copyright (c) 2014 Keste. All rights reserved.
//

#import "KSTIndustryTableViewController.h"
#import "KSTCaseStudyViewController.h"

@interface KSTIndustryTableViewController ()

@end

@implementation KSTIndustryTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (void)getInfo:(id)sender
{
    [refreshControl beginRefreshing];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://dug-presentation.herokuapp.com/services/rest/feedback/"]];
    
    // Create url connection and fire request
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getInfo:self];
    // Initialize Refresh Control
    refreshControl = [[UIRefreshControl alloc] init];
    
    // Configure Refresh Control
    [refreshControl addTarget:self action:@selector(getInfo:) forControlEvents:UIControlEventValueChanged];
    
    // Configure View Controller
    [self setRefreshControl:refreshControl];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"preparing for segue");
    if([[segue identifier] isEqualToString:@"feedback_view"])
    {
        KSTCaseStudyViewController *vc = [segue destinationViewController];
        NSInteger i = [self.tableView indexPathForSelectedRow].row;
        [vc setCaseStudy:(NSDictionary*)[industries objectAtIndex:i]];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(industries == nil)
        return 0;
    else
        return industries.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.textLabel.text = [(NSDictionary *)[industries objectAtIndex:indexPath.row] valueForKey:@"name"];
    cell.detailTextLabel.text = [(NSDictionary *)[industries objectAtIndex:indexPath.row] valueForKey:@"full_name__c"];
    
    return cell;
}

#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [_responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    NSLog(@"done making callout");
    NSError *err = nil;
    industries = [NSJSONSerialization JSONObjectWithData:_responseData options:0 error:&err];
    if(err != nil) {
        NSLog(@"error from JSON");
        return;
    }
    
    NSLog(@"Reloading...");
    [self.tableView reloadData];
    [refreshControl endRefreshing];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    
    NSLog(@"callout error received");
}
@end
