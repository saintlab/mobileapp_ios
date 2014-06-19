//
//  OMNLoginVC.m
//  seocialtest
//
//  Created by tea on 09.06.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNLoginVC.h"
#import "OMNUser.h"
#import "OMNRegisterUserVC.h"
#import "OMNAuthorisation.h"
#import "OMNPhoneNumberTextFieldDelegate.h"
#import "OMNConfirmCodeVC.h"

@interface OMNLoginVC ()
<UITextFieldDelegate,
OMNRegisterUserVCDelegate,
OMNConfirmCodeVCDelegate>

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
  
  _loginTF.text = @"89833087335";
  _loginTF.placeholder = NSLocalizedString(@"Введите телефон", nil);
  _phoneNumberTextFieldDelegate = [[OMNPhoneNumberTextFieldDelegate alloc] init];
  _loginTF.delegate = _phoneNumberTextFieldDelegate;
  
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Войти", nil) style:UIBarButtonItemStylePlain target:self action:@selector(loginTap)];
  
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

- (void)requestAuthorizationCode {
  
  OMNConfirmCodeVC *confirmCodeVC = [[OMNConfirmCodeVC alloc] initWithPhone:self.decimalPhoneNumber];
  confirmCodeVC.delegate = self;
  [self.navigationController pushViewController:confirmCodeVC animated:YES];
  
}

#pragma mark - OMNConfirmCodeVCDelegate

- (void)confirmCodeVC:(OMNConfirmCodeVC *)confirmCodeVC didEnterCode:(NSString *)code {
  
  __weak typeof(self)weakSelf = self;
  
  [OMNUser loginUsingPhone:[self decimalPhoneNumber] code:code complition:^(NSString *token) {
    
    [weakSelf tokenDidReceived:token];
    
  } failure:^(NSError *error) {
    
    [confirmCodeVC reset];
    [[[UIAlertView alloc] initWithTitle:error.localizedDescription message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil] show];
    
  }];
  
}


- (IBAction)registerTap {
  
  OMNRegisterUserVC *registerUserVC = [[OMNRegisterUserVC alloc] init];
  [self.navigationController pushViewController:registerUserVC animated:YES];
  
}

#pragma mark - OMNRegisterUserVCDelegate

-(void)registerUserVC:(OMNRegisterUserVC *)registerUserVC didRegisterUserWithToken:(NSString *)token {
  
  [self tokenDidReceived:token];
  
}

- (void)tokenDidReceived:(NSString *)token {
  
  NSLog(@"tokenDidReceived>%@", token);
  [[OMNAuthorisation authorisation] updateToken:token];
  
  [self.delegate loginVC:self didReceiveToken:token];
  
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
