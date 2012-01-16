//
//  MemberDetailViewController.h
//  DungaRadar
//
//  Created by  on 11/12/14.
//  Copyright (c) 2011年 Kawaz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DungaMember.h"
#import <MapKit/MKMapView.h>

@interface MemberDetailViewController : UIViewController <MKMapViewDelegate> {
  MKMapView* mapView_;
  DungaMember* member_;
}

- (id)initWithMember:(DungaMember*)member;
- (void)startLoadingHistory;

@property(readwrite, retain) MKMapView* mapView;
@property(readwrite, retain) DungaMember* member;
@end
