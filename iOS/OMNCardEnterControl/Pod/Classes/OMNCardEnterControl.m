//
//  OMNCardEnterControl.m
//  cardEnterControl
//
//  Created by tea on 07.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNCardEnterControl.h"
#import "OMNDeletedTextField.h"
#import <OMNStyler.h>
#import "NSString+omn_pan.h"

NSString * const OMNCardEnterControlPanString = @"OMNCardEnterControlPanString";
NSString * const OMNCardEnterControlMonthString = @"OMNCardEnterControlMonthString";
NSString * const OMNCardEnterControlYearString = @"OMNCardEnterControlYearString";
NSString * const OMNCardEnterControlCVVString = @"OMNCardEnterControlCVVString";

NSInteger kDesiredPanLength = 19;
NSInteger kCVVLength = 3;

@interface OMNCardEnterControl ()
<UITextFieldDelegate>

@end

@implementation OMNCardEnterControl {
  
  OMNDeletedTextField *_panTF;
  OMNDeletedTextField *_expireTF;
  OMNDeletedTextField *_cvvTF;
  
  UIButton *_scanActionView;
  UIButton *_smallCameraButton;
  
  UIButton *_saveButton;

  UIButton *_scanFrame;
  UILabel *_scanLabel;
}

- (UIFont *)fontWithSize:(CGFloat)size {
  return [UIFont fontWithName:@"Futura-LSF-Omnom-LE-Regular" size:size];
}

- (OMNDeletedTextField *)numberTextField {
  
  OMNDeletedTextField *numberTextField = [[OMNDeletedTextField alloc] init];
  numberTextField.font = [self fontWithSize:20.0f];
  numberTextField.tintColor = [UIColor whiteColor];
  numberTextField.textAlignment = NSTextAlignmentLeft;
  numberTextField.translatesAutoresizingMaskIntoConstraints = NO;
  numberTextField.keyboardType = UIKeyboardTypeNumberPad;
  numberTextField.delegate = self;
  return numberTextField;
  
}

