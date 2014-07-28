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

- (UIImage *)omn_tintWithColor:(UIColor *)tintColor;

@end
