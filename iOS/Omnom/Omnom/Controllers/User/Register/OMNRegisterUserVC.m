//
//  OMNRegisterUserVC.m
//  seocialtest
//
//  Created by tea on 09.06.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNRegisterUserVC.h"
#import "OMNUser.h"
#import "OMNUser+network.h"
#import "OMNConfirmCodeVC.h"
#import "OMNAnalitics.h"
#import "OMNErrorTextField.h"
#import "OMNNavigationBarProgressView.h"
#import <OMNStyler.h>
#import "OMNDisclamerView.h"
#import "UIBarButtonItem+omn_custom.h"

@interface OMNRegisterUserVC ()
<OMNConfirmCodeVCDelegate,
UITextFieldDelegate>

@end

@implementation OMNRegisterUserVC {
  
  OMNErrorTextField *_nameTF;
  OMNErrorTextField *_phoneTF;
  OMNErrorTextField *_emailTF;
  OMNErrorTextField *_birthdayTF;
  
  UIDatePicker *_datePicker;
  UIScrollView *_scroll;
  UILabel *_errorLabel;
  
  __weak UITextField *_currentTextField;
  NSArray *_textFields;
  
  OMNUser *_user;
}

- (void)dealloc {
  
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.automaticallyAdjustsScrollViewInsets = NO;
  self.view.backgroundColor = [UIColor whiteColor];
  
  [self omn_setup];
  
  OMNNavigationBarProgressView *navigationBarProgressView = [[OMNNavigationBarProgressView alloc] initWithText:NSLocalizedString(@"REGISTER_USER_TITLE", @"Создать аккаунт") count:2];
  self.navigationItem.titleView = navigationBarProgressView;
  self.navigationItem.leftBarButtonItem = [UIBarButtonItem omn_barButtonWithImage:[UIImage imageNamed:@"cross_icon_white"] color:[UIColor blackColor] target:self action:@selector(closeTap)];
  self.navigationItem.rightBarButtonItem = [self createUserButton];
  
  _emailTF.textField.text = self.email;
  _phoneTF.textField.text = self.phone;
  
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  [_nameTF.textField becomeFirstResponder];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidBeginEditing:) name:UITextFieldTextDidBeginEditingNotification object:nil];
  
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (UIBarButtonItem *)createUserButton {
  
  return [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"REGISTER_USER_BUTTON_TITLE", @"Далее") style:UIBarButtonItemStylePlain target:self action:@selector(createUserTap)];
  
}

- (void)doneTap {
  
  if ([[NSDate date] timeIntervalSinceDate:_datePicker.date] > 18 * 365 * 24 * 60 * 60) {
    [self updateBirthDate];
    [_birthdayTF setErrorText:nil];
    [self.view endEditing:YES];
  }
  else {
    
    [_birthdayTF setErrorText:NSLocalizedString(@"REGISTER_USER_ERROR_AGE", @"Слишком мало лет =(")];
    
  }
  
}

- (void)nextTap {
  
  NSInteger index = (_currentTextField.tag + 1)%_textFields.count;
  if (index < _textFields.count) {
    OMNErrorTextField *textField = _textFields[index];
    [textField.textField becomeFirstResponder];
  }
  
}

- (void)cancelTap {
  [self.view endEditing:YES];
}

- (void)datePickerChange:(UIDatePicker *)datePicker {
  
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
  
  [_emailTF setErrorText:nil];
  [_phoneTF setErrorText:nil];
  [_nameTF setErrorText:nil];
  [_birthdayTF setErrorText:nil];
  
  BOOL hasErrors = NO;
  if (0 == _emailTF.textField.text.length) {
    [_emailTF setErrorText:NSLocalizedString(@"REGISTER_USER_ERROR_NO_EMAIL", @"Вы забыли ввести e-mail")];
    hasErrors = YES;
  }
  else if (NO == [_emailTF.textField.text omn_isValidEmail]) {
    [_emailTF setErrorText:NSLocalizedString(@"REGISTER_USER_ERROR_EMAIL", @"Некорректный e-mail")];
    hasErrors = YES;
  }
  
  if (0 == _phoneTF.textField.text.length) {
    [_phoneTF setErrorText:NSLocalizedString(@"REGISTER_USER_ERROR_NO_PHONE_NUMBER", @"Вы забыли ввести номер телефона")];
    hasErrors = YES;
  }
  else if (NO == [_phoneTF.textField.text omn_isValidPhone]) {
    [_phoneTF setErrorText:NSLocalizedString(@"REGISTER_USER_ERROR_PHONE_NUMBER", @"Некорректный номер телефона")];
    hasErrors = YES;
  }

  if (0 == _nameTF.textField.text.length) {
    [_nameTF setErrorText:NSLocalizedString(@"REGISTER_USER_ERROR_NO_NAME", @"Вы забыли ввести имя")];
    hasErrors = YES;
  }
  
  [UIView animateWithDuration:0.3 animations:^{
    [self.view layoutIfNeeded];
  }];
  
  if (hasErrors) {
    return;
  }

  _user = [[OMNUser alloc] init];
  _user.email = _emailTF.textField.text;
  _user.phone = _phoneTF.textField.text;
  _user.name = _nameTF.textField.text;
  if (_birthdayTF.textField.text) {
    _user.birthDate = _datePicker.date;
  }
  
  
  [self.view endEditing:YES];
  self.navigationItem.rightBarButtonItem = [UIBarButtonItem omn_loadingItem];
  __weak typeof(self)weakSelf = self;
  [_user registerWithCompletion:^{
    
    [weakSelf requestAuthorizationCode];
    
  } failure:^(NSError *error) {
    
    [weakSelf processError:error];
    
  }];
  
}

