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

@implementation HttpConnection

NSMutableData* loadedData = nil;

- (NSDictionary*)connectTo:(NSString *)path params:(NSDictionary *)parameters method:(NSString *)method{
  /**
   Returns dictionary that has key data and response. 
   */
  NSMutableURLRequest* httpPostRequest = [NSMutableURLRequest requestWithURL:[self buildURL:path]];
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

- (BOOL)auth:(NSString *)userName passwordHash:(NSString *)passwordHash{
  NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL:[self buildURL:(NSString*)PATH_LOGIN]];
  [req addValue:(NSString*)USER_AGENT forHTTPHeaderField:@"http.useragent"];
  NSString* agent = [req valueForHTTPHeaderField:@"http.useragent"];
  NSString* encrypted = [passwordHash toEncrypted:agent];
  NSDictionary* post = [NSDictionary dictionaryWithObjectsAndKeys:userName, 
                        @"user_name", encrypted, 
                        @"enc_password", passwordHash, 
                        @"password", nil];
  NSURLResponse* res = (NSURLResponse*)[[self connectTo:(NSString*)PATH_LOGIN 
                                                 params:post method:@"POST"] 
                                        objectForKey:@"response"];
  NSHTTPURLResponse* urlRes = (NSHTTPURLResponse*)res;
  return (urlRes.statusCode == 200);
}

- (NSString*)post:(NSString *)path params:(NSDictionary *)postParameters{
  NSData* res = (NSData*)[[self connectTo:path params:postParameters method:@"POST"] objectForKey:@"data"];
  return [[NSString alloc] initWithData:res encoding:NSUTF8StringEncoding];;
}

- (NSString*)get:(NSString *)path params:(NSDictionary *)getParameters{
  NSData* res = (NSData*)[[self connectTo:path params:getParameters method:@"GET"] objectForKey:@"data"];
  return [[NSString alloc] initWithData:res encoding:NSUTF8StringEncoding];;
}

- (NSURL*)buildURL:(NSString *)path{
  NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@%@", (NSString*)SERVER_SCHEME, (NSString*)SERVER_HOST, (NSString*)path]];
  return url;
}

@end
