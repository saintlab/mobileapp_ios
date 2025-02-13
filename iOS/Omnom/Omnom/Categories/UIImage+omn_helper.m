//
//  UIImage+omn_helper.m
//  omnom
//
//  Created by tea on 21.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "UIImage+omn_helper.h"

#define IS_IPHONE5 (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height==568)

@implementation UIImage (omn_helper)

+ (UIImage *)omn_imageNamed:(NSString *)name {

  if (IS_IPHONE5) {
    return [UIImage imageNamed:[name stringByAppendingString:@"-568h"]];
  }
  else {
    return [UIImage imageNamed:name];
  }
  
}

- (UIImage *)omn_ovalImageInRect:(CGRect)frame {
  
  CGRect drawFrame = frame;
  drawFrame.origin = CGPointZero;
  
  UIGraphicsBeginImageContextWithOptions(drawFrame.size, NO, 0.0f);
  [[UIBezierPath bezierPathWithOvalInRect:drawFrame] addClip];
  [self drawAtPoint:CGPointMake(-frame.origin.x, -frame.origin.y)];
  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return image;
  
}

- (UIImage *)omn_circleImageWithDiametr:(CGFloat)diametr {
  
  if (diametr <= 0.0f) {
    return nil;
  }
  
  CGRect drawRect = CGRectZero;
  drawRect.size = self.size;
  
  if (self.size.width > self.size.height) {
    
    CGFloat scale = diametr/self.size.width;
    drawRect.size.width *= scale;
    drawRect.size.height *= scale;
    drawRect.origin.y = (diametr - drawRect.size.height)/2.0f;
    
  }
  else {

    CGFloat scale = diametr/self.size.height;
    drawRect.size.width *= scale;
    drawRect.size.height *= scale;
    drawRect.origin.x = (diametr - drawRect.size.width)/2.0f;
    
  }
  
  CGRect drawFrame = CGRectMake(0.0f, 0.0f, diametr, diametr);
  UIGraphicsBeginImageContextWithOptions(drawFrame.size, NO, 0.0f);
  [[UIBezierPath bezierPathWithOvalInRect:drawFrame] addClip];
  [self drawInRect:drawRect];
  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return image;
  
}

- (UIImage *)omn_tintWithColor:(UIColor *)tintColor {

  UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
  CGRect drawRect = CGRectMake(0, 0, self.size.width, self.size.height);
  [self drawInRect:drawRect];
  [tintColor set];
  UIRectFillUsingBlendMode(drawRect, kCGBlendModeSourceIn);
  UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return tintedImage;

}

- (UIImage *)omn_blendWithColor:(UIColor *)tintColor {
  return [self omn_blendWithColor:tintColor blendMode:kCGBlendModeMultiply alpha:1.0f];
}

- (UIImage *)omn_blendWithColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode alpha:(CGFloat)alpha {
  
  UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
  CGRect drawRect = CGRectMake(0, 0, self.size.width, self.size.height);
  [self drawInRect:drawRect];
  [[tintColor colorWithAlphaComponent:alpha] set];
  UIRectFillUsingBlendMode(drawRect, blendMode);
  UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return tintedImage;
  
}

@end
