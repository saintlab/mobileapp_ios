//
//  OMNToolbarBotton.h
//  omnom
//
//  Created by tea on 14.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OMNToolbarButton : UIButton

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title;
- (instancetype)initWithFitImage:(UIImage *)image title:(NSString *)title;
- (instancetype)initWithFitImage:(UIImage *)image title:(NSString *)title  color:(UIColor *)color;
- (void)setSelectedImage:(UIImage *)selectedImage selectedTitle:(NSString *)selectedTitle;

@end
