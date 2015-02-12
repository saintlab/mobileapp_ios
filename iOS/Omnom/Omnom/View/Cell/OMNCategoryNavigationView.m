//
//  OMNProductNavigationView.m
//  omnom
//
//  Created by tea on 28.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNCategoryNavigationView.h"
#import "OMNConstants.h"
#import <OMNStyler.h>
#import "UIImage+omn_helper.h"

@implementation OMNCategoryNavigationView {
  
  UILabel *_label;
  UIImageView *_iconView;
  
}

- (instancetype)init {
  self = [super initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
  if (self) {
    
    _label = [[UILabel alloc] init];
    _label.font = FuturaLSFOmnomLERegular(17.0f);
    _label.textColor = colorWithHexString(@"FFFFFF");
    [self addSubview:_label];
   
    _iconView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"ic_back_to_menu"] omn_tintWithColor:[UIColor whiteColor]]];
    [self addSubview:_iconView];
    
    UIButton *button = [[UIButton alloc] initWithFrame:self.bounds];
    button.autoresizingMask = (UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth);
    [button addTarget:self action:@selector(buttonTap) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
  }
  return self;
}

- (void)buttonTap {
  
  [self sendActionsForControlEvents:UIControlEventTouchUpInside];
  
}

- (void)setCategory:(OMNMenuCategory *)category {
  
  _category = category;
  _label.text = category.name;
  [_label sizeToFit];
  [self layoutIfNeeded];
  
}

- (void)layoutSubviews {
  [super layoutSubviews];
  
  CGFloat superviewCenter = 0.5f*CGRectGetWidth(self.superview.frame);
  CGFloat centerXOffset = (superviewCenter - CGRectGetMinX(self.frame));
  _label.center = CGPointMake(centerXOffset, 18.0f);
  _iconView.center = CGPointMake(centerXOffset, 34.0f);
  
}

@end
