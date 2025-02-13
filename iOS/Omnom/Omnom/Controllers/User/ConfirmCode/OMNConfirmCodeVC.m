//
//  OMNConfirmCodeVC.m
//  restaurants
//
//  Created by tea on 17.06.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNConfirmCodeVC.h"
#import "OMNEnterCodeView.h"
#import "OMNUser.h"
#import "OMNNavigationBarProgressView.h"
#import <BlocksKit.h>
#import <OMNStyler.h>
#import "UIView+omn_autolayout.h"

@implementation OMNConfirmCodeVC {

  OMNEnterCodeView *_codeView;
  UIButton *_resendButton;
  NSString *_phone;
  NSTimer *_timer;
}

- (void)dealloc {
  [_timer invalidate];
  _timer = nil;
}

- (instancetype)initWithPhone:(NSString *)phone {
  self = [super init];
  if (self) {
    
    _phone = phone;
    
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  OMNNavigationBarProgressView *navigationBarProgressView = [[OMNNavigationBarProgressView alloc] initWithText:kOMN_LOGIN_TITLE count:2];
  [navigationBarProgressView setPage:1];
  self.navigationItem.titleView = navigationBarProgressView;
  
  self.view.backgroundColor = [UIColor whiteColor];
  
  UILabel *label = [UILabel omn_autolayoutView];
  label.textAlignment = NSTextAlignmentCenter;
  label.numberOfLines = 0;
  label.font = FuturaOSFOmnomRegular(18.0f);
  label.textColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
  label.text = [NSString stringWithFormat:kOMN_CONFIRM_CODE_HINT_FORMAT, _phone];
  [self.view addSubview:label];
  
  _codeView = [[OMNEnterCodeView alloc] init];
  _codeView.enabled = YES;
  [_codeView addTarget:self action:@selector(didEnterCode) forControlEvents:UIControlEventEditingDidEnd];
  [self.view addSubview:_codeView];

  _resendButton = [UIButton omn_autolayoutView];
  [_resendButton setBackgroundImage:[UIImage imageNamed:@"roundy_button_white_black_border"] forState:UIControlStateNormal];
  [_resendButton setBackgroundImage:[UIImage imageNamed:@"roundy_button_white_light_grey_border"] forState:UIControlStateHighlighted];
  [_resendButton setBackgroundImage:[UIImage imageNamed:@"roundy_button_white_light_grey_border"] forState:UIControlStateDisabled];
  [_resendButton setTitle:kOMN_RESEND_CODE_BUTTON_TITLE forState:UIControlStateNormal];
  [_resendButton addTarget:self action:@selector(resentTap) forControlEvents:UIControlEventTouchUpInside];
  _resendButton.titleLabel.font = FuturaOSFOmnomRegular(18.0f);
  _resendButton.contentEdgeInsets = [OMNStyler buttonEdgeInsets];
  [_resendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  [_resendButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
  [_resendButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
  [self.view addSubview:_resendButton];

  NSDictionary *views =
  @{
    @"label" : label,
    @"codeView" : _codeView,
    @"resendButton" : _resendButton,
    @"topLayoutGuide" : self.topLayoutGuide,
    };
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topLayoutGuide]-[label]-[codeView]-(20)-[resendButton]" options:kNilOptions metrics:nil views:views]];
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_codeView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_resendButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];

  [self startTimer];
  
}

- (void)startTimer {
  
  [_timer invalidate];
  _resendButton.enabled = NO;
  UIButton *resendButton = _resendButton;
  _timer = [NSTimer bk_scheduledTimerWithTimeInterval:7.0 block:^(NSTimer *timer) {
    
    [UIView transitionWithView:resendButton duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
      resendButton.enabled = YES;
    } completion:nil];
    
  } repeats:NO];
  
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  [_codeView becomeFirstResponder];
  
}

- (void)resentTap {
  
  [self startTimer];
  [self.delegate confirmCodeVCRequestResendCode:self];
  
}

- (void)didEnterCode {
  
  _codeView.enabled = NO;
  _resendButton.enabled = NO;
  UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
  [spinner startAnimating];
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
  [self.delegate confirmCodeVC:self didEnterCode:[_codeView.code copy]];
  
}

- (void)resetAnimated:(BOOL)animated {
  
  self.navigationItem.rightBarButtonItem = nil;
  if (animated) {
    
    const CGFloat offset = 5.0f;
    _codeView.transform = CGAffineTransformMakeTranslation(-offset, 0.0f);
    [UIView animateWithDuration:0.07 delay:0. options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat animations:^{
      [UIView setAnimationRepeatCount:2];
      
      _codeView.transform = CGAffineTransformMakeTranslation(offset, 0.0f);
      
    } completion:^(BOOL finished) {
      
      _codeView.transform = CGAffineTransformIdentity;
      
    }];
  }
  
  _codeView.code = @"";
  _codeView.enabled = YES;
  _resendButton.enabled = YES;
  
}

@end
