//
//  OMNSelectOrderButton.m
//  omnom
//
//  Created by tea on 06.11.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNSelectOrderButton.h"
#import "OMNConstants.h"

@implementation OMNSelectOrderButton

- (instancetype)init {
  self = [super init];
  if (self) {
    self.titleLabel.font = FuturaOSFOmnomMedium(20.0f);
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.layer.borderColor = [UIColor blackColor].CGColor;
    self.contentEdgeInsets = UIEdgeInsetsMake(3.0f, 10.0f, 3.0f, 10.0f);
    self.layer.borderWidth = 1.0f;
    self.layer.cornerRadius = 2.0f;
  }
  return self;
}

@end
