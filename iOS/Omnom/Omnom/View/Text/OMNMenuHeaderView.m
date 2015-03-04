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
  self = [super initWithFrame:frame];
  if (self) {
    
    [self omn_setup];
    
  }
  return self;
}

- (void)omn_setup {
  
  UIColor *tintColor = colorWithHexString(@"F5A623");
  
  self.titleLabel.font = FuturaOSFOmnomRegular(25.0f);
  [self setTitleColor:tintColor forState:UIControlStateNormal];
  [self setTitleColor:[tintColor colorWithAlphaComponent:0.5f] forState:UIControlStateHighlighted];
  [self setTitle:NSLocalizedString(@"MENU_LIST_TITLE", @"Меню") forState:UIControlStateNormal];
  [self setImage:[[UIImage imageNamed:@"ic_menu"] omn_tintWithColor:tintColor] forState:UIControlStateNormal];
  [self omn_centerButtonAndImageWithSpacing:7.0f];
  
}

@end
