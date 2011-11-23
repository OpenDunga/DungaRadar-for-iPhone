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

- (void)auth:(NSString *)userName passwordHash:(NSString *)passwordHash{
  NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL:[HttpConnection buildURL:(NSString*)PATH_LOGIN]];
  [req addValue:(NSString*)USER_AGENT forHTTPHeaderField:@"http.useragent"];
  NSString* agent = [req valueForHTTPHeaderField:@"http.useragent"];
  NSString* encrypted = [passwordHash toEncrypted:agent];
  NSDictionary* post = [NSDictionary dictionaryWithObjectsAndKeys:userName, @"user_name", encrypted, @"enc_password", passwordHash, @"password", nil];
  [self post:(NSString*)PATH_LOGIN params:post];
}

- (void)post:(NSString *)path params:(NSDictionary *)postParameters{
  NSMutableURLRequest* httpPostRequest = [NSMutableURLRequest requestWithURL:[HttpConnection buildURL:path]];
  [httpPostRequest setHTTPMethod:@"POST"];
  NSData* requestData = [[postParameters dump] dataUsingEncoding:NSUTF8StringEncoding];
  [httpPostRequest addValue:(NSString*)USER_AGENT forHTTPHeaderField:(NSString*)HEADER_FIELD];
  [httpPostRequest setHTTPBody:requestData];
  NSURLConnection* connect = [NSURLConnection connectionWithRequest:httpPostRequest delegate:self];
}

- (NSString*)get:(NSString *)path{
  return @"";
}

+ (NSURL*)buildURL:(NSString *)path{
  NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@%@", (NSString*)SERVER_SCHEME, (NSString*)SERVER_HOST, (NSString*)path]];
  return url;
}

// 非同期通信 ヘッダーが返ってきた
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
	// データを初期化
	loadedData = [[NSMutableData alloc] initWithData:0];
}

// 非同期通信 ダウンロード中
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
	// データを追加する
	[loadedData appendData:data];
}

// 非同期通信 エラー
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSString *error_str = [error localizedDescription];
	UIAlertView *alertView = [[
                            [UIAlertView alloc]
                            initWithTitle : @"RequestError"
                            message : error_str
                            delegate : nil
                            cancelButtonTitle : @"OK"
                            otherButtonTitles : nil
                            ] autorelease];
	[alertView show];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
  NSString* response = [[[NSString alloc] initWithData:loadedData encoding:NSUTF8StringEncoding] autorelease];
  NSLog(@"%@", response);
}

@end
