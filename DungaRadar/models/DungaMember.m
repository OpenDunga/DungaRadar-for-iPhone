//
//  DungaMember.m
//  DungaRadar
//
//  Created by giginet on 11/05/29.
//  Copyright 2011 Kawaz. All rights reserved.
//

#import "UIImageExtention.h"
#import "HttpConnection.h"
#import "DungaRegister.h"
#import "DungaMember.h"

const NSString* PATH_MEMBER_PROFILE_ICON_LOCATION	= @"/api/profile/icon/";

@interface DungaMember()
- (UIImage*)loadIconImage;
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

- (id)initWithUserData:(NSDictionary *)userData{
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

- (void)dealloc{
  [dispName_ release];
  [timestamp_ release];
  [iconImage_ release];
  [location_ release];
  [super dealloc];
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

- (UIImage*)loadIconImage {
  if([DungaRegister authWithStorage]){
    NSData* icon = (NSData*)[[DungaRegister connectToDunga:[NSString stringWithFormat:@"%@%d", 
                                                            (NSString*)PATH_MEMBER_PROFILE_ICON_LOCATION, 
                                                            primaryKey_] 
                                                    params:nil 
                                                    method:@"GET"] 
                             objectForKey:@"data"];
    UIImage* origin = [[[UIImage alloc] initWithData:icon] autorelease];
    return [origin resize:CGSizeMake(32, 32) aspect:YES];
  }
  return nil;
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

- (UIImage*)iconImage {
  if(iconImage_ == nil) {
    self.iconImage = [self loadIconImage];
  }
  return iconImage_;
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
