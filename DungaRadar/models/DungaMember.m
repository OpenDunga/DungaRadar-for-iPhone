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

@implementation DungaMember
@synthesize primaryKey=primaryKey_, dispName=dispName_, 
timestamp=timestamp_, iconImage=iconImage_, location=location_;

- (id)initWithUserData:(NSDictionary *)userData{
  //
  // {"latitude":43.0838878,"longitude":141.3531251,"dispName":"ちくだ","memberID":47,"registeredTime":1310288033071}
  [super init];
  if(self){
    primaryKey_ = [(NSNumber*)[userData objectForKey:@"primaryKey"] intValue];
    dispName_ = [(NSString*)[userData objectForKey:@"memberDispName"] retain];
    iconImage_ = nil;
    location_ = [[CLLocation alloc] initWithLatitude:(CLLocationDegrees)[(NSNumber*)[userData objectForKey:@"latitude"] doubleValue] 
                                           longitude:(CLLocationDegrees)[(NSNumber*)[userData objectForKey:@"longitude"] doubleValue]];
    timestamp_ = [[NSDate alloc] initWithTimeIntervalSince1970:(NSTimeInterval)[(NSNumber*)[userData objectForKey:@"registeredTime"] intValue]];
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

- (UIImage*)iconImage{
  if(iconImage_){
    return iconImage_;
  }else{
    if([DungaRegister authWithStorage]){
      NSData* icon = (NSData*)[[DungaRegister connectToDunga:[NSString stringWithFormat:@"%@%d", 
                                                              (NSString*)PATH_MEMBER_PROFILE_ICON_LOCATION, 
                                                              primaryKey_] 
                                                      params:nil 
                                                      method:@"GET"] 
                               objectForKey:@"data"];
      UIImage* origin = [[UIImage alloc] initWithData:icon];
      iconImage_ = [origin resize:CGSizeMake(32, 32) aspect:YES];
      return iconImage_;
    }
    return nil;
  }
  return nil;
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
