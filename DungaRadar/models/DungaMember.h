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
  int primaryKey_;
  NSString* dispName_;
  NSDate* timestamp_;
  UIImage* iconImage_;
  CLLocation* location_;
  NSArray* history_;
}

- (id)initWithUserData:(NSDictionary*)userData;
- (NSComparisonResult)sortByTimestamp:(DungaMember*)otherMember;
- (NSString*)descriptionDetailFromMember:(DungaMember*)member;
- (NSArray*)historySinceDate:(NSDate*)date;
- (void)startLoadingIcon;

@property(readonly) int primaryKey;
@property(readwrite, copy) NSString* dispName;
@property(readwrite, retain) UIImage* iconImage;
@property(readwrite, retain) CLLocation* location;
@property(readwrite, retain) NSDate* timestamp;
@property(readwrite, retain) NSArray* history;

@end
