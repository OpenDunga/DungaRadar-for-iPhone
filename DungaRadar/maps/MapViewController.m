//
//  MapViewController.m
//  DungaRadar
//
//  Created by giginet on 11/05/29.
//  Copyright 2011 Kawaz. All rights reserved.
//

#import "NSDictionary_JSONExtensions.h"

#import "MapViewController.h"
#import "HttpConnection.h"
#import "DungaRegister.h"
#import "Me.h"

const NSString* PATH_ALL_MEMBER_LOCATION = @"/api/location/all";

@interface MapViewController()
- (void)addMember:(DungaMember*)member;
- (NSArray*)getAllMembers;
@end

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
  //[locationManager_ startUpdatingLocation];
  //[locationManager_ startMonitoringSignificantLocationChanges];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  /*[mapView_ removeAnnotations:[mapView_ annotations]];
  NSArray* members = [self getAllMembers];
  for(DungaMember* member in members){
    [self addMember:member];
  }*/
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
  [me commit];
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

- (void)addMember:(DungaMember *)member{
  MKCoordinateRegion cr = mapView_.region;
  cr.center = [member coordinate];
  cr.span.latitudeDelta = 0.01;
  cr.span.longitudeDelta = 0.01;
  [mapView_ setRegion:cr animated:NO];
  [mapView_ addAnnotation:member];
}

- (NSArray*)getAllMembers{
  if([DungaRegister authWithStorage]){
    NSError* err;
    NSDictionary* res = [NSDictionary dictionaryWithJSONString:[DungaRegister get:(NSString*)PATH_ALL_MEMBER_LOCATION 
                                                                           params:nil]
                                                            error:&err];
    NSArray* memberInfos = (NSArray*)[res objectForKey:@"entries"];
    NSMutableArray* members = [NSMutableArray array];
    for(NSDictionary* userData in memberInfos){
      DungaMember* member;
      member = [[DungaMember alloc] initWithUserData:userData];
      [members addObject:member];
    }
    return members;
  }
  return [NSArray array];
}

@end
