//
//  HttpAsyncConnection.m
//  DungaRadar
//
//  Created by  on 1/15/12.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import "HttpAsyncConnection.h"
#import "DictionaryExtention.h"

@implementation HttpAsyncConnection
@synthesize response = response_;
@synthesize data = data_;
@synthesize finish = finish_;
@synthesize fail = fail_;
@synthesize delegate = delegate_;

+ (id)connection {
  return [[[HttpAsyncConnection alloc] init] autorelease];
}

- (id)init {
  self = [super init];
  if (self) {
    response_ = nil;
    data_ = nil;
    finish_ = nil;
    fail_ = nil;    
  }
  return self;
}

- (BOOL)connectTo:(NSURL *)url 
           params:(NSDictionary *)parameters 
           method:(NSString *)method 
        userAgent:(NSString *)ua 
       httpHeader:(NSString *)header {
  NSMutableURLRequest* httpRequest = [NSMutableURLRequest requestWithURL:url];
  [httpRequest setHTTPMethod:method];
  if(parameters){
    NSData* requestData = [[parameters dump] dataUsingEncoding:NSUTF8StringEncoding];
    [httpRequest setHTTPBody:requestData];
  }
  [httpRequest addValue:(NSString*)ua forHTTPHeaderField:(NSString*)header];
  NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:httpRequest delegate:self];
  return connection != nil;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
  if (self.response) {
    [self.delegate performSelector:self.response withObject:response];
  }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
  if (self.data) {
    [self.delegate performSelector:self.data withObject:data];
  }	
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
  if (self.fail) {
    [self.delegate performSelector:self.fail withObject:error];
  }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
  if (self.finish) {
    [self.delegate performSelector:self.finish withObject:connection];
  }	
}

+ (NSURL*)buildURL:(NSString *)schema host:(NSString *)host path:(NSString *)path {
  NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@%@", (NSString*)schema, (NSString*)host, (NSString*)path]];
  return url;
}

@end
