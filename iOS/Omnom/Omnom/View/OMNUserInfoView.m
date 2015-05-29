//
//  OMNUserInfoView.m
//  omnom
//
//  Created by tea on 04.12.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNUserInfoView.h"
#import <OMNStyler.h>
#import "UIBarButtonItem+omn_custom.h"

@interface OMNUserInfoView ()
<UITextFieldDelegate>

@end

@implementation OMNUserInfoView {
  
  UIDatePicker *_datePicker;
  
  __weak UITextField *_currentTextField;
  NSArray *_textFields;
  
  OMNUser *_user;
  BOOL _constraintsUpdated;
  
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithUser:(OMNUser *)user {
  self = [super init];
  if (self) {
    
    _user = [user copy];
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self setupView];
    _nameTF.textField.text = _user.name;
    _phoneTF.textField.text = _user.phone;
    _emailTF.textField.text = _user.email;
    
    if (_user.birthDate) {
      
      _datePicker.date = _user.birthDate;
      [self updateBirthDate];
      
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidBeginEditing:) name:UITextFieldTextDidBeginEditingNotification object:nil];
    
  }
  return self;
}

- (void)setupView {
  
  UIToolbar *nextToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 0.0f, 44.0f)];
  nextToolbar.items =
  @[
    [[UIBarButtonItem alloc] initWithTitle:kOMN_CANCEL_BUTTON_TITLE style:UIBarButtonItemStylePlain target:self action:@selector(cancelTap)],
    [UIBarButtonItem omn_flexibleItem],
    [[UIBarButtonItem alloc] initWithTitle:kOMN_REGISTER_USER_FIELD_NEXT style:UIBarButtonItemStylePlain target:self action:@selector(nextTap)],
    ];
  
  UIToolbar *doneToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 0.0f, 44.0f)];
  doneToolbar.items =
  @[
    [[UIBarButtonItem alloc] initWithTitle:kOMN_CANCEL_BUTTON_TITLE style:UIBarButtonItemStylePlain target:self action:@selector(cancelTap)],
    [UIBarButtonItem omn_flexibleItem],
    [[UIBarButtonItem alloc] initWithTitle:kOMN_DONE_BUTTON_TITLE style:UIBarButtonItemStylePlain target:self action:@selector(doneTap)],
    ];

  _nameTF = [[OMNErrorTextField alloc] init];
  _nameTF.textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
  _nameTF.textField.returnKeyType = UIReturnKeyNext;
  _nameTF.textField.inputAccessoryView = nextToolbar;
  _nameTF.textField.tag = 0;
  _nameTF.textField.delegate = self;
  _nameTF.textField.placeholder = kOMN_REGISTER_PLACEHOLDER_NAME;
  [self addSubview:_nameTF];
  
  _emailTF = [[OMNErrorTextField alloc] init];
  _emailTF.textField.tag = 1;
  _emailTF.textField.inputAccessoryView = nextToolbar;
  _emailTF.textField.delegate = self;
  _emailTF.textField.keyboardType = UIKeyboardTypeEmailAddress;
  _emailTF.textField.returnKeyType = UIReturnKeyNext;
  _emailTF.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
  _emailTF.textField.autocorrectionType = UITextAutocorrectionTypeNo;
  _emailTF.textField.placeholder = kOMN_REGISTER_PLACEHOLDER_EMAIL;
  [self addSubview:_emailTF];
  
  _phoneTF = [[OMNErrorTextField alloc] init];
  _phoneTF.textField.tag = 2;
  _phoneTF.textField.keyboardType = UIKeyboardTypePhonePad;
  _phoneTF.textField.inputAccessoryView = nextToolbar;
  _phoneTF.textField.placeholder = kOMN_REGISTER_PLACEHOLDER_PHONE_NUMBER;
  [self addSubview:_phoneTF];
  
  _datePicker = [[UIDatePicker alloc] init];
  _datePicker.backgroundColor = [UIColor whiteColor];
  _datePicker.datePickerMode = UIDatePickerModeDate;
  [_datePicker addTarget:self action:@selector(dateDidChange:) forControlEvents:UIControlEventValueChanged];
  NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
  NSDateComponents *components = [calendar components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:[NSDate date]];
  components.year -= 30;
  _datePicker.date = [calendar dateFromComponents:components];
  
  _birthdayTF = [[OMNErrorTextField alloc] init];
  _birthdayTF.textField.tag = 3;
  _birthdayTF.textField.delegate = self;
  _birthdayTF.textField.inputView = _datePicker;
  _birthdayTF.textField.inputAccessoryView = doneToolbar;
  _birthdayTF.textField.placeholder = kOMN_REGISTER_PLACEHOLDER_BIRTHDATE;
  [self addSubview:_birthdayTF];
  
  _textFields = @[_nameTF, _emailTF, _phoneTF, _birthdayTF];
  
}

