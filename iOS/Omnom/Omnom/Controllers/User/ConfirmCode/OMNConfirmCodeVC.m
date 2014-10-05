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
#import "OMNResetPasswordVC.h"
#import <BlocksKit.h>

@interface OMNConfirmCodeVC ()

@end

@implementation OMNConfirmCodeVC {

  OMNEnterCodeView *_codeView;
  UILabel *_helpLabel;
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
  
  OMNNavigationBarProgressView *navigationBarProgressView = [[OMNNavigationBarProgressView alloc] initWithText:NSLocalizedString(@"Вход", nil) count:2];
  [navigationBarProgressView setPage:1];
  self.navigationItem.titleView = navigationBarProgressView;
  
  self.view.backgroundColor = [UIColor whiteColor];
  
  UILabel *label = [[UILabel alloc] init];
  label.translatesAutoresizingMaskIntoConstraints = NO;
  label.textAlignment = NSTextAlignmentCenter;
  label.numberOfLines = 0;
  label.font = FuturaOSFOmnomRegular(18.0f);
  label.textColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
  label.text = [NSString stringWithFormat:NSLocalizedString(@"Должна прийти\nSMS с кодом на номер\n%@", nil), _phone];
  [self.view addSubview:label];
  
  _codeView = [[OMNEnterCodeView alloc] init];
  _codeView.enabled = YES;
  [_codeView addTarget:self action:@selector(didEnterCode) forControlEvents:UIControlEventEditingDidEnd];
  [self.view addSubview:_codeView];

  _resendButton = [[UIButton alloc] init];
  _resendButton.translatesAutoresizingMaskIntoConstraints = NO;
  [_resendButton setBackgroundImage:[UIImage imageNamed:@"roundy_button_white_black_border"] forState:UIControlStateNormal];
  [_resendButton setBackgroundImage:[UIImage imageNamed:@"roundy_button_white_light_grey_border"] forState:UIControlStateHighlighted];
  [_resendButton setBackgroundImage:[UIImage imageNamed:@"roundy_button_white_light_grey_border"] forState:UIControlStateDisabled];
  [_resendButton setTitle:NSLocalizedString(@"Выслать новый код", nil) forState:UIControlStateNormal];
  [_resendButton addTarget:self action:@selector(resentTap) forControlEvents:UIControlEventTouchUpInside];
  _resendButton.titleLabel.font = FuturaOSFOmnomRegular(18.0f);
  _resendButton.contentEdgeInsets = UIEdgeInsetsMake(0.0f, 10.0f, 0.0f, 10.0f);
  [_resendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  [_resendButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
  [_resendButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
  [self.view addSubview:_resendButton];
  
  
//  UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.frame), 44.0f)];
//  toolBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//  
//  NSMutableArray *items = [NSMutableArray arrayWithObject:[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Повторить код", nil) style:UIBarButtonItemStylePlain target:self action:@selector(resentTap)]];
//  if (self.allowChangePhoneNumber) {
//    [items addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]];
//    [items addObject:[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Изменить номер", nil) style:UIBarButtonItemStylePlain target:self action:@selector(changeNumberTap)]];
//  }
//  
//  toolBar.items = items;
//  _codeView.textField.inputAccessoryView = toolBar;

  NSDictionary *views =
  @{
    @"label" : label,
    @"codeView" : _codeView,
    @"resendButton" : _resendButton,
    @"topLayoutGuide" : self.topLayoutGuide,
    };
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topLayoutGuide]-[label]-[codeView]-(20)-[resendButton]" options:0 metrics:0 views:views]];
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_codeView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_resendButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];

  [self startTimer];
  
}

- (void)startTimer {
  [_timer invalidate];
  _resendButton.enabled = NO;
  __weak UIButton *resendButton = _resendButton;
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

- (void)changeNumberTap {

  __weak typeof(self)weakSelf = self;
  [OMNUser recoverUsingData:_phone completion:^{
    
    [weakSelf didRecoveCode];
    
  } failure:^(NSError *error) {
    
    
    
  }];
  
}

- (void)didRecoveCode {
  
  OMNResetPasswordVC *resetPasswordVC = [[OMNResetPasswordVC alloc] init];
  __weak typeof(self)weakSelf = self;
  resetPasswordVC.completionBlock = ^{
    [weakSelf didFinishReset];
  };
  [self.navigationController pushViewController:resetPasswordVC animated:YES];
  
}

- (void)didFinishReset {

  if ([self.delegate respondsToSelector:@selector(confirmCodeVCDidResetPhone:)]) {
    [self.delegate confirmCodeVCDidResetPhone:self];
  }
  
}

- (void)didEnterCode {
  
  _codeView.enabled = NO;
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
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}


@end
