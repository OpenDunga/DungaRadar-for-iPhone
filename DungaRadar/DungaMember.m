//
//  DungaMember.m
//  DungaRadar
//
//  Created by giginet on 11/05/29.
//  Copyright 2011 Kawaz. All rights reserved.
//

#import "DungaMember.h"


@implementation DungaMember
@synthesize dispName=dispName_, userName=userName_, iconImage=iconImage_;

- (id)initWithDictionary:(NSDictionary *)dictionary{
  [super init];
  userName_ = @"cig1n3t";
  dispName_ = @"ぎぎねっと";
  iconImageURL_ = [NSURL URLWithString:@"http://www.opendunga.net/thumb/8711916913726209.1.png"];
  iconImage_ = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:iconImageURL_]];
  longitude_ = [[dictionary objectForKey:@"longitude"] doubleValue];
  latitude_ = [[dictionary objectForKey:@"latitude"] doubleValue];
  return self;
}

- (CLLocationCoordinate2D)coordinate{
  CLLocationCoordinate2D coordinate;
  coordinate.longitude = longitude_;
  coordinate.latitude = latitude_;
  return coordinate;
}

- (NSString*)title{
  return dispName_;
}

- (void)dealloc{
  [userName_ release];
  [dispName_ release];
  [iconImage_ release];
  [super dealloc];
}

@end
