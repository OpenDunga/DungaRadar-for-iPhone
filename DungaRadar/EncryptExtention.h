//
//  EncryptExtention.h
//  DungaRadar
//
//  Created by giginet on 11/05/29.
//  Copyright 2011 Kawaz. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (EncryptExtention)
- (NSString*)toMD5;
- (NSString*)toEncrypted:(NSString*)passwordHash userAgent:(NSString*)agent;
@end
