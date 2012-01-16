//
//  Me.h
//  DungaRadar
//
//  Created by  on 11/12/12.
//  Copyright (c) 2011年 Kawaz. All rights reserved.
//

#import "DungaMember.h"

@interface Me : DungaMember <CLLocationManagerDelegate> {
  CLLocationManager* locationManager_;
}

+ (id)sharedMe;
- (BOOL)commit;
- (void)updateFromJSON:(NSString*)json;
- (void)updateLocationStatus;

@end
