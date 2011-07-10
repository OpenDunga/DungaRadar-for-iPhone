//
//  EncryptExtention.m
//  DungaRadar
//
//  Created by giginet on 11/05/29.
//  Copyright 2011 Kawaz. All rights reserved.
//

#import "EncryptExtention.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (EncryptExtention)
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

- (NSString*)toEncrypted:(NSString *)agent{
  NSString* key = [agent toMD5];
  
  int keyNum = 5;
  for (int i=0;i<[key length];++i) {
    NSString* keyChar = [key substringWithRange:NSMakeRange(i, 1)];
    @try {
      int num = [keyChar intValue];
      if (num > 1) {
        keyNum = num;
        break;
      }
      
    }
    @catch (NSException* e) {
    }
  }
  
  NSMutableString* encrypted = [NSMutableString stringWithString:[key substringWithRange:NSMakeRange(0, 4)]];
  [encrypted appendString:self]; 
  [encrypted appendString:[key substringWithRange:NSMakeRange(4, 4)]];
  
  NSMutableString* inserted = [NSMutableString string];
  int index = 31;
  for (int i=0;i<[encrypted length];++i) {
    if (i%keyNum == 0) {
      NSString* k = [key substringWithRange:NSMakeRange(index, 1)];
      [inserted appendString:k];
      --index;
    }
    [inserted appendString:[encrypted substringWithRange:NSMakeRange(i, 1)]];
  }
  
  return inserted;
}

@end
