//
//  GTipSelector.m
//  seocialtest
//
//  Created by tea on 20.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "GTipSelector.h"

@implementation GTipSelector {
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
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = i;
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    button.titleLabel.numberOfLines = 0;
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.frame = CGRectMake(i * buttonWidth, 0, buttonWidth, buttonHeight);
    [button addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    [buttons addObject:button];
  }
  
  _buttons = buttons;
  
}

- (void)buttonTap:(UIButton *)b {
  
  self.selectedIndex = b.tag;
  [self sendActionsForControlEvents:UIControlEventValueChanged];
  
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {

  UIButton *previousSelectedButton = _buttons[_selectedIndex];
  previousSelectedButton.selected = NO;
  
  _selectedIndex = selectedIndex;
  UIButton *b = _buttons[selectedIndex];
  b.selected = YES;
  
  _calculationAmount.selectedTipIndex = selectedIndex;
  
}

- (void)update {
  
  [_calculationAmount.tips enumerateObjectsUsingBlock:^(GTip *tip, NSUInteger idx, BOOL *stop) {
    
    UIButton *button = _buttons[idx];
    [button setTitle:tip.title forState:UIControlStateNormal];
    [button setTitle:tip.selectedTitle forState:UIControlStateSelected];
    
  }];
  
}

- (void)setCalculationAmount:(GCalculationAmount *)calculationAmount {
  _calculationAmount = calculationAmount;
  
  [self update];
  
  
}


@end
