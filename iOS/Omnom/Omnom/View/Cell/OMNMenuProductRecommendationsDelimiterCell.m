//
//  OMNMenuProductDelimiterCell.m
//  omnom
//
//  Created by tea on 23.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMenuProductRecommendationsDelimiterCell.h"
#import "UIView+omn_autolayout.h"
#import <OMNStyler.h>
#import "OMNConstants.h"
#import <BlocksKit.h>

@implementation OMNMenuProductRecommendationsDelimiterCell {
  
  UILabel *_label;

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
  self.backgroundView.backgroundColor = [UIColor clearColor];
  self.backgroundColor = [UIColor clearColor];
  
  UIColor *lineColor = colorWithHexString(@"F5A623");
  UIView *leftLine = [UIView omn_autolayoutView];
  leftLine.backgroundColor = lineColor;
  [self.contentView addSubview:leftLine];
  
  UIView *rightLine = [UIView omn_autolayoutView];
  rightLine.backgroundColor = lineColor;
  [self.contentView addSubview:rightLine];
  
  _label = [UILabel omn_autolayoutView];
  _label.textColor = lineColor;
  _label.font = FuturaOSFOmnomRegular(20.0f);
  _label.text = NSLocalizedString(@"BEST_WITH_PRODUCT_DELIMITER_TEXT", @"Хорошо вместе");
  [self.contentView addSubview:_label];
  
  [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:leftLine attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0f constant:[OMNStyler styler].leftOffset.floatValue]];
  [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:leftLine attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_label attribute:NSLayoutAttributeLeft multiplier:1.0f constant:-10.0f]];
  [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:leftLine attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
  [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:leftLine attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0f constant:2.0f]];
  
  [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:rightLine attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0f constant:-[OMNStyler styler].leftOffset.floatValue]];
  [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:rightLine attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_label attribute:NSLayoutAttributeRight multiplier:1.0f constant:10.0f]];
  [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:rightLine attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
  [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:rightLine attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0f constant:2.0f]];
  
  [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_label attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_label attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
  
}

@end
