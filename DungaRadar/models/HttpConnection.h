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

- (NSData*)connectTo:(NSString*)path params:(NSDictionary*)postParameters method:(NSString*)method;
- (NSString*)auth:(NSString*)userName passwordHash:(NSString*)passwordHash;
- (NSString*)post:(NSString*)path params:(NSDictionary*)postParameters;
- (NSString*)get:(NSString*)path params:(NSDictionary*)getParameters;
- (NSURL*)buildURL:(NSString*)path;

@end
