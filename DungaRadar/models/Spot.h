//
//  Spot.h
//  DungaRadar
//
//  Created by  on 11/12/11.
//  Copyright (c) 2011年 Kawaz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Spot : NSObject <MKAnnotation>{
  int primaryKey_;
  int scope_;
  BOOL autoInform_;
  NSString* dispName_;
  CLLocation* location_;
}

- (id)initWithLocation:(CLLocation*)location;
- (id)initWithJson:(NSString*)json;
- (BOOL)commit;
- (NSDictionary*)dump;

@property(readonly) int primaryKey;
@property(readwrite) int scope;
@property(readwrite) BOOL autoInform;
@property(readwrite, copy) NSString* dispName;
@property(readwrite, retain) CLLocation* location;
@end
