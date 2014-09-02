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
#import "OMNErrorTextField.h"
#import "OMNNavigationBarProgressView.h"
#import <OMNStyler.h>
#import "OMNDisclamerView.h"

@interface OMNRegisterUserVC ()
<OMNConfirmCodeVCDelegate>

@end

@implementation OMNRegisterUserVC {
  
  OMNErrorTextField *_nameTF;
  OMNErrorTextField *_phoneTF;
  OMNErrorTextField *_emailTF;
  OMNErrorTextField *_birthdayTF;
  
  UIDatePicker *_datePicker;
  UIScrollView *_scroll;
  UILabel *_errorLabel;
  
  OMNUser *_user;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.view.backgroundColor = [UIColor whiteColor];
  
  _datePicker = [[UIDatePicker alloc] init];
  _datePicker.datePickerMode = UIDatePickerModeDate;
  [_datePicker addTarget:self action:@selector(datePickerChange:) forControlEvents:UIControlEventValueChanged];
  
  OMNNavigationBarProgressView *navigationBarProgressView = [[OMNNavigationBarProgressView alloc] initWithText:NSLocalizedString(@"Создать аккаунт", nil) count:2];
  self.navigationItem.titleView = navigationBarProgressView;
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"cross_icon_white"] style:UIBarButtonItemStylePlain target:self action:@selector(closeTap)];
  
  UIBarButtonItem *submitButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Далее", nil) style:UIBarButtonItemStylePlain target:self action:@selector(createUserTap)];
  self.navigationItem.rightBarButtonItem = submitButton;
  
  [self setup];
  
}

