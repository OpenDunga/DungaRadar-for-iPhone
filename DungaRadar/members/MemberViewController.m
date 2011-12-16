//
//  MemberViewController.m
//  DungaRadar
//
//  Created by  on 11/12/14.
//  Copyright (c) 2011年 Kawaz. All rights reserved.
//

#import "MemberViewController.h"
#import "MemberDetailViewController.h"
#import "MemberManager.h"
#import "Me.h"

@interface MemberViewController()
- (void)pressReloadButton:(id)sender;
@end

@implementation MemberViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
  }
  return self;
}

- (void)didReceiveMemoryWarning {
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  UITableViewController* rootView = [[[UITableViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
  rootView.tableView.delegate = self;
  rootView.tableView.dataSource = self;
  rootView.title = @"メンバー";
  rootView.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh 
                                                                                             target:self 
                                                                                             action:@selector(pressReloadButton:)] autorelease];
  [self pushViewController:rootView animated:NO];
}

- (void)viewDidUnload {
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  UITableViewController* tvc = (UITableViewController*)[self.viewControllers objectAtIndex:0];
  [tvc.tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)pressReloadButton:(id)sender {
  [[MemberManager instance] updateMembers];
  UITableViewController* tvc = (UITableViewController*)self.visibleViewController;
  [tvc.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [[[MemberManager instance] members] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *CellIdentifier = [NSString stringWithFormat:@"Cell_%d", indexPath.row];
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  DungaMember* member = (DungaMember*)[[[MemberManager instance] members] objectAtIndex:indexPath.row];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  }
  cell.textLabel.text = member.dispName;
  cell.detailTextLabel.text = [member descriptionDetailFromMember:[Me sharedMe]];
  cell.imageView.image = member.iconImage;
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  int row = indexPath.row;
  DungaMember* member = [[[MemberManager instance] members] objectAtIndex:row];
  MemberDetailViewController* vc = [[MemberDetailViewController alloc] initWithMember:member];
  [self pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 56;
}

@end
