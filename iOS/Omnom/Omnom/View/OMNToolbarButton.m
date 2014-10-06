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
  return [self initWithImage:image title:title minimumSize:70.0f];
}

- (instancetype)initWithFitImage:(UIImage *)image title:(NSString *)title {
  return [self initWithImage:image title:title minimumSize:0.0f];
}

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title minimumSize:(CGFloat)minimumSize {
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
      [self setImage:[templateImage omn_tintWithColor:kBarButtonHighlightedColor] forState:UIControlStateDisabled];
      
    }
    [self setTitle:title forState:UIControlStateNormal];
    [self sizeToFit];
    if (minimumSize > 0.0f) {
      CGRect frame = self.frame;
      frame.size.width = MAX(minimumSize, frame.size.width);
      self.frame = frame;
    }
    
  }
  return self;
}

- (void)setSelectedImage:(UIImage *)selectedImage selectedTitle:(NSString *)selectedTitle {
  
  UIImage *templateImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
  [self setImage:[templateImage omn_tintWithColor:kBarButtonNormalColor] forState:UIControlStateSelected];
  [self setImage:[templateImage omn_tintWithColor:kBarButtonHighlightedColor] forState:UIControlStateSelected|UIControlStateHighlighted];

  [self setTitle:selectedTitle forState:UIControlStateSelected];
  [self setTitle:selectedTitle forState:UIControlStateSelected|UIControlStateHighlighted];

  [self setTitleColor:kBarButtonNormalColor forState:UIControlStateSelected];
  [self setTitleColor:kBarButtonHighlightedColor forState:UIControlStateSelected|UIControlStateHighlighted];
  
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
    [self setTitleColor:kBarButtonHighlightedColor forState:UIControlStateDisabled];
    [self setTitleColor:kBarButtonHighlightedColor forState:UIControlStateSelected|UIControlStateHighlighted];
  }
  return self;
}

@end
