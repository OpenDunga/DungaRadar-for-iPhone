//
//  MemberDetailViewController.m
//  DungaRadar
//
//  Created by  on 11/12/14.
//  Copyright (c) 2011年 Kawaz. All rights reserved.
//

#import "NSDictionary_JSONExtensions.h"

#import "MemberDetailViewController.h"
#import "DungaAsyncConnection.h"

@interface MemberDetailViewController()
- (void)onSucceedLoadingMemberHistroy:(NSURLConnection*)connection aConnection:(DungaAsyncConnection*)aConnection;
@end

@implementation MemberDetailViewController
@synthesize mapView=mapView_, member=member_;

const NSString* PATH_MEMBER_LOCATION_HISTORY = @"/api/location/history/%d";

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
  [self.view addSubview:mapView_];
}

- (void)viewDidUnload {
  [mapView_ release];
  [member_ release];
  [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self startLoadingHistory];
}

- (void)startLoadingHistory {
  DungaAsyncConnection* dac = [DungaAsyncConnection connection];
  dac.delegate = self;
  dac.finishSelector = @selector(onSucceedLoadingMemberHistroy:aConnection:);
  [dac connectToDungaWithAuth:[NSString stringWithFormat:(NSString*)PATH_MEMBER_LOCATION_HISTORY, self.member.primaryKey] 
                       params:nil 
                       method:@"GET"];
}

- (void)onSucceedLoadingMemberHistroy:(NSURLConnection *)connection aConnection:(DungaAsyncConnection *)aConnection {
  NSError* err;
  NSArray* histories = (NSArray*)[[NSDictionary dictionaryWithJSONString:aConnection.responseBody error:&err] objectForKey:@"entries"];
  if (histories) {
    self.member.history = histories;
    histories = [self.member historySinceDate:[NSDate dateWithTimeIntervalSinceNow:60* 60 * 24 * -3]];
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
  }
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
