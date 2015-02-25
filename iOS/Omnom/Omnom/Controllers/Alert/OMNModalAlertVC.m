//
//  OMNModalAlertVC.m
//  omnom
//
//  Created by tea on 08.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNModalAlertVC.h"
#import "OMNAlertTransitionAnimator.h"
#import "UIView+omn_autolayout.h"
#import <OMNStyler.h>
#import "UIImage+omn_helper.h"
#import "UIButton+omn_helper.h"

@interface OMNModalAlertVC ()
<UIViewControllerTransitioningDelegate>

@end

@implementation OMNModalAlertVC {
  
  UIButton *_closeButton;
  
}

- (instancetype)init {
  self = [super init];
  if (self) {
    
    self.modalPresentationStyle = UIModalPresentationCustom;
    self.transitioningDelegate = self;
    
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
 
  [self omn_setup];
  [_closeButton omn_setImage:[UIImage imageNamed:@"cross_icon_black"] withColor:[UIColor blackColor]];
  [_closeButton addTarget:self action:@selector(closeTap) forControlEvents:UIControlEventTouchUpInside];
  
}

- (void)closeTap {
  
  if (self.didCloseBlock) {
    
    self.didCloseBlock();
    
  }
  
}

- (void)omn_setup {
  
  self.view.backgroundColor = [UIColor clearColor];
  
  _fadeView = [UIView omn_autolayoutView];
  _fadeView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
  [self.view addSubview:_fadeView];
  
  UIColor *backgroundColor = [UIColor whiteColor];
  
  _alertView = [UIView omn_autolayoutView];
  _alertView.opaque = YES;
  _alertView.backgroundColor = backgroundColor;
  [self.view addSubview:_alertView];
  
  _closeButton = [UIButton omn_autolayoutView];
  [_alertView addSubview:_closeButton];
  
  _contentView = [UIView omn_autolayoutView];
  _contentView.opaque = YES;
  _contentView.backgroundColor = backgroundColor;
  [_alertView addSubview:_contentView];
  
  NSDictionary *views =
  @{
    @"closeButton" : _closeButton,
    @"alertView" : _alertView,
    @"fadeView" : _fadeView,
    @"contentView" : _contentView,
    };
  
  CGFloat buttonSize = 44.0f;
  NSDictionary *metrics =
  @{
    @"leftOffset" : [[OMNStyler styler] leftOffset],
    @"buttonSize" : @(buttonSize),
    };
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[fadeView]|" options:kNilOptions metrics:metrics views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[fadeView]|" options:kNilOptions metrics:metrics views:views]];
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[alertView]|" options:kNilOptions metrics:metrics views:views]];
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_alertView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f]];

  [_alertView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[closeButton(buttonSize)]-[contentView]|" options:kNilOptions metrics:metrics views:views]];
  [_alertView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[contentView]|" options:kNilOptions metrics:metrics views:views]];
  
  [_alertView addConstraint:[NSLayoutConstraint constraintWithItem:_closeButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_alertView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  [_alertView addConstraint:[NSLayoutConstraint constraintWithItem:_closeButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0f constant:buttonSize]];
  
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source {
  
  OMNAlertTransitionAnimator *animator = [[OMNAlertTransitionAnimator alloc] init];
  animator.presenting = YES;
  return animator;
  
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
  
  OMNAlertTransitionAnimator *animator = [[OMNAlertTransitionAnimator alloc] init];
  return animator;
  
}

@end
