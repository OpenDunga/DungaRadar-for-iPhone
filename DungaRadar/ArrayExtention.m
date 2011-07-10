//
//  ArrayExtention.m
//  DungaRadar
//
//  Created by giginet on 11/07/10.
//  Copyright 2011 Kawaz. All rights reserved.
//

#import "ArrayExtention.h"
#import <block.h>

@implementation NSArray (ArrayExtention)

- (NSArray *)map:(void (^)(id))block {
  NSMutableArray *newArray = [NSMutableArray array];
  /*[self enumerateObjectsUsingBlock:^(id item,NSUInteger idx,BOOL *stop){
    id obj = block(item);
    [newArray addObject:obj];
  }];*/
  return newArray;
}
- (NSString*)join:(NSString *)separator{
  NSMutableString* joined = [NSMutableString string];
  for(id object in self){
    [joined appendFormat:@"%@%@", object, separator];
  }
  [joined deleteCharactersInRange:NSMakeRange([joined length]-1, 1)];
  return joined;
}

@end
