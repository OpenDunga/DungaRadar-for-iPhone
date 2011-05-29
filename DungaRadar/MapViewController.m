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
  initialized_ = NO;
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
  NSDictionary* dictionary = [NSDictionary dictionaryWithObjectsAndKeys:lat, @"latitude", log, @"longitude", nil];
  DungaMember* me = [[DungaMember alloc] initWithDictionary:dictionary];
  if(!initialized_){
    // 縮尺を指定
    MKCoordinateRegion cr = mapView_.region;
    cr.center = [me coordinate];
    cr.span.latitudeDelta = 0.01;
    cr.span.longitudeDelta = 0.01;
    [mapView_ setRegion:cr animated:NO];
    initialized_ = YES;
  }else{
    [mapView_ removeAnnotation:me];
  }
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
  CGSize newSize = CGSizeMake(32, 32);
  UIGraphicsBeginImageContext(newSize);
  [member.iconImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
  UIImage* resizedImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  av.image = resizedImage;
  return av;
}

@end
