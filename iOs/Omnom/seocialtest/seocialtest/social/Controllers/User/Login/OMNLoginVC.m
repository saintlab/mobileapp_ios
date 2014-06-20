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
#import <Flurry.h>

@interface OMNLoginVC ()
<OMNConfirmCodeVCDelegate>

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
  
  if (kUseStubUser) {
    _loginTF.text = @"89833087335";
  }
  
  _loginTF.placeholder = NSLocalizedString(@"Введите телефон", nil);
  _phoneNumberTextFieldDelegate = [[OMNPhoneNumberTextFieldDelegate alloc] init];
  _loginTF.delegate = _phoneNumberTextFieldDelegate;
  
  self.navigationItem.title = NSLocalizedString(@"Вход", nil);
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Закрыть", nil) style:UIBarButtonItemStylePlain target:self action:@selector(closeTap)];
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Далее", nil) style:UIBarButtonItemStylePlain target:self action:@selector(loginTap)];
  
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  [_loginTF becomeFirstResponder];
  
}

- (void)loginTap {
  
  __weak typeof(self)weakSelf = self;
  [OMNUser loginUsingPhone:self.decimalPhoneNumber code:nil complition:^(NSString *token) {
    
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
  
  [OMNUser loginUsingPhone:[self decimalPhoneNumber] code:code complition:^(NSString *token) {
    
    [Flurry logEvent:@"user_login_confirm"];
    [weakSelf tokenDidReceived:token];
    
  } failure:^(NSError *error) {
    
    [confirmCodeVC reset];
    [[[UIAlertView alloc] initWithTitle:error.localizedDescription message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil] show];
    
  }];
  
}

- (void)tokenDidReceived:(NSString *)token {
  
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
  // Dispose of any resources that can be recreated.
}

@end
