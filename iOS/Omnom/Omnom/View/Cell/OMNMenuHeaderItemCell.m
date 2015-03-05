//
//  OMNMenuHeaderItemCell.m
//  omnom
//
//  Created by tea on 19.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMenuHeaderItemCell.h"
#import "UIView+omn_autolayout.h"
#import "OMNMenuHeaderView.h"

@implementation OMNMenuHeaderItemCell

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
  
  OMNMenuHeaderView *headerView = [OMNMenuHeaderView omn_autolayoutView];
  headerView.userInteractionEnabled = NO;
  [self.contentView addSubview:headerView];

  [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:headerView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:headerView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
  
}

@end