- (void)processError:(NSError *)error {

  self.navigationItem.rightBarButtonItem = [self createUserButton];
  if (error) {
    _errorLabel.text = error.localizedDescription;
  }
  else {
    _errorLabel.text = NSLocalizedString(@"REGISTER_USER_ERROR_COMMON", @"Что-то пошло не так. Повторите попытку.");
  }
  
}

- (void)requestAuthorizationCode {
  
  _errorLabel.text = @"";
  OMNConfirmCodeVC *confirmCodeVC = [[OMNConfirmCodeVC alloc] initWithPhone:_user.phone];
  confirmCodeVC.delegate = self;
  [self.navigationController pushViewController:confirmCodeVC animated:YES];
  self.navigationItem.rightBarButtonItem = [self createUserButton];
  
}

#pragma mark - OMNConfirmCodeVCDelegate

- (void)confirmCodeVC:(OMNConfirmCodeVC *)confirmCodeVC didEnterCode:(NSString *)code {
  
  __weak typeof(self)weakSelf = self;
  [_user verifyPhoneCode:code completion:^(NSString *token) {
    
    [weakSelf didRegisterWithToken:token];
    
  } failure:^(NSError *error) {
    
    [confirmCodeVC resetAnimated:YES];
    [weakSelf processError:error];
    
  }];
  
}

- (void)confirmCodeVCRequestResendCode:(OMNConfirmCodeVC *)confirmCodeVC {
  
  [_user verifyPhoneCode:nil completion:^(NSString *token) {
    
  } failure:^(NSError *error) {
    
  }];
  
}

- (void)didRegisterWithToken:(NSString *)token {
  
  if (token) {

    [self.delegate authorizationVC:self didReceiveToken:token fromRegstration:YES];
    
  }
  else {
    [self processError:nil];
  }
  
}

- (void)textDidBeginEditing:(NSNotification *)notification {

  UITextField *textField = notification.object;
  _currentTextField = textField;

  if ([textField isEqual:_phoneTF.textField] &&
      0 == _phoneTF.textField.text.length) {
    _phoneTF.textField.text = @"+7";
  }
  
  CGRect textFieldFrame = [textField convertRect:textField.bounds toView:_scroll];
  [_scroll scrollRectToVisible:textFieldFrame animated:YES];
  CGPoint contentOffset = CGPointMake(0.0f, MAX(0.0f, textFieldFrame.origin.y - 20.0f));
  [UIView animateWithDuration:0.3 delay:0.1 options:0 animations:^{
    [_scroll setContentOffset:contentOffset];
  } completion:nil];
  
}

- (void)keyboardDidShow:(NSNotification *)notification {
  
  NSDictionary* info = [notification userInfo];
  CGRect kbRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
  kbRect = [self.view convertRect:kbRect fromView:nil];
  
  UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbRect.size.height, 0.0);
  CGPoint offset = _scroll.contentOffset;
  _scroll.contentInset = contentInsets;
  _scroll.scrollIndicatorInsets = contentInsets;
  _scroll.contentOffset = offset;
  
}

- (void)keyboardWillHide:(NSNotification *)notification {
  UIEdgeInsets contentInsets = UIEdgeInsetsZero;
  _scroll.contentInset = contentInsets;
  _scroll.scrollIndicatorInsets = contentInsets;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [self nextTap];
  return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
  
  if ([textField isEqual:_birthdayTF]) {
    return NO;
  }
  
  return YES;
  
}

#pragma mark - setup

