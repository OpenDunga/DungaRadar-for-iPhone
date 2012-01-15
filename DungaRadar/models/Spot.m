//
//  Spot.m
//  DungaRadar
//
//  Created by  on 11/12/11.
//  Copyright (c) 2011年 Kawaz. All rights reserved.
//

#import "CJSONDeserializer.h"
#import "NSDictionary_JSONExtensions.h"
#import "Spot.h"
#import "DungaAsyncConnection.h"

@implementation Spot
@synthesize primaryKey=primaryKey_, scope=scope_, autoInform=autoInform_, 
registeredMemberId=registeredMemberId_, dispName=dispName_, location=location_;

- (id)init {
  self = [super init];
  if(self) {
    NSString* path = [[NSBundle mainBundle] pathForResource:@"scopes" ofType:@"plist"];
    NSDictionary* spots = [[NSDictionary dictionaryWithContentsOfFile:path] objectForKey:@"root"];
    primaryKey_ = -1;
    scope_ = [(NSNumber*)[[spots allValues] objectAtIndex:0] intValue];
    autoInform_ = NO;
    dispName_ = [[NSString alloc] init];
    location_ = [[CLLocation alloc] init];
  }
  return self;
}

- (void)dealloc {
  [dispName_ release];
  [location_ release];
  [super dealloc];
}

- (id)initWithLocation:(CLLocation *)location {
  self = [self init];
  if(self) {
    self.location = location;
  }
  return self;
}

- (id)initWithInfo:(NSDictionary *)dictionary {
  self = [self init];
  if(self) {
    primaryKey_ = [(NSNumber*)[dictionary objectForKey:@"ID"] intValue];
    self.scope = [(NSNumber*)[dictionary objectForKey:@"scope"] intValue];
    self.registeredMemberId = [(NSNumber*)[dictionary objectForKey:@"registeredMemberID"] intValue];
    self.autoInform = [(NSString*)[dictionary objectForKey:@"autoInform"] isEqual:@"true"];
    self.dispName = (NSString*)[dictionary objectForKey:@"dispName"];
    double lat = [(NSNumber*)[dictionary objectForKey:@"latitude"] doubleValue];
    double lng = [(NSNumber*)[dictionary objectForKey:@"longitude"] doubleValue];
    self.location = [[CLLocation alloc] initWithLatitude:lat longitude:lng];
  }
  return self;
}

- (id)initWithJson:(NSString *)json {
  NSError* err;
  NSDictionary* spot = [NSDictionary dictionaryWithJSONString:json error:&err];
  self = [self initWithInfo:spot];
  return self;
}
     
- (NSDictionary*)dump {
  /**
   * Dumps the spot into a dictionary formatted for OpenDunga Web API.
   */
  return [NSDictionary dictionaryWithObjectsAndKeys:
          [NSString stringWithFormat:@"%d", self.scope], @"scope",
          self.autoInform ? @"true" : @"false", @"auto_inform",
          self.dispName, @"disp_name",
          [NSString stringWithFormat:@"%lf", self.location.coordinate.latitude], @"latitude",
          [NSString stringWithFormat:@"%lf", self.location.coordinate.longitude], @"longitude", 
          nil];
}

- (int)scopeIndex {
  NSString* path = [[NSBundle mainBundle] pathForResource:@"spots" ofType:@"plist"];
  NSDictionary* spots = [[NSDictionary dictionaryWithContentsOfFile:path] objectForKey:@"root"];
  int count = [spots count];
  for(int i = 0; i < count; ++i) {
    if([(NSNumber*)[[spots allValues] objectAtIndex:i] intValue] == self.scope) {
      return i;
    }
  }
  return count;
}

- (NSString*)scopeName {
  /**
   * Returns a scopeName in scopes.plist via self.scope.
   */
  NSString* path = [[NSBundle mainBundle] pathForResource:@"spots" ofType:@"plist"];
  NSDictionary* spots = [[NSDictionary dictionaryWithContentsOfFile:path] objectForKey:@"root"];
  return (NSString*)[[spots allKeys] objectAtIndex:self.scopeIndex];
}

- (CLLocationCoordinate2D)coordinate {
  return self.location.coordinate;
}

- (NSString*)title {
  return self.dispName;
}

- (BOOL)isEqual:(id)object {
  Spot* spot = (Spot*)object;
  return spot.primaryKey == self.primaryKey;
}

@end
