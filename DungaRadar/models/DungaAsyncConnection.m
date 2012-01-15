//
//  DungaAsyncConnection.m
//  DungaRadar
//
//  Created by  on 1/15/12.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import "DungaAsyncConnection.h"
#import "EncryptExtention.h"

@interface DungaAsyncConnection()
@property(readwrite, retain) NSURL* url;
@property(readwrite, retain) NSDictionary* parameters;
@property(readwrite, retain) NSString* method;
@end

@implementation DungaAsyncConnection
@synthesize url = url_;
@synthesize parameters = parameters_;
@synthesize method = method_;

/** サーバースキーマ。 */
const NSString*	SERVER_SCHEME2	= @"http";

/** サーバーホスト。 */
const NSString*	SERVER_HOST2		= @"www.opendunga.net";

/** HttpHeaderField **/
/**
 http.useragentを利用すると、cocoaの罠にはまるので便宜的にnamaco.
 **/
const NSString* HEADER_FIELD2 = @"namaco";

/** ユーザーエージェント。 */
const NSString*	USER_AGENT2		= @"DungaRadar/1.0";

/** ログイン用URIのパス。 */
const NSString* PATH_LOGIN2		= @"/api/login";

- (id)init {
  self = [super init];
  if (self) {
    state_ = DungaAsyncStateData;
  }
  return self;
}

- (void)dealloc {
  [self.url release];
  [self.parameters release];
  [self.method release];
  [super dealloc];
}

- (BOOL)connectToDungaWithAuth:(NSString *)path 
                        params:(NSDictionary *)parameters 
                        method:(NSString *)method {
  NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
  NSString* userName = [ud objectForKey:@"username"];
  NSString* passwordHash = [[ud objectForKey:@"password"] toMD5];
  return [self connectToDungaWithAuth:path 
                               params:parameters 
                               method:method 
                             userName:userName 
                         passwordHash:passwordHash];
}

- (BOOL)connectToDungaWithAuth:(NSString *)path 
                        params:(NSDictionary *)parameters 
                        method:(NSString *)method 
                      userName:(NSString *)userName 
                  passwordHash:(NSString *)passwordHash {
  self.url = [DungaAsyncConnection buildFullPath:path];
  self.parameters = parameters;
  self.method = method;
  NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL:[DungaAsyncConnection buildFullPath:(NSString*)PATH_LOGIN2]];
  [req addValue:(NSString*)USER_AGENT2 forHTTPHeaderField:@"http.useragent"];
  NSString* agent = [req valueForHTTPHeaderField:@"http.useragent"];
  NSString* encrypted = [passwordHash toEncrypted:agent];
  NSDictionary* post = [NSDictionary dictionaryWithObjectsAndKeys:
                        userName, @"user_name", 
                        encrypted, @"enc_password", 
                        passwordHash, @"password", nil];
  state_ = DungaAsyncStateLogin;
  return [self connectTo:[DungaAsyncConnection buildFullPath:(NSString*)PATH_LOGIN2]
                  params:post
                  method:@"POST" 
               userAgent:(NSString*)USER_AGENT2
              httpHeader:(NSString*)HEADER_FIELD2];
}

+ (NSURL*)buildFullPath:(NSString *)path {
  if(!path) return nil;
  return [HttpAsyncConnection buildURL:(NSString*)SERVER_SCHEME2 
                                  host:(NSString*)SERVER_HOST2
                                  path:path];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
  if (state_ == DungaAsyncStateLogin) {
    state_ = DungaAsyncStateData;
    NSLog(@"%@", self.url);
    if (self.url) {
      [self connectTo:self.url 
               params:self.parameters 
               method:self.method 
            userAgent:(NSString*)USER_AGENT2 
           httpHeader:(NSString*)HEADER_FIELD2];
    } else {
      [self.delegate performSelector:self.finishSelector withObject:connection];
    }
  } else {
    if (self.finishSelector) {
      NSLog(@"aaa: %@", [[[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding] autorelease]);
      [self.delegate performSelector:self.finishSelector withObject:connection];
    }	
  }
}

@end
