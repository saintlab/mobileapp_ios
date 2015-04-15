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
#import "UIButton+omn_helper.h"
#import "UIView+omn_autolayout.h"
#import "UIImage+omn_helper.h"

@implementation OMNMenuHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
  
  self = [super initWithFrame:CGRectMake(0.0f, 0.0f, 0.0f, 44.0f)];
  if (self) {
    
    [self omn_setup];
    
  }
  return self;
}

- (void)omn_setup {
  
  UIColor *tintColor = colorWithHexString(@"F5A623");
  UIColor *highlightedTintColor = [tintColor colorWithAlphaComponent:0.5f];
  self.titleLabel.font = FuturaOSFOmnomRegular(25.0f);
  [self setTitleColor:tintColor forState:UIControlStateNormal];
  [self setTitleColor:highlightedTintColor forState:UIControlStateHighlighted];
  [self setTitle:kOMN_MENU_LIST_TITLE forState:UIControlStateNormal];
  [self setImage:[[UIImage imageNamed:@"ic_menu"] omn_tintWithColor:tintColor] forState:UIControlStateNormal];
  [self setImage:[[UIImage imageNamed:@"ic_menu"] omn_tintWithColor:highlightedTintColor] forState:UIControlStateHighlighted];
  [self omn_centerButtonAndImageWithSpacing:7.0f];
  
}

@end
