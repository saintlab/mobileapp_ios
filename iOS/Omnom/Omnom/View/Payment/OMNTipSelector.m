//
//  GTipSelector.m
//  seocialtest
//
//  Created by tea on 20.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNTipSelector.h"
#import "OMNTipButton.h"

@implementation OMNTipSelector {
  NSArray *_buttons;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    [self setup];
  }
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
  self = [super initWithCoder:coder];
  if (self) {
    [self setup];
  }
  return self;
}

- (void)setup {
  
  [self setupButtons];
  self.backgroundColor = [UIColor clearColor];
}

- (void)setupButtons {
  
  NSMutableArray *buttons = [NSMutableArray arrayWithCapacity:4];
  const CGFloat buttonWidth = 80.0f;
  const CGFloat buttonHeight = 55.0f;
  for (int i = 0; i < 4; i++) {
    
    OMNTipButton *tipButton = [[OMNTipButton alloc] init];
    tipButton.tag = i;
    tipButton.frame = CGRectMake(i * buttonWidth, 0, buttonWidth, buttonHeight);
    [tipButton addTarget:self action:@selector(tipButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:tipButton];
    [buttons addObject:tipButton];
  }
  
  _buttons = buttons;
  
}

- (void)tipButtonTap:(OMNTipButton *)tipButton {
  
  self.selectedIndex = tipButton.tag;
  [self sendActionsForControlEvents:UIControlEventValueChanged];
  
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {

  _selectedIndex = selectedIndex;
  _calculationAmount.selectedTipIndex = selectedIndex;
  
}

- (void)update {
  
  OMNCalculationAmount *calculationAmount = _calculationAmount;
  [_buttons enumerateObjectsUsingBlock:^(OMNTipButton *tipButton, NSUInteger idx, BOOL *stop) {
    
    tipButton.tip = calculationAmount.tips[idx];
    [calculationAmount configureTipButton:tipButton];
    tipButton.selected = (idx == calculationAmount.selectedTipIndex);
    
  }];
  
}

- (void)setCalculationAmount:(OMNCalculationAmount *)calculationAmount {
  _calculationAmount = calculationAmount;
  self.selectedIndex = 1;
  [self update];
  
}


@end
