//
//  SpotEditViewController.h
//  DungaRadar
//
//  Created by  on 11/11/23.
//  Copyright (c) 2011年 Kawaz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Spot.h"

@interface SpotEditViewController : UITableViewController <UIPickerViewDataSource, UIPickerViewDelegate>{
  Spot* spot_;
}


@end
