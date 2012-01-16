//
//  HttpAsyncConnection.h
//  DungaRadar
//
//  Created by  on 1/15/12.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KWAsyncConnectionDelegate.h"

@interface HttpAsyncConnection : NSObject <KWAsyncConnectionDelegate> {
  SEL responseSelector_;
  SEL dataSelector_;
  SEL finishSelector_;
  SEL failSelector_;
  id delegate_;
  NSMutableData* data_;
  NSHTTPURLResponse* urlRes_;
}

@property(readwrite) SEL responseSelector;
@property(readwrite) SEL dataSelector;
@property(readwrite) SEL finishSelector;
@property(readwrite) SEL failSelector;
@property(readwrite, assign) id delegate;
@property(readonly, retain) NSMutableData* data;
@property(readonly) NSString* responseBody;
@property(readonly) NSHTTPURLResponse* urlRes;

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
