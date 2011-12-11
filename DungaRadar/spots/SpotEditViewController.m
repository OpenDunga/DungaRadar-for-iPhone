//
//  SpotEditViewController.m
//  DungaRadar
//
//  Created by  on 11/11/23.
//  Copyright (c) 2011年 Kawaz. All rights reserved.
//

#import "SpotEditViewController.h"

@interface SpotEditViewController()
- (void)pressSaveButton:(id)sender;
- (void)pressCancelButton:(id)sender;
@end

@implementation SpotEditViewController

- (id)initWithStyle:(UITableViewStyle)style {
  self = [super initWithStyle:style];
  if (self) {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    spot_ = [[Spot alloc] init];
  }
  return self;
}

- (void)dealloc {
  [spot_ release];
  [super dealloc];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                                          target:self 
                                                                                          action:@selector(pressSaveButton:)] autorelease];
  self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                                         target:self 
                                                                                                         action:@selector(pressCancelButton:)] autorelease];
}

- (void)viewDidUnload {
  [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"Cell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  int row = indexPath.row;
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString* cellName[] = {@"スポット名", @"範囲", @"自動通知"}; 
    if(row == 0){
      UITextField* field = [[[UITextField alloc] initWithFrame:CGRectMake(0, 0, 170, 25)] autorelease];
      field.textColor = [UIColor colorWithRed:0.22 green:0.33 blue:0.53 alpha:1];
      cell.accessoryView = field;
    }else if(row == 1){
      cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
      cell.detailTextLabel.text = @"コンビニサイズ";
      cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }else if(row == 2){
      UISwitch* sw = [[[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 0, 0)] autorelease];
      cell.accessoryView = sw;
    }
    cell.textLabel.text = cellName[row];
  }
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if(indexPath.row == 1){
    UIPickerView* picker = [[[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)] autorelease];
    picker.showsSelectionIndicator = YES;
    picker.dataSource = self;
    picker.delegate = self;
    UIViewController* pickerController = [[[UIViewController alloc] init] autorelease];
    [pickerController.view addSubview:picker];
    pickerController.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.navigationController pushViewController:pickerController animated:YES];
  }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
  return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
  NSString* path = [[NSBundle mainBundle] pathForResource:@"spots" ofType:@"plist"];
  NSDictionary* spots = [NSDictionary dictionaryWithContentsOfFile:path];
  return [(NSDictionary*)[spots objectForKey:@"root"] count];
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
  NSString* path = [[NSBundle mainBundle] pathForResource:@"spots" ofType:@"plist"];
  NSDictionary* spots = [NSDictionary dictionaryWithContentsOfFile:path];
  return (NSString*)[[(NSDictionary*)[spots objectForKey:@"root"] allKeys] objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
  if(component == 0) {
    NSString* path = [[NSBundle mainBundle] pathForResource:@"spots" ofType:@"plist"];
    NSDictionary* spots = [NSDictionary dictionaryWithContentsOfFile:path];
    NSLog(@"%@", [[spots allValues] objectAtIndex:row]);
    spot_.scope = [(NSNumber*)[[spots allValues] objectAtIndex:row] intValue];
  }
}

- (void)pressSaveButton:(id)sender {
  spot_.dispName = @"ぎぎねっと邸";
  spot_.autoInform = false;
  [spot_ commit];
}

- (void)pressCancelButton:(id)sender {
  [self dismissModalViewControllerAnimated:YES];
}

@end
