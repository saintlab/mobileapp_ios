//
//  OMNLoginVC.m
//  seocialtest
//
//  Created by tea on 09.06.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNChangePhoneVC.h"
#import "OMNConfirmCodeVC.h"
#import "OMNErrorTextField.h"
#import "OMNLoginVC.h"
#import "OMNNavigationBarProgressView.h"
#import "OMNPhoneNumberTextFieldDelegate.h"
#import "OMNRegisterUserVC.h"
#import "OMNUser.h"
#import "OMNUser+network.h"
#import "UIBarButtonItem+omn_custom.h"
#import <OMNStyler.h>
#import <TTTAttributedLabel.h>
#import "UIView+omn_autolayout.h"

@interface OMNLoginVC ()
<OMNConfirmCodeVCDelegate,
OMNChangePhoneVCDelegate,
TTTAttributedLabelDelegate> {
}

@end

@implementation OMNLoginVC {
  
  OMNErrorTextField *_loginTF;
  TTTAttributedLabel *_hintLabel;

  NSURL *_createUserUrl;
  NSURL *_resetPhoneUrl;
  
}

- (void)viewDidLoad {
  
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor whiteColor];
  self.navigationItem.title = @"";
  self.navigationItem.leftBarButtonItem = [UIBarButtonItem omn_barButtonWithImage:[UIImage imageNamed:@"cross_icon_white"] color:[UIColor blackColor] target:self action:@selector(closeTap)];
  
  _createUserUrl = [NSURL URLWithString:@"createUserUrl"];
  _resetPhoneUrl = [NSURL URLWithString:@"resetPhoneUrl"];
  
  [self setup];
  
  _loginTF.textField.text = self.phone;
  
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  OMNNavigationBarProgressView *navigationBarProgressView = [[OMNNavigationBarProgressView alloc] initWithText:NSLocalizedString(@"Вход", nil) count:2];
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
  
  _loginTF = [[OMNErrorTextField alloc] init];
  [self.view addSubview:_loginTF];
  
  _hintLabel = [TTTAttributedLabel omn_autolayoutView];
  _hintLabel.font = FuturaOSFOmnomRegular(18.0f);
  _hintLabel.textColor = [OMNStyler redColor];
  _hintLabel.numberOfLines = 0;
  _hintLabel.delegate = self;
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
  
  NSDictionary *views =
  @{
    @"loginTF" : _loginTF,
    @"hintLabel" : _hintLabel,
    @"topLayoutGuide" : self.topLayoutGuide,
    };
  
  NSDictionary *metrics =
  @{
    @"leftOffset" : [[OMNStyler styler] leftOffset],
    };
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[loginTF]-|" options:kNilOptions metrics:metrics views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[hintLabel]-|" options:kNilOptions metrics:metrics views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topLayoutGuide]-[loginTF]-[hintLabel]" options:kNilOptions metrics:nil views:views]];
  
  _loginTF.textField.placeholder = NSLocalizedString(@"Номер телефона", nil);
  _loginTF.textField.keyboardType = UIKeyboardTypePhonePad;

  [self setResetPhoneHint];
  
}

- (void)setCreateUserHint {
  
  NSString *buttonText = NSLocalizedString(@"LOGIN_CREATE_USER_ACTION", @"регистрация");
  NSString *text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"LOGIN_CREATE_USER_HINT", @"Ещё нет аккаунта? Прошу сюда –"), buttonText];
  
  NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
  [attributedString setAttributes:
   @{
     NSForegroundColorAttributeName : [colorWithHexString(@"000000") colorWithAlphaComponent:0.5f],
     NSFontAttributeName : FuturaOSFOmnomRegular(15.0f),
     } range:NSMakeRange(0, text.length)];
  
  [_hintLabel setText:attributedString];
  [_hintLabel addLinkToURL:_createUserUrl withRange:[text rangeOfString:buttonText]];
  _hintLabel.hidden = NO;
  
}

- (void)setResetPhoneHint {
  
  NSString *text = NSLocalizedString(@"LOGIN_RESET_PHONE_HINT", @"У меня сменился номер телефона");
  [_hintLabel setText:text];
  [_hintLabel addLinkToURL:_resetPhoneUrl withRange:NSMakeRange(0, text.length)];
  _hintLabel.hidden = NO;
  
}

- (void)closeTap {
  
  [self.delegate authorizationVCDidCancel:self];
  
}

- (void)loginTap {

  [self setNextButtonLoading:YES];
  
  @weakify(self)
  [self requestAuthorisationCodeCompletion:^{
    
    @strongify(self)
    [self requestAuthorizationCode];
    
  }];
  
}

- (void)requestAuthorisationCodeCompletion:(dispatch_block_t)completionBlock {
  
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

    if (kOMNUserErrorCodeNoSuchUser == error.code) {
      
      [self setCreateUserHint];
      
    }
    [_loginTF setErrorText:error.localizedDescription];
    
  }
  else {
    
    [_loginTF setErrorText:NSLocalizedString(@"Что-то пошло не так. Повторите попытку.", nil)];
    
  }
  
  [UIView animateWithDuration:0.3 animations:^{
    
    [self.view layoutIfNeeded];
    
  }];
  
}

- (void)createUser {
  
  OMNRegisterUserVC *registerUserVC = [[OMNRegisterUserVC alloc] init];
  registerUserVC.delegate = self.delegate;
  
  if ([_loginTF.textField.text omn_isValidPhone]) {
    
    registerUserVC.phone = _loginTF.textField.text;
    
  }
  else if ([_loginTF.textField.text omn_isValidEmail]) {
    
    registerUserVC.email = _loginTF.textField.text;
    
  }
  [self.navigationController pushViewController:registerUserVC animated:YES];
  
}

- (void)resetPhone {
  
  OMNChangePhoneVC *changePhoneVC = [[OMNChangePhoneVC alloc] init];
  changePhoneVC.delegate = self;
  [self.navigationController pushViewController:changePhoneVC animated:YES];
  
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

- (void)confirmCodeVCRequestResendCode:(OMNConfirmCodeVC *)confirmCodeVC {
  
  [self requestAuthorisationCodeCompletion:nil];
  
}

- (void)confirmCodeVCDidResetPhone:(OMNConfirmCodeVC *)confirmCodeVC {
  
  [self.delegate authorizationVCDidCancel:self];
  
}

#pragma mark - OMNChangePhoneVCDelegate

- (void)changePhoneVCDidFinish:(OMNChangePhoneVC *)changePhoneVC {
  
  [self.navigationController popToViewController:self animated:YES];
  
}

- (NSString *)decimalPhoneNumber {
  NSArray *components = [_loginTF.textField.text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]];
  NSString *decimalString = [components componentsJoinedByString:@""];
  return decimalString;
}

- (void)tokenDidReceived:(NSString *)token {
  
  [self.delegate authorizationVC:self didReceiveToken:token fromRegstration:NO];
  
}

#pragma mark - TTTAttributedLabelDelegate

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
  
  if ([url isEqual:_createUserUrl]) {
    
    [self createUser];
    
  }
  else if ([url isEqual:_resetPhoneUrl]) {
    
    [self resetPhone];
    
  }
  
}

@end
