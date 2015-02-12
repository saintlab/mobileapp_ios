//
//  OMNMenuHeaderItemCell.m
//  omnom
//
//  Created by tea on 19.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMenuHeaderItemCell.h"
#import "UIView+omn_autolayout.h"
#import <OMNStyler.h>
#import "OMNConstants.h"
#import "UIImage+omn_helper.h"

@implementation OMNMenuHeaderItemCell {
  
  UILabel *_label;
  UIImageView *_iconView;
  
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
  
  _label = [UILabel omn_autolayoutView];
  _label.textColor = colorWithHexString(@"F5A623");
  _label.font = FuturaOSFOmnomRegular(20.0f);
  _label.text = NSLocalizedString(@"MENU_LIST_TITLE", @"Меню");
  [self.contentView addSubview:_label];
  
  _iconView = [UIImageView omn_autolayoutView];
  _iconView.image = [[UIImage imageNamed:@"ic_menu"] omn_tintWithColor:colorWithHexString(@"F5A623")];
  [self.contentView addSubview:_iconView];
  
  [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_label attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_iconView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_label attribute:NSLayoutAttributeLeft multiplier:1.0f constant:-7.0f]];
  
  [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_label attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
  [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_iconView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
  
}

@end
