//
//  OMNRegisterUserVC.m
//  seocialtest
//
//  Created by tea on 09.06.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNRegisterUserVC.h"
#import "OMNUser.h"
#import "OMNUser+network.h"
#import "OMNConfirmCodeVC.h"
#import "OMNAnalitics.h"
#import "OMNNavigationBarProgressView.h"
#import <OMNStyler.h>
#import "OMNUserInfoView.h"
#import "UIBarButtonItem+omn_custom.h"
#import "OMNDisclamerView.h"
#import "UIView+omn_autolayout.h"
#import "OMNUtils.h"
#import "OMNLoginVC.h"

@interface OMNRegisterUserVC ()
<OMNConfirmCodeVCDelegate,
OMNUserInfoViewDelegate,
TTTAttributedLabelDelegate>

@end

@implementation OMNRegisterUserVC {

  OMNUserInfoView *_userInfoView;
  UIScrollView *_scroll;
  OMNUser *_user;
  TTTAttributedLabel *_errorLabel;

}

- (void)dealloc {
  
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.automaticallyAdjustsScrollViewInsets = NO;
  self.view.backgroundColor = [UIColor whiteColor];
  
  [self omn_setup];
  
  OMNNavigationBarProgressView *navigationBarProgressView = [[OMNNavigationBarProgressView alloc] initWithText:NSLocalizedString(@"REGISTER_USER_TITLE", @"Создать аккаунт") count:2];
  self.navigationItem.titleView = navigationBarProgressView;
  self.navigationItem.leftBarButtonItem = [UIBarButtonItem omn_barButtonWithImage:[UIImage imageNamed:@"cross_icon_white"] color:[UIColor blackColor] target:self action:@selector(closeTap)];
  self.navigationItem.rightBarButtonItem = [self createUserButton];
  
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  [_userInfoView beginEditing];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
  
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (UIBarButtonItem *)createUserButton {
  
  return [[UIBarButtonItem alloc] initWithTitle:kOMN_NEXT_BUTTON_TITLE style:UIBarButtonItemStylePlain target:self action:@selector(createUserTap)];
  
}


- (void)closeTap {
  
  [self.delegate authorizationVCDidCancel:self];
  
}

- (IBAction)resendTap:(id)sender {
  
  [_user confirmPhoneResend:^{
    
  } failure:^(OMNError *error) {
    
  }];
  
}

- (void)createUserTap {
  
  _user = [_userInfoView getUser];
  
  if (_user) {
    
    [self.view endEditing:YES];
    _errorLabel.text = nil;
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem omn_loadingItem];
    @weakify(self)
    [_user registerWithCompletion:^{
      
      @strongify(self)
      [self requestAuthorizationCode];
      
    } failure:^(OMNError *error) {
      
      @strongify(self)
      [self processError:error];
      
    }];
    
  }
  
  [UIView animateWithDuration:0.3 animations:^{
    [self.view layoutIfNeeded];
  }];
  
}

- (void)processError:(OMNError *)error {

  self.navigationItem.rightBarButtonItem = [self createUserButton];
  if (kOMNUserErrorCodeUserExist == error.code) {
    
    NSString *actionText = NSLocalizedString(@"REGISTER_USER_NO_USER_ACTION_TEXT", @"Можно входить");
    NSString *text = [NSString stringWithFormat:NSLocalizedString(@"REGISTER_USER_NO_USER_TEXT %@", @"{REGISTER_USER_NO_USER_ACTION_TEXT}. Пользователь с таким номером телефона уже зарегистрирован"), actionText];
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:text attributes:[OMNUtils textAttributesWithFont:FuturaOSFOmnomRegular(18.0f) textColor:[OMNStyler redColor] textAlignment:NSTextAlignmentCenter]];
    _errorLabel.text = attributedText;
    [_errorLabel addLinkToURL:[NSURL URLWithString:@""] withRange:[text rangeOfString:actionText]];
    
  }
  else if (error) {
    
    _errorLabel.text = error.localizedDescription;
    
  }
  else {
    
    _errorLabel.text = NSLocalizedString(@"REGISTER_USER_ERROR_COMMON", @"Что-то пошло не так. Повторите попытку.");
    
  }
  
  [UIView animateWithDuration:0.3 animations:^{
    [self.view layoutIfNeeded];
  }];
  
}

- (void)requestAuthorizationCode {
  
  _errorLabel.text = nil;
  OMNConfirmCodeVC *confirmCodeVC = [[OMNConfirmCodeVC alloc] initWithPhone:_user.phone];
  confirmCodeVC.delegate = self;
  [self.navigationController pushViewController:confirmCodeVC animated:YES];
  self.navigationItem.rightBarButtonItem = [self createUserButton];
  
}

#pragma mark - OMNConfirmCodeVCDelegate

- (void)confirmCodeVC:(OMNConfirmCodeVC *)confirmCodeVC didEnterCode:(NSString *)code {
  
  @weakify(self)
  [_user verifyPhoneCode:code completion:^(NSString *token) {
    
    @strongify(self)
    [self didRegisterWithToken:token];
    
  } failure:^(OMNError *error) {
    
    @strongify(self)
    [confirmCodeVC resetAnimated:YES];
    [self processError:error];
    
  }];
  
}

