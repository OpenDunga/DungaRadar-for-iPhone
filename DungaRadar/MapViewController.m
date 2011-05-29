//
//  MapViewController.m
//  DungaRadar
//
//  Created by giginet on 11/05/29.
//  Copyright 2011 Kawaz. All rights reserved.
//

#import "MapViewController.h"
#import "DungaMember.h"

@implementation MapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)dealloc{
  [locationManager_ release];
  [super dealloc];
}

- (void)didReceiveMemoryWarning{
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad{
  [super viewDidLoad];
  locationManager_ = [[CLLocationManager alloc] init];
  locationManager_.delegate = self;
  [locationManager_ startUpdatingLocation];
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
  NSNumber* lat = [NSNumber numberWithDouble:newLocation.coordinate.latitude];
  NSNumber* log = [NSNumber numberWithDouble:newLocation.coordinate.longitude];
  NSLog(@"%f, %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
  NSDictionary* dictionary = [NSDictionary dictionaryWithObjectsAndKeys:lat, @"latitude", log, @"longitude", nil];
  DungaMember* me = [[DungaMember alloc] initWithDictionary:dictionary];
  [mapView_ addAnnotation:me];
}

- (MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
  DungaMember* member = (DungaMember*)annotation;
  NSString *PinIdentifier = [NSString stringWithFormat:@"Pin_%@", member.userName];
  MKAnnotationView *av =
  (MKAnnotationView*)
  [mapView dequeueReusableAnnotationViewWithIdentifier:PinIdentifier];
  if(av == nil){
    av = [[[MKAnnotationView alloc]
           initWithAnnotation:member reuseIdentifier:PinIdentifier] autorelease];
  }
  av.image = member.iconImage;
  return av;
}

@end
