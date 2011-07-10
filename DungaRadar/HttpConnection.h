//
//  HttpConnection.h
//  DungaRadar
//
//  Created by giginet on 11/06/01.
//  Copyright 2011 Kawaz. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HttpConnection : NSObject <NSCoding>{
  NSString* encryptedPassword_;
  NSString* userId_;
}

+ (NSURL*)buildURL:(NSString*)path;

- (BOOL)auth:(NSString*)userName passwordHash:(NSString*)passwordHash;
- (NSString*)post:(NSString*)path params:(NSDictionary*)postParameters;
- (NSString*)get:(NSString*)path;

@end
