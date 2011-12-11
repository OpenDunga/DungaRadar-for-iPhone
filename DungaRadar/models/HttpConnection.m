//
//  HttpConnection.m
//  DungaRadar
//
//  Created by giginet on 11/06/01.
//  Copyright 2011 Kawaz. All rights reserved.
//

#import "HttpConnection.h"
#import "EncryptExtention.h"
#import "DictionaryExtention.h"

@implementation HttpConnection

NSMutableData* loadedData = nil;

+ (NSDictionary*)connectTo:(NSURL *)url
                    params:(NSDictionary *)parameters 
                    method:(NSString *)method 
                 userAgent:(NSString *)ua 
                httpHeader:(NSString *)header {
  /**
   Returns dictionary that has key data and response. 
   */
  NSMutableURLRequest* httpPostRequest = [NSMutableURLRequest requestWithURL:url];
  [httpPostRequest setHTTPMethod:method];
  if(parameters){
    NSData* requestData = [[parameters dump] dataUsingEncoding:NSUTF8StringEncoding];
    [httpPostRequest setHTTPBody:requestData];
  }
  [httpPostRequest addValue:(NSString*)ua forHTTPHeaderField:(NSString*)header];
  NSURLResponse* res;
  NSError* err;
  NSData* data = [NSURLConnection sendSynchronousRequest:httpPostRequest 
                                           returningResponse:&res 
                                                       error:&err];
  return [NSDictionary dictionaryWithObjectsAndKeys:data, @"data", res, @"response", nil];
}

+ (NSString*)post:(NSURL *)url
           params:(NSDictionary *)postParameters 
        userAgent:(NSString *)ua 
       httpHeader:(NSString *)header{
  NSData* res = (NSData*)[[HttpConnection connectTo:url
                                             params:postParameters 
                                             method:@"POST" 
                                          userAgent:ua 
                                         httpHeader:header] objectForKey:@"data"];
  return [[NSString alloc] initWithData:res encoding:NSUTF8StringEncoding];;
}

+ (NSString*)get:(NSURL *)url
          params:(NSDictionary *)getParameters 
       userAgent:(NSString *)ua 
      httpHeader:(NSString *)header {
  NSData* res = (NSData*)[[HttpConnection connectTo:url
                                             params:getParameters 
                                             method:@"GET" 
                                          userAgent:ua 
                                         httpHeader:header] objectForKey:@"data"];
  return [[NSString alloc] initWithData:res encoding:NSUTF8StringEncoding];;
}

+ (NSURL*)buildURL:(NSString *)schema host:(NSString *)host path:(NSString *)path {
  NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@%@", (NSString*)schema, (NSString*)host, (NSString*)path]];
  return url;
}

@end
