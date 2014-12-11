//
//  OMNToolbarBotton.m
//  omnom
//
//  Created by tea on 14.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNToolbarButton.h"
#import "UIImage+omn_helper.h"
#import "UIButton+omn_helper.h"

#define kBarButtonNormalColor ([UIColor blackColor])

@implementation OMNToolbarButton {
  UIImage *_image;
}

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title {
  return [self initWithImage:image title:title minimumSize:70.0f color:kBarButtonNormalColor];
}

- (instancetype)initWithFitImage:(UIImage *)image title:(NSString *)title {
  return [self initWithImage:image title:title minimumSize:0.0f color:kBarButtonNormalColor];
}

- (instancetype)initWithFitImage:(UIImage *)image title:(NSString *)title  color:(UIColor *)color {
  return [self initWithImage:image title:title minimumSize:0.0f color:color];
}

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title minimumSize:(CGFloat)minimumSize color:(UIColor *)color {
  self = [self init];
  if (self) {
    if (image) {
      _image = image;
      if (title.length) {
        CGFloat space = 4.0f;
        self.titleLabel.textAlignment = NSTextAlignmentRight;
        [self omn_centerButtonAndImageWithSpacing:space];
      }
      
    }
    
    if (title) {
      [self setTitle:title forState:UIControlStateNormal];
    }

    [self setColor:color];
    
    [self sizeToFit];
    if (minimumSize > 0.0f) {
      CGRect frame = self.frame;
      frame.size.width = MAX(minimumSize, frame.size.width);
      self.frame = frame;
    }
    
  }
  return self;
}

- (void)setImage:(UIImage *)image color:(UIColor *)color {
  
  UIImage *templateImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
  UIColor *highlightedColor = [color colorWithAlphaComponent:0.5f];
  [self setImage:[templateImage omn_tintWithColor:color] forState:UIControlStateNormal];
  [self setImage:[templateImage omn_tintWithColor:highlightedColor] forState:UIControlStateHighlighted];
  [self setImage:[templateImage omn_tintWithColor:highlightedColor] forState:UIControlStateDisabled];
  
}

- (void)setColor:(UIColor *)color {
  
  UIColor *highlightedColor = [color colorWithAlphaComponent:0.5f];
  [self setTitleColor:color forState:UIControlStateNormal];
  [self setTitleColor:highlightedColor forState:UIControlStateHighlighted];
  [self setTitleColor:highlightedColor forState:UIControlStateDisabled];
  [self setTitleColor:highlightedColor forState:UIControlStateSelected|UIControlStateHighlighted];
  
  if (_image) {
    [self setImage:_image color:color];
  }
  
}

- (void)setSelectedImage:(UIImage *)selectedImage selectedTitle:(NSString *)selectedTitle {

  UIColor *highlightedColor = [kBarButtonNormalColor colorWithAlphaComponent:0.5f];
  if (selectedImage) {
    UIImage *templateImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self setImage:[templateImage omn_tintWithColor:kBarButtonNormalColor] forState:UIControlStateSelected];
    [self setImage:[templateImage omn_tintWithColor:highlightedColor] forState:UIControlStateSelected|UIControlStateHighlighted];
  }

  if (selectedTitle) {
    [self setTitle:selectedTitle forState:UIControlStateSelected];
    [self setTitle:selectedTitle forState:UIControlStateSelected|UIControlStateHighlighted];
  }

  [self setTitleColor:kBarButtonNormalColor forState:UIControlStateSelected];
  [self setTitleColor:highlightedColor forState:UIControlStateSelected|UIControlStateHighlighted];
  
}

- (instancetype)init {
  self = [super init];
  if (self) {

    self.tintColor = [UIColor blackColor];
    self.titleLabel.font = [UIFont fontWithName:@"Futura-OSF-Omnom-Regular" size:20.0f];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;

  }
  return self;
}

@end
