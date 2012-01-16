//
//  DungaMember.m
//  DungaRadar
//
//  Created by giginet on 11/05/29.
//  Copyright 2011 Kawaz. All rights reserved.
//

#import "RelativeDate.h"
#import "UIImageExtention.h"
#import "DungaAsyncConnection.h"
#import "DungaMember.h"

const NSString* PATH_MEMBER_PROFILE_ICON_LOCATION	= @"/api/profile/icon/";

@interface DungaMember()
- (UIImage*)loadImageFromStorage;
- (void)onSucceedLoadingImage:(NSURLConnection*)connection aConnection:(DungaAsyncConnection*)aConnection;
@end

@implementation DungaMember
@synthesize primaryKey=primaryKey_, dispName=dispName_, 
timestamp=timestamp_, iconImage=iconImage_, location=location_, history = history_;

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
    self.location = [[CLLocation alloc] initWithLatitude:(CLLocationDegrees)[(NSNumber*)[userData objectForKey:@"latitude"] doubleValue] 
                                           longitude:(CLLocationDegrees)[(NSNumber*)[userData objectForKey:@"longitude"] doubleValue]];
    double epoch = [(NSNumber*)[userData objectForKey:@"registeredTime"] doubleValue] / 1000;
    self.timestamp = [[NSDate alloc] initWithTimeIntervalSince1970:epoch];
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
  [aCoder encodeObject:[NSNumber numberWithInt:primaryKey_] forKey:@"primaryKey"];
  [aCoder encodeObject:dispName_ forKey:@"dispName"];
  [aCoder encodeObject:timestamp_ forKey:@"timestamp"];
  NSData* imageData = UIImagePNGRepresentation(self.iconImage);
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

- (void)dealloc {
  [dispName_ release];
  [timestamp_ release];
  [iconImage_ release];
  [location_ release];
  [history_ release];
  [super dealloc];
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

- (NSString*)descriptionDetailFromMember:(DungaMember*)member {
  NSString* date = [NSString stringWithFormat:@"%@ ago", [self.timestamp relativeDate]];
  CLLocationDistance distance = [self.location distanceFromLocation:member.location];
  if ((float)distance < 1000) {
    return [NSString stringWithFormat:@"%@ %.1f m", date, distance];
  }
  return [NSString stringWithFormat:@"%@ %.3f km", date, distance / 1000];
}

- (NSArray*)historySinceDate:(NSDate *)date {
  if (!history_) return [NSArray array];
  double since = [date timeIntervalSince1970];
  NSMutableArray* results = [NSMutableArray array];
  for(NSDictionary* history in history_) {
    double epoch = [(NSNumber*)[history objectForKey:@"registeredTime"] doubleValue] / 1000;
    if(epoch < since) break;
    [results addObject:history];
  }
  return results;
}

- (void)startLoadingIcon {
  DungaAsyncConnection* dac = [DungaAsyncConnection connection];
  dac.delegate = self;
  dac.finishSelector = @selector(onSucceedLoadingImage:aConnection:);
  [dac connectToDungaWithAuth:[NSString stringWithFormat:@"%@%d", 
                               (NSString*)PATH_MEMBER_PROFILE_ICON_LOCATION, 
                               self.primaryKey]  
                       params:nil 
                       method:@"GET"];
}

- (UIImage*)iconImage {
  if(iconImage_ == nil) {
    UIImage* storage = [self loadImageFromStorage];
    if (storage) {
      iconImage_ = [storage retain];
    } else if (self.primaryKey) {
      [self startLoadingIcon];
    }
  }
  return iconImage_;
}

- (UIImage*)loadImageFromStorage {
  NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
  NSMutableDictionary* imageIcons = [ud objectForKey:@"imageIcons"];
  NSData* imageData = [imageIcons objectForKey:[NSString stringWithFormat:@"%d", self.primaryKey]];
  if (imageData) {
    return [[[UIImage alloc] initWithData:imageData] autorelease];
  }
  return nil;
}

- (void)onSucceedLoadingImage:(NSURLConnection *)connection aConnection:(DungaAsyncConnection *)aConnection {
  self.iconImage = [[[UIImage alloc] initWithData:aConnection.data] autorelease];
  NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
  NSMutableDictionary* imageIcons = [NSMutableDictionary dictionaryWithDictionary:[ud objectForKey:@"imageIcons"]];
  if (!imageIcons) {
    imageIcons = [NSMutableDictionary dictionary];
  }
  NSData* imageData = UIImagePNGRepresentation(self.iconImage);
  [imageIcons setObject:imageData forKey:[NSString stringWithFormat:@"%d", self.primaryKey]];
  [ud setObject:imageIcons forKey:@"imageIcons"];
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

- (NSString*)description {
  return [NSString stringWithFormat:@"%@(%d)", self.dispName, self.primaryKey];
}

@end
