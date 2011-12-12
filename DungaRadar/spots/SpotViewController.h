//
//  SpotViewController.h
//  DungaRadar
//
//  Created by giginet on 11/07/10.
//  Copyright 2011 Kawaz. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SpotViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
  NSMutableArray* spots_;
  IBOutlet UITableView* tableView_;
}

-( IBAction)pressAddButton:(id)sender;

@property(readwrite, retain) NSMutableArray* spots;
@end
