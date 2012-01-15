//
//  Spot.h
//  DungaRadar
//
//  Created by  on 11/12/11.
//  Copyright (c) 2011年 Kawaz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DungaAsyncConnection.h"
#import <MapKit/MapKit.h>

@interface Spot : NSObject <MKAnnotation>{
  int primaryKey_;
  int scope_;
  int registeredMemberId_;
  BOOL autoInform_;
  NSString* dispName_;
  CLLocation* location_;
}

- (id)initWithLocation:(CLLocation*)location;
- (id)initWithInfo:(NSDictionary*)dictionary;
- (id)initWithJson:(NSString*)json;
- (NSDictionary*)dump;

@property(readonly) int primaryKey;
@property(readwrite) int scope;
@property(readwrite) int registeredMemberId;
@property(readwrite) BOOL autoInform;
@property(readwrite, copy) NSString* dispName;
@property(readwrite, retain) CLLocation* location;
@property(readonly) int scopeIndex;
@property(readonly, copy) NSString* scopeName;
@end
