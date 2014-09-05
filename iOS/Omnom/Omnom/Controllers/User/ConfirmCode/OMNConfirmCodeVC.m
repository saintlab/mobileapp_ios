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

@interface OMNConfirmCodeVC ()

@end

@implementation OMNConfirmCodeVC {

  OMNEnterCodeView *_codeView;
  UILabel *_helpLabel;
  
  NSString *_phone;
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
  label.font = [UIFont fontWithName:@"Futura-OSF-Omnom-Regular" size:18.0f];
  label.textColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
  label.text = [NSString stringWithFormat:NSLocalizedString(@"Должна прийти\nSMS с кодом на номер\n%@", nil), _phone];
  [self.view addSubview:label];
  
  _codeView = [[OMNEnterCodeView alloc] init];
  [_codeView addTarget:self action:@selector(didEnterCode) forControlEvents:UIControlEventEditingDidEnd];
  [self.view addSubview:_codeView];

  UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.frame), 44.0f)];
  toolBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
  
  NSMutableArray *items = [NSMutableArray arrayWithObject:[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Повторить код", nil) style:UIBarButtonItemStylePlain target:self action:@selector(resentTap)]];
  if (self.allowChangePhoneNumber) {
    [items addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]];
    [items addObject:[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Изменить номер", nil) style:UIBarButtonItemStylePlain target:self action:@selector(changeNumberTap)]];
  }
  
  toolBar.items = items;
  _codeView.textField.inputAccessoryView = toolBar;

  
  NSDictionary *views =
  @{
    @"label" : label,
    @"codeView" : _codeView,
    @"topLayoutGuide" : self.topLayoutGuide,
    };
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topLayoutGuide]-[label]-[codeView]" options:0 metrics:0 views:views]];
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_codeView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];

}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [_codeView becomeFirstResponder];
}

- (void)resentTap {
  
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
  
  [self.delegate confirmCodeVC:self didEnterCode:[_codeView.code copy]];
  
}

- (void)resetAnimated:(BOOL)animated {
  
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
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}


@end