- (void)confirmCodeVCRequestResendCode:(OMNConfirmCodeVC *)confirmCodeVC {
  
  [_user verifyPhoneCode:nil completion:^(NSString *token) {
    
  } failure:^(OMNError *error) {
    
  }];
  
}

- (void)didRegisterWithToken:(NSString *)token {
  
  if (token) {

    [self.delegate authorizationVC:self didReceiveToken:token fromRegstration:YES];
    
  }
  else {
    
    [self processError:nil];
    
  }
  
}

- (void)keyboardDidShow:(NSNotification *)notification {
  
  NSDictionary* info = [notification userInfo];
  CGRect kbRect = [info[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
  kbRect = [self.view convertRect:kbRect fromView:nil];
  
  UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbRect.size.height, 0.0);
  CGPoint offset = _scroll.contentOffset;
  _scroll.contentInset = contentInsets;
  _scroll.scrollIndicatorInsets = contentInsets;
  _scroll.contentOffset = offset;
  
}

- (void)keyboardWillHide:(NSNotification *)notification {
  
  UIEdgeInsets contentInsets = UIEdgeInsetsZero;
  _scroll.contentInset = contentInsets;
  _scroll.scrollIndicatorInsets = contentInsets;
  
}

#pragma mark - setup

- (void)omn_setup {

  _scroll = [UIScrollView omn_autolayoutView];
  [self.view addSubview:_scroll];
  
  UIView *contentView = [UIView omn_autolayoutView];
  [_scroll addSubview:contentView];
  
  OMNUser *user = [[OMNUser alloc] init];
  user.email = self.email;
  user.phone = self.phone;
  _userInfoView = [[OMNUserInfoView alloc] initWithUser:user];
  _userInfoView.delegate = self;
  [contentView addSubview:_userInfoView];
  
  _errorLabel = [TTTAttributedLabel omn_autolayoutView];
  _errorLabel.linkAttributes =
  @{
    (__bridge NSString *)kCTUnderlineStyleAttributeName : @(YES),
    NSForegroundColorAttributeName : colorWithHexString(@"4A90E2"),
    NSFontAttributeName : FuturaOSFOmnomRegular(18.0f),
    };
  _errorLabel.activeLinkAttributes =
  @{
    (__bridge NSString *)kCTUnderlineStyleAttributeName : @(YES),
    NSForegroundColorAttributeName : [colorWithHexString(@"4A90E2") colorWithAlphaComponent:0.5f],
    NSFontAttributeName : FuturaOSFOmnomRegular(18.0f),
    };
  _errorLabel.delegate = self;
  _errorLabel.text = nil;
  _errorLabel.font = FuturaOSFOmnomRegular(18.0f);
  _errorLabel.textColor = [OMNStyler redColor];
  _errorLabel.textAlignment = NSTextAlignmentCenter;
  _errorLabel.numberOfLines = 0;
  [contentView addSubview:_errorLabel];
  
  OMNDisclamerView *disclamerView = [[OMNDisclamerView alloc] init];
  [contentView addSubview:disclamerView];
  
  NSDictionary *views =
  @{
    @"scroll" : _scroll,
    @"userInfoView" : _userInfoView,
    @"topLayoutGuide" : self.topLayoutGuide,
    @"disclamerView" : disclamerView,
    @"errorLabel" : _errorLabel,
    @"contentView" : contentView,
    };

  NSDictionary *metrics =
  @{
    @"leftOffset" : [[OMNStyler styler] leftOffset],
    };
  
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.0f]];
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0f constant:0.0f]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scroll]|" options:kNilOptions metrics:metrics views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topLayoutGuide][scroll]|" options:kNilOptions metrics:metrics views:views]];
  [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[disclamerView]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[errorLabel]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[userInfoView]-[errorLabel]-[disclamerView]-|" options:kNilOptions metrics:metrics views:views]];
  [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[userInfoView]|" options:kNilOptions metrics:metrics views:views]];

  [_scroll addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[contentView]|" options:kNilOptions metrics:metrics views:views]];

}

#pragma mark - OMNUserInfoViewDelegate

- (void)userInfoView:(OMNUserInfoView *)userInfoView didbeginEditingTextField:(UITextField *)textField {
  
  CGRect textFieldFrame = [textField convertRect:textField.bounds toView:_scroll];
  [_scroll scrollRectToVisible:textFieldFrame animated:YES];
  CGPoint contentOffset = CGPointMake(0.0f, MAX(0.0f, textFieldFrame.origin.y - 20.0f));
  [UIView animateWithDuration:0.3 delay:0.1 options:kNilOptions animations:^{
    
    [_scroll setContentOffset:contentOffset];
    
  } completion:nil];
  
}

#pragma mark - TTTAttributedLabelDelegate

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
  
  OMNLoginVC *loginVC = [[OMNLoginVC alloc] init];
  loginVC.phone = _userInfoView.phoneTF.textField.text;
  loginVC.delegate = self.delegate;
  [self.navigationController pushViewController:loginVC animated:YES];
  
}

@end
