//
//  OMNResetPasswordVC.m
//  omnom
//
//  Created by tea on 19.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNResetPasswordVC.h"
#import <OMNStyler.h>

@interface OMNResetPasswordVC ()

@end

@implementation OMNResetPasswordVC

- (void)viewDidLoad {
  
  [super viewDidLoad];
  [self setup];
  
  [self.navigationItem setHidesBackButton:YES animated:NO];
  self.view.backgroundColor = [UIColor whiteColor];
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Готово", nil) style:UIBarButtonItemStylePlain target:self action:@selector(doneTap)];
  
}

- (void)setup {
  
  UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"success_icon_green"]];
  imageView.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view addSubview:imageView];
  
  UILabel *label = [[UILabel alloc] init];
  label.translatesAutoresizingMaskIntoConstraints = NO;
  label.numberOfLines = 0;
  label.textAlignment = NSTextAlignmentCenter;
  label.text = NSLocalizedString(@"На ваш e-mail выслана ссылка\nдля смены номера\nтелефона", nil);
  label.font = [UIFont fontWithName:@"Fututa-OSF-Omnom-Regular" size:20.0f];
  label.textColor = colorWithHexString(@"787878");
  [self.view addSubview:label];
  
  NSDictionary *views =
  @{
    @"imageView" : imageView,
    @"label" : label,
    @"topLayoutGuide" : self.topLayoutGuide,
    };

  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[label]-|" options:0 metrics:nil views:views]];
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topLayoutGuide]-[imageView]-[label]" options:0 metrics:nil views:views]];
  
}

- (void)doneTap {
  
  if (self.completionBlock) {
    self.completionBlock();
  }
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  
}

@end

