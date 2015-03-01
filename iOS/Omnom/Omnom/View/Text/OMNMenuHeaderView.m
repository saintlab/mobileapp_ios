//
//  OMNMenuHeaderView.m
//  omnom
//
//  Created by tea on 26.02.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMenuHeaderView.h"
#import <OMNStyler.h>
#import "OMNConstants.h"
#import "UIView+omn_autolayout.h"
#import "UIImage+omn_helper.h"

@implementation OMNMenuHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    
    [self omn_setup];
    
  }
  return self;
}

- (void)omn_setup {
  
  UIColor *tintColor = colorWithHexString(@"F5A623");
  
  UILabel *label = [UILabel omn_autolayoutView];
  label.textColor = tintColor;
  label.font = FuturaOSFOmnomRegular(25.0f);
  label.text = NSLocalizedString(@"MENU_LIST_TITLE", @"Меню");
  [self addSubview:label];
  
  UIImageView *iconView = [UIImageView omn_autolayoutView];
  iconView.contentMode = UIViewContentModeCenter;
  iconView.image = [[UIImage imageNamed:@"ic_menu"] omn_tintWithColor:tintColor];
  [self addSubview:iconView];
  
  NSDictionary *views =
  @{
    @"label" : label,
    @"iconView" : iconView,
    };
  
  NSDictionary *metrics =
  @{
    };
  
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[iconView]-(7@999)-[label]|" options:kNilOptions metrics:metrics views:views]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[iconView]|" options:kNilOptions metrics:metrics views:views]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[label]|" options:kNilOptions metrics:metrics views:views]];
  
}

- (CGSize)sizeThatFits:(CGSize)size {
  
  [self layoutIfNeeded];
  size = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
  return size;
  
}

@end
