//
//  MemberManager.m
//  DungaRadar
//
//  Created by  on 11/12/14.
//  Copyright (c) 2011年 Kawaz. All rights reserved.
//

#import "NSDictionary_JSONExtensions.h"
#import "MemberManager.h"
#import "DungaAsyncConnection.h"
#import "Me.h"

const NSString* PATH_ALL_MEMBER_LOCATION = @"/api/location/all";

@interface MemberManager()
- (NSMutableArray*)membersFromInfo:(NSArray*)userInfos;
- (NSMutableArray*)membersFromStorage;
- (void)onSucceedLoadingMembers:(NSURLConnection*)connection aConnection:(DungaAsyncConnection*)aConnection;
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
    self.members = [self.members sortedArrayUsingSelector:@selector(sortByTimestamp:)];
  }else {
    DungaAsyncConnection* dac = [DungaAsyncConnection connection];
    dac.delegate = self;
    dac.finishSelector = @selector(onSucceedLoadingMembers:aConnection:);
    [dac connectToDungaWithAuth:(NSString*)PATH_ALL_MEMBER_LOCATION 
                         params:nil 
                         method:@"GET"];
  }
}

- (NSMutableArray*)membersFromInfo:(NSArray *)userInfos {
  NSMutableArray* members = [NSMutableArray array];
  for(NSDictionary* userInfo in userInfos){
    DungaMember* member = [[[DungaMember alloc] initWithUserData:userInfo] autorelease];
    [members addObject:member];
  }
  return members;
}

- (NSMutableArray*)membersFromStorage {
  NSMutableArray* members = [NSMutableArray array];
  NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
  NSArray* memberData = [ud arrayForKey:@"members"];
  if (!memberData) return members;
  for (NSData* data in memberData) {
    DungaMember* member = (DungaMember*)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (!member.primaryKey) continue;
    [members addObject:member];
  }
  return members;
}

- (void)onSucceedLoadingMembers:(NSURLConnection *)connection aConnection:(DungaAsyncConnection *)aConnection {
  NSError* err;
  NSDictionary* res = [NSDictionary dictionaryWithJSONString:aConnection.responseBody
                                                       error:&err];
  NSArray* memberInfos = (NSArray*)[res objectForKey:@"entries"];
  self.members = [self membersFromInfo:memberInfos];
  self.members = [self.members sortedArrayUsingSelector:@selector(sortByTimestamp:)];
  NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
  NSMutableArray* saveMembers = [NSMutableArray array];
  for (DungaMember* member in self.members) {
    if (!member.primaryKey) continue;
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:member];
    [saveMembers addObject:data];
  }
  [ud setObject:saveMembers forKey:@"members"];
}

@end
