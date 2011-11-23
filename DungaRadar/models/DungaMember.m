//
//  DungaMember.m
//  DungaRadar
//
//  Created by giginet on 11/05/29.
//  Copyright 2011 Kawaz. All rights reserved.
//

#import "DungaMember.h"


@implementation DungaMember
@synthesize memberID=memberID_, memberDispName=memberDispName_, 
timestamp=timestamp_, iconImage=iconImage_, location=location_;

- (id)initWithUserData:(NSDictionary *)userData{
  //
  // {"latitude":43.0838878,"longitude":141.3531251,"memberDispName":"ちくだ","memberID":47,"registeredTime":1310288033071}
  [super init];
  if(self){
    memberID_ = [(NSNumber*)[userData objectForKey:@"memberID"] intValue];
    memberDispName_ = [(NSString*)[userData objectForKey:@"memberDispName"] retain];
    NSURL* iconImageURL = [NSURL URLWithString:@"http://www.kawaz.org/storage/profiles/giginet/icon_4.middle.png"];
    iconImage_ = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:iconImageURL]];
    location_ = [[CLLocation alloc] initWithLatitude:(CLLocationDegrees)[(NSNumber*)[userData objectForKey:@"latitude"] doubleValue] 
                                           longitude:(CLLocationDegrees)[(NSNumber*)[userData objectForKey:@"longitude"] doubleValue]];
    timestamp_ = [[NSDate alloc] initWithTimeIntervalSince1970:(NSTimeInterval)[(NSNumber*)[userData objectForKey:@"registeredTime"] intValue]];
  }
  return self;
}

- (void)dealloc{
  [memberDispName_ release];
  [timestamp_ release];
  [iconImage_ release];
  [location_ release];
  [super dealloc];
}

- (BOOL)isEqual:(id)object{
  DungaMember* member = (DungaMember*)object;
  return memberID_ == member.memberID;
}

@end
