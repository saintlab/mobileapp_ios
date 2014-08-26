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

  [UIView animateWithDuration:0.3 animations:^{
    self.label.alpha = 1.0f;
    [self.label layoutIfNeeded];
    [self.view layoutIfNeeded];
  }];
}

- (void)setFaded:(BOOL)faded {
  _faded = faded;
  _fadeView.hidden = !self.faded;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

@end

