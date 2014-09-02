//
//  UIView+screenshot.m
//  omnom
//
//  Created by tea on 24.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "UIView+screenshot.h"

@implementation UIView (screenshot)

- (UIImage *)omn_screenshot {
	UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0f);
  // Create a graphics context and translate it the view we want to crop so
  // that even in grabbing (0,0), that origin point now represents the actual
  // cropping origin desired:
	[self layoutIfNeeded];
	[self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO];
	UIImage *screenshotImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return screenshotImage;
}

+ (UIImage *)omn_imageFromArray:(NSArray *)images {
  
  __block CGSize size = CGSizeZero;
  
  [images enumerateObjectsUsingBlock:^(UIImage *image, NSUInteger idx, BOOL *stop) {
    size.height += image.size.height;
    size.width = MAX(size.width, image.size.width);
  }];
  
  
  UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
  
  __block CGFloat offset = 0.0f;
  [images enumerateObjectsUsingBlock:^(UIImage *image, NSUInteger idx, BOOL *stop) {
    
    [image drawAtPoint:CGPointMake(0.0f, offset)];
    offset += image.size.height;
    
  }];
  
  UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  return finalImage;
}

@end
