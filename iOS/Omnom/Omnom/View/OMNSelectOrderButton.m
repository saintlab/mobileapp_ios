//
//  OMNSelectOrderButton.m
//  omnom
//
//  Created by tea on 06.11.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNSelectOrderButton.h"
#import <OMNStyler.h>

@implementation OMNSelectOrderButton

- (instancetype)init {
  self = [super init];
  if (self) {
    
    self.titleLabel.font = FuturaOSFOmnomMedium(20.0f);
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
  }
  return self;
}

@end
