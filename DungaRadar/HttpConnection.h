//
//  HttpConnection.h
//  DungaRadar
//
//  Created by giginet on 11/06/01.
//  Copyright 2011 Kawaz. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HttpConnection : NSObject{
}

+ (NSURL*)buildURL:(NSString*)path;

- (void)auth:(NSString*)userName passwordHash:(NSString*)passwordHash;
- (void)post:(NSString*)path params:(NSDictionary*)postParameters;
- (NSString*)get:(NSString*)path;

@end
