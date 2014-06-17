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

@interface OMNLoginVC ()
<UITextFieldDelegate,
OMNRegisterUserVCDelegate>

@property (nonatomic, strong) OMNUser *user;

@end

@implementation OMNLoginVC {
  
  __weak IBOutlet UITextField *_loginTF;
  __weak IBOutlet UITextField *_passwordTF;
  
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
  
  _loginTF.placeholder = NSLocalizedString(@"Введите телефон", nil);
  _phoneNumberTextFieldDelegate = [[OMNPhoneNumberTextFieldDelegate alloc] init];
  _loginTF.delegate = _phoneNumberTextFieldDelegate;
  
  _passwordTF.placeholder = NSLocalizedString(@"Введите код", nil);
  _passwordTF.delegate = self;

  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Регистрация", nil) style:UIBarButtonItemStylePlain target:self action:@selector(registerTap)];
  
  [self updateInterface];
  _passwordTF.hidden = YES;
//  _loginTF.text = @"89833087335";
  
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  [_loginTF becomeFirstResponder];
  
}

- (void)loginTap {
  
  __weak typeof(self)weakSelf = self;
  [OMNUser loginUsingPhone:self.decimalPhoneNumber code:nil complition:^(NSString *token) {
    
    weakSelf.user = [OMNUser userWithPhone:self.decimalPhoneNumber];
    
  } failure:^(NSError *error) {

    [[[UIAlertView alloc] initWithTitle:error.localizedDescription message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil] show];
    weakSelf.user = nil;
    
  }];
  
}

- (void)setUser:(OMNUser *)user {

  _user = user;
  [self updateInterface];
  
}

- (void)registerTap {
  
  OMNRegisterUserVC *registerUserVC = [[OMNRegisterUserVC alloc] init];
  [self.navigationController pushViewController:registerUserVC animated:YES];
  
}

#pragma mark - OMNRegisterUserVCDelegate

-(void)registerUserVC:(OMNRegisterUserVC *)registerUserVC didRegisterUserWithToken:(NSString *)token {
  
  [self tokenDidReceived:token];
  
}

- (void)resetTap {
  
  self.user = nil;
  _loginTF.text = @"";
  
}

- (void)submitCodeTap {
  
  _passwordTF.userInteractionEnabled = NO;
  
  __weak typeof(self)weakSelf = self;
  
  [OMNUser loginUsingPhone:_loginTF.text code:_passwordTF.text complition:^(NSString *token) {
    
    [weakSelf processSuccessLogin];
    
  } failure:^(NSError *error) {

    [[[UIAlertView alloc] initWithTitle:error.localizedDescription message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil] show];
    
    _passwordTF.text = @"";
    _passwordTF.userInteractionEnabled = YES;
    NSLog(@"error>%@", error);
    
  }];
  
}

- (void)tokenDidReceived:(NSString *)token {
  
  [[OMNAuthorisation authorisation] updateToken:token];
  
  
  
}

- (void)processSuccessLogin {
  
  NSLog(@"processSuccessLogin");
  
}

- (void)updateInterface {
  
  if (self.user) {
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Сбросить", nil) style:UIBarButtonItemStylePlain target:self action:@selector(resetTap)];
    _loginTF.enabled = NO;
    _passwordTF.hidden = NO;
    [_passwordTF becomeFirstResponder];
    
  }
  else {
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Войти", nil) style:UIBarButtonItemStylePlain target:self action:@selector(loginTap)];
    _loginTF.enabled = YES;
    _passwordTF.hidden = YES;
    
  }
  
}

- (NSString *)decimalPhoneNumber {
  NSArray *components = [_loginTF.text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]];
  NSString *decimalString = [components componentsJoinedByString:@""];
  return decimalString;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
  
  NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
  
  if ([textField isEqual:_passwordTF]) {
    
    if (4 == newString.length) {
      textField.text = newString;
      [self submitCodeTap];
      return NO;
    }
    else {
      return YES;
    }
    
  }
  return YES;
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
