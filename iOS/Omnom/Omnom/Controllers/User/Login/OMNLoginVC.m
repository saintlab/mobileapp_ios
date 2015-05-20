//
//  OMNLoginVC.m
//  seocialtest
//
//  Created by tea on 09.06.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNConfirmCodeVC.h"
#import "OMNErrorTextField.h"
#import "OMNLoginVC.h"
#import "OMNNavigationBarProgressView.h"
#import "OMNPhoneNumberTextFieldDelegate.h"
#import "OMNUser.h"
#import "OMNUser+network.h"
#import "UIBarButtonItem+omn_custom.h"
#import <OMNStyler.h>
#import <TTTAttributedLabel.h>
#import "UIView+omn_autolayout.h"
#import "OMNNavigationControllerDelegate.h"
#import "OMNAuthorization.h"
#import "OMNAnalitics.h"
#import "OMNDisclamerView.h"

@interface OMNLoginVC ()
<OMNConfirmCodeVCDelegate>

@end

@implementation OMNLoginVC {
  
  OMNErrorTextField *_loginTF;
  UILabel *_descriptionLabel;
  TTTAttributedLabel *_hintLabel;
  
  PMKFulfiller fulfiller;
  PMKRejecter rejecter;
  
}

- (void)viewDidLoad {
  
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor whiteColor];
  self.navigationItem.title = @"";
  self.navigationItem.leftBarButtonItem = [UIBarButtonItem omn_barButtonWithImage:[UIImage imageNamed:@"cross_icon_white"] color:[UIColor blackColor] target:self action:@selector(closeTap)];
  
  [self setup];
  
  _descriptionLabel.text = kOMN_USER_LOGIN_HINT;
  _loginTF.textField.text = self.phone;
  
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  OMNNavigationBarProgressView *navigationBarProgressView = [[OMNNavigationBarProgressView alloc] initWithText:kOMN_LOGIN_TITLE count:2];
  [navigationBarProgressView setPage:0];
  self.navigationItem.titleView = navigationBarProgressView;
  [self setNextButtonLoading:NO];
  [self.navigationController.navigationBar layoutIfNeeded];
  
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];

  [_loginTF becomeFirstResponder];
  if (0 == _loginTF.textField.text.length) {
    _loginTF.textField.text = @"+7";
  }
  
}

- (PMKPromise *)requestLogin:(UIViewController *)rootVC {
  
  UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self];
  navigationController.delegate = [OMNNavigationControllerDelegate sharedDelegate];
  [rootVC presentViewController:navigationController animated:YES completion:nil];
  
  return [PMKPromise new:^(PMKFulfiller fulfill, PMKRejecter reject) {
    
    fulfiller = fulfill;
    rejecter = reject;
    
  }];
  
}

- (void)setNextButtonLoading:(BOOL)loading {
  
  UIBarButtonItem *rightBarButtonItem = nil;
  
  if (loading) {
    
    rightBarButtonItem = [UIBarButtonItem omn_loadingItem];
    
  }
  else {
    
    rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:kOMN_NEXT_BUTTON_TITLE style:UIBarButtonItemStylePlain target:self action:@selector(loginTap)];
    
  }
  [self.navigationItem setRightBarButtonItem:rightBarButtonItem animated:YES];
  
}

