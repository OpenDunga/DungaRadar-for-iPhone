//
//  MapViewController.m
//  DungaRadar
//
//  Created by giginet on 11/05/29.
//  Copyright 2011 Kawaz. All rights reserved.
//

#import "MapViewController.h"
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
  [super dealloc];
}

- (void)didReceiveMemoryWarning{
  [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad{
  [super viewDidLoad];
  MemberManager* manager = [MemberManager instance];
  Me* me = [Me sharedMe];
  for(DungaMember* member in manager.members) {
    if (me.primaryKey != member.primaryKey) {
      [mapView_ addAnnotation:member];
    }
  }
}

- (void)viewWillAppear:(BOOL)animated {
  Me* me = [Me sharedMe];
  MKCoordinateRegion cr = mapView_.region;
  cr.center = me.location.coordinate;
  cr.span.latitudeDelta = 0.03;
  cr.span.longitudeDelta = 0.03;
  [mapView_ setRegion:cr animated:NO];
  // Update my annotation
  [mapView_ removeAnnotation:me];
  [mapView_ addAnnotation:me];
  [[MemberManager instance] updateMembers];
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