- (void)setup {

  self.automaticallyAdjustsScrollViewInsets = NO;
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardDidShow:)
                                               name:UIKeyboardDidShowNotification
                                             object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWillHide:)
                                               name:UIKeyboardWillHideNotification
                                             object:nil];
  
  _scroll = [[UIScrollView alloc] init];
  _scroll.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view addSubview:_scroll];

  UIView *contentView = [[UIView alloc] init];
  contentView.translatesAutoresizingMaskIntoConstraints = NO;
  [_scroll addSubview:contentView];

  OMNDisclamerView *disclamerView = [[OMNDisclamerView alloc] init];
  [contentView addSubview:disclamerView];
  
  _errorLabel = [[UILabel alloc] init];
  _errorLabel.translatesAutoresizingMaskIntoConstraints = NO;
  _errorLabel.font = [UIFont fontWithName:@"Futura-OSF-Omnom-Regular" size:18.0f];
  _errorLabel.textColor = colorWithHexString(@"d0021b");
  _errorLabel.text = nil;
  _errorLabel.textAlignment = NSTextAlignmentCenter;
  _errorLabel.numberOfLines = 0;
  [contentView addSubview:_errorLabel];
  
  _nameTF = [[OMNErrorTextField alloc] init];
  _nameTF.textField.placeholder = NSLocalizedString(@"Имя", nil);
  [contentView addSubview:_nameTF];
  
  _phoneTF = [[OMNErrorTextField alloc] init];
  _phoneTF.textField.keyboardType = UIKeyboardTypePhonePad;
  _phoneTF.textField.placeholder = NSLocalizedString(@"Номер телефона", nil);
  [contentView addSubview:_phoneTF];
  
  _emailTF = [[OMNErrorTextField alloc] init];
  _emailTF.textField.keyboardType = UIKeyboardTypeEmailAddress;
  _emailTF.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
  _emailTF.textField.autocorrectionType = UITextAutocorrectionTypeNo;
  _emailTF.textField.placeholder = NSLocalizedString(@"Почта", nil);
  [contentView addSubview:_emailTF];
  
  _birthdayTF = [[OMNErrorTextField alloc] init];
  _birthdayTF.textField.inputView = _datePicker;
  [contentView addSubview:_birthdayTF];
  
  NSDictionary *views =
  @{
    @"tf1" : _nameTF,
    @"tf2" : _emailTF,
    @"tf3" : _phoneTF,
    @"tf4" : _birthdayTF,
    @"errorLabel" : _errorLabel,
    @"contentView" : contentView,
    @"disclamerView" : disclamerView,
    @"topLayoutGuide" : self.topLayoutGuide,
    @"scroll" : _scroll,
    };
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scroll]|" options:0 metrics:nil views:views]];
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topLayoutGuide][scroll]|" options:0 metrics:nil views:views]];

  [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[tf1]-|" options:0 metrics:nil views:views]];

  [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[tf2]-|" options:0 metrics:nil views:views]];

  [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[tf3]-|" options:0 metrics:nil views:views]];

  [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[tf4]-|" options:0 metrics:nil views:views]];

  [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[disclamerView]-|" options:0 metrics:nil views:views]];
  
  [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[errorLabel]-|" options:0 metrics:nil views:views]];
  
  [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[tf1][tf2][tf3]-[tf4]-45-[errorLabel]-[disclamerView]-|" options:0 metrics:nil views:views]];

  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeLeading relatedBy:0 toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
  
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeTrailing relatedBy:0 toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
  
  [_scroll addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[contentView]|" options:0 metrics:nil views:views]];
  
  [self updateBirthDate];
  
}

- (void)datePickerChange:(UIDatePicker *)datePicker {
  
  [self updateBirthDate];
  
}

- (void)updateBirthDate {

  NSDateFormatter *df = [[NSDateFormatter alloc] init];
  [df setDateFormat:@"dd/MM/yyyy"];
  _birthdayTF.textField.text = [df stringFromDate:_datePicker.date];
  
}

- (void)closeTap {
  
  [self.delegate authorizationVCDidCancel:self];
  
}

- (IBAction)resendTap:(id)sender {
  
  [_user confirmPhoneResend:^{
    
  } failure:^(NSError *error) {
    
  }];
  
}

- (void)resetTap:(UIBarButtonItem *)button {

  _emailTF.textField.text = @"";
  _phoneTF.textField.text = @"";
  _nameTF.textField.text = @"";
  
}

- (void)createUserTap {
  
  [_emailTF setError:nil animated:NO];
  [_phoneTF setError:nil animated:NO];
  [_nameTF setError:nil animated:NO];
  [_birthdayTF setError:nil animated:NO];
  
  BOOL hasErrors = NO;
  
  if (0 == _emailTF.textField.text.length) {
    [_emailTF setError:NSLocalizedString(@"Неправильный емайл", nil) animated:NO];
    hasErrors = YES;
  }
  
  if (0 == _phoneTF.textField.text.length) {
    [_phoneTF setError:NSLocalizedString(@"Неправильный телефон", nil) animated:NO];
    hasErrors = YES;
  }
  
  if (0 == _nameTF.textField.text.length) {
    [_nameTF setError:NSLocalizedString(@"Неправильное имя", nil) animated:NO];
    hasErrors = YES;
  }
  
  if (hasErrors) {
    return;
  }
  
  _user = [[OMNUser alloc] init];
  _user.email = _emailTF.textField.text;
  _user.phone = _phoneTF.textField.text;
  _user.name = _nameTF.textField.text;
  _user.birthDate = _datePicker.date;
  
  __weak typeof(self)weakSelf = self;
  [_user registerWithCompletion:^{
    
    [weakSelf requestAuthorizationCode];
    
  } failure:^(NSError *error) {
    
    [weakSelf processError:error];
    
  }];
  
}

- (void)processError:(NSError *)error {

  if (error) {
    _errorLabel.text = error.localizedDescription;
  }
  else {
    _errorLabel.text = NSLocalizedString(@"Что-то пошло не так. Повторите попытку", nil);
  }
  
}

- (void)requestAuthorizationCode {
  
  _errorLabel.text = @"";
  OMNConfirmCodeVC *confirmCodeVC = [[OMNConfirmCodeVC alloc] initWithPhone:_user.phone];
  confirmCodeVC.delegate = self;
  [self.navigationController pushViewController:confirmCodeVC animated:YES];
  
}

#pragma mark - OMNConfirmCodeVCDelegate

- (void)confirmCodeVC:(OMNConfirmCodeVC *)confirmCodeVC didEnterCode:(NSString *)code {
  
  __weak typeof(self)weakSelf = self;
  [_user confirmPhone:code completion:^(NSString *token) {
    
    [weakSelf didRegisterWithToken:token];
    
  } failure:^(NSError *error) {
    
    [confirmCodeVC resetAnimated:YES];
    [weakSelf processError:error];
    
  }];
  
}

- (void)confirmCodeVCRequestResendCode:(OMNConfirmCodeVC *)confirmCodeVC {
  
  [_user registerWithCompletion:^{
    
  } failure:^(NSError *error) {
    
  }];
  
}

- (void)didRegisterWithToken:(NSString *)token {
  
  if (token) {

    [OMNUser userWithToken:token user:^(OMNUser *user) {
      
      [[OMNAnalitics analitics] logRegisterUser:user];
      
    } failure:^(NSError *error) {
      //TODO: handle
    }];
    
    [self.delegate authorizationVC:self didReceiveToken:token];
    
  }
  else {
    [self processError:nil];
  }
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}


- (void)keyboardDidShow:(NSNotification *)notification {
  NSDictionary* info = [notification userInfo];
  CGRect kbRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
  kbRect = [self.view convertRect:kbRect fromView:nil];
  
  UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbRect.size.height, 0.0);
  _scroll.contentInset = contentInsets;
  _scroll.scrollIndicatorInsets = contentInsets;
  
  CGRect aRect = self.view.frame;
  aRect.size.height -= kbRect.size.height;
//  if (!CGRectContainsPoint(aRect, self.activeField.frame.origin) ) {
//    [_scroll scrollRectToVisible:self.activeField.frame animated:YES];
//  }
}

- (void)keyboardWillHide:(NSNotification *)notification {
  UIEdgeInsets contentInsets = UIEdgeInsetsZero;
  _scroll.contentInset = contentInsets;
  _scroll.scrollIndicatorInsets = contentInsets;
}

@end
