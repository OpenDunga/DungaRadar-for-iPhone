//
//  MapViewController.h
//  DungaRadar
//
//  Created by giginet on 11/05/29.
//  Copyright 2011 Kawaz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MKMapView.h>

@interface MapViewController : UIViewController <MKMapViewDelegate> {
  IBOutlet MKMapView* mapView_;
}

@end