- (void)dateDidChange:(UIDatePicker *)datePicker {
  
  [self setBirthDate:datePicker.date];
  
}

- (void)updateConstraints {
  
  [super updateConstraints];
  
  if (_constraintsUpdated) {
    return;
  }
  
  _constraintsUpdated = YES;
  
  NSDictionary *views =
  @{
    @"tf1" : _nameTF,
    @"tf2" : _emailTF,
    @"tf3" : _phoneTF,
    @"tf4" : _birthdayTF,
    };

  NSDictionary *metrics =
  @{
    @"leftOffset" : @(OMNStyler.leftOffset),
    };
  
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[tf1]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[tf2]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[tf3]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[tf4]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[tf1][tf2][tf3]-[tf4]-|" options:kNilOptions metrics:metrics views:views]];
  
}

- (void)beginEditing {
  
  [_nameTF.textField becomeFirstResponder];
  
}

- (void)doneTap {

  [self setBirthDate:_datePicker.date];
  [self endEditing:YES];
  
}

- (void)setBirthDate:(NSDate *)birthDate {
  
  _user.birthDate = birthDate;
  [self updateBirthDate];
  [_birthdayTF setErrorText:nil];
  
}

- (void)updateBirthDate {
  
  static NSDateFormatter *dateFormatter = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setLocale:[NSLocale currentLocale]];
  });
  
  if (_user.birthDate) {
    
    _birthdayTF.textField.text = [dateFormatter stringFromDate:_user.birthDate];
    
  }
  else {
    
    _birthdayTF.textField.text = @"";
    
  }
  
  
}

- (void)nextTap {
  
  NSInteger index = (_currentTextField.tag + 1)%_textFields.count;
  if (index < _textFields.count) {
    OMNErrorTextField *textField = _textFields[index];
    
    if (textField.userInteractionEnabled) {
      
      [textField.textField becomeFirstResponder];
      
    }
    else {
      
      _currentTextField = textField.textField;
      [self nextTap];
      
    }
    
  }
  
}

- (void)cancelTap {
  [self endEditing:YES];
}

- (OMNUser *)userWithToken:(NSString *)token {
  
  [_emailTF setErrorText:nil];
  [_phoneTF setErrorText:nil];
  [_nameTF setErrorText:nil];
  [_birthdayTF setErrorText:nil];
  
  BOOL hasErrors = NO;
  if (_emailTF.textField.text.length &&
      ![_emailTF.textField.text omn_isValidEmail]) {
    [_emailTF setErrorText:kOMN_REGISTER_USER_ERROR_EMAIL];
    hasErrors = YES;
  }
  
  if (0 == _phoneTF.textField.text.length) {
    [_phoneTF setErrorText:kOMN_REGISTER_USER_ERROR_NO_PHONE_NUMBER];
    hasErrors = YES;
  }
  else if (![_phoneTF.textField.text omn_isValidPhone]) {
    [_phoneTF setErrorText:kOMN_REGISTER_USER_ERROR_PHONE_NUMBER];
    hasErrors = YES;
  }
  
  [UIView animateWithDuration:0.3 animations:^{
    [self.superview layoutIfNeeded];
  }];
  
  if (hasErrors) {
    return nil;
  }
  
  OMNUser *user = [OMNUser userWithPhone:_phoneTF.textField.text token:token];
  user.email = _emailTF.textField.text;
  user.name = _nameTF.textField.text;
  if (_birthdayTF.textField.text) {
    
    user.birthDate = _datePicker.date;
    
  }
  [self endEditing:YES];
  
  return user;
  
}

#pragma mark - UITextFieldDelegate

- (void)textDidBeginEditing:(NSNotification *)notification {
  
  UITextField *textField = notification.object;
  _currentTextField = textField;
  
  if ([textField isEqual:_phoneTF.textField] &&
      0 == _phoneTF.textField.text.length) {
    
    _phoneTF.textField.text = @"+7";
    
  }

  [self.delegate userInfoView:self didbeginEditingTextField:textField];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  
  [self nextTap];
  
  return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    return [textField isEqual:_birthdayTF] ? NO : YES;

}

@end
