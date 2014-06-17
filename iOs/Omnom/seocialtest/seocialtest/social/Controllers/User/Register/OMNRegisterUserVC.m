//
//  OMNRegisterUserVC.m
//  seocialtest
//
//  Created by tea on 09.06.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNRegisterUserVC.h"
#import "OMNUser.h"

@interface OMNRegisterUserVC ()
<UITextFieldDelegate>

@end

@implementation OMNRegisterUserVC {
  
  __weak IBOutlet UITextField *_nameTF;
  __weak IBOutlet UITextField *_phoneTF;
  __weak IBOutlet UITextField *_emailTF;
  __weak IBOutlet UITextField *_confirmTF;
  
  __weak IBOutlet UIButton *_resendButton;
  __weak IBOutlet UITextField *_confirmCodeTF;
  
  OMNUser *_user;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  if (kUseStubUser) {
    _emailTF.text = @"teanet@mail.ru";
    _phoneTF.text = @"89833087335";
    _nameTF.text = @"Женя";
  }
  
  _resendButton.hidden = YES;
  _confirmCodeTF.hidden = YES;
  
  _confirmCodeTF.delegate = self;
  
  UIBarButtonItem *submitButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Подтвердить", nil) style:UIBarButtonItemStylePlain target:self action:@selector(submitTap:)];
  UIBarButtonItem *resetButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Сбросить", nil) style:UIBarButtonItemStylePlain target:self action:@selector(resetTap:)];
  
  self.navigationItem.rightBarButtonItems = @[submitButton, resetButton];
  
}

- (IBAction)resendTap:(id)sender {
  
  [_user confirmPhoneResend:^{
    
    
    
  } failure:^(NSError *error) {
    
    NSLog(@"%@", error);
    
  }];
  
}


- (void)submitTap:(UIBarButtonItem *)button {
  
  if (_user) {
    
    [self confirmUser];
    
  }
  else {
    
    [self createUser];
    
  }
  
}

- (void)resetTap:(UIBarButtonItem *)button {
  
  _user = nil;
  [self updateInterface];
  
}

- (void)createUser {
  
  _user = [[OMNUser alloc] init];
  _user.email = _emailTF.text;
  _user.phone = _phoneTF.text;
  _user.firstName = _nameTF.text;
  
  __weak typeof(self)weakSelf = self;
  [_user registerWithComplition:^{
    
    [weakSelf updateInterface];
    
  } failure:^(NSError *error) {
    
    NSLog(@"error>%@", error);
    
  }];
  
}

- (void)updateInterface {
  
  BOOL emptyUser = (_user == nil);
  
  _nameTF.enabled = emptyUser;
  _phoneTF.enabled = emptyUser;
  _emailTF.enabled = emptyUser;
  
  _resendButton.hidden = emptyUser;
  _confirmCodeTF.hidden = emptyUser;
  
  if (NO == emptyUser) {
    [_confirmCodeTF becomeFirstResponder];
  }
  
}

- (void)confirmUser {
  
  __weak typeof(self)weakSelf = self;
  [_user confirmPhone:_confirmCodeTF.text complition:^(NSString *token) {
    
    [weakSelf didRegisterWithToken:token];
    
  } failure:^(NSError *error) {
    
    [[[UIAlertView alloc] initWithTitle:error.localizedDescription message:error.localizedRecoverySuggestion delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    NSLog(@"error>%@", error);
    
  }];
  
}

- (void)didRegisterWithToken:(NSString *)token {
  
  [self.delegate registerUserVC:self didRegisterUserWithToken:token];
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

@end
