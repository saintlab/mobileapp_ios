//
//  OMNMenuHeaderLabel.m
//  omnom
//
//  Created by tea on 12.02.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMenuHeaderLabel.h"
#import <OMNStyler.h>

@implementation OMNMenuHeaderLabel

- (instancetype)init {
  self = [super init];
  if (self) {
    
    self.textColor = colorWithHexString(@"FFFFFF");
    self.highlightedTextColor = colorWithHexString(@"CCCCCC");
    self.textAlignment = NSTextAlignmentCenter;
    self.font = FuturaLSFOmnomLERegular(25.0f);
    
  }
  return self;
}

@end
