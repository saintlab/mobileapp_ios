//
//  OMNBorderedButton.m
//  omnom
//
//  Created by tea on 22.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNBorderedButton.h"

@implementation OMNBorderedButton

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.titleLabel.font = [UIFont fontWithName:@"Futura-OSF-Omnom-Regular" size:20.0f];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [self setTitleColor:[UIColor colorWithWhite:0.0f alpha:0.3f] forState:UIControlStateDisabled];
    [self setBackgroundImage:[[UIImage imageNamed:@"roundy_button_white_black_border"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 30.0f, 0.0f, 30.0f)] forState:UIControlStateNormal];
    [self setBackgroundImage:[[UIImage imageNamed:@"roundy_button_white_light_grey_border"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 30.0f, 0.0f, 30.0f)] forState:UIControlStateHighlighted];
    [self setBackgroundImage:[[UIImage imageNamed:@"roundy_button_white_light_grey_border"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 30.0f, 0.0f, 30.0f)] forState:UIControlStateDisabled];
  }
  return self;
}

@end
