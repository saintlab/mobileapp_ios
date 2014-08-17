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

  UILabel *hintLabel = [[UILabel alloc] init];
  hintLabel.translatesAutoresizingMaskIntoConstraints = NO;
  hintLabel.font = [UIFont fontWithName:@"Futura-OSF-Omnom-Regular" size:18.0f];
  hintLabel.textColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
  hintLabel.text = NSLocalizedString(@"Укажите, чтобы мы не забыли вас поздравить", nil);
  hintLabel.textAlignment = NSTextAlignmentCenter;
  hintLabel.numberOfLines = 0;
  
  UIView *contentView = [[UIView alloc] init];
  contentView.translatesAutoresizingMaskIntoConstraints = NO;
  [_scroll addSubview:contentView];
  [contentView addSubview:hintLabel];
  
  _nameTF = [[OMNErrorTextField alloc] init];
  _nameTF.textField.placeholder = NSLocalizedString(@"Имя", nil);
  [contentView addSubview:_nameTF];
  
  _phoneTF = [[OMNErrorTextField alloc] init];
  _phoneTF.textField.keyboardType = UIKeyboardTypePhonePad;
  _phoneTF.textField.placeholder = NSLocalizedString(@"Номер телефона", nil);
  [contentView addSubview:_phoneTF];
  
  _emailTF = [[OMNErrorTextField alloc] init];
  _emailTF.textField.keyboardType = UIKeyboardTypeEmailAddress;
  _emailTF.textField.placeholder = NSLocalizedString(@"Почта", nil);
  [contentView addSubview:_emailTF];
  
  _birthdayTF = [[OMNErrorTextField alloc] init];
  [contentView addSubview:_birthdayTF];
  
  NSDictionary *views =
  @{
    @"tf1" : _nameTF,
    @"tf2" : _emailTF,
    @"tf3" : _phoneTF,
    @"tf4" : _birthdayTF,
    @"hintLabel" : hintLabel,
    @"contentView" : contentView,
    @"topLayoutGuide" : self.topLayoutGuide,
    @"scroll" : _scroll,
    };
  
  NSArray *h = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scroll]|" options:0 metrics:nil views:views];
  [self.view addConstraints:h];
  
  NSArray *v = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topLayoutGuide][scroll]|" options:0 metrics:nil views:views];
  [self.view addConstraints:v];

  
  h = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[tf1]-|" options:0 metrics:nil views:views];
  [contentView addConstraints:h];
  h = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[tf2]-|" options:0 metrics:nil views:views];
  [contentView addConstraints:h];
  h = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[tf3]-|" options:0 metrics:nil views:views];
  [contentView addConstraints:h];
  h = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[tf4]-|" options:0 metrics:nil views:views];
  [contentView addConstraints:h];
  h = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[hintLabel]-|" options:0 metrics:nil views:views];
  [contentView addConstraints:h];
  v = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[tf1][tf2][tf3]-45-[tf4]-[hintLabel]-|" options:0 metrics:nil views:views];
  [contentView addConstraints:v];



  NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:contentView
                                                                    attribute:NSLayoutAttributeLeading
                                                                    relatedBy:0
                                                                       toItem:self.view
                                                                    attribute:NSLayoutAttributeLeft
                                                                   multiplier:1.0
                                                                     constant:0];
  [self.view addConstraint:leftConstraint];
  
  NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:contentView
                                                                     attribute:NSLayoutAttributeTrailing
                                                                     relatedBy:0
                                                                        toItem:self.view
                                                                     attribute:NSLayoutAttributeRight
                                                                    multiplier:1.0
                                                                      constant:0];
  [self.view addConstraint:rightConstraint];
  
  v = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[contentView]|" options:0 metrics:nil views:views];
  [_scroll addConstraints:v];
  
  [self updateBirthDate];

  
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
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
    
    NSLog(@"%@", error);
    
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
    [_emailTF setError:NSLocalizedString(@"Непривильный емаил", nil) animated:NO];
    hasErrors = YES;
  }
  
  if (0 == _phoneTF.textField.text.length) {
    [_phoneTF setError:NSLocalizedString(@"Непривильный телефон", nil) animated:NO];
    hasErrors = YES;
  }
  
  if (0 == _nameTF.textField.text.length) {
    [_nameTF setError:NSLocalizedString(@"Непривильное имя", nil) animated:NO];
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
  [_user confirmPhone:code completion:^(NSString *token) {
    
    [weakSelf didRegisterWithToken:token];
    
  } failure:^(NSError *error) {
    
    [confirmCodeVC resetAnimated:YES];
    [[[UIAlertView alloc] initWithTitle:error.localizedDescription message:error.localizedRecoverySuggestion delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    
  }];
  
}

- (void)confirmCodeVCRequestResendCode:(OMNConfirmCodeVC *)confirmCodeVC {
  
  [_user registerWithCompletion:^{
    
  } failure:^(NSError *error) {
    
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
