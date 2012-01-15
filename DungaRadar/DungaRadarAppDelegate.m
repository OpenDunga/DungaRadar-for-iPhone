//
//  DungaRadarAppDelegate.m
//  DungaRadar
//
//  Created by giginet on 11/05/29.
//  Copyright 2011 Kawaz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DungaRadarAppDelegate.h"
#import "MemberManager.h"
#import "Me.h"
#import "define.h"

@interface DungaRadarAppDelegate()
- (int)calcActivateFrequency;
@end

@implementation DungaRadarAppDelegate
@synthesize window=_window;

@synthesize tabBarController=_tabBarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
  [[MemberManager instance] updateMembers];
  locationManager_ = [[CLLocationManager alloc] init];
  locationManager_.delegate = self;
  [locationManager_ startUpdatingLocation];
  [locationManager_ startMonitoringSignificantLocationChanges];
  // set my location for last place.
  NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
  double longitude = [ud doubleForKey:@"lastLongitude"];
  double latitude = [ud doubleForKey:@"lastLatitude"];
  if(longitude && latitude) {
    Me* me = [Me sharedMe];
    me.location = [[[CLLocation alloc] initWithLatitude:latitude longitude:longitude] autorelease];
  }
  self.window.rootViewController = self.tabBarController;
  [self.window makeKeyAndVisible];
  NSDictionary* defaults = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"300", KEY_FOR_FREQUENCY,
                            @"YES", KEY_FOR_SAVEMODE, nil];
  [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
  return YES;
}

- (void)dealloc {
  [_window release];
  [_tabBarController release];
    [super dealloc];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation 
           fromLocation:(CLLocation *)oldLocation{
  Me* me = [Me sharedMe];
  me.location = newLocation;
  NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
  [ud setDouble:newLocation.coordinate.longitude forKey:@"lastLongitude"];
  [ud setDouble:newLocation.coordinate.latitude forKey:@"lastLatitude"];
  double last = [ud doubleForKey:@"lastUpdate"];
  double now = [[NSDate date] timeIntervalSince1970];
  int frequency = [self calcActivateFrequency];
  if(!last || last + frequency < now) {
    [me commit];
    [ud setDouble:now forKey:@"lastUpdate"];
  }
}

- (int)calcActivateFrequency {
  int frequency = [[NSUserDefaults standardUserDefaults] integerForKey:KEY_FOR_FREQUENCY];
  BOOL saveMode = [[NSUserDefaults standardUserDefaults] boolForKey:KEY_FOR_SAVEMODE];
  if(!saveMode) return frequency;
  UIDevice* device = [UIDevice currentDevice];
  device.batteryMonitoringEnabled = YES;
  if (device.batteryState == UIDeviceBatteryStateCharging || 
      device.batteryState == UIDeviceBatteryStateFull || 
      device.batteryLevel == -1) {
    return frequency;
  } else if (0.2 < device.batteryLevel && device.batteryLevel < 0.5) {
    return frequency * 2;
  } else if (device.batteryLevel <= 0.2) {
    return INT_MAX;
  }
  return frequency;
}

@end
