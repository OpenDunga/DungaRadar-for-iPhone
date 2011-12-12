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
#import "DungaRegister.h"

const NSString* PATH_SPOT_CREATION = @"/api/location/venue/new";

@implementation Spot
@synthesize primaryKey=primaryKey_, scope=scope_, autoInform=autoInform_, 
dispName=dispName_, location=location_;

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

- (id)initWithJson:(NSString *)json {
  self = [self init];
  if(self) {
    NSError* err;
    NSDictionary* spot = [NSDictionary dictionaryWithJSONString:json error:&err];
    primaryKey_ = [(NSNumber*)[spot objectForKey:@"ID"] intValue];
    scope_ = [(NSNumber*)[spot objectForKey:@"scope"] intValue];
    autoInform_ = [(NSString*)[spot objectForKey:@"auto_inform"] isEqual:@"true"];
    dispName_ = (NSString*)[spot objectForKey:@"disp_name"];
    double lat = [(NSNumber*)[spot objectForKey:@"latitude"] doubleValue];
    double lng = [(NSNumber*)[spot objectForKey:@"longitude"] doubleValue];
    location_ = [[CLLocation alloc] initWithLatitude:lat longitude:lng];
  }
  return self;
}

- (NSDictionary*)commit {
  /**
   * Commits spot data to server.
   * Returns a dictionary contains two values.
   *     succeed(NSNumber) success or not
   *     message(NSString) message
   */
  NSMutableDictionary* result = [NSMutableDictionary dictionary];
  if([DungaRegister authWithStorage]) {
    NSDictionary* response = [DungaRegister connectToDunga:(NSString*)PATH_SPOT_CREATION params:[self dump] method:@"POST"];
    NSHTTPURLResponse* res = (NSHTTPURLResponse*)[response objectForKey:@"response"];
    [result setObject:[NSNumber numberWithBool:res.statusCode == 200] forKey:@"succeed"];
    NSData* json = [response objectForKey:@"data"];
    NSError* err;
    NSString* message = [[[CJSONDeserializer deserializer] deserializeAsArray:json error:&err] objectAtIndex:0];
    [result setObject:message forKey:@"message"];
    return result;
  }
  [result setObject:[NSNumber numberWithBool:NO] forKey:@"succeed"];
  [result setObject:@"ログインに失敗しました" forKey:@"message"];
  return result;
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
          [NSString stringWithFormat:@"%lf", self.location.coordinate.latitude], @"longitude", 
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
