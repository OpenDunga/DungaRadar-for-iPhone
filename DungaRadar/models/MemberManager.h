//
//  MemberManager.h
//  DungaRadar
//
//  Created by  on 11/12/14.
//  Copyright (c) 2011年 Kawaz. All rights reserved.
//

#import "KWSingleton.h"

@interface MemberManager : KWSingleton {
  NSArray* members_;
}

- (void)updateMembers;

@property(readwrite, retain) NSArray* members;
@end
