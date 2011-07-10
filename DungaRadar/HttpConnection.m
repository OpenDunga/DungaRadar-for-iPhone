//
//  HttpConnection.m
//  DungaRadar
//
//  Created by giginet on 11/06/01.
//  Copyright 2011 Kawaz. All rights reserved.
//

#import "HttpConnection.h"

@interface HttpConnection()
+ (NSData*)encodeParameters:(NSDictionary*)parameters:(NSStringEncoding)encoding;
@end

/** サーバースキーマ。 */
const NSString*	SERVER_SCHEME	= @"http";

/** サーバーホスト。 */
const NSString*	SERVER_HOST		= @"opendunga.net";

/** ユーザーエージェント。 */
const NSString*	USER_AGENT		= @"DungaRadar/1.0";

/** ログイン用URIのパス。 */
const NSString* PATH_LOGIN		= @"/api/login";

@implementation HttpConnection

- (id)initWithCoder:(NSCoder *)aDecoder{
  if( (self = [super init]) ){
    encryptedPassword_ = [[aDecoder decodeObjectForKey:@"PASSWD"] retain];
    userId_            = [[aDecoder decodeObjectForKey:@"ID"] retain];
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
  [aCoder encodeObject:encryptedPassword_ forKey:@"PASSWD"];
  [aCoder encodeObject:userId_ forKey:@"ID"];
}

- (BOOL)auth:(NSString *)userName :(NSString *)passwordHash{
  return YES;
}

- (NSString*)post:(NSString *)path :(NSDictionary *)postParameters{
  NSMutableString* responseString = [NSMutableString string];
  NSMutableURLRequest* httpPostRequest = [NSMutableURLRequest requestWithURL:[HttpConnection buildURL:(NSString*)PATH_LOGIN]];
  [httpPostRequest setHTTPMethod:@"POST"];
  NSData* requestData = [@"" dataUsingEncoding:NSUTF8StringEncoding];
  [httpPostRequest setHTTPBody:requestData];
  NSURLConnection* connect = [NSURLConnection connectionWithRequest:httpPostRequest delegate:self];
   
}

- (NSString*)get:(NSString *)path{
}

@end
