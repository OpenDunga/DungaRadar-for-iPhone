//
//  ConfigurationViewController.m
//  DungaRadar
//
//  Created by  on 1/15/12.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import "define.h"
#import "ConfigurationViewController.h"
#import "LoginViewController.h"
#import "Me.h"

@interface ConfigurationViewController()
- (void)switchEnableRegistration:(id)sender;
- (void)switchEnableBackground:(id)sender;
- (void)switchSaveMode:(id)sender;
- (NSString*)labelFromFrequency:(int)second;
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
  frequencies_ = [[NSArray alloc] initWithObjects:@"1分", @"5分", @"10分", 
                          @"15分", @"30分", @"1時間", 
                          @"3時間", @"6時間", @"12時間", @"24時間", nil];
  [self pushViewController:tvc animated:NO];
}

- (void)dealloc {
  [frequencies_ release];
  [super dealloc];
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
  return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  int rows[4] = {1, 4, 1, 1};
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
      Me* me = [Me sharedMe];
      cell.textLabel.text = @"ログイン設定";
      cell.detailTextLabel.text = me.dispName;
      cell.imageView.image = me.iconImage;
      cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if (section == 1) {
      if (row == 0) {
        cell.textLabel.text = @"現在位置を送信する";
        UISwitch* sw = [[[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 0, 0)] autorelease];
        sw.on = [[NSUserDefaults standardUserDefaults] boolForKey:KEY_FOR_ENABLE_ACTIVATION];
        cell.accessoryView = sw;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [sw addTarget:self 
               action:@selector(switchEnableRegistration:) 
     forControlEvents:UIControlEventValueChanged];
      } else if (row == 1) {
        cell.textLabel.text = @"バックグラウンド送信";
        UISwitch* sw = [[[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 0, 0)] autorelease];
        sw.on = [[NSUserDefaults standardUserDefaults] boolForKey:KEY_FOR_ENABLE_BACKGROUND];
        cell.accessoryView = sw;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [sw addTarget:self 
               action:@selector(switchEnableBackground:) 
     forControlEvents:UIControlEventValueChanged];
      } else if (row == 2) {
        cell.textLabel.text = @"送信頻度";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
      } else if (row == 3) {
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
      if (row == 0) {
        cell.textLabel.text = @"表示日数";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
      }
    } else if (section == 3) {
      if (row == 0) {
        cell.textLabel.text = @"アイコンを再取得";
      }
    }
    
  }
  if (section == 1 && row == 2) {
    int frequency = [[NSUserDefaults standardUserDefaults] integerForKey:KEY_FOR_FREQUENCY];
    cell.detailTextLabel.text = [self labelFromFrequency:frequency];
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
    if (row == 2) {
      UIViewController* vc = [[[UIViewController alloc] init] autorelease];
      UIPickerView* picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
      vc.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
      picker.delegate = self;
      picker.dataSource = self;
      picker.showsSelectionIndicator = YES;
      int frequency = [[NSUserDefaults standardUserDefaults] integerForKey:KEY_FOR_FREQUENCY];
      [picker selectRow:[frequencies_ indexOfObject:[self labelFromFrequency:frequency]]
            inComponent:0 animated:NO];
      [vc.view addSubview:picker];
      [self pushViewController:vc animated:YES];
    }
  }
}
  
- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  NSString* header[] = {@"", @"送信設定", @"履歴設定", @""};
  return header[section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 0 && indexPath.row == 0){
    return 56;
  }
  return 44;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
  return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
  return [frequencies_ count];
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
  return [frequencies_ objectAtIndex:row];
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
    UITableViewController* tvc = (UITableViewController*)[self.viewControllers objectAtIndex:0];
    UITableViewCell* cell = [self tableView:tvc.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    cell.detailTextLabel.text = label;
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    [ud setInteger:minute * 60 forKey:KEY_FOR_FREQUENCY];
    [tvc.tableView reloadData];
  }
}

- (void)switchEnableRegistration:(id)sender {
  UISwitch* sw = (UISwitch*)sender;
  [[NSUserDefaults standardUserDefaults] setBool:sw.on forKey:KEY_FOR_ENABLE_ACTIVATION];
  [[Me sharedMe] updateLocationStatus];
}

- (void)switchEnableBackground:(id)sender {
  UISwitch* sw = (UISwitch*)sender;
  [[NSUserDefaults standardUserDefaults] setBool:sw.on forKey:KEY_FOR_ENABLE_BACKGROUND];
  [[Me sharedMe] updateLocationStatus];
}

- (void)switchSaveMode:(id)sender {
  UISwitch* sw = (UISwitch*)sender;
  NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
  [ud setBool:sw.on forKey:KEY_FOR_SAVEMODE];
}

- (NSString*)labelFromFrequency:(int)second {
  if (second < 60 * 60) { 
    return [NSString stringWithFormat:@"%d分", second / 60];
  }
  return [NSString stringWithFormat:@"%d時間", second / 3600];
}

@end
