//
//  OMNBorderedButton.m
//  omnom
//
//  Created by tea on 22.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNBorderedButton.h"
#import "UIImage+omn_helper.h"

#define kBorderedButtonNormalColor ([UIColor blackColor])
#define kBorderedButtonHighlightedColor ([UIColor lightGrayColor])

@implementation OMNBorderedButton

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    
    self.titleLabel.font = [UIFont fontWithName:@"Futura-OSF-Omnom-Regular" size:20.0f];
    [self setTitleColor:kBorderedButtonNormalColor forState:UIControlStateNormal];
    [self setTitleColor:kBorderedButtonHighlightedColor forState:UIControlStateHighlighted];
    [self setTitleColor:kBorderedButtonHighlightedColor forState:UIControlStateDisabled];
    [self setBackgroundImage:[[UIImage imageNamed:@"roundy_button_white_black_border"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 30.0f, 0.0f, 30.0f)] forState:UIControlStateNormal];
    [self setBackgroundImage:[[UIImage imageNamed:@"roundy_button_white_light_grey_border"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 30.0f, 0.0f, 30.0f)] forState:UIControlStateHighlighted];
    [self setBackgroundImage:[[UIImage imageNamed:@"roundy_button_white_light_grey_border"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 30.0f, 0.0f, 30.0f)] forState:UIControlStateDisabled];
  }
  return self;
}

- (void)setTitle:(NSString *)title selectedTitle:(NSString *)selectedTitle image:(UIImage *)image {
  
  if (image) {
    
    if (title.length) {
      CGFloat space = 8.0f;
      CGFloat edgeSpace = 20.0f;
      self.titleLabel.textAlignment = NSTextAlignmentRight;
      self.titleEdgeInsets = UIEdgeInsetsMake(0.0f, space, 0.0f, -space);
      self.contentEdgeInsets = UIEdgeInsetsMake(0.0f, edgeSpace, 0.0f, space + edgeSpace);
    }
    UIImage *templateImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    [self setImage:[templateImage omn_tintWithColor:kBorderedButtonNormalColor] forState:UIControlStateNormal];
    [self setImage:[templateImage omn_tintWithColor:kBorderedButtonHighlightedColor] forState:UIControlStateHighlighted];
  }
  
  [self setTitle:title forState:UIControlStateNormal];

  [self setTitle:selectedTitle forState:UIControlStateSelected];
  [self setTitle:selectedTitle forState:UIControlStateSelected|UIControlStateHighlighted];
}

@end
