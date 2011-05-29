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
  int userId_;
  double latitude_;
  double longitude_;
  NSString* userName_;
  NSString* dispName_;
  NSURL* iconImageURL_;
  UIImage* iconImage_;
}

- (id)initWithDictionary:(NSDictionary*)dictionary;

@property(readonly, copy) NSString* userName;
@property(readonly, copy) NSString* dispName;
@property(readonly, retain) UIImage* iconImage;

@end
