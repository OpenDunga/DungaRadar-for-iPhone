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
@synthesize responseSelector = responseSelector_;
@synthesize dataSelector = dataSelector_;
@synthesize finishSelector = finishSelector_;
@synthesize failSelector = failSelector_;
@synthesize delegate = delegate_;
@synthesize data = data_;

+ (id)connection {
  return [[[HttpAsyncConnection alloc] init] autorelease];
}

- (id)init {
  self = [super init];
  if (self) {
    responseSelector_ = nil;
    dataSelector_ = nil;
    finishSelector_ = nil;
    failSelector_ = nil;
    data_ = [[NSMutableData alloc] initWithData:0];
  }
  return self;
}

- (void)dealloc {
  [data_ release];
  [super dealloc];
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

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
  if (self.responseSelector) {
    [self.delegate performSelector:self.responseSelector withObject:response];
  }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
  [data_ appendData:data];
  if (self.dataSelector) {
    [self.delegate performSelector:self.dataSelector withObject:data];
  }	
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
  if (self.failSelector) {
    [self.delegate performSelector:self.failSelector withObject:error];
  }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
  if (self.finishSelector) {
    [self.delegate performSelector:self.finishSelector withObject:connection];
  }	
}

+ (NSURL*)buildURL:(NSString *)schema host:(NSString *)host path:(NSString *)path {
  NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@%@", (NSString*)schema, (NSString*)host, (NSString*)path]];
  return url;
}

@end
