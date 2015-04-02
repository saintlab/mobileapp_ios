//
//  OMNBottomTextButton.h
//  omnom
//
//  Created by tea on 25.12.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OMNBottomTextButton : UIButton

@property (nonatomic, strong, readonly) UIImageView *iconView;
@property (nonatomic, strong, readonly) UILabel *label;
@property (nonatomic, strong) UIFont *font;

- (void)setTitle:(NSString *)title image:(UIImage *)image color:(UIColor *)color disabledColor:(UIColor *)disabledColor;
- (void)setTitle:(NSString *)title image:(UIImage *)image highlightedImage:(UIImage *)highlightedImage color:(UIColor *)color disabledColor:(UIColor *)disabledColor;

@end
