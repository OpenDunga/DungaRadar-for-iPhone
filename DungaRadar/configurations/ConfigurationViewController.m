//
//  ConfigurationViewController.m
//  DungaRadar
//
//  Created by  on 1/15/12.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import "ConfigurationViewController.h"
#import "LoginViewController.h"

@implementation ConfigurationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  UITableViewController* tvc = [[UITableViewController alloc] initWithStyle:UITableViewStyleGrouped];
  tvc.tableView.dataSource = self;
  tvc.tableView.delegate = self;
  tvc.title = @"設定";
  [self pushViewController:tvc animated:NO];
  
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  int rows[3] = {1, 2, 1};
  return rows[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  int section = indexPath.section;
  int row = indexPath.row;
  NSString *CellIdentifier = [NSString stringWithFormat:@"Cell_%d_%d", section, row];
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    if (section == 0) {
      cell.textLabel.text = @"ログイン設定";
      cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if (section == 1) {
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else if (section == 2) {
    }
    
  }
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  int section = indexPath.section;
  int row = indexPath.row;
  if (section == 0) {
    LoginViewController* vc = [[[LoginViewController alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
    [self pushViewController:vc animated:YES];
  }
}
  
- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  NSString* header[] = {@"", @"送信設定", @"アイコン設定"};
  return header[section];
}

@end
