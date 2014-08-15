//
//  OMNToolbarBotton.m
//  omnom
//
//  Created by tea on 14.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNToolbarButton.h"

@implementation OMNToolbarButton

- (instancetype)init {
  self = [super init];
  if (self) {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.tintColor = [UIColor blackColor];
    self.titleLabel.font = [UIFont fontWithName:@"Futura-OSF-Omnom-Regular" size:20.0f];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected|UIControlStateHighlighted];
  }
  return self;
}

@end
