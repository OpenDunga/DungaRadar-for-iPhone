//
//  ConfigurationViewController.m
//  DungaRadar
//
//  Created by giginet on 11/05/29.
//  Copyright 2011 Kawaz. All rights reserved.
//

#import "ConfigurationViewController.h"
#import "HttpConnection.h"

@interface ConfigurationViewController()
- (void)pressLoginButton:(id)sender;
@end

@implementation ConfigurationViewController

- (id)initWithStyle:(UITableViewStyle)style{
  self = [super initWithStyle:UITableViewStyleGrouped];
  if (self) {
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
  self.tableView.allowsSelection = NO;
  UIButton* loginButton = [UIButton buttonWithType:111];
  loginButton.frame = CGRectMake(10, 150, 300, 45);
  [loginButton setTitle:@"OpenDungaにログイン" forState:UIControlStateNormal];
  [loginButton setTintColor:[UIColor redColor]];
  [self.view addSubview:loginButton];
  [loginButton addTarget:self action:@selector(pressLoginButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  NSString *CellIdentifier = [NSString stringWithFormat:@"Cell:%d_%d", indexPath.section, indexPath.row];
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
  }
  if(indexPath.section==0){
    UITextField* field = [[UITextField alloc] initWithFrame:CGRectMake(125, 12, 125, 25)];
    field.delegate = self;
    field.textAlignment = UITextAlignmentLeft;
    field.returnKeyType = UIReturnKeyDone;
    field.keyboardType = UIKeyboardTypeASCIICapable;
    field.textColor = [UIColor colorWithRed:0.22 green:0.33 blue:0.53 alpha:1];
    if(indexPath.row==0){
      cell.textLabel.text = @"ユーザー名";
    }else if(indexPath.row==1){
      cell.textLabel.text = @"パスワード";
      field.secureTextEntry = YES;
    }
    [cell addSubview:field];
  }else{
    
  }
  return cell;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
  return section == 0 ? @"ログイン設定" : @"";
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
  // <UITextFieldDelegate>　完了ボタンが押されたときにIMEを閉じる
  if([textField canResignFirstResponder]){
    [textField resignFirstResponder];
  }
  return YES;
}

- (void)pressLoginButton:(id)sender{
  HttpConnection* hc = [[[HttpConnection alloc] init] autorelease];
  NSDictionary* post = [NSDictionary dictionaryWithObjectsAndKeys:@"cig1n3t", @"user_name", @"hogehoge", @"enc_password", @"hogehoge", @"password", nil];
  NSLog(@"%@", [post description]);
  [hc post:@"/api/login" params:post];
}

@end
