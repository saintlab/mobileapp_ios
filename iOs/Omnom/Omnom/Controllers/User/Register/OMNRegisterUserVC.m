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
#import "OMNAnalitics.h"

@interface OMNRegisterUserVC ()
<OMNConfirmCodeVCDelegate>

@end

@implementation OMNRegisterUserVC {
  
  __weak IBOutlet UITextField *_nameTF;
  __weak IBOutlet UITextField *_phoneTF;
  __weak IBOutlet UITextField *_emailTF;
  __weak IBOutlet UITextField *_birthdayTF;
  
  
  UIDatePicker *_datePicker;
  
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
  
  _datePicker = [[UIDatePicker alloc] init];
  _datePicker.datePickerMode = UIDatePickerModeDate;
  [_datePicker addTarget:self action:@selector(datePickerChange:) forControlEvents:UIControlEventValueChanged];
  _birthdayTF.inputView = _datePicker;
  
  self.navigationItem.title = NSLocalizedString(@"Создать аккаунт", nil);
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Закрыть", nil) style:UIBarButtonItemStylePlain target:self action:@selector(closeTap)];
  UIBarButtonItem *submitButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Далее", nil) style:UIBarButtonItemStylePlain target:self action:@selector(createUserTap)];
  self.navigationItem.rightBarButtonItems = @[submitButton];
  
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [_nameTF becomeFirstResponder];
  [self updateBirthDate];
  
}

- (void)datePickerChange:(UIDatePicker *)datePicker {
  
  [self updateBirthDate];
  
}

- (void)updateBirthDate {

  NSDateFormatter *df = [[NSDateFormatter alloc] init];
  [df setDateFormat:@"dd/MM/yyyy"];
  _birthdayTF.text = [df stringFromDate:_datePicker.date];
  
}

- (void)closeTap {
  
  [self.delegate authorizationVCDidCancel:self];
  
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
  _user.name = _nameTF.text;
  _user.birthDate = _datePicker.date;
  
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
    
    [confirmCodeVC resetAnimated:YES];
    [[[UIAlertView alloc] initWithTitle:error.localizedDescription message:error.localizedRecoverySuggestion delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    
  }];
  
}

- (void)didRegisterWithToken:(NSString *)token {
  
  [OMNUser userWithToken:token user:^(OMNUser *user) {
    
    [[OMNAnalitics analitics] logRegisterUser:user];
    
  } failure:^(NSError *error) {
    
    NSLog(@"%@", error);
    
  }];
  
  [self.delegate authorizationVC:self didReceiveToken:token];
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

@end
