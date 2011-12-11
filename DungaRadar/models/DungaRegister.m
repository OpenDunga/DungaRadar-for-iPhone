//
//  DungaRegister.m
//  DungaRadar
//
//  Created by giginet on 11/11/23.
//  Copyright (c) 2011年 Kawaz. All rights reserved.
//

#import "HttpConnection.h"
#import "DictionaryExtention.h"
#import "EncryptExtention.h"
#import "DungaRegister.h"

@implementation DungaRegister

/** サーバースキーマ。 */
const NSString*	SERVER_SCHEME	= @"http";

/** サーバーホスト。 */
const NSString*	SERVER_HOST		= @"www.opendunga.net";

/** HttpHeaderField **/
/**
 http.useragentを利用すると、cocoaの罠にはまるので便宜的にnamaco.
 **/
const NSString* HEADER_FIELD = @"namaco";

/** ユーザーエージェント。 */
const NSString*	USER_AGENT		= @"DungaRadar/1.0";

/** ログイン用URIのパス。 */
const NSString* PATH_LOGIN		= @"/api/login";

+ (BOOL)auth:(NSString *)userName passwordHash:(NSString *)passwordHash {
  NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL:[HttpConnection buildURL:(NSString*)SERVER_SCHEME 
                                                                                     host:(NSString*)SERVER_HOST 
                                                                                     path:(NSString*)PATH_LOGIN]];
  [req addValue:(NSString*)USER_AGENT forHTTPHeaderField:@"http.useragent"];
  NSString* agent = [req valueForHTTPHeaderField:@"http.useragent"];
  NSString* encrypted = [passwordHash toEncrypted:agent];
  NSDictionary* post = [NSDictionary dictionaryWithObjectsAndKeys:userName, 
                        @"user_name", encrypted, 
                        @"enc_password", passwordHash, 
                        @"password", nil];
  NSURLResponse* res = (NSURLResponse*)[[DungaRegister connectToDunga:(NSString*)PATH_LOGIN 
                                                               params:post 
                                                               method:@"POST"] objectForKey:@"response"];
  NSHTTPURLResponse* urlRes = (NSHTTPURLResponse*)res;
  return (urlRes.statusCode == 200);
}

+ (BOOL)authWithStorage {
  NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
  return [DungaRegister auth:(NSString*)[ud objectForKey:@"username"] 
                passwordHash:[(NSString*)[ud objectForKey:@"password"] toMD5]];
}

+ (NSDictionary*)connectToDunga:(NSString *)path 
                         params:(NSDictionary *)parameters 
                         method:(NSString *)method {
  /**
   Returns dictionary that has key data and response. 
   */
  NSMutableURLRequest* httpPostRequest = [NSMutableURLRequest requestWithURL:[HttpConnection buildURL:(NSString*)SERVER_SCHEME 
                                                                                                 host:(NSString*)SERVER_HOST 
                                                                                                 path:path]];
  [httpPostRequest setHTTPMethod:method];
  if(parameters){
    NSData* requestData = [[parameters dump] dataUsingEncoding:NSUTF8StringEncoding];
    [httpPostRequest setHTTPBody:requestData];
  }
  [httpPostRequest addValue:(NSString*)USER_AGENT forHTTPHeaderField:(NSString*)HEADER_FIELD];
  NSURLResponse* res;
  NSError* err;
  NSData* data = [NSURLConnection sendSynchronousRequest:httpPostRequest 
                                       returningResponse:&res 
                                                   error:&err];
  return [NSDictionary dictionaryWithObjectsAndKeys:data, @"data", res, @"response", nil];
}

+ (NSString*)post:(NSString *)path
           params:(NSDictionary *)postParameters {
  NSData* res = (NSData*)[[DungaRegister connectToDunga:path
                                                 params:postParameters 
                                                 method:@"POST"] objectForKey:@"data"];
  return [[NSString alloc] initWithData:res encoding:NSUTF8StringEncoding];;
}

+ (NSString*)get:(NSString *)path
          params:(NSDictionary *)getParameters {
  NSData* res = (NSData*)[[DungaRegister connectToDunga:path
                                                 params:getParameters 
                                                 method:@"GET"] objectForKey:@"data"];
  return [[NSString alloc] initWithData:res encoding:NSUTF8StringEncoding];;
}

@end
