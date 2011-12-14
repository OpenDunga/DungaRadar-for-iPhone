//
//  MapViewController.m
//  DungaRadar
//
//  Created by giginet on 11/05/29.
//  Copyright 2011 Kawaz. All rights reserved.
//

#import "MapViewController.h"
#import "HttpConnection.h"
#import "Me.h"
#import "MemberManager.h"

@implementation MapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
  }
  return self;
}

- (void)dealloc{
  [locationManager_ release];
  [super dealloc];
}

- (void)didReceiveMemoryWarning{
  [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad{
  [super viewDidLoad];
  initialized_ = NO;
  locationManager_ = [[CLLocationManager alloc] init];
  locationManager_.delegate = self;
  [locationManager_ startUpdatingLocation];
  [locationManager_ startMonitoringSignificantLocationChanges];
  MemberManager* manager = [MemberManager instance];
  for(DungaMember* member in manager.members) {
    [mapView_ addAnnotation:member];
  }
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
}

- (void)viewDidUnload{
  [mapView_ release];
  [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation 
           fromLocation:(CLLocation *)oldLocation{
  Me* me = [Me sharedMe];
  me.location = newLocation;
  NSLog(@"%@", newLocation);
  [me commit];
  MKCoordinateRegion cr = mapView_.region;
  cr.center = me.location.coordinate;
  cr.span.latitudeDelta = 0.03;
  cr.span.longitudeDelta = 0.03;
  [mapView_ setRegion:cr animated:NO];
  // Update my annotation
  [mapView_ removeAnnotation:me];
  [mapView_ addAnnotation:me];
}

- (MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
  DungaMember* member = (DungaMember*)annotation;
  NSString* identifier = [NSString stringWithFormat:@"Pin_%@", member.dispName];
  MKAnnotationView *av = (MKAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
  if(!av){
    av = [[[MKAnnotationView alloc]
           initWithAnnotation:member reuseIdentifier:identifier] autorelease];
  }
  av.image = member.iconImage;
  return av;
}

@end
