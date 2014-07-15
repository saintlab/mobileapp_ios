//
//  OMNNumberKeyboardView.m
//  seocialtest
//
//  Created by tea on 20.06.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNNumberKeyboardView.h"

const CGFloat kCalculatorButtonWidth = 44.0f;
const CGFloat kCalculatorButtonOffset = 15.0f;

@implementation OMNNumberKeyboardView

- (instancetype)init {
  self = [super initWithFrame:CGRectMake(0, 0, 320.0f, 300.0f)];
  if (self) {
    [self setup];
  }
  return self;
}

- (void)awakeFromNib {
  [self setup];
}

- (UIButton *)numberButton {
  
  UIButton *numberButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kCalculatorButtonWidth, kCalculatorButtonWidth)];
  return numberButton;
  
}

- (void)setup {
  
  for (int i = 1; i <= 9; i++) {
    
  }
  
}

@end