- (void)setup {
  
  _descriptionLabel = [UILabel omn_autolayoutView];
  _descriptionLabel.font = FuturaOSFOmnomRegular(18.0f);
  _descriptionLabel.textColor = [OMNStyler greyColor];
  _descriptionLabel.textAlignment = NSTextAlignmentCenter;
  [self.view addSubview:_descriptionLabel];

  _loginTF = [[OMNErrorTextField alloc] init];
  [self.view addSubview:_loginTF];
  
  _hintLabel = [TTTAttributedLabel omn_autolayoutView];
  _hintLabel.font = FuturaOSFOmnomRegular(18.0f);
  _hintLabel.textColor = [OMNStyler redColor];
  _hintLabel.numberOfLines = 0;
  _hintLabel.linkAttributes =
  @{
    (__bridge NSString *)kCTUnderlineStyleAttributeName : @(YES),
    NSForegroundColorAttributeName : [OMNStyler linkColor],
    NSFontAttributeName : FuturaOSFOmnomRegular(15.0f),
    };
  _hintLabel.activeLinkAttributes =
  @{
    (__bridge NSString *)kCTUnderlineStyleAttributeName : @(YES),
    NSForegroundColorAttributeName : [OMNStyler activeLinkColor],
    NSFontAttributeName : FuturaOSFOmnomRegular(15.0f),
    };
  [self.view addSubview:_hintLabel];

  OMNDisclamerView *disclamerView = [[OMNDisclamerView alloc] init];
  [self.view addSubview:disclamerView];
  
  NSDictionary *views =
  @{
    @"descriptionLabel" : _descriptionLabel,
    @"loginTF" : _loginTF,
    @"hintLabel" : _hintLabel,
    @"disclamerView" : disclamerView,
    @"topLayoutGuide" : self.topLayoutGuide,
    };
  
  NSDictionary *metrics =
  @{
    @"leftOffset" :@(OMNStyler.leftOffset),
    };
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[descriptionLabel]|" options:kNilOptions metrics:metrics views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[loginTF]-|" options:kNilOptions metrics:metrics views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[disclamerView]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[hintLabel]-|" options:kNilOptions metrics:metrics views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topLayoutGuide]-(leftOffset)-[descriptionLabel]-(leftOffset)-[loginTF]-[hintLabel]-(leftOffset)-[disclamerView]" options:kNilOptions metrics:metrics views:views]];
  
  _loginTF.textField.placeholder = kOMN_PHONE_NUMBER_PLACEHOLDER;
  _loginTF.textField.keyboardType = UIKeyboardTypePhonePad;
  
}

- (void)closeTap {
  rejecter([OMNError omnomErrorFromCode:kOMNErrorCancel]);
}

- (void)loginTap {

  [self setNextButtonLoading:YES];
  
  @weakify(self)
  [self requestAuthorizationCodeCompletion:^{
    
    @strongify(self)
    [self requestAuthorizationCode];
    
  }];
  
}

- (void)requestAuthorizationCodeCompletion:(dispatch_block_t)completionBlock {
  
  @weakify(self)
  [OMNUser loginUsingData:_loginTF.textField.text code:nil completion:^(NSString *token) {
    
    if (completionBlock) {
      completionBlock();
    }
    
  } failure:^(NSError *error) {

    @strongify(self)
    [self processLoginError:error];
    
  }];
}

- (void)processLoginError:(NSError *)error {
  [self setNextButtonLoading:NO];

  if (error) {

    [_loginTF setErrorText:error.localizedDescription];
    
  }
  else {
    
    [_loginTF setErrorText:kOMN_ERROR_MESSAGE_UNKNOWN_ERROR];
    
  }
  
  [UIView animateWithDuration:0.3 animations:^{
    
    [self.view layoutIfNeeded];
    
  }];
  
}

- (void)requestAuthorizationCode {
  
  OMNConfirmCodeVC *confirmCodeVC = [[OMNConfirmCodeVC alloc] initWithPhone:self.decimalPhoneNumber];
  confirmCodeVC.allowChangePhoneNumber = YES;
  confirmCodeVC.delegate = self;
  [self.navigationController pushViewController:confirmCodeVC animated:YES];
  [self setNextButtonLoading:NO];
  
}

#pragma mark - OMNConfirmCodeVCDelegate

- (void)confirmCodeVC:(OMNConfirmCodeVC *)confirmCodeVC didEnterCode:(NSString *)code {
  
  @weakify(self)
  [OMNUser loginUsingData:_loginTF.textField.text code:code completion:^(NSString *token) {

    @strongify(self)
    [self tokenDidReceived:token];
    
  } failure:^(NSError *error) {
    
    [confirmCodeVC resetAnimated:YES];
    
  }];
  
}

- (void)tokenDidReceived:(NSString *)token {
  
  [[OMNAuthorization authorization] setAuthenticationToken:token].finally(^{
    
    [[OMNAnalitics analitics] logUserLoginWithRegistration:NO];
    fulfiller(token);
    
  });
  
}

- (void)confirmCodeVCRequestResendCode:(OMNConfirmCodeVC *)confirmCodeVC {
  [self requestAuthorizationCodeCompletion:nil];
}

- (void)confirmCodeVCDidResetPhone:(OMNConfirmCodeVC *)confirmCodeVC {
  [self closeTap];
}

- (NSString *)decimalPhoneNumber {
  NSArray *components = [_loginTF.textField.text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]];
  NSString *decimalString = [components componentsJoinedByString:@""];
  return decimalString;
}

@end
