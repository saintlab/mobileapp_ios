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
  UIView *_fadeView;
  __weak IBOutlet NSLayoutConstraint *_actionButtonSpace;
}

- (instancetype)initWithParent:(OMNCircleRootVC *)parent {
  self = [super initWithNibName:@"OMNCircleRootVC" bundle:nil];
  if (self) {
    self.circleBackground = parent.circleBackground;
    self.backgroundImage = parent.backgroundImage;
  }
  return self;
}

- (void)viewDidLoad {
  
  [super viewDidLoad];

  if (self.circleIcon) {
    [self.circleButton setImage:self.circleIcon forState:UIControlStateNormal];
  }

  _fadeView = [[UIView alloc] initWithFrame:self.backgroundView.bounds];
  _fadeView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.7f];
  _fadeView.hidden = !self.faded;
  [self.backgroundView addSubview:_fadeView];
  
  self.circleBackground = _circleBackground;
  self.label.font = [UIFont fontWithName:@"Futura-OSF-Omnom-Regular" size:25.0f];
  
  if (self.buttonInfo) {
    self.button.hidden = NO;
    [self.button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.button.tintColor = [UIColor blackColor];
    self.button.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.9f];
    self.button.titleEdgeInsets = UIEdgeInsetsMake(0.0f, 10.0f, 0.0f, 0.0f);
    [self.button addTarget:self action:@selector(buttonTap) forControlEvents:UIControlEventTouchUpInside];
    
    [self.button setTitle:self.buttonInfo[@"title"] forState:UIControlStateNormal];
    [self.button setImage:self.buttonInfo[@"image"] forState:UIControlStateNormal];

  }
  else {
    self.button.hidden = YES;
  }
  
  self.label.text = self.text;
  self.label.alpha = 0.0f;
  self.label.textColor = [UIColor blackColor];
  
}

- (void)setCircleBackground:(UIImage *)circleBackground {
  _circleBackground = circleBackground;
  [self.circleButton setBackgroundImage:self.circleBackground forState:UIControlStateNormal];
}

- (void)setCircleIcon:(UIImage *)circleIcon {
  _circleIcon = circleIcon;
  [self.circleButton setImage:circleIcon forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.navigationController setNavigationBarHidden:YES animated:animated];

}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  if (NO == self.navigationController.toolbarHidden) {
    [self.navigationController setToolbarHidden:YES animated:animated];
  }
  
  _actionButtonSpace.constant = 0;
  [UIView animateWithDuration:0.3 animations:^{
    self.label.alpha = 1.0f;
    [self.button layoutIfNeeded];
    [self.label layoutIfNeeded];
  }];
}

- (void)setFaded:(BOOL)faded {
  _faded = faded;
  _fadeView.hidden = !self.faded;
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
