//
//  UIView+screenshot.h
//  omnom
//
//  Created by tea on 24.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (screenshot)

- (UIImage *)omn_screenshot;
+ (UIImage *)omn_imageFromArray:(NSArray *)images;

@end
