//
//  OMNMenuModiferCategoryCell.m
//  omnom
//
//  Created by tea on 03.02.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMenuModiferCategoryCell.h"
#import "OMNConstants.h"
#import <OMNStyler.h>
#import "UIView+omn_autolayout.h"
@implementation OMNMenuModiferCategoryCell {
  
  UILabel *_label;
  UIImageView *_arrowView;
  
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {

    [self omn_setup];
    
  }
  return self;
}

- (void)omn_setup {

  UIView *content = [UIView omn_autolayoutView];
  [self.contentView addSubview:content];
  
  _label = [UILabel omn_autolayoutView];
  _label.font = FuturaOSFOmnomRegular(20.0f);
  _label.textColor = colorWithHexString(@"000000");
  [content addSubview:_label];
  
  _arrowView = [UIImageView omn_autolayoutView];
  _arrowView.image = [UIImage imageNamed:@"ic_modifier_group_dropdown"];
  [content addSubview:_arrowView];
  
  NSDictionary *views =
  @{
    @"label" : _label,
    @"arrowView" : _arrowView,
    @"content" : content,
    };
  
  NSDictionary *metrics =
  @{
    };
  
  [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:content attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[content]|" options:kNilOptions metrics:metrics views:views]];
  
  [content addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[label]-(6)-[arrowView]|" options:kNilOptions metrics:metrics views:views]];
  [content addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[label]|" options:kNilOptions metrics:metrics views:views]];
  [content addConstraint:[NSLayoutConstraint constraintWithItem:_arrowView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:content attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
  
}

- (void)setCategory:(OMNMenuProductModiferCategory *)category {
  
  _label.text = category.name;
  _arrowView.transform = (category.selected) ? (CGAffineTransformIdentity) : (CGAffineTransformMakeRotation(-M_PI_2));
  
}


@end
