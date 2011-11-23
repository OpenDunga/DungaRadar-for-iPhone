//
//  DungaRegister.m
//  DungaRadar
//
//  Created by giginet on 11/11/23.
//  Copyright (c) 2011年 Kawaz. All rights reserved.
//

#import "HttpConnection.h"
#import "EncryptExtention.h"
#import "DungaRegister.h"

@implementation DungaRegister

+ (BOOL)auth{
  NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
  HttpConnection* hc = [HttpConnection instance];
  return [hc auth:(NSString*)[ud objectForKey:@"username"] 
     passwordHash:[(NSString*)[ud objectForKey:@"password"] toMD5]];
  return NO;
}

@end
