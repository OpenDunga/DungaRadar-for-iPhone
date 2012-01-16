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

@implementation DungaRadarAppDelegate
@synthesize window=_window;

@synthesize tabBarController=_tabBarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
  [[MemberManager instance] updateMembers];
  Me* me = [Me sharedMe];
  NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
  // set my location for last place.
  double longitude = [ud doubleForKey:@"lastLongitude"];
  double latitude = [ud doubleForKey:@"lastLatitude"];
  if(longitude && latitude) {
    me.location = [[[CLLocation alloc] initWithLatitude:latitude longitude:longitude] autorelease];
  }
  self.window.rootViewController = self.tabBarController;
  [self.window makeKeyAndVisible];
  NSDictionary* defaults = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"YES", KEY_FOR_ENABLE_ACTIVATION,
                            @"YES", KEY_FOR_ENABLE_BACKGROUND,
                            @"300", KEY_FOR_FREQUENCY,
                            @"YES", KEY_FOR_SAVEMODE,
                            @"1", KEY_FOR_HISTORY_RANGE, nil];
  [ud registerDefaults:defaults];
  [me updateLocationStatus];
  [me commit];
  return YES;
}

- (void)dealloc {
  [_window release];
  [_tabBarController release];
  [super dealloc];
}

@end
