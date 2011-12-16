//
//  MemberDetailViewController.m
//  DungaRadar
//
//  Created by  on 11/12/14.
//  Copyright (c) 2011年 Kawaz. All rights reserved.
//

#import "MemberDetailViewController.h"

@implementation MemberDetailViewController
@synthesize mapView=mapView_, member=member_;

- (id)initWithMember:(DungaMember *)member {
  self = [super init];
  if(self) {
    self.member = member;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = self.member.dispName;
  mapView_ = [[[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)] autorelease];
  mapView_.delegate = self;
  MKCoordinateRegion cr = mapView_.region;
  cr.center = self.member.location.coordinate;
  cr.span.latitudeDelta = 0.01;
  cr.span.longitudeDelta = 0.01;
  [mapView_ setRegion:cr animated:NO];
  [mapView_ addAnnotation:self.member];
  NSArray* histories = [self.member historySinceDate:[NSDate dateWithTimeIntervalSinceNow:-1 * 60 * 60 * 24]];
  CLLocationCoordinate2D coordinates[[histories count]];
  int i = 0;
  for(NSDictionary* history in histories) {
    double lat = [[history objectForKey:@"latitude"] doubleValue];
    double lng = [[history objectForKey:@"longitude"] doubleValue];
    coordinates[i] = CLLocationCoordinate2DMake(lat, lng);
    ++i;
  }
  MKPolyline* line = [MKPolyline polylineWithCoordinates:coordinates count:[histories count]];
  [mapView_ addOverlay:line];
  [self.view addSubview:mapView_];
}

- (void)viewDidUnload {
  [super viewDidUnload];
}

- (MKOverlayView*)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay {
  MKPolylineView* plv = [[[MKPolylineView alloc] initWithOverlay:overlay] autorelease];  
  plv.strokeColor = [UIColor blueColor];
  plv.lineWidth = 3.0;
  return plv;
}

- (MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
  DungaMember* member = (DungaMember*)annotation;
  NSString* identifier = [NSString stringWithFormat:@"Pin_%d", member.primaryKey];
  MKAnnotationView *av = (MKAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
  if(!av){
    av = [[[MKAnnotationView alloc] initWithAnnotation:member reuseIdentifier:identifier] autorelease];
  }
  av.image = member.iconImage;
  return av;
}

@end
