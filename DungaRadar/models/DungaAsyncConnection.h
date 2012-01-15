//
//  DungaAsyncConnection.h
//  DungaRadar
//
//  Created by  on 1/15/12.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpAsyncConnection.h"

typedef enum {
  DungaAsyncStateLogin,
  DungaAsyncStateData
} DungaAsyncState;

@interface DungaAsyncConnection : HttpAsyncConnection {
  DungaAsyncState state_;
  NSURL* url_;
  NSDictionary* parameters_;
  NSString* method_;
}

- (BOOL)connectToDungaWithAuth:(NSString *)path
                        params:(NSDictionary *)parameters 
                        method:(NSString *)method;

- (BOOL)connectToDungaWithAuth:(NSString *)path
                        params:(NSDictionary *)parameters 
                        method:(NSString *)method 
                      userName:(NSString*)userName 
                  passwordHash:(NSString*)passwordHash;

+ (NSURL*)buildFullPath:(NSString*)path;

@end
