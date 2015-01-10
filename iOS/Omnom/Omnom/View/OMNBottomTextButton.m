//
//  OMNBottomTextButton.m
//  omnom
//
//  Created by tea on 25.12.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNBottomTextButton.h"
#import "UIImage+omn_helper.h"
#import "OMNConstants.h"
#import "UIView+omn_autolayout.h"

@implementation OMNBottomTextButton {
  
}

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
  
}

- (void)setTitle:(NSString *)title image:(UIImage *)image color:(UIColor *)color {

  _iconView.image = [image omn_tintWithColor:color];
  
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
    NSForegroundColorAttributeName : (color) ? (color) : ([UIColor blackColor]),
    } range:NSMakeRange(0, title.length)];
  
  _label.attributedText = attributedText;
  
}

- (void)fadeControls:(BOOL)fade {
  
  _iconView.alpha = (fade) ? (0.5f) : (1.0f);
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
