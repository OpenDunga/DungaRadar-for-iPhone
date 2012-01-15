//
//  SpotViewController.m
//  DungaRadar
//
//  Created by giginet on 11/07/10.
//  Copyright 2011 Kawaz. All rights reserved.
//

#import "NSDictionary_JSONExtensions.h"
#import "SpotEditViewController.h"
#import "SpotViewController.h"
#import "DungaAsyncConnection.h"
#import "Spot.h"
#import "Me.h"

const int SCOPE_RADIUS = 10000;
const NSString* PATH_VENUE_LIST = @"/api/location/venue/list/%lf/%lf/%d";

@interface SpotViewController()
- (void)reloadSpotList;
- (void)onSucceedLoadingSpots:(NSURLConnection*)connection aConnection:(DungaAsyncConnection*)aConnection;
@end

@implementation SpotViewController
@synthesize spots = spots_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
  }
  return self;
}

- (void)dealloc{
  [spots_ release];
  [tableView_ release];
  [super dealloc];
}

- (void)didReceiveMemoryWarning{
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad{
  [super viewDidLoad];
  tableView_.delegate = self;
  tableView_.dataSource = self;
  [self reloadSpotList];
}

- (void)viewDidUnload{
  [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self reloadSpotList];
}

- (void)reloadSpotList {
  Me* me = [Me sharedMe];
  NSString* path = [NSString stringWithFormat:(NSString*)PATH_VENUE_LIST, 
                    me.location.coordinate.latitude, 
                    me.location.coordinate.longitude, 
                    SCOPE_RADIUS];
  DungaAsyncConnection* dac = [DungaAsyncConnection connection];
  dac.delegate = self;
  dac.finishSelector = @selector(onSucceedLoadingSpots:aConnection:);
  [dac connectToDungaWithAuth:path params:nil method:@"GET"];
}

- (void)onSucceedLoadingSpots:(NSURLConnection *)connection aConnection:(DungaAsyncConnection *)aConnection {
  NSString* json = aConnection.responseBody;
  NSError* err;
  NSArray* entries = (NSArray*)[[NSDictionary dictionaryWithJSONString:json error:&err] objectForKey:@"entries"];
  
  if (entries) {
    self.spots = [NSMutableArray arrayWithArray:entries];
    for(NSDictionary* spotData in self.spots) {
      Spot* spot = [[Spot alloc] initWithInfo:spotData];
      [spots_ addObject:spot];
    }
  }
  [tableView_ reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [spots_ count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  NSString *CellIdentifier = [NSString stringWithFormat:@"Cell:%d_%d", indexPath.section, indexPath.row];
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    int row = indexPath.row;
    Spot* spot = (Spot*)[spots_ objectAtIndex:row];
    cell.textLabel.text = spot.dispName;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%lf, %lf", 
                                 spot.location.coordinate.latitude, 
                                 spot.location.coordinate.longitude];
  }
  return cell;  
}

- (void)pressAddButton:(id)sender{
  SpotEditViewController* addViewController = [[SpotEditViewController alloc] initWithStyle:UITableViewStyleGrouped];
  UINavigationController* navigationController = [[[UINavigationController alloc] initWithRootViewController:addViewController] autorelease];
  [self presentModalViewController:navigationController animated:YES];
}

@end
