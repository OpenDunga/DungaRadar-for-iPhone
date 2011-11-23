//
//  UIImageExtention.m
//  DungaRadar
//
//  Created by  on 11/11/23.
//  Copyright (c) 2011年 Kawaz. All rights reserved.
//

#import "UIImageExtention.h"

@implementation UIImage (UIImageExtention)
- (UIImage*)resize:(CGSize)size aspect:(BOOL)aspect{
  if(aspect){
    double widthRate = ((double)size.width/(double)self.size.width);
    double heightRate = ((double)size.height/(double)self.size.height);
    if(widthRate < heightRate){
      size.width = (double)size.width * (double)self.size.width / (double)self.size.height;
    }else{
      size.height = (double)size.height * (double)self.size.height / (double)self.size.width;
    }
  }
  UIGraphicsBeginImageContext(size);
  [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
  UIImage* resizedImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return resizedImage;
}
@end
