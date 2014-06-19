//
//  OMNRegisterUserVC.m
//  seocialtest
//
//  Created by tea on 09.06.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNRegisterUserVC.h"
#import "OMNUser.h"
#import "OMNConfirmCodeVC.h"

@interface OMNRegisterUserVC ()
<OMNConfirmCodeVCDelegate>

@end

@implementation OMNRegisterUserVC {
  
  __weak IBOutlet UITextField *_nameTF;
  __weak IBOutlet UITextField *_phoneTF;
  __weak IBOutlet UITextField *_emailTF;
  __weak IBOutlet UITextField *_confirmTF;
  
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
  
  UIBarButtonItem *submitButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Подтвердить", nil) style:UIBarButtonItemStylePlain target:self action:@selector(createUserTap)];
  UIBarButtonItem *resetButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Сбросить", nil) style:UIBarButtonItemStylePlain target:self action:@selector(resetTap:)];
  
  self.navigationItem.rightBarButtonItems = @[submitButton, resetButton];
  
}

- (IBAction)resendTap:(id)sender {
  
  [_user confirmPhoneResend:^{
    
    
  } failure:^(NSError *error) {
    
    NSLog(@"%@", error);
    
  }];
  
}

- (void)resetTap:(UIBarButtonItem *)button {

  _emailTF.text = @"";
  _phoneTF.text = @"";
  _nameTF.text = @"";
  
}

- (void)createUserTap {
  
  _user = [[OMNUser alloc] init];
  _user.email = _emailTF.text;
  _user.phone = _phoneTF.text;
  _user.firstName = _nameTF.text;
  
  __weak typeof(self)weakSelf = self;
  [_user registerWithComplition:^{
    
    [weakSelf requestAuthorizationCode];
    
  } failure:^(NSError *error) {
    
    [[[UIAlertView alloc] initWithTitle:error.localizedDescription message:error.localizedRecoverySuggestion delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    
  }];
  
}

- (void)requestAuthorizationCode {
  
  OMNConfirmCodeVC *confirmCodeVC = [[OMNConfirmCodeVC alloc] initWithPhone:_user.phone];
  confirmCodeVC.delegate = self;
  [self.navigationController pushViewController:confirmCodeVC animated:YES];
  
}

#pragma mark - OMNConfirmCodeVCDelegate

- (void)confirmCodeVC:(OMNConfirmCodeVC *)confirmCodeVC didEnterCode:(NSString *)code {
  
  __weak typeof(self)weakSelf = self;
  [_user confirmPhone:code complition:^(NSString *token) {
    
    [weakSelf didRegisterWithToken:token];
    
  } failure:^(NSError *error) {
    
    [confirmCodeVC reset];
    [[[UIAlertView alloc] initWithTitle:error.localizedDescription message:error.localizedRecoverySuggestion delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    
  }];
  
}

- (void)didRegisterWithToken:(NSString *)token {
  
  [self.delegate registerUserVC:self didRegisterUserWithToken:token];
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

@end
