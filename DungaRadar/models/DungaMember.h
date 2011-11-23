//
//  DungaMember.h
//  DungaRadar
//
//  Created by giginet on 11/05/29.
//  Copyright 2011 Kawaz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface DungaMember : NSObject <MKAnnotation>{
 @private
  int memberID_;
  NSString* memberDispName_;
  NSDate* timestamp_;
  UIImage* iconImage_;
  CLLocation* location_;
}

- (id)initWithUserData:(NSDictionary*)userData;

@property(readonly) int memberID;
@property(readonly, copy) NSString* memberDispName;
@property(readonly, retain) UIImage* iconImage;
@property(readwrite, retain) CLLocation* location;
@property(readonly, retain) NSDate* timestamp;

@end
