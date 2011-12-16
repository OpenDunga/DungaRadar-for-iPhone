//
//  DungaRegister.h
//  DungaRadar
//
//  Created by giginet on 11/11/23.
//  Copyright (c) 2011年 Kawaz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DungaRegister : NSObject

+ (BOOL)auth:(NSString*)userName passwordHash:(NSString*)passwordHash;
+ (BOOL)authWithStorage;

+ (NSDictionary*)connectToDunga:(NSString *)path
                         params:(NSDictionary *)parameters 
                         method:(NSString *)method;
+ (NSString*)post:(NSString*)path
           params:(NSDictionary*)postParameters;
+ (NSString*)get:(NSString*)path
          params:(NSDictionary*)getParameters;
+ (NSURL*)buildFullPath:(NSString*)path;
@end