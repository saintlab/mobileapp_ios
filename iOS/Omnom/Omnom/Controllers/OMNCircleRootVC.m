//
//  OMNSearchBeaconRootVC.m
//  omnom
//
//  Created by tea on 21.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNCircleRootVC.h"

@interface OMNCircleRootVC ()

@end

@implementation OMNCircleRootVC {
  NSString *_title;
  NSArray *_buttons;
  
  __weak IBOutlet NSLayoutConstraint *_actionButtonSpace;
}

- (instancetype)initWithTitle:(NSString *)title buttons:(NSArray *)buttons {
  self = [super initWithNibName:@"OMNCircleRootVC" bundle:nil];
  if (self) {
    _title = title;
    _buttons = buttons;
  }
  return self;
}

- (void)viewDidLoad {
  
  [super viewDidLoad];

  if (self.circleIcon) {
    [self.circleButton setImage:self.circleIcon forState:UIControlStateNormal];
  }
  
  [self.circleButton setBackgroundImage:self.circleBackground forState:UIControlStateNormal];

  if (_buttons.count) {
    self.button.hidden = NO;
    [self.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.button setTitle:[_buttons firstObject] forState:UIControlStateNormal];
    self.button.backgroundColor = [UIColor blackColor];
  }
  else {
    self.button.hidden = YES;
  }
  
  [self.button addTarget:self action:@selector(buttonTap) forControlEvents:UIControlEventTouchUpInside];
  self.label.text = _title;
  self.label.alpha = 0.0f;
  self.label.textColor = [UIColor whiteColor];
  
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.navigationController setNavigationBarHidden:YES animated:animated];
  _actionButtonSpace.constant = -CGRectGetHeight(self.button.frame);
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  _actionButtonSpace.constant = 0;
  [UIView animateWithDuration:0.3 animations:^{
    self.label.alpha = 1.0f;
    [self.button layoutIfNeeded];
    [self.label layoutIfNeeded];
  }];
}

- (void)buttonTap {
  if (self.actionBlock) {
    self.actionBlock();
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

@end
