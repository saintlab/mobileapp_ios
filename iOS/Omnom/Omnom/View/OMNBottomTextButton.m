//
//  OMNBottomTextButton.m
//  omnom
//
//  Created by tea on 25.12.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNBottomTextButton.h"
#import "UIImage+omn_helper.h"
#import <OMNStyler.h>
#import "UIView+omn_autolayout.h"

@implementation OMNBottomTextButton 

- (instancetype)init {
  self = [super init];
  if (self) {
    [self setup];
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    
    [self setup];
    
  }
  return self;
}

- (void)setup {
  
  self.font = FuturaOSFOmnomRegular(16.0f);
  
  _iconView = [UIImageView omn_autolayoutView];
  [self addSubview:_iconView];
  
  _label = [UILabel omn_autolayoutView];
  _label.font = self.font;
  _label.numberOfLines = 0;
  _label.textAlignment = NSTextAlignmentCenter;
  [self addSubview:_label];
  
  NSDictionary *views =
  @{
    @"iconView" : _iconView,
    @"label" : _label,
    };
  
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[iconView]-(8)-[label]-(>=0)-|" options:kNilOptions metrics:nil views:views]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[label]|" options:kNilOptions metrics:nil views:views]];
  [self addConstraint:[NSLayoutConstraint constraintWithItem:_iconView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:_iconView attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0.0f]];
  
}

- (void)setTitle:(NSString *)title image:(UIImage *)image highlightedImage:(UIImage *)highlightedImage color:(UIColor *)color disabledColor:(UIColor *)disabledColor {
  
  _iconView.image = [image omn_tintWithColor:color];
  _iconView.highlightedImage = highlightedImage;
  
  NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:(title) ? (title) : (@"")];
  NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
  style.lineSpacing = 0.0f;
  style.maximumLineHeight = 18.0f;
  style.alignment = NSTextAlignmentCenter;
  [attributedText addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, attributedText.length)];
  
  [attributedText setAttributes:
   @{
     NSParagraphStyleAttributeName : style,
     NSFontAttributeName : (self.font) ? (self.font) : ([UIFont systemFontOfSize:16.0f]),
     } range:NSMakeRange(0, title.length)];
  _label.textColor = color;
  _label.attributedText = attributedText;
  
}

- (void)setTitle:(NSString *)title image:(UIImage *)image color:(UIColor *)color disabledColor:(UIColor *)disabledColor {
  [self setTitle:title image:image highlightedImage:[image omn_tintWithColor:disabledColor] color:color disabledColor:disabledColor];
}

- (void)fadeControls:(BOOL)fade {
  
  _iconView.highlighted = fade;
  _label.alpha = (fade) ? (0.5f) : (1.0f);
  
}

- (void)setHighlighted:(BOOL)highlighted {
  [super setHighlighted:highlighted];
  
  [self fadeControls:highlighted];
  
}

- (void)setEnabled:(BOOL)enabled {
  [super setEnabled:enabled];

  [self fadeControls:!enabled];

}

@end
