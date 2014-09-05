//
//  OMNToolbarBotton.m
//  omnom
//
//  Created by tea on 14.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNToolbarButton.h"
#import "UIImage+omn_helper.h"

#define kBarButtonNormalColor ([UIColor blackColor])
#define kBarButtonHighlightedColor ([UIColor lightGrayColor])

@implementation OMNToolbarButton

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title {
  self = [self init];
  if (self) {
    if (image) {
      
      if (title.length) {
        CGFloat space = 8.0f;
        self.titleLabel.textAlignment = NSTextAlignmentRight;
        self.titleEdgeInsets = UIEdgeInsetsMake(0.0f, space, 0.0f, -space);
        self.contentEdgeInsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, space);
      }
      UIImage *templateImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
      
      [self setImage:[templateImage omn_tintWithColor:kBarButtonNormalColor] forState:UIControlStateNormal];
      [self setImage:[templateImage omn_tintWithColor:kBarButtonHighlightedColor] forState:UIControlStateHighlighted];
    }
    [self setTitle:title forState:UIControlStateNormal];
    [self sizeToFit];
  }
  return self;
}

- (instancetype)init {
  self = [super init];
  if (self) {
//    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.tintColor = [UIColor blackColor];
    self.titleLabel.font = [UIFont fontWithName:@"Futura-OSF-Omnom-Regular" size:20.0f];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self setTitleColor:kBarButtonNormalColor forState:UIControlStateNormal];
    [self setTitleColor:kBarButtonHighlightedColor forState:UIControlStateHighlighted];
    [self setTitleColor:kBarButtonHighlightedColor forState:UIControlStateSelected|UIControlStateHighlighted];
  }
  return self;
}

@end
