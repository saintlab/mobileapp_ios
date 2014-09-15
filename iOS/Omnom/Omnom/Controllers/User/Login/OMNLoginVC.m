//
//  OMNLoginVC.m
//  seocialtest
//
//  Created by tea on 09.06.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNLoginVC.h"
#import "OMNUser.h"
#import "OMNPhoneNumberTextFieldDelegate.h"
#import "OMNConfirmCodeVC.h"
#import "OMNAnalitics.h"
#import "OMNNavigationBarProgressView.h"
#import "OMNErrorTextField.h"
#import <OMNStyler.h>
#import <OMNRegisterUserVC.h>

@interface OMNLoginVC ()
<OMNConfirmCodeVCDelegate,
UITextViewDelegate> {
//  __weak IBOutlet UIButton *_vkButton;
//  __weak IBOutlet UIButton *_fbButton;
//  __weak IBOutlet UIButton *_twitterButton;
  
}

@end

@implementation OMNLoginVC {
  
  OMNErrorTextField *_loginTF;
  UITextView *_hintTextView;
  OMNPhoneNumberTextFieldDelegate *_phoneNumberTextFieldDelegate;
  
}

- (void)viewDidLoad {
  
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor whiteColor];
  
  [self setup];
  
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"cross_icon_white"] style:UIBarButtonItemStylePlain target:self action:@selector(closeTap)];
  
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  OMNNavigationBarProgressView *navigationBarProgressView = [[OMNNavigationBarProgressView alloc] initWithText:NSLocalizedString(@"Вход", nil) count:2];
  [navigationBarProgressView setPage:0];
  self.navigationItem.titleView = navigationBarProgressView;
  [self setNextButtonLoading:NO];
  [self.navigationController.navigationBar layoutIfNeeded];
  
}

- (void)setNextButtonLoading:(BOOL)loading {
  
  UIBarButtonItem *rightBarButtonItem = nil;
  
  if (loading) {
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
  }
  else {
    rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Далее", nil) style:UIBarButtonItemStylePlain target:self action:@selector(loginTap)];
  }
  [self.navigationItem setRightBarButtonItem:rightBarButtonItem animated:YES];
  
}

- (void)setup {
  
  _loginTF = [[OMNErrorTextField alloc] init];
  [self.view addSubview:_loginTF];
  
  _hintTextView = [[UITextView alloc] init];
  _hintTextView.font = [UIFont fontWithName:@"Futura-OSF-Omnom-Regular" size:18.0f];
  _hintTextView.translatesAutoresizingMaskIntoConstraints = NO;
  _hintTextView.textColor = colorWithHexString(@"D0021B");
  _hintTextView.delegate = self;
  _hintTextView.scrollEnabled = NO;
  _hintTextView.editable = NO;
  _hintTextView.textContainer.lineFragmentPadding = 0;
  _hintTextView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
  [self.view addSubview:_hintTextView];
  
  NSDictionary *views =
  @{
    @"loginTF" : _loginTF,
    @"hintTextView" : _hintTextView,
    @"topLayoutGuide" : self.topLayoutGuide,
    };
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[loginTF]-|" options:0 metrics:nil views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[hintTextView]-|" options:0 metrics:nil views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topLayoutGuide]-[loginTF]-[hintTextView]" options:0 metrics:nil views:views]];
  
  _loginTF.textField.placeholder = NSLocalizedString(@"Почта или номер телефона", nil);
  _loginTF.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;

  NSString *buttonText = NSLocalizedString(@"регистрация", nil);
  NSString *text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Ещё нет аккаунта? Прошу сюда –", nil), buttonText];
  
  NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
  [attributedString setAttributes:
   @{
     NSForegroundColorAttributeName : [colorWithHexString(@"000000") colorWithAlphaComponent:0.5f],
     NSFontAttributeName : FuturaOSFOmnomRegular(15.0f),
     } range:NSMakeRange(0, text.length)];
  
  [attributedString addAttribute:NSLinkAttributeName value:[NSURL URLWithString:@""] range:[text rangeOfString:buttonText]];
  _hintTextView.linkTextAttributes =
  @{
    NSForegroundColorAttributeName : colorWithHexString(@"4A90E2"),
    NSFontAttributeName : FuturaOSFOmnomRegular(15.0f),
    };
  _hintTextView.attributedText = attributedString;
  _hintTextView.textAlignment = NSTextAlignmentCenter;
  _hintTextView.hidden = YES;
//  [_vkButton setBackgroundImage:[UIImage imageNamed:@"vk_login_icon"] forState:UIControlStateNormal];
//  [_fbButton setBackgroundImage:[UIImage imageNamed:@"fb_login_icon"] forState:UIControlStateNormal];
//  [_twitterButton setBackgroundImage:[UIImage imageNamed:@"twitter_login_icon"] forState:UIControlStateNormal];
  
}

- (void)closeTap {
  
  [self.delegate authorizationVCDidCancel:self];
  
}

- (IBAction)vkLoginTap:(id)sender {
  [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"тут должен быть логин через VK", nil) message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil] show];
}
- (IBAction)twitterLoginTap:(id)sender {
  [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"тут должен быть логин через twitter", nil) message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil] show];
}
- (IBAction)fbLoginTap:(id)sender {
  [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"тут должен быть логин через facebook", nil) message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil] show];
}


- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  [_loginTF becomeFirstResponder];
  
}

- (void)loginTap {

  [self setNextButtonLoading:YES];
  __weak typeof(self)weakSelf = self;

  [self requestAuthorisationCodeCompletion:^{
    [weakSelf requestAuthorizationCode];
  }];
  
}

- (void)requestAuthorisationCodeCompletion:(dispatch_block_t)completionBlock {
  
  __weak typeof(self)weakSelf = self;
  [OMNUser loginUsingData:_loginTF.textField.text code:nil completion:^(NSString *token) {
    
    if (completionBlock) {
      completionBlock();
    }
    
  } failure:^(NSError *error) {

    [weakSelf processLoginError:error];
    
  }];
}

- (void)processLoginError:(NSError *)error {
  [self setNextButtonLoading:NO];
  
  if (error) {
  
    //no such user error code
    if (101 == error.code) {
      _hintTextView.hidden = NO;
    }
    [_loginTF setError:error.localizedDescription];
    
  }
  else {
    
    [_loginTF setError:NSLocalizedString(@"Что-то пошло не так. Повторите попытку", nil)];
    
  }
  
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
  
  [self presentViewController:[[UINavigationController alloc] initWithRootViewController:registerUserVC] animated:YES completion:nil];
  
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)url inRange:(NSRange)characterRange {
  [self createUser];
  return NO;
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
  
  __weak typeof(self)weakSelf = self;
  
  [OMNUser loginUsingData:_loginTF.textField.text code:code completion:^(NSString *token) {

    [weakSelf tokenDidReceived:token];
    
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

- (NSString *)decimalPhoneNumber {
  NSArray *components = [_loginTF.textField.text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]];
  NSString *decimalString = [components componentsJoinedByString:@""];
  return decimalString;
}

- (void)tokenDidReceived:(NSString *)token {
  
  [self.delegate authorizationVC:self didReceiveToken:token fromRegstration:NO];
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

@end
