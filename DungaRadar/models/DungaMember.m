//
//  DungaMember.m
//  DungaRadar
//
//  Created by giginet on 11/05/29.
//  Copyright 2011 Kawaz. All rights reserved.
//

#import "NSDictionary_JSONExtensions.h"
#import "RelativeDate.h"
#import "UIImageExtention.h"
#import "DungaAsyncConnection.h"
#import "DungaMember.h"

const NSString* PATH_MEMBER_PROFILE_ICON_LOCATION	= @"/api/profile/icon/";
const NSString* PATH_MEMBER_LOCATION_HISTORY = @"/api/location/history/%d";

@interface DungaMember()
- (void)onSucceedLoadingImage:(NSURLConnection*)connection aConnection:(DungaAsyncConnection*)aConnection;
@end

@implementation DungaMember
@synthesize primaryKey=primaryKey_, dispName=dispName_, 
timestamp=timestamp_, iconImage=iconImage_, location=location_;

- (id)init {
  self = [super init];
  if(self) {
    primaryKey_ = 0;
    dispName_ = @"";
    iconImage_ = nil;
    location_ = [[CLLocation alloc] init];
    timestamp_ = [[NSDate alloc] init];
  }
  return self;
}

- (id)initWithUserData:(NSDictionary *)userData {
  //
  // {"latitude":43.0838878,"longitude":141.3531251,"dispName":"ちくだ","memberID":47,"registeredTime":1310288033071}
  self = [super init];
  if(self){
    primaryKey_ = [(NSNumber*)[userData objectForKey:@"memberID"] intValue];
    self.dispName = [(NSString*)[userData objectForKey:@"memberDispName"] retain];
    self.iconImage = nil;
    self.location = [[CLLocation alloc] initWithLatitude:(CLLocationDegrees)[(NSNumber*)[userData objectForKey:@"latitude"] doubleValue] 
                                           longitude:(CLLocationDegrees)[(NSNumber*)[userData objectForKey:@"longitude"] doubleValue]];
    double epoch = [(NSNumber*)[userData objectForKey:@"registeredTime"] doubleValue] / 1000;
    self.timestamp = [[NSDate alloc] initWithTimeIntervalSince1970:epoch];
  }
  return self;
}

- (void)dealloc {
  [dispName_ release];
  [timestamp_ release];
  [iconImage_ release];
  [location_ release];
  [super dealloc];
}

- (NSString*)descriptionDetailFromMember:(DungaMember*)member {
  NSString* date = [NSString stringWithFormat:@"%@ ago", [self.timestamp relativeDate]];
  CLLocationDistance distance = [self.location distanceFromLocation:member.location];
  if ((float)distance < 1000) {
    return [NSString stringWithFormat:@"%@ %.1f m", date, distance];
  }
  return [NSString stringWithFormat:@"%@ %.3f km", date, distance / 1000];
}

- (NSComparisonResult)sortByTimestamp:(DungaMember*)otherMember {
  NSComparisonResult result = [self.timestamp compare:otherMember.timestamp];
  if(result == NSOrderedAscending) {
    return NSOrderedDescending;
  }else {
    return NSOrderedAscending;
  }
  return result;
}

- (NSArray*)historySinceDate:(NSDate *)date {
  /*if([DungaRegister authWithStorage]){
    NSString* json = [DungaRegister get:[NSString stringWithFormat:(NSString*)PATH_MEMBER_LOCATION_HISTORY, primaryKey_] 
                                 params:nil];
    NSError* err;
    NSArray* histories = (NSArray*)[[NSDictionary dictionaryWithJSONString:json error:&err] objectForKey:@"entries"];
    double since = [date timeIntervalSince1970];
    NSMutableArray* results = [NSMutableArray array];
    for(NSDictionary* history in histories) {
      double epoch = [(NSNumber*)[history objectForKey:@"registeredTime"] doubleValue] / 1000;
      if(epoch < since) break;
      [results addObject:history];
    }
    return results;
  }*/
  return [NSArray array];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
  [aCoder encodeObject:[NSNumber numberWithInt:primaryKey_] forKey:@"primaryKey"];
  [aCoder encodeObject:dispName_ forKey:@"dispName"];
  [aCoder encodeObject:timestamp_ forKey:@"timestamp"];
  NSData* imageData = UIImagePNGRepresentation(iconImage_);
  [aCoder encodeObject:imageData forKey:@"iconImage"];
  [aCoder encodeObject:location_ forKey:@"location"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super init];
  if(self) {
    primaryKey_ = [(NSNumber*)[aDecoder decodeObjectForKey:@"primaryKey"] intValue];
    self.dispName = [aDecoder decodeObjectForKey:@"dispName"];
    self.timestamp = [aDecoder decodeObjectForKey:@"timestamp"];
    self.iconImage = [UIImage imageWithData:[aDecoder decodeObjectForKey:@"iconImage"]];
    self.location = [aDecoder decodeObjectForKey:@"location"];
  }
  return self;
}

- (UIImage*)iconImage {
  if(iconImage_ == nil) {
    DungaAsyncConnection* dac = [DungaAsyncConnection connection];
    dac.delegate = self;
    dac.finishSelector = @selector(onSucceedLoadingImage:aConnection:);
    [dac connectToDungaWithAuth:[NSString stringWithFormat:@"%@%d", 
                                 (NSString*)PATH_MEMBER_PROFILE_ICON_LOCATION, 
                                 primaryKey_]  
                         params:nil 
                         method:@"GET"];
  }
  return iconImage_;
}

- (void)onSucceedLoadingImage:(NSURLConnection *)connection aConnection:(DungaAsyncConnection *)aConnection {
  self.iconImage = [[[UIImage alloc] initWithData:aConnection.data] autorelease];
}

- (CLLocationCoordinate2D)coordinate{
  return self.location.coordinate;
}

- (NSString*)title{
  return self.dispName;
}

- (BOOL)isEqual:(id)object{
  DungaMember* member = (DungaMember*)object;
  return primaryKey_ == member.primaryKey;
}

@end
