//
//  HttpAsyncConnection.h
//  DungaRadar
//
//  Created by  on 1/15/12.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpAsyncConnection : NSObject {
  SEL response_;
  SEL data_;
  SEL finish_;
  SEL fail_;
  id delegate_;
}

@property(readwrite) SEL response;
@property(readwrite) SEL data;
@property(readwrite) SEL finish;
@property(readwrite) SEL fail;
@property(readwrite, assign) id delegate;

+ (id)connection;

- (BOOL)connectTo:(NSURL*)url
           params:(NSDictionary*)parameters 
           method:(NSString*)method 
        userAgent:(NSString*)ua 
       httpHeader:(NSString*)header;
+ (NSURL*)buildURL:(NSString*)schema 
              host:(NSString*)host 
              path:(NSString*)path;
@end
