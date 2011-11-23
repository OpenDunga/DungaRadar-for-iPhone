//
//  ConfigurationViewController.h
//  DungaRadar
//
//  Created by giginet on 11/05/29.
//  Copyright 2011 Kawaz. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ConfigurationViewController : UITableViewController <UITextFieldDelegate>{
  UITextField* usernameField_;
  UITextField* passwordField_;
}

@end