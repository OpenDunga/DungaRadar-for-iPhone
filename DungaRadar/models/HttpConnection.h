//
//  HttpConnection.h
//  DungaRadar
//
//  Created by giginet on 11/06/01.
//  Copyright 2011 Kawaz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KWSingleton.h"

@interface HttpConnection : KWSingleton{
}

+ (NSDictionary*)connectTo:(NSURL*)url
                    params:(NSDictionary*)parameters 
                    method:(NSString*)method 
                 userAgent:(NSString*)ua 
                httpHeader:(NSString*)header;
+ (NSString*)post:(NSURL*)url
           params:(NSDictionary*)postParameters 
        userAgent:(NSString*)ua 
       httpHeader:(NSString*)header;
+ (NSString*)get:(NSURL*)url 
          params:(NSDictionary*)getParameters
       userAgent:(NSString*)ua 
      httpHeader:(NSString*)header;
+ (NSURL*)buildURL:(NSString*)schema 
              host:(NSString*)host 
              path:(NSString*)path;
@end