- (void)omn_setup {
  
  _scroll = [[UIScrollView alloc] init];
  _scroll.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view addSubview:_scroll];
  
  UIView *contentView = [[UIView alloc] init];
  contentView.translatesAutoresizingMaskIntoConstraints = NO;
  [_scroll addSubview:contentView];
  
  OMNDisclamerView *disclamerView = [[OMNDisclamerView alloc] init];
  [contentView addSubview:disclamerView];
  
  UIToolbar *nextToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 0.0f, 44.0f)];
  nextToolbar.items =
  @[
    [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"REGISTER_USER_FIELD_CANCEL", @"Отмена") style:UIBarButtonItemStylePlain target:self action:@selector(cancelTap)],
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
    [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"REGISTER_USER_FIELD_NEXT", @"Следующий") style:UIBarButtonItemStylePlain target:self action:@selector(nextTap)],
    ];
  
  UIToolbar *doneToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 0.0f, 44.0f)];
  doneToolbar.items =
  @[
    [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"REGISTER_USER_FIELD_CANCEL", @"Отмена") style:UIBarButtonItemStylePlain target:self action:@selector(cancelTap)],
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
    [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"REGISTER_USER_FIELD_DONE", @"Готово") style:UIBarButtonItemStylePlain target:self action:@selector(doneTap)],
    ];
  
  _errorLabel = [[UILabel alloc] init];
  _errorLabel.translatesAutoresizingMaskIntoConstraints = NO;
  _errorLabel.font = FuturaOSFOmnomRegular(18.0f);
  _errorLabel.textColor = colorWithHexString(@"d0021b");
  _errorLabel.text = nil;
  _errorLabel.textAlignment = NSTextAlignmentCenter;
  _errorLabel.numberOfLines = 0;
  [contentView addSubview:_errorLabel];
  
  _nameTF = [[OMNErrorTextField alloc] init];
  _nameTF.textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
  _nameTF.textField.returnKeyType = UIReturnKeyNext;
  _nameTF.textField.inputAccessoryView = nextToolbar;
  _nameTF.textField.tag = 0;
  _nameTF.textField.delegate = self;
  _nameTF.textField.placeholder = NSLocalizedString(@"REGISTER_PLACEHOLDER_NAME", @"Имя");
  [contentView addSubview:_nameTF];
  
  _emailTF = [[OMNErrorTextField alloc] init];
  _emailTF.textField.tag = 1;
  _emailTF.textField.inputAccessoryView = nextToolbar;
  _emailTF.textField.delegate = self;
  _emailTF.textField.keyboardType = UIKeyboardTypeEmailAddress;
  _emailTF.textField.returnKeyType = UIReturnKeyNext;
  _emailTF.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
  _emailTF.textField.autocorrectionType = UITextAutocorrectionTypeNo;
  _emailTF.textField.placeholder = NSLocalizedString(@"REGISTER_PLACEHOLDER_EMAIL", @"Почта");
  [contentView addSubview:_emailTF];
  
  _phoneTF = [[OMNErrorTextField alloc] init];
  _phoneTF.textField.tag = 2;
  _phoneTF.textField.keyboardType = UIKeyboardTypePhonePad;
  _phoneTF.textField.inputAccessoryView = nextToolbar;
  _phoneTF.textField.placeholder = NSLocalizedString(@"REGISTER_PLACEHOLDER_PHONE_NUMBER", @"Номер телефона");
  [contentView addSubview:_phoneTF];
  
  _datePicker = [[UIDatePicker alloc] init];
  _datePicker.backgroundColor = [UIColor whiteColor];
  _datePicker.datePickerMode = UIDatePickerModeDate;
  [_datePicker addTarget:self action:@selector(datePickerChange:) forControlEvents:UIControlEventValueChanged];
  NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
  NSDateComponents *components = [calendar components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:[NSDate date]];
  components.year -= 30;
  _datePicker.date = [calendar dateFromComponents:components];
  
  _birthdayTF = [[OMNErrorTextField alloc] init];
  _birthdayTF.textField.tag = 3;
  _birthdayTF.textField.delegate = self;
  _birthdayTF.textField.inputView = _datePicker;
  _birthdayTF.textField.inputAccessoryView = doneToolbar;
  _birthdayTF.textField.placeholder = NSLocalizedString(@"REGISTER_PLACEHOLDER_BIRTHDATE", @"День рождения");
  [contentView addSubview:_birthdayTF];
  
  _textFields = @[_nameTF, _emailTF, _phoneTF, _birthdayTF];
  
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
  
  NSDictionary *metrics =
  @{
    @"leftOffset" : [[OMNStyler styler] leftOffset],
    };
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scroll]|" options:0 metrics:metrics views:views]];
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topLayoutGuide][scroll]|" options:0 metrics:metrics views:views]];
  
  [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[tf1]-|" options:0 metrics:metrics views:views]];
  
  [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[tf2]-|" options:0 metrics:metrics views:views]];
  
  [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[tf3]-|" options:0 metrics:metrics views:views]];
  
  [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[tf4]-|" options:0 metrics:metrics views:views]];
  
  [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[disclamerView]-|" options:0 metrics:metrics views:views]];
  
  [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[errorLabel]-|" options:0 metrics:metrics views:views]];
  
  [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[tf1][tf2][tf3]-[tf4]-[disclamerView]-[errorLabel]-|" options:0 metrics:nil views:views]];
  
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeLeading relatedBy:0 toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
  
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeTrailing relatedBy:0 toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
  
  [_scroll addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[contentView]|" options:0 metrics:nil views:views]];
  
}

@end
