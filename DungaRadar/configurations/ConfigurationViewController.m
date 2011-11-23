//
//  ConfigurationViewController.m
//  DungaRadar
//
//  Created by giginet on 11/05/29.
//  Copyright 2011 Kawaz. All rights reserved.
//

#import "ConfigurationViewController.h"
#import "HttpConnection.h"
#import "EncryptExtention.h"

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
  [usernameField_ release];
  [passwordField_ release];
  [super dealloc];
}

- (void)viewDidLoad{
  [super viewDidLoad];
  usernameField_ = [[UITextField alloc] initWithFrame:CGRectMake(125, 12, 125, 25)];
  passwordField_ = [[UITextField alloc] initWithFrame:CGRectMake(125, 12, 125, 25)];
  self.tableView.allowsSelection = NO;
  UIButton* loginButton = [UIButton buttonWithType:111];
  loginButton.frame = CGRectMake(10, 150, 300, 45);
  [loginButton setTitle:@"設定を保存する" forState:UIControlStateNormal];
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
    if(indexPath.section == 0){
      UITextField* field;
      NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
      if(indexPath.row == 0){
        field = usernameField_;
        cell.textLabel.text = @"ユーザー名";
        if([ud stringForKey:@"username"]){
          field.text = [ud stringForKey:@"username"];
        }
      }else if(indexPath.row ==1){
        field = passwordField_;
        cell.textLabel.text = @"パスワード";
        field.secureTextEntry = YES;
        if([ud stringForKey:@"password"]){
          field.text = [ud stringForKey:@"password"];
        }
      }
      field.delegate = self;
      field.textAlignment = UITextAlignmentLeft;
      field.returnKeyType = UIReturnKeyDone;
      field.keyboardType = UIKeyboardTypeASCIICapable;
      field.textColor = [UIColor colorWithRed:0.22 green:0.33 blue:0.53 alpha:1];
      [cell addSubview:field];
    }
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
  HttpConnection* hc = [HttpConnection instance];
  NSString* res = [hc auth:usernameField_.text passwordHash:[passwordField_.text toMD5]];
  NSLog(@"%@", res);
  NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
  [ud setObject:usernameField_.text forKey:@"username"];
  [ud setObject:passwordField_.text forKey:@"password"];
}

@end
