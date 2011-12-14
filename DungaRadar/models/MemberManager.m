//
//  MemberManager.m
//  DungaRadar
//
//  Created by  on 11/12/14.
//  Copyright (c) 2011年 Kawaz. All rights reserved.
//

#import "NSDictionary_JSONExtensions.h"
#import "MemberManager.h"
#import "DungaRegister.h"
#import "Me.h"

const NSString* PATH_ALL_MEMBER_LOCATION = @"/api/location/all";

@interface MemberManager()
- (NSMutableArray*)membersFromInfo:(NSArray*)userInfos;
- (NSMutableArray*)membersFromStorage;
- (NSMutableArray*)membersFromAPI;
@end

@implementation MemberManager
@synthesize members=members_;

- (id)init {
  self = [super init];
  if(self) {
    self.members = [NSArray array];
  }
  return self;
}

- (void)dealloc {
  [members_ release];
  [super dealloc];
}

- (void)updateMembers {
  NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
  NSArray* cache = [ud objectForKey:@"members"];
  if([self.members count] == 0 && cache && [cache count] != 0) {
    self.members = [self membersFromStorage];
  }else {
    self.members = [self membersFromAPI];
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:self.members forKey:@"members"];
  }
  self.members = [self.members sortedArrayUsingSelector:@selector(sortByTimestamp:)];
}

- (NSMutableArray*)membersFromInfo:(NSArray *)userInfos {
  Me* me = [Me sharedMe];
  NSMutableArray* members = [NSMutableArray array];
  for(NSDictionary* userInfo in userInfos){
    if ([me.dispName isEqual:[userInfo objectForKey:@"dispName"]]){
      [members addObject:me];
    } else {
      DungaMember* member = [[[DungaMember alloc] initWithUserData:userInfo] autorelease];
      [members addObject:member];
    }
  }
  return members;
}

- (NSMutableArray*)membersFromStorage {
  NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
  return [self membersFromInfo:[ud arrayForKey:@"members"]];
}

- (NSMutableArray*)membersFromAPI {
  if([DungaRegister authWithStorage]) {
    NSError* err;
    NSDictionary* res = [NSDictionary dictionaryWithJSONString:[DungaRegister get:(NSString*)PATH_ALL_MEMBER_LOCATION 
                                                                           params:nil]
                                                         error:&err];
    NSArray* memberInfos = (NSArray*)[res objectForKey:@"entries"];
    [[NSUserDefaults standardUserDefaults] setObject:memberInfos forKey:@"members"];
    return [self membersFromInfo:memberInfos];
  }
  return [NSArray array];
}

@end
