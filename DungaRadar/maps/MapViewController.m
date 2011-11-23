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
#import "EncryptExtention.h"
#import "DungaMember.h"

const NSString* PATH_ALL_MEMBER_LOCATION = @"/api/location/all";

@interface MapViewController()
- (void)addMember:(DungaMember*)member;
- (NSArray*)getAllMembers;
- (BOOL)registerLocation:(double)lng latitude:(double)lat;
@end

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
  NSArray* members = [self getAllMembers];
  for(DungaMember* member in members){
    [self addMember:member];
  }
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
  NSNumber* lng = [NSNumber numberWithDouble:newLocation.coordinate.longitude];
  NSDictionary* dictionary = [NSDictionary dictionaryWithObjectsAndKeys:lat, @"latitude", lng, @"longitude", nil];
  
  DungaMember* me = [[DungaMember alloc] initWithUserData:dictionary];
  if(!initialized_){
    // 縮尺を指定
    [self addMember:me];
  }else{
    [mapView_ removeAnnotation:me];
  }
}

- (MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
  DungaMember* member = (DungaMember*)annotation;
  NSString* identifier = [NSString stringWithFormat:@"Pin_%@", member.memberDispName];
  MKAnnotationView *av = (MKAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
  if(!av){
    av = [[[MKAnnotationView alloc]
           initWithAnnotation:member reuseIdentifier:identifier] autorelease];
  }
  CGSize newSize = CGSizeMake(32, 32);
  UIGraphicsBeginImageContext(newSize);
  [member.iconImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
  UIImage* resizedImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  av.image = resizedImage;
  return av;
}

- (void)addMember:(DungaMember *)member{
  MKCoordinateRegion cr = mapView_.region;
  cr.center = [member coordinate];
  cr.span.latitudeDelta = 0.01;
  cr.span.longitudeDelta = 0.01;
  [mapView_ setRegion:cr animated:NO];
  initialized_ = YES;
  [mapView_ addAnnotation:member];
}

- (NSArray*)getAllMembers{
  HttpConnection* hc = [HttpConnection instance];
  NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
  if([hc auth:(NSString*)[ud objectForKey:@"username"] 
 passwordHash:[(NSString*)[ud objectForKey:@"password"] toMD5]]){
    NSError* err;
    NSDictionary* res = [NSDictionary dictionaryWithJSONString:[hc get:(NSString*)PATH_ALL_MEMBER_LOCATION 
                                                                    params:nil]
                                                            error:&err];
    NSArray* memberInfos = (NSArray*)[res objectForKey:@"entries"];
    NSMutableArray* members = [NSMutableArray array];
    for(NSDictionary* userData in memberInfos){
      DungaMember* member = [[DungaMember alloc] initWithUserData:userData];
      [members addObject:member];
    }
    return members;
  }
  return [NSArray array];
}

- (BOOL)registerLocation:(double)lng latitude:(double)lat{
  return NO;
}

@end
