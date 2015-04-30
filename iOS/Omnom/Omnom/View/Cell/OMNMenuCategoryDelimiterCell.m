//
//  OMNMenuCategoryDelimiterCell.m
//  omnom
//
//  Created by tea on 22.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMenuCategoryDelimiterCell.h"
#import "UIView+omn_autolayout.h"
#import <OMNStyler.h>

@implementation OMNMenuCategoryDelimiterCell {
  
  OMNMenuCategoryDelimiterView *_delimiterView;
  
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    
    [self omn_setup];
    
  }
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
  self = [super initWithCoder:coder];
  if (self) {
    
    [self omn_setup];
    
  }
  return self;
}

- (void)omn_setup {
  
  self.selectionStyle = UITableViewCellSelectionStyleNone;
  self.backgroundView = [[UIView alloc] init];
  self.backgroundView.backgroundColor = [UIColor whiteColor];
  self.backgroundColor = [UIColor whiteColor];

  _delimiterView = [OMNMenuCategoryDelimiterView omn_autolayoutView];
  [self.contentView addSubview:_delimiterView];
  
  NSDictionary *views =
  @{
    @"delimiterView" : _delimiterView
    };
  
  NSDictionary *metrics =
  @{
    };

  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[delimiterView]|" options:kNilOptions metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[delimiterView]|" options:kNilOptions metrics:metrics views:views]];
  
}

- (void)setMenuCategory:(OMNMenuCategory *)menuCategory {
  
  _menuCategory = menuCategory;
  _delimiterView.menuCategory = menuCategory;
  
}

@end

@implementation OMNMenuCategoryDelimiterView {
  
  UILabel *_label;
  
}

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    
    [self omn_setup];
    
  }
  return self;
}

- (void)setMenuCategory:(OMNMenuCategory *)menuCategory {
  
  _menuCategory = menuCategory;
  _label.text = menuCategory.name;
  
}

- (void)omn_setup {
  
  UIColor *lineColor = colorWithHexString(@"7B7B7B");
  UIView *leftLine = [UIView omn_autolayoutView];
  leftLine.backgroundColor = lineColor;
  [self addSubview:leftLine];
  
  UIView *rightLine = [UIView omn_autolayoutView];
  rightLine.backgroundColor = lineColor;
  [self addSubview:rightLine];
  
  _label = [UILabel omn_autolayoutView];
  _label.textColor = lineColor;
  _label.font = FuturaLSFOmnomLERegular(20.0f);
  _label.numberOfLines = 0;
  [self addSubview:_label];
  
  NSDictionary *views =
  @{
    @"label" : _label,
    };
  
  [self addConstraint:[NSLayoutConstraint constraintWithItem:leftLine attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.0f]];
  [self addConstraint:[NSLayoutConstraint constraintWithItem:leftLine attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_label attribute:NSLayoutAttributeLeft multiplier:1.0f constant:-10.0f]];
  [self addConstraint:[NSLayoutConstraint constraintWithItem:leftLine attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
  [self addConstraint:[NSLayoutConstraint constraintWithItem:leftLine attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0f constant:2.0f]];
  
  [self addConstraint:[NSLayoutConstraint constraintWithItem:rightLine attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0f constant:0.0f]];
  [self addConstraint:[NSLayoutConstraint constraintWithItem:rightLine attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_label attribute:NSLayoutAttributeRight multiplier:1.0f constant:10.0f]];
  [self addConstraint:[NSLayoutConstraint constraintWithItem:rightLine attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
  [self addConstraint:[NSLayoutConstraint constraintWithItem:rightLine attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0f constant:2.0f]];
  
  [self addConstraint:[NSLayoutConstraint constraintWithItem:_label attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[label]|" options:kNilOptions metrics:nil views:views]];
  
}

- (void)layoutSubviews {
  
  CGFloat preferredMaxLayoutWidth = CGRectGetWidth(self.frame) - 2*OMNStyler.leftOffset;
  _label.preferredMaxLayoutWidth = preferredMaxLayoutWidth;
  [super layoutSubviews];
  
}

@end
