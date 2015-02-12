//
//  OMNMenuCategoryHeaderView.m
//  omnom
//
//  Created by tea on 23.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMenuCategoryHeaderView.h"
#import "UIView+omn_autolayout.h"
#import <OMNStyler.h>
#import "OMNConstants.h"

@implementation OMNMenuCategoryHeaderView {
  
  UILabel *_label;
  
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithReuseIdentifier:reuseIdentifier];
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
  
  self.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"bar_2nd_level_category"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 20.0f, 0.0f, 20.0f)]];
  
  _label = [UILabel omn_autolayoutView];
  _label.textColor = colorWithHexString(@"000000");
  _label.textAlignment = NSTextAlignmentCenter;
  _label.font = FuturaOSFOmnomRegular(20.0f);
  _label.adjustsFontSizeToFitWidth = YES;
  [self addSubview:_label];
  
  NSDictionary *views =
  @{
    @"label" : _label,
    };
  
  NSDictionary *metrics =
  @{
    };
  
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[label]|" options:kNilOptions metrics:metrics views:views]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[label]|" options:kNilOptions metrics:metrics views:views]];
  
}

- (void)setMenuCategory:(OMNMenuCategory *)menuCategory {
  
  _menuCategory = menuCategory;
  _label.text = menuCategory.name;
  
}

@end
