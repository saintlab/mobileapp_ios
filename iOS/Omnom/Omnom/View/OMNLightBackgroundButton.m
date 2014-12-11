//
//  OMNLignBackgroundButton.m
//  omnom
//
//  Created by tea on 02.09.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNLightBackgroundButton.h"
#import "OMNConstants.h"

@implementation OMNLightBackgroundButton

- (instancetype)init {
  self = [super init];
  if (self) {
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    self.titleLabel.font = FuturaOSFOmnomRegular(20.0f);
    self.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.3f];
    self.contentEdgeInsets = UIEdgeInsetsMake(3.0f, 10.0f, 3.0f, 10.0f);
    self.layer.cornerRadius = 5.0f;
    [self setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
  }
  return self;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state {
  [super setTitle:title forState:state];
  [self sizeToFit];
}

@end
