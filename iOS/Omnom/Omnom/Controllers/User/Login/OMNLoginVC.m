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

@interface OMNLoginVC ()
<OMNConfirmCodeVCDelegate> {
//  __weak IBOutlet UIButton *_vkButton;
//  __weak IBOutlet UIButton *_fbButton;
//  __weak IBOutlet UIButton *_twitterButton;
  
}

@end

@implementation OMNLoginVC {
  
  OMNErrorTextField *_loginTF;
  OMNPhoneNumberTextFieldDelegate *_phoneNumberTextFieldDelegate;
  
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad {
  
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor whiteColor];
  
  [self setup];
  
//  _phoneNumberTextFieldDelegate = [[OMNPhoneNumberTextFieldDelegate alloc] init];
//  _loginTF.delegate = _phoneNumberTextFieldDelegate;
  
  OMNNavigationBarProgressView *navigationBarProgressView = [[OMNNavigationBarProgressView alloc] initWithText:NSLocalizedString(@"Вход", nil) count:2];
  [navigationBarProgressView setPage:0];
  self.navigationItem.titleView = navigationBarProgressView;
  [self.navigationController.navigationBar setNeedsLayout];
  NSLog(@"%@", navigationBarProgressView);
  
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"cross_icon_white"] style:UIBarButtonItemStylePlain target:self action:@selector(closeTap)];
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Далее", nil) style:UIBarButtonItemStylePlain target:self action:@selector(loginTap)];
  
}

- (void)setup {
  
  _loginTF = [[OMNErrorTextField alloc] init];
  [self.view addSubview:_loginTF];
  
  NSDictionary *views =
  @{
    @"loginTF" : _loginTF,
    @"topLayoutGuide" : self.topLayoutGuide,
    };
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[loginTF]-|" options:0 metrics:nil views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topLayoutGuide]-[loginTF]" options:0 metrics:nil views:views]];
  
  _loginTF.textField.placeholder = NSLocalizedString(@"Почта или номер телефона", nil);
  _loginTF.textField.keyboardType = UIKeyboardTypeNumberPad;

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

  __weak typeof(self)weakSelf = self;
  [OMNUser loginUsingData:_loginTF.textField.text code:nil completion:^(NSString *token) {
    
    [weakSelf requestAuthorizationCode];
    
  } failure:^(NSError *error) {
    
    [weakSelf processLoginError:error];
    
  }];
  
}


- (void)processLoginError:(NSError *)error {
  
  [_loginTF setError:error.localizedDescription animated:NO];
  
}

- (void)requestAuthorizationCode {
  
  OMNConfirmCodeVC *confirmCodeVC = [[OMNConfirmCodeVC alloc] initWithPhone:self.decimalPhoneNumber];
  confirmCodeVC.delegate = self;
  [self.navigationController pushViewController:confirmCodeVC animated:YES];
  
}

#pragma mark - OMNConfirmCodeVCDelegate

- (void)confirmCodeVC:(OMNConfirmCodeVC *)confirmCodeVC didEnterCode:(NSString *)code {
  
  __weak typeof(self)weakSelf = self;
  
  [OMNUser loginUsingData:_loginTF.textField.text code:code completion:^(NSString *token) {

    [weakSelf tokenDidReceived:token];
    
  } failure:^(NSError *error) {
    
    [confirmCodeVC resetAnimated:YES];
    NSLog(@"%@", error);
    
  }];
  
}

- (NSString *)decimalPhoneNumber {
  NSArray *components = [_loginTF.textField.text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]];
  NSString *decimalString = [components componentsJoinedByString:@""];
  return decimalString;
}

- (void)tokenDidReceived:(NSString *)token {
  
  [OMNUser userWithToken:token user:^(OMNUser *user) {
    
    [[OMNAnalitics analitics] logLoginUser:user];
    
  } failure:^(NSError *error) {
    
    NSLog(@"%@", error);
    
  }];
  
  [self.delegate authorizationVC:self didReceiveToken:token];
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

@end
