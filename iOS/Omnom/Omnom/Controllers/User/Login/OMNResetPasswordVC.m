//
//  OMNResetPasswordVC.m
//  omnom
//
//  Created by tea on 19.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNResetPasswordVC.h"
#import <OMNStyler.h>
#import "OMNConstants.h"
#import "UIBarButtonItem+omn_custom.h"

@implementation OMNResetPasswordVC

- (void)viewDidLoad {
  
  [super viewDidLoad];
  [self omn_setup];
  
  [self.navigationItem setHidesBackButton:YES animated:NO];
  self.view.backgroundColor = [UIColor whiteColor];
  self.navigationItem.rightBarButtonItem = [UIBarButtonItem omn_barButtonWithTitle:kOMN_DONE_BUTTON_TITLE color:[UIColor blackColor] target:self action:@selector(doneTap)];
  
}

- (void)omn_setup {
  
  UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"success_icon_green"]];
  imageView.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view addSubview:imageView];
  
  UILabel *label = [[UILabel alloc] init];
  label.translatesAutoresizingMaskIntoConstraints = NO;
  label.numberOfLines = 0;
  label.textAlignment = NSTextAlignmentCenter;
  label.text = NSLocalizedString(@"RESET_PASSWORD_HINT", @"На вашу почту была выслана\nссылка для смены номера\nтелефона");
  label.font = FuturaOSFOmnomRegular(20.0f);
  label.textColor = [OMNStyler greyColor];
  [self.view addSubview:label];
  
  NSDictionary *views =
  @{
    @"imageView" : imageView,
    @"label" : label,
    @"topLayoutGuide" : self.topLayoutGuide,
    };

  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[label]-|" options:kNilOptions metrics:nil views:views]];
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topLayoutGuide]-(20)-[imageView]-[label]" options:kNilOptions metrics:nil views:views]];
  
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