- (NSAttributedString *)attributedPlaceholderWithText:(NSString *)text {
  
  UIColor *color = [UIColor colorWithWhite:1.0f alpha:0.3f];
  return [[NSAttributedString alloc] initWithString:text attributes:@{NSForegroundColorAttributeName: color}];
  
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
  
  self = [super init];
  if (self) {
    self.userInteractionEnabled = YES;
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.backgroundColor = [UIColor clearColor];
    
    UIImageView *bgIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"card_area"]];
    bgIV.userInteractionEnabled = YES;
    bgIV.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:bgIV];
    
    _smallCameraButton = [[UIButton alloc] init];
    _smallCameraButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_smallCameraButton setImage:[UIImage imageNamed:@"camera_icon_white"] forState:UIControlStateNormal];
    [_smallCameraButton addTarget:self action:@selector(cameraButtonTap) forControlEvents:UIControlEventTouchUpInside];
    [bgIV addSubview:_smallCameraButton];
    
    _scanFrame = [[UIButton alloc] init];
    _scanFrame.userInteractionEnabled = NO;
    _scanFrame.translatesAutoresizingMaskIntoConstraints = NO;
    [_scanFrame setBackgroundImage:[UIImage imageNamed:@"scan_frame"] forState:UIControlStateNormal];
    [_scanFrame setImage:[UIImage imageNamed:@"camera_icon_white"] forState:UIControlStateNormal];
    
    _scanLabel = [[UILabel alloc] init];
    _scanLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _scanLabel.numberOfLines = 0;
    _scanLabel.text = NSLocalizedString(@"— Отсканируйте\nвашу карту", nil);
    _scanLabel.font = [self fontWithSize:15.0f];
    _scanLabel.textColor = [UIColor colorWithWhite:1.0f alpha:1.0f];
    _scanLabel.highlightedTextColor = [UIColor colorWithWhite:0.5f alpha:0.5f];
    _scanActionView = [[UIButton alloc] init];
    [_scanActionView addTarget:self action:@selector(cameraButtonTap) forControlEvents:UIControlEventTouchUpInside];
    _scanActionView.translatesAutoresizingMaskIntoConstraints = NO;

    [_scanActionView addTarget:self action:@selector(cameraButtonDown) forControlEvents:UIControlEventTouchDown];
    [_scanActionView addTarget:self action:@selector(cameraButtonUp) forControlEvents:UIControlEventTouchUpInside];
    [_scanActionView addTarget:self action:@selector(cameraButtonUp) forControlEvents:UIControlEventTouchUpOutside];
    
    [bgIV addSubview:_scanActionView];
    
    [_scanActionView addSubview:_scanFrame];
    [_scanActionView addSubview:_scanLabel];
    
    _panTF = [self numberTextField];
    _panTF.attributedPlaceholder = [self attributedPlaceholderWithText:NSLocalizedString(@"Номер банковской карты", nil)];
    [bgIV addSubview:_panTF];
    
    _expireTF = [self numberTextField];
    _expireTF.attributedPlaceholder = [self attributedPlaceholderWithText:[NSString stringWithFormat:@"MM%@YY", kMM_YYSeporator]];
    [bgIV addSubview:_expireTF];
    
    _cvvTF = [self numberTextField];
    _cvvTF.attributedPlaceholder = [self attributedPlaceholderWithText:@"CVV"];
    [bgIV addSubview:_cvvTF];
    
    NSDictionary *metrics =
    @{
       @"textFieldHeight" : @(40.0f),
       @"textFieldWidth" : @(80.0f),
       @"textFieldsOffset" : @(25.0f),
       @"cameraButtonSize" : @(44.0f),
       @"cornerOffset" : @(20.0f),
       };
    
    _saveButton = [[UIButton alloc] init];
    [_saveButton addTarget:self action:@selector(saveTap) forControlEvents:UIControlEventTouchUpInside];
    _saveButton.translatesAutoresizingMaskIntoConstraints = NO;
    _saveButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _saveButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _saveButton.tintColor = [UIColor blackColor];
    _saveButton.titleEdgeInsets = UIEdgeInsetsMake(0.0f, 10.0f, 0.0f, 0.0f);
    _saveButton.contentEdgeInsets = UIEdgeInsetsMake(0.0f, [metrics[@"cornerOffset"] floatValue], 0.0f, 0.0f);
    _saveButton.titleLabel.numberOfLines = 0;
    _saveButton.titleLabel.font = [self fontWithSize:15.0f];
    _saveButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    _saveButton.titleLabel.minimumScaleFactor = 0.1f;
    [_saveButton setTitleColor:[UIColor colorWithWhite:120.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [_saveButton setTitle:NSLocalizedString(@"Сохранить данные для следующих платежей", nil) forState:UIControlStateNormal];
    [_saveButton setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
    [_saveButton setImage:[UIImage imageNamed:@"checkbox_icon"] forState:UIControlStateSelected];
    [_saveButton setImage:[UIImage imageNamed:@"checkbox_icon"] forState:UIControlStateSelected|UIControlStateHighlighted];
    _saveButton.selected = YES;
    [self addSubview:_saveButton];
    
    NSDictionary *views =
    @{
      @"bgIV" : bgIV,
      @"cameraButton" : _smallCameraButton,
      @"panTF" : _panTF,
      @"cvvTF" : _cvvTF,
      @"expireTF" : _expireTF,
      @"saveButton" : _saveButton,
      @"scanActionButton" : _scanActionView,
      @"scanFrame" : _scanFrame,
      @"scanLabel" : _scanLabel,
      };
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[bgIV]-(10)-[saveButton(cameraButtonSize)]-(4)-|" options:kNilOptions metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(cornerOffset)-[bgIV]-(cornerOffset)-|" options:kNilOptions metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[saveButton]|" options:kNilOptions metrics:metrics views:views]];
    
    [bgIV addConstraint:[NSLayoutConstraint constraintWithItem:_scanActionView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:bgIV attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    [_scanActionView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scanFrame]-(14)-[scanLabel]|" options:kNilOptions metrics:metrics views:views]];
    [_scanActionView addConstraint:[NSLayoutConstraint constraintWithItem:_scanFrame attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_scanActionView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
    [_scanActionView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scanLabel]|" options:kNilOptions metrics:metrics views:views]];
    
    [bgIV addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(cornerOffset)-[scanActionButton]" options:kNilOptions metrics:metrics views:views]];
    
    [bgIV addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[cameraButton(cameraButtonSize)]-4-|" options:kNilOptions metrics:metrics views:views]];
    
    [bgIV addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(textFieldsOffset)-[panTF]-(textFieldsOffset)-|" options:kNilOptions metrics:metrics views:views]];
    
    [bgIV addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(textFieldsOffset)-[expireTF(textFieldWidth)]-(textFieldsOffset)-[cvvTF(textFieldWidth)]" options:kNilOptions metrics:metrics views:views]];
    [bgIV addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-4-[cameraButton(cameraButtonSize)]" options:kNilOptions metrics:metrics views:views]];
    [bgIV addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[panTF(textFieldHeight)]-(8)-[expireTF(textFieldHeight)]-(cornerOffset)-|" options:kNilOptions metrics:metrics views:views]];

    [bgIV addConstraint:[NSLayoutConstraint constraintWithItem:_cvvTF attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_expireTF attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
    [bgIV addConstraint:[NSLayoutConstraint constraintWithItem:_cvvTF attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_expireTF attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.0f]];

    [self addKeyboardObservers];
    [self updateCameraButton];
    [self setSaveButtonHidden:YES];
    
  }
  return self;
}

- (void)addKeyboardObservers {
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
  
}

- (void)updateCameraButton {
  
  BOOL keyboardShown = (_panTF.editing ||
                        _cvvTF.editing ||
                        _expireTF.editing);
  
  [UIView animateWithDuration:0.3 animations:^{
    
    _scanActionView.alpha = (keyboardShown) ? (0.0f) : (1.0f);
    _smallCameraButton.alpha = (keyboardShown) ? (1.0f) : (0.0f);
    
  }];
  
}

- (void)keyboardWillShow:(NSNotification *)n {
  
  [self updateCameraButton];
  
}

- (void)keyboardDidHide:(NSNotification *)n {
  
  [self updateCameraButton];
  
}

- (void)cameraButtonDown {
  
  _scanFrame.highlighted = YES;
  _scanLabel.highlighted = YES;
  
}

- (void)cameraButtonUp {
  
  _scanFrame.highlighted = NO;
  _scanLabel.highlighted = NO;
  
}

- (void)cameraButtonTap {
  
  [self.delegate cardEnterControlDidRequestScan:self];
  
}

- (void)saveTap {
  
  _saveButton.selected = !_saveButton.selected;
  [self.delegate cardEnterControlSaveButtonStateDidChange:self];
  
}

- (BOOL)saveButtonSelected {
  
  return _saveButton.selected;
  
}

- (void)setSaveButtonSelected:(BOOL)saveButtonSelected {
  
  _saveButton.selected = saveButtonSelected;
  
}

- (void)setSaveButtonHidden:(BOOL)hidden {
  
  _saveButton.hidden = hidden;
  
}

- (void)showExpireTFWithText:(NSString *)text {
  
  if (0 == _expireTF.text.length) {
    
    _expireTF.text = text;
    
  }

  [_expireTF becomeFirstResponder];
  
}

- (void)setPan:(NSString *)pan {

  NSString *left = @"";
  const NSInteger kPurePanLength = 16;
  if (pan.length > kPurePanLength) {
    left = [pan substringFromIndex:kPurePanLength];
  }

  _panTF.text = [pan omn_panFormatedString];
  
  if (_panTF.text.length >= kDesiredPanLength) {
    [self checkPanTF:YES];
    [self showExpireTFWithText:left];
  }
  
}

- (void)showPANTF {
  
  if (0 == _cvvTF.text.length &&
      0 == _expireTF.text.length &&
      _panTF.text.length < kDesiredPanLength) {

    [_panTF becomeFirstResponder];
    
  }
  else {
    [_panTF becomeFirstResponder];
  }
  
}

- (void)didFinishEnterCardDetails:(BOOL)updateTextFields {
  
  if ([self checkPanTF:updateTextFields] &&
      [self checkExpireTF:updateTextFields] &&
      [self checkCVVTF:updateTextFields]) {
    
    NSString *pan = [self panString];
    
    NSArray *mmyyComponents = [_expireTF.text componentsSeparatedByString:kMM_YYSeporator];
    if (mmyyComponents.count != 2) {
      [self didEnterFailCardData];
      return;
    }
    NSString *mm = mmyyComponents[0];
    NSString *yy = mmyyComponents[1];
    
    NSString *cvv = _cvvTF.text;
    
    NSDictionary *cardData =
    @{
      OMNCardEnterControlPanString : pan,
      OMNCardEnterControlMonthString : mm,
      OMNCardEnterControlYearString : yy,
      OMNCardEnterControlCVVString : cvv,
      };
    
    [self.delegate cardEnterControl:self didEnterCardData:cardData];
    
  }
  else {
    
    [self didEnterFailCardData];
    
  }
  
}

- (void)didEnterFailCardData {
  if ([self.delegate respondsToSelector:@selector(cardEnterControlDidEnterFailCardData:)]) {
    [self.delegate cardEnterControlDidEnterFailCardData:self];
  }
}

- (NSString *)panString {
  return [_panTF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (BOOL)checkPanTF:(BOOL)updateTextField {
  
  NSString *pan = [self panString];
  BOOL isValidPan = [pan omn_isValidPan];
  if (updateTextField) {
    _panTF.error = (NO == isValidPan);
  }
  
  return isValidPan;
  
}

- (BOOL)checkExpireTF:(BOOL)updateTextField {
  
  NSString *expireDate = _expireTF.text;
  BOOL isValidDate = [expireDate omn_isValidDate];
  if (updateTextField) {
    _expireTF.error = (NO == isValidDate);
  }
  return isValidDate;
  
}

- (BOOL)checkCVVTF:(BOOL)updateTextField {
  
  BOOL isValidCVV = (_cvvTF.text.length == kCVVLength);
  if (updateTextField) {
    _cvvTF.error = (NO == isValidCVV);
  }
  
  return isValidCVV;
  
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
  
  NSString *finalString = [textField.text stringByReplacingCharactersInRange:range withString:string];
  
  if ([textField isEqual:_panTF]) {
    
    NSString *pan = [finalString omn_decimalString];
    UITextRange *selectedTextRange = [textField selectedTextRange];
    UITextRange *startPosition = [textField positionFromPosition:selectedTextRange.start offset:(string.length) ? (string.length) : (-1)];
    [self setPan:pan];
    if (startPosition) {
      [textField setSelectedTextRange:[textField textRangeFromPosition:startPosition toPosition:startPosition]];
    }
    
    [self didFinishEnterCardDetails:NO];
    return NO;
  }
  else if ([textField isEqual:_expireTF]) {
    
    NSArray *MM_YYComponents = [finalString componentsSeparatedByString:kMM_YYSeporator];
    
    NSString *mm = [MM_YYComponents firstObject];
    
    if (0 == mm.length &&
        [string isEqualToString:@""]) {
      textField.text = @"";
      [self showPANTF];
      return NO;
    }
    
    if (1 == MM_YYComponents.count) {
      
      if (mm.length < 2) {
        
        textField.text = mm;
        
      }
      else {
        
        NSString *yy = [mm substringFromIndex:2];
        mm = [mm substringToIndex:2];
        
        if (0 == yy.length &&
            [string isEqualToString:@""]) {
          textField.text = mm;
        }
        else {
          textField.text = [NSString stringWithFormat:@"%@%@%@", mm, kMM_YYSeporator, yy];
        }
        
      }
      
    }
    else {
      
      NSString *yy = MM_YYComponents[1];
      
      if (0 == yy.length &&
          [string isEqualToString:@""]) {
        
        textField.text = mm;
        
      }
      else if (yy.length < 2) {
        
        textField.text = [NSString stringWithFormat:@"%@%@%@", mm, kMM_YYSeporator, yy];
        
      }
      else {
        
        NSString *left = [yy substringFromIndex:2];
        yy = [yy substringToIndex:2];
        textField.text = [NSString stringWithFormat:@"%@%@%@", mm, kMM_YYSeporator, yy];

        if (left.length) {
          _cvvTF.text = left;
        }
        [_cvvTF becomeFirstResponder];
        
      }
      
    }
    
    [self didFinishEnterCardDetails:NO];
    return NO;
    
  }
  else if ([textField isEqual:_cvvTF]) {
    
    NSString *cvv = [finalString omn_decimalString];
    
    if (cvv.length > kCVVLength) {
      cvv = [cvv substringToIndex:kCVVLength];
    }
    
    textField.text = cvv;
    
    if (kCVVLength == cvv.length) {
      [self didFinishEnterCardDetails:YES];
    }
    else {
      if (0 == cvv.length) {
        [self showExpireTFWithText:@""];
      }
      [self didFinishEnterCardDetails:NO];
    }
    return NO;
  }
  
  return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
  
  OMNDeletedTextField *deletedTextField = textField;
  
  if ([deletedTextField isKindOfClass:[OMNDeletedTextField class]]) {
    deletedTextField.error = NO;
  }
  [textField setNeedsDisplay];
  
  [self didFinishEnterCardDetails:NO];
  
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
  
  if ([textField isEqual:_panTF]) {
    [self checkPanTF:YES];
  }
  else if ([textField isEqual:_expireTF]) {
    [self checkExpireTF:YES];
  }
  else if ([textField isEqual:_cvvTF]) {
    [self checkCVVTF:YES];
  }
  
}

@end
