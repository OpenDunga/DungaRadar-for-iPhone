//
//  ArrayExtention.h
//  DungaRadar
//
//  Created by giginet on 11/07/10.
//  Copyright 2011 Kawaz. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSArray (ArrayExtention)
- (NSArray *)map:(void (^)(id))block;
- (NSString*)join:(NSString*)separator;
@end
