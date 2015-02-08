//
//  UIImage+omn_helper.h
//  omnom
//
//  Created by tea on 21.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (omn_helper)

+ (UIImage *)omn_imageNamed:(NSString *)name;

- (UIImage *)omn_ovalImageInRect:(CGRect)frame;
- (UIImage *)omn_circleImageWithDiametr:(CGFloat)diametr;
- (UIImage *)omn_tintWithColor:(UIColor *)tintColor;

- (UIImage *)omn_blendWithColor:(UIColor *)tintColor;
- (UIImage *)omn_blendWithColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode alpha:(CGFloat)alpha;

@end
