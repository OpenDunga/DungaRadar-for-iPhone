//
//  ConfigurationViewController.m
//  DungaRadar
//
//  Created by  on 1/15/12.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import "ConfigurationViewController.h"
#import "LoginViewController.h"
#import "define.h"

@interface ConfigurationViewController()
- (void)switchSaveMode:(id)sender;
@end

@implementation ConfigurationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  UITableViewController* tvc = [[[UITableViewController alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
  tvc.tableView.dataSource = self;
  tvc.tableView.delegate = self;
  tvc.title = @"設定";
  [self pushViewController:tvc animated:NO];
  
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [[(UITableViewController*)[self.viewControllers objectAtIndex:0] tableView] reloadData];
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
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    if (section == 0) {
      cell.textLabel.text = @"ログイン設定";
      cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if (section == 1) {
      if (row == 0) {
        cell.textLabel.text = @"送信頻度";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        int frequency = [[NSUserDefaults standardUserDefaults] integerForKey:KEY_FOR_FREQUENCY];
        if (frequency < 60 * 60) { 
          cell.detailTextLabel.text = [NSString stringWithFormat:@"%d分", frequency/60];
        } else {
          cell.detailTextLabel.text = [NSString stringWithFormat:@"%d時間", frequency/3600];
        }
      } else if (row == 1) {
        cell.textLabel.text = @"節電モード";
        UISwitch* sw = [[[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 0, 0)] autorelease];
        sw.on = [[NSUserDefaults standardUserDefaults] boolForKey:KEY_FOR_SAVEMODE];
        cell.accessoryView = sw;
        [sw addTarget:self 
               action:@selector(switchSaveMode:) 
     forControlEvents:UIControlEventValueChanged];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
      }
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
  } else if (section == 1) {
    if (row == 0) {
      UIViewController* vc = [[[UIViewController alloc] init] autorelease];
      UIPickerView* picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
      vc.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
      picker.delegate = self;
      picker.dataSource = self;
      picker.showsSelectionIndicator = YES;
      [vc.view addSubview:picker];
      [self pushViewController:vc animated:YES];
    }
  }
}
  
- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  NSString* header[] = {@"", @"送信設定", @"アイコン設定"};
  return header[section];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
  return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
  return 10;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
  NSString* string[] = {@"1分", @"5分", @"10分", 
    @"15分", @"30分", @"1時間", 
    @"3時間", @"6時間", @"12時間", @"24時間"};
  return string[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
  if(component == 0) {
    NSString* label = [self pickerView:pickerView titleForRow:row forComponent:component];
    int minute;
    if ([label hasSuffix:@"分"]) {
      NSString* min = [label stringByReplacingOccurrencesOfString:@"分" withString:@""];
      minute = [min intValue];
    } else if([label hasSuffix:@"時間"]) {
      NSString* hour = [label stringByReplacingOccurrencesOfString:@"分" withString:@""];
      minute = [hour intValue] * 60;
    }
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    [ud setInteger:minute * 60 forKey:KEY_FOR_FREQUENCY];
    UITableViewController* tvc = (UITableViewController*)[self.viewControllers objectAtIndex:0];
    NSLog(@"%@", tvc);
    UITableViewCell* cell = [self tableView:tvc.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    NSLog(@"%@", cell);
    cell.detailTextLabel.text = label;
    [tvc.tableView reloadData];
  }
}

- (void)switchSaveMode:(id)sender {
  UISwitch* sw = (UISwitch*)sender;
  NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
  if (sw.on) {
    [ud setBool:YES forKey:KEY_FOR_SAVEMODE];
  } else {
    [ud setBool:NO forKey:KEY_FOR_SAVEMODE];
  }
}

@end
