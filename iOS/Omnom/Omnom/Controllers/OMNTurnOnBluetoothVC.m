//
//  OMNTurnOnBluetoothVC.m
//  restaurants
//
//  Created by tea on 08.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNTurnOnBluetoothVC.h"

@interface OMNTurnOnBluetoothVC ()

@end

@implementation OMNTurnOnBluetoothVC {
  UIImageView *_arrowIV;
  UIImageView *_arrowRectangleIV;
}

- (instancetype)initWithParent:(OMNCircleRootVC *)parent{
  self = [super initWithParent:parent];
  if (self) {
    self.faded = YES;
    self.text = NSLocalizedString(@"TURN_ON_BLUETOOTH_HELP_TEXT", @"Включите Bluetooth.\nМожно справиться,\nпотянув за\u00A0край экрана\nснизу-вверх.");
    self.circleIcon = [UIImage imageNamed:@"bluetooth_icon_big"];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self setup];
  
}

- (void)setup {
  
  _arrowIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_up_icon_big"]];
  _arrowIV.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view addSubview:_arrowIV];
  
  _arrowRectangleIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Rectangle 83"]];
  _arrowRectangleIV.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view addSubview:_arrowRectangleIV];
  
  NSDictionary *views =
  @{
    @"arrowIV" : _arrowIV,
    @"arrowRectangleIV" : _arrowRectangleIV,
    };
  
  NSDictionary *metrics =
  @{
    @"bottomOffset" : @(5.0f),
    };
  
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_arrowIV attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_arrowRectangleIV attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[arrowIV][arrowRectangleIV]-(bottomOffset)-|" options:kNilOptions metrics:metrics views:views]];
  
}

- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];
  _arrowIV.center = CGPointMake(CGRectGetWidth(self.view.frame)/2.0f, CGRectGetHeight(self.view.frame) - CGRectGetHeight(_arrowIV.frame)/2.0f);
  _arrowRectangleIV.center = CGPointMake(CGRectGetWidth(self.view.frame)/2.0f, CGRectGetHeight(self.view.frame) - CGRectGetHeight(_arrowRectangleIV.frame)/2.0f);
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

@end
