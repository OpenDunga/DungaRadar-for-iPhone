//
//  SpotViewController.m
//  DungaRadar
//
//  Created by giginet on 11/07/10.
//  Copyright 2011 Kawaz. All rights reserved.
//


#import "EditSpotViewController.h"
#import "SpotViewController.h"

@interface SpotViewController()
- (void)pressAddButton:(id)sender;
@end

@implementation SpotViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)dealloc{
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
  UITableViewController* tableViewController = [[[UITableViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
  tableViewController.title = @"スポット";
  tableViewController.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] 
                                                            initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
                                                            target:self 
                                                            action:@selector(pressAddButton:)] autorelease];
  tableViewController.tableView.dataSource = self;
  tableViewController.tableView.delegate = self;
  [self pushViewController:tableViewController animated:NO];
}

- (void)viewDidUnload{
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  NSString *CellIdentifier = [NSString stringWithFormat:@"Cell:%d_%d", indexPath.section, indexPath.row];
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
  }
  return cell;  
}

- (void)pressAddButton:(id)sender{
  EditSpotViewController* addViewController = [[EditSpotViewController alloc] initWithStyle:UITableViewStyleGrouped];
  [self pushViewController:addViewController animated:YES];
}

@end
