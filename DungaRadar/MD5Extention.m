//
//  MD5Extention.m
//  DungaRadar
//
//  Created by giginet on 11/05/29.
//  Copyright 2011 Kawaz. All rights reserved.
//

#import "MD5Extention.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (MD5Extention)
- (NSString *)toMD5{
  const char *cStr = [self UTF8String];
  unsigned char result[16];
  CC_MD5( cStr, strlen(cStr), result ); // This is the md5 call
  return [NSString stringWithFormat:
          @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
          result[0], result[1], result[2], result[3], 
          result[4], result[5], result[6], result[7],
          result[8], result[9], result[10], result[11],
          result[12], result[13], result[14], result[15]
          ];  
}
@end
