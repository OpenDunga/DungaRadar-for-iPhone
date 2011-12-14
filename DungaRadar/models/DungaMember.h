//
//  DungaMember.h
//  DungaRadar
//
//  Created by giginet on 11/05/29.
//  Copyright 2011 Kawaz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface DungaMember : NSObject <MKAnnotation, NSCoding>{
 @private
  int primaryKey_;
  NSString* dispName_;
  NSDate* timestamp_;
  UIImage* iconImage_;
  CLLocation* location_;
}

- (id)initWithUserData:(NSDictionary*)userData;
- (NSComparisonResult)sortByTimestamp:(DungaMember*)otherMember;
- (NSString*)descriptionDetailFrom:(DungaMember*)member;

@property(readonly) int primaryKey;
@property(readwrite, copy) NSString* dispName;
@property(readwrite, retain) UIImage* iconImage;
@property(readwrite, retain) CLLocation* location;
@property(readwrite, retain) NSDate* timestamp;

@end
