//
//  SpotEditViewController.h
//  DungaRadar
//
//  Created by  on 11/11/23.
//  Copyright (c) 2011年 Kawaz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Spot.h"

@interface SpotEditViewController : UITableViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UIAlertViewDelegate>{
  Spot* spot_;
}

- (id)initWithSpot:(Spot*)spot;

@property(readwrite, retain) Spot* spot;
@end
