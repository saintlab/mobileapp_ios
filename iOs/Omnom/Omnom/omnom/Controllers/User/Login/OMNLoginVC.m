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

@interface OMNLoginVC ()
<OMNConfirmCodeVCDelegate> {
  __weak IBOutlet UIButton *_vkButton;
  __weak IBOutlet UIButton *_fbButton;
  __weak IBOutlet UIButton *_twitterButton;
  
}

@end

@implementation OMNLoginVC {
  
  __weak IBOutlet UITextField *_loginTF;
//  __weak IBOutlet UITextField *_passwordTF;
  
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
  
  [self setup];
  
  _phoneNumberTextFieldDelegate = [[OMNPhoneNumberTextFieldDelegate alloc] init];
//  _loginTF.delegate = _phoneNumberTextFieldDelegate;
  
  self.navigationItem.title = NSLocalizedString(@"Вход", nil);
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Закрыть", nil) style:UIBarButtonItemStylePlain target:self action:@selector(closeTap)];
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Далее", nil) style:UIBarButtonItemStylePlain target:self action:@selector(loginTap)];
  
}

- (void)setup {
  
  if (kUseStubUser) {
    _loginTF.text = @"89833087335";
  }
  
  _loginTF.placeholder = NSLocalizedString(@"Почта или номер телефона", nil);
  _loginTF.keyboardType = UIKeyboardTypeNumberPad;
//  UIToolbar *inputAccessoryView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 44.0f)];
//  inputAccessoryView.items =
//  @[
//    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
//    [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"<#text#>", <#comment#>) style:<#(UIBarButtonItemStyle)#> target:<#(id)#> action:<#(SEL)#>],
//    ];
//  _loginTF.inputAccessoryView =
  
  
  [_vkButton setBackgroundImage:[UIImage imageNamed:@"vk_login_icon"] forState:UIControlStateNormal];
  [_fbButton setBackgroundImage:[UIImage imageNamed:@"fb_login_icon"] forState:UIControlStateNormal];
  [_twitterButton setBackgroundImage:[UIImage imageNamed:@"twitter_login_icon"] forState:UIControlStateNormal];
  
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
  [OMNUser loginUsingData:_loginTF.text code:nil complition:^(NSString *token) {
    
    [weakSelf requestAuthorizationCode];
    
  } failure:^(NSError *error) {
    
    [[[UIAlertView alloc] initWithTitle:error.localizedDescription message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil] show];
    
  }];
  
}

- (void)closeTap {
  
  [self.delegate authorizationVCDidCancel:self];
  
}

- (void)requestAuthorizationCode {
  
  OMNConfirmCodeVC *confirmCodeVC = [[OMNConfirmCodeVC alloc] initWithPhone:self.decimalPhoneNumber];
  confirmCodeVC.delegate = self;
  [self.navigationController pushViewController:confirmCodeVC animated:YES];
  
}

#pragma mark - OMNConfirmCodeVCDelegate

- (void)confirmCodeVC:(OMNConfirmCodeVC *)confirmCodeVC didEnterCode:(NSString *)code {
  
  __weak typeof(self)weakSelf = self;
  
  [OMNUser loginUsingData:_loginTF.text code:code complition:^(NSString *token) {

    [weakSelf tokenDidReceived:token];
    
  } failure:^(NSError *error) {
    
    [confirmCodeVC resetAnimated:YES];
    NSLog(@"%@", error);
    
  }];
  
}

- (void)tokenDidReceived:(NSString *)token {
  
  [OMNUser userWithToken:token user:^(OMNUser *user) {
    
    [[OMNAnalitics analitics] logLoginUser:user];
    
  } failure:^(NSError *error) {
    
    NSLog(@"%@", error);
    
  }];
  
  [self.delegate authorizationVC:self didReceiveToken:token];
  
}

- (void)resetTap {
  
  _loginTF.text = @"";
  
}

- (NSString *)decimalPhoneNumber {
  NSArray *components = [_loginTF.text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]];
  NSString *decimalString = [components componentsJoinedByString:@""];
  return decimalString;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

@end
