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
  
  UIButton *_saveButton;

}

- (OMNDeletedTextField *)numberTextField {
  
  OMNDeletedTextField *numberTextField = [[OMNDeletedTextField alloc] init];
  numberTextField.font = [UIFont fontWithName:@"Futura-LSF-Omnom-LE-Regular" size:20.0f];
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

- (instancetype)init {
  
  self = [super init];
  if (self) {
    self.userInteractionEnabled = YES;
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.backgroundColor = [UIColor clearColor];
    
    UIImageView *bgIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"card_area"]];
    bgIV.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:bgIV];
    
    UIButton *cameraButton = [[UIButton alloc] init];
    cameraButton.translatesAutoresizingMaskIntoConstraints = NO;
    [cameraButton setImage:[UIImage imageNamed:@"camera_icon_white"] forState:UIControlStateNormal];
    [cameraButton addTarget:self action:@selector(cameraButtonTap) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cameraButton];
    
    _panTF = [self numberTextField];
    _panTF.attributedPlaceholder = [self attributedPlaceholderWithText:NSLocalizedString(@"Номер банковской карты", nil)];
    [self addSubview:_panTF];
    
    _expireTF = [self numberTextField];
    _expireTF.attributedPlaceholder = [self attributedPlaceholderWithText:[NSString stringWithFormat:@"MM%@YY", kMM_YYSeporator]];
    [self addSubview:_expireTF];
    
    _cvvTF = [self numberTextField];
    _cvvTF.attributedPlaceholder = [self attributedPlaceholderWithText:@"CVV"];
    [self addSubview:_cvvTF];
    
  
    _saveButton = [[UIButton alloc] init];
    [_saveButton addTarget:self action:@selector(saveTap) forControlEvents:UIControlEventTouchUpInside];
    _saveButton.translatesAutoresizingMaskIntoConstraints = NO;
    _saveButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _saveButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _saveButton.tintColor = [UIColor blackColor];
    _saveButton.titleEdgeInsets = UIEdgeInsetsMake(0.0f, 10.0f, 0.0f, 0.0f);
    _saveButton.titleLabel.numberOfLines = 0;
    _saveButton.titleLabel.font = [UIFont fontWithName:@"Futura-LSF-Omnom-LE-Regular" size:15.0f];
    _saveButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    _saveButton.titleLabel.minimumScaleFactor = 0.1f;
    [_saveButton setTitleColor:[UIColor colorWithWhite:120.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [_saveButton setTitle:NSLocalizedString(@"Сохранить данные для следующих платежей", nil) forState:UIControlStateNormal];
    [_saveButton setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
    [_saveButton setImage:[UIImage imageNamed:@"checkbox_galka"] forState:UIControlStateSelected];
    [_saveButton setImage:[UIImage imageNamed:@"checkbox_galka"] forState:UIControlStateSelected|UIControlStateHighlighted];
    _saveButton.selected = YES;
    [self addSubview:_saveButton];

    NSDictionary *views =
    @{
      @"bgIV" : bgIV,
      @"cameraButton" : cameraButton,
      @"panTF" : _panTF,
      @"cvvTF" : _cvvTF,
      @"expireTF" : _expireTF,
      @"saveButton" : _saveButton,
      };
    
    NSDictionary *metrics =
    [@{
       @"height" : @(40.0f),
       @"width" : @(80.0f),
       @"textFieldsOffset" : @(25.0f),
       @"cameraButtonSize" : @(44.0f),
       } mutableCopy];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[bgIV]-(10)-[saveButton(cameraButtonSize)]-(4)-|" options:kNilOptions metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[bgIV]|" options:kNilOptions metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[saveButton]|" options:kNilOptions metrics:metrics views:views]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[cameraButton(cameraButtonSize)]-4-|" options:kNilOptions metrics:metrics views:views]];
    
    NSArray *panH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(textFieldsOffset)-[panTF]-(textFieldsOffset)-|" options:kNilOptions metrics:metrics views:views];
    [self addConstraints:panH];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(textFieldsOffset)-[expireTF(width)]-(textFieldsOffset)-[cvvTF(width)]" options:kNilOptions metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-4-[cameraButton(cameraButtonSize)][panTF(height)]-(8)-[expireTF(height)]" options:kNilOptions metrics:metrics views:views]];

    [self addConstraint:[NSLayoutConstraint constraintWithItem:_cvvTF attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_expireTF attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_cvvTF attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_expireTF attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.0f]];

    [self setSaveButtonHidden:YES];
    
  }
  return self;
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

- (void)setSaveButtonHidden:(BOOL)hidden {
  
  _saveButton.hidden = hidden;
  
}

- (void)showExpireTF {
  
  if (_panTF.text.length < kDesiredPanLength) {
    return;
  }
  
  [_expireTF becomeFirstResponder];
  
}

- (void)setPan:(NSString *)pan {
  _panTF.text = [pan omn_panFormatedString];
  if (_panTF.text.length >= kDesiredPanLength) {
    [self checkPanTF:YES];
    [self showExpireTF];
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
    
    if (pan.length > kDesiredPanLength) {
      pan = [pan substringToIndex:kDesiredPanLength];
    }
    
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
        [self showExpireTF];
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
