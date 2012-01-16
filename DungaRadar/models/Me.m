//
//  Me.m
//  DungaRadar
//
//  Created by  on 11/12/12.
//  Copyright (c) 2011年 Kawaz. All rights reserved.
//

#import "NSDictionary_JSONExtensions.h"
#import "define.h"

#import "Me.h"
#import "DungaAsyncConnection.h"

const NSString* PATH_REGISTER_MEMBER_LOCATION = @"/api/location/register";

@interface Me()
- (void)onSucceedCommit:(NSURLConnection*)connection aConnection:(DungaAsyncConnection*)aConnection;
- (int)calcActivateFrequency;
@end

@implementation Me

static id _instance = nil;
static BOOL _willDelete = NO;

- (id)init {
  self = [super init];
  if (self) {
    locationManager_ = [[CLLocationManager alloc] init];
    locationManager_.delegate = self;
  }
  return self;
}

+ (id)sharedMe {
	@synchronized(self) {
		if(!_instance) {
			[[self alloc] init];
		}
	}
	return _instance;
}

+ (id)allocWithZone:(NSZone*)zone {
	@synchronized(self) {
		if(!_instance) {
			_instance = [super allocWithZone:zone];
			return _instance;
		}
	}
	return nil;
}

+ (void)deleteInstance {
	if(_instance) {
		@synchronized(_instance) {
			_willDelete = YES;
			[_instance release];
			_instance = nil;
			_willDelete = NO;
		}
	}
}

- (void)release {
  @synchronized(self){
		if(_willDelete){
			[super release];
		}
	}
}

- (id)copyWithZone:(NSZone*)zone { return self; }
- (id)retain { return self; }
- (unsigned)retainCount { return UINT_MAX; }
- (id)autorelease { return self; }

- (BOOL)commit {
  float lng = self.location.coordinate.longitude;
  float lat = self.location.coordinate.latitude;
  NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                          [NSString stringWithFormat:@"%f", lng], 
                          @"longitude", 
                          [NSString stringWithFormat:@"%f", lat],
                          @"latitude",
                          nil];
  DungaAsyncConnection* dac = [DungaAsyncConnection connection];
  dac.finishSelector = @selector(onSucceedCommit:aConnection:);
  dac.delegate = self;
  return [dac connectToDungaWithAuth:(NSString*)PATH_REGISTER_MEMBER_LOCATION 
                              params:params 
                              method:@"POST"];
}

- (void)updateFromJSON:(NSString *)json {
  NSError* err;
  NSDictionary* myData = [NSDictionary dictionaryWithJSONString:json error:&err];
  if (myData) {
    self.dispName = [myData objectForKey:@"dispName"];
    primaryKey_ = [(NSNumber*)[myData objectForKey:@"ID"] intValue];
  }
}

- (void)updateLocationStatus {
  NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
  if ([ud boolForKey:KEY_FOR_ENABLE_ACTIVATION]) {
    [locationManager_ startUpdatingLocation];
    if ([ud boolForKey:KEY_FOR_ENABLE_BACKGROUND]) {
      [locationManager_ startMonitoringSignificantLocationChanges];
    } else {
      [locationManager_ stopMonitoringSignificantLocationChanges];
    }
  } else {
    [locationManager_ stopUpdatingLocation];
  }
}

- (void)onSucceedCommit:(NSURLConnection *)connection aConnection:(DungaAsyncConnection *)aConnection {
  NSLog(@"おくりました");
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation 
           fromLocation:(CLLocation *)oldLocation{
  self.location = newLocation;
  NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
  [ud setDouble:newLocation.coordinate.longitude forKey:@"lastLongitude"];
  [ud setDouble:newLocation.coordinate.latitude forKey:@"lastLatitude"];
  double last = [ud doubleForKey:@"lastUpdate"];
  double now = [[NSDate date] timeIntervalSince1970];
  int frequency = [self calcActivateFrequency];
  if(!last || last + frequency < now) {
    [self commit];
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
