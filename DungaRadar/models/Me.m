//
//  Me.m
//  DungaRadar
//
//  Created by  on 11/12/12.
//  Copyright (c) 2011年 Kawaz. All rights reserved.
//

#import "Me.h"
#import "DungaAsyncConnection.h"

const NSString* PATH_REGISTER_MEMBER_LOCATION = @"/api/location/register";

@interface Me()
- (void)onSucceedCommit:(NSURLConnection*)connection aRegister:(DungaAsyncConnection*)aRegister;
@end

@implementation Me

static id _instance = nil;
static BOOL _willDelete = NO;

+ (id)sharedMe {
	@synchronized(self) {
		if(!_instance) {
			[[self alloc] init];
		}
	}
	return _instance;
}

+ (id)allocWithZone:(NSZone*)zone {
	@synchronized(self) {
		if(!_instance) {
			_instance = [super allocWithZone:zone];
			return _instance;
		}
	}
	return nil;
}

+ (void)deleteInstance {
	if(_instance) {
		@synchronized(_instance) {
			_willDelete = YES;
			[_instance release];
			_instance = nil;
			_willDelete = NO;
		}
	}
}

- (void)release {
  @synchronized(self){
		if(_willDelete){
			[super release];
		}
	}
}

- (id)copyWithZone:(NSZone*)zone { return self; }
- (id)retain { return self; }
- (unsigned)retainCount { return UINT_MAX; }
- (id)autorelease { return self; }

- (BOOL)commit {
  float lng = self.location.coordinate.longitude;
  float lat = self.location.coordinate.latitude;
  NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                          [NSString stringWithFormat:@"%f", lng], 
                          @"longitude", 
                          [NSString stringWithFormat:@"%f", lat],
                          @"latitude",
                          nil];
  DungaAsyncConnection* dac = [DungaAsyncConnection connection];
  dac.finishSelector = @selector(onSucceedCommit:aRegister:);
  dac.delegate = self;
  return [dac connectToDungaWithAuth:(NSString*)PATH_REGISTER_MEMBER_LOCATION 
                              params:params 
                              method:@"POST"];
}

- (void)onSucceedCommit:(NSURLConnection *)connection aRegister:(DungaAsyncConnection *)aRegister {
  NSLog(@"おくりました");
}

@end
