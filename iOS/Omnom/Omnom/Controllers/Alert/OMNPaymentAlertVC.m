//
//  OMNPaymentAlertVC.m
//  omnom
//
//  Created by tea on 03.10.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNPaymentAlertVC.h"
#import <OMNStyler.h>
#import "OMNConstants.h"
#import "UIButton+omn_helper.h"
#import "OMNAlertTransitionAnimator.h"
#import "OMNUtils.h"

@interface OMNPaymentAlertVC ()
<UIViewControllerTransitioningDelegate>

@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *detailedText;

@end

@implementation OMNPaymentAlertVC {
  UIButton *_payButton;
  UIButton *_closeButton;
  long long _amount;
}

- (instancetype)initWithText:(NSString *)text detailedText:(NSString *)detailedText amount:(long long)amount {
  self = [super init];
  if (self) {
    _amount = amount;
    self.text = text;
    self.detailedText = detailedText;
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
  
  _payButton.titleLabel.font = FuturaLSFOmnomLERegular(20.0f);
  [_payButton setBackgroundImage:[[UIImage imageNamed:@"red_roundy_button"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 20.0f, 0.0f, 20.0f)] forState:UIControlStateNormal];
  [_payButton setTitleColor:colorWithHexString(@"FFFFFF") forState:UIControlStateNormal];
  [_payButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
  [_payButton addTarget:self action:@selector(payTap) forControlEvents:UIControlEventTouchUpInside];
  [_payButton setTitle:[NSString stringWithFormat:@"Оплатить %@",  [OMNUtils commaStringFromKop:_amount]] forState:UIControlStateNormal];
  
}

- (UILabel *)textLabel {
  UILabel *textLabel = [[UILabel alloc] init];
  textLabel.textColor = colorWithHexString(@"787878");
  textLabel.opaque = YES;
  textLabel.numberOfLines = 0;
  textLabel.textAlignment = NSTextAlignmentCenter;
  textLabel.font = FuturaOSFOmnomRegular(15.0f);
  textLabel.translatesAutoresizingMaskIntoConstraints = NO;
  return textLabel;
}

- (void)omn_setup {
  
  self.view.backgroundColor = [UIColor clearColor];
  
  _fadeView = [[UIView alloc] init];
  _fadeView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
  _fadeView.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view addSubview:_fadeView];
  
  UIColor *backgroundColor = [UIColor whiteColor];
  
  _contentView = [[UIView alloc] init];
  _contentView.opaque = YES;
  _contentView.backgroundColor = backgroundColor;
  _contentView.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view addSubview:_contentView];

  UILabel *textLabel = [self textLabel];
  textLabel.text = self.text;
  textLabel.backgroundColor = backgroundColor;
  [_contentView addSubview:textLabel];
  
  UILabel *detailedTextLabel = [self textLabel];
  detailedTextLabel.text = self.detailedText;
  detailedTextLabel.backgroundColor = backgroundColor;
  [_contentView addSubview:detailedTextLabel];
  
  _closeButton = [[UIButton alloc] init];
  _closeButton.translatesAutoresizingMaskIntoConstraints = NO;
  [_contentView addSubview:_closeButton];
  
  _payButton = [[UIButton alloc] init];
  _payButton.hidden = YES;
  _payButton.translatesAutoresizingMaskIntoConstraints = NO;
  [_contentView addSubview:_payButton];
  
  NSDictionary *views =
  @{
    @"closeButton" : _closeButton,
    @"containerView" : _contentView,
    @"textLabel" : textLabel,
    @"detailedTextLabel" : detailedTextLabel,
    @"payButton" : _payButton,
    @"fadeView" : _fadeView,
    };
  
  CGFloat buttonSize = 44.0f;
  NSDictionary *metrics =
  @{
    @"leftOffset" : [[OMNStyler styler] leftOffset],
    @"buttonSize" : @(buttonSize),
    };

  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[fadeView]|" options:0 metrics:metrics views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[fadeView]|" options:0 metrics:metrics views:views]];
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[containerView]|" options:0 metrics:metrics views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[containerView]|" options:0 metrics:metrics views:views]];
  [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[textLabel]-(leftOffset)-|" options:0 metrics:metrics views:views]];
  
  [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:_closeButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:_closeButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0f constant:buttonSize]];
  
  if (_detailedText.length) {

    _payButton.hidden = NO;
    [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[detailedTextLabel]-(leftOffset)-|" options:0 metrics:metrics views:views]];
    [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[closeButton(buttonSize)]-[textLabel]-[detailedTextLabel]-20-[payButton]-(10)-|" options:0 metrics:metrics views:views]];
    [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:_payButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    
  }
  else {

    [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[closeButton(buttonSize)]-[textLabel]-|" options:0 metrics:metrics views:views]];
    
  }
  
}

- (void)payTap {
  if (self.didPayBlock) {
    self.didPayBlock();
  }
}

- (void)closeTap {
  if (self.didCloseBlock) {
    self.didCloseBlock();
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
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
