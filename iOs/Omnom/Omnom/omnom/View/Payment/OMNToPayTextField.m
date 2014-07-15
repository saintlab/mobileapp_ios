//
//  GToPayTextField.m
//  seocialtest
//
//  Created by tea on 14.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNToPayTextField.h"

@implementation OMNToPayTextField

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
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
  self.textColor = [UIColor lightGrayColor];
}

- (BOOL)becomeFirstResponder {
  
  [UIView transitionWithView:self duration:0.1 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
    
    [self setupActiveState];

  } completion:nil];
  
  return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder {

  [UIView transitionWithView:self duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
    
    [self setupInactiveState];
    
  } completion:nil];
  
  
  return [super resignFirstResponder];
}

- (void)setupInactiveState {
  
  self.textColor = [UIColor lightGrayColor];
  
}

- (void)setupActiveState {
  
  self.textColor = [UIColor whiteColor];
  
}


@end
