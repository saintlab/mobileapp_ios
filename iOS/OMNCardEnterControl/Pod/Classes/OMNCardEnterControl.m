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

NSTimeInterval kSlideAnimationDuratiom = 0.5;
NSInteger kDesiredPanLength = 19;
NSInteger kCVVLength = 3;
CGFloat kTextFieldsOffset = 20.0f;

@interface OMNCardEnterControl ()
<UITextFieldDelegate>

@end

@implementation OMNCardEnterControl {
  
  OMNDeletedTextField *_panTF;
  OMNDeletedTextField *_expireTF;
  OMNDeletedTextField *_cvvTF;
  UIButton *_saveButton;
  
  CGSize _panSize;
  CGFloat _expireWidth;
  
  NSDictionary *_views;
  NSMutableDictionary *_metrics;
  
  NSMutableArray *_dynamycConstraints;
  
  BOOL _expireCCVTFHidden;
}

- (instancetype)init {
  
  self = [super initWithFrame:(CGRect){CGPointZero, _panSize}];
  if (self) {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.backgroundColor = [UIColor clearColor];
    
    _dynamycConstraints = [NSMutableArray array];
    
    UIButton *cameraButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 44.0f, 44.0f)];
    [cameraButton setImage:[UIImage imageNamed:@"camera_icon"] forState:UIControlStateNormal];
    [cameraButton addTarget:self action:@selector(cameraButtonTap) forControlEvents:UIControlEventTouchUpInside];
    
    _panTF = [[OMNDeletedTextField alloc] init];
    _panTF.rightViewMode = UITextFieldViewModeAlways;
    _panTF.rightView = cameraButton;
    _panTF.translatesAutoresizingMaskIntoConstraints = NO;
    _panTF.placeholder = NSLocalizedString(@"Номер банковской карты", nil);
    _panTF.keyboardType = UIKeyboardTypeNumberPad;
    _panTF.delegate = self;
    [self addSubview:_panTF];
    
    _expireTF = [[OMNDeletedTextField alloc] init];
    _expireTF.textAlignment = NSTextAlignmentLeft;
    _expireTF.translatesAutoresizingMaskIntoConstraints = NO;
    _expireTF.keyboardType = UIKeyboardTypeNumberPad;
    _expireTF.delegate = self;
    _expireTF.placeholder = [NSString stringWithFormat:@"MM%@YY", kMM_YYSeporator];
    [self addSubview:_expireTF];
    
    _cvvTF = [[OMNDeletedTextField alloc] init];
    _cvvTF.textAlignment = NSTextAlignmentLeft;
    _cvvTF.translatesAutoresizingMaskIntoConstraints = NO;
    _cvvTF.keyboardType = UIKeyboardTypeNumberPad;
    _cvvTF.delegate = self;
    _cvvTF.placeholder = @"CVV";
    [self addSubview:_cvvTF];
    
    _saveButton = [[UIButton alloc] init];
    [_saveButton addTarget:self action:@selector(saveTap) forControlEvents:UIControlEventTouchUpInside];
    _saveButton.translatesAutoresizingMaskIntoConstraints = NO;
    _saveButton.titleEdgeInsets = UIEdgeInsetsMake(0.0f, 10.0f, 0.0f, 0.0f);
    _saveButton.titleLabel.numberOfLines = 0;
    _saveButton.titleLabel.font = [UIFont fontWithName:@"Futura-OSF-Omnom-Regular" size:15.0f];
    _saveButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    _saveButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _saveButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _saveButton.tintColor = [UIColor blackColor];
    [_saveButton setImage:[UIImage imageNamed:@"not_selected_check_box_icon"] forState:UIControlStateNormal];
    [_saveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_saveButton setImage:[UIImage imageNamed:@"selected_check_box_icon"] forState:UIControlStateSelected];
    [_saveButton setImage:[UIImage imageNamed:@"selected_check_box_icon"] forState:UIControlStateSelected|UIControlStateHighlighted];
    _saveButton.titleLabel.minimumScaleFactor = 0.1f;
    [_saveButton setTitle:NSLocalizedString(@"Сохранить данные для следующих платежей", nil) forState:UIControlStateNormal];
    [self addSubview:_saveButton];
    
    self.clipsToBounds = YES;
    
    _views =
    @{
      @"panTF" : _panTF,
      @"cvvTF" : _cvvTF,
      @"expireTF" : _expireTF,
      @"saveButton" : _saveButton,
      };
    
    _metrics =
    [@{
       @"saveButtonHeight" : @(50.0f),
       @"height" : @(50.0f),
       @"width" : @(100.0f),
       @"offset" : @(28.0f),
       } mutableCopy];
    
    NSArray *panH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[panTF]|" options:0 metrics:nil views:_views];
    [self addConstraints:panH];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[saveButton]|" options:0 metrics:nil views:_views]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[expireTF(width)]-(offset)-[cvvTF(width)]" options:0 metrics:_metrics views:_views]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[panTF(height)]" options:0 metrics:_metrics views:_views]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_cvvTF attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_expireTF attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    NSArray *equalVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[cvvTF(==expireTF)]" options:0 metrics:nil views:_views];
    [self addConstraints:equalVConstraints];
    [self setExpireCCVTFHidden:YES animated:NO completion:nil];
    
  }
  return self;
}

- (void)cameraButtonTap {
  [self.delegate cardEnterControlDidRequestScan:self];
}

- (void)saveTap {
  _saveButton.selected = !_saveButton.selected;
}

- (BOOL)saveButtonSelected {
  return _saveButton.selected;
}

- (void)setSaveButtonHidden:(BOOL)hidden {
  _metrics[@"saveButtonHeight"] = (hidden) ? (@(0.0f)) : (@(50.0f));
  _saveButton.hidden = hidden;
  [self updateConstraintsAnimated:NO completion:nil];
}

- (void)setExpireCCVTFHidden:(BOOL)hidden animated:(BOOL)animated completion:(dispatch_block_t)completion {
  _metrics[@"expireTFHeight"] = (hidden) ? (@(0.0f)) : (@(50.0f));
  [self updateConstraintsAnimated:animated completion:completion];
  _expireCCVTFHidden = hidden;
}

- (void)updateConstraintsAnimated:(BOOL)animated completion:(dispatch_block_t)completion {
  NSMutableArray *dynamycConstraints = [NSMutableArray array];
  NSArray *constraintsV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[panTF(height)]-[expireTF(expireTFHeight)]-[saveButton(saveButtonHeight)]|" options:0 metrics:_metrics views:_views];
  [dynamycConstraints addObjectsFromArray:constraintsV];
  
  [self removeConstraints:_dynamycConstraints];
  _dynamycConstraints = dynamycConstraints;
  [self addConstraints:_dynamycConstraints];
  
  if (animated) {
    
    [UIView animateWithDuration:0.3f animations:^{
      [self layoutIfNeeded];
    } completion:^(BOOL finished) {
      
      if (completion) {
        completion();
      }
      
    }];
    
  }
  else {
    [self layoutIfNeeded];
    if (completion) {
      completion();
    }
  }
}

- (void)showExpireTF {
  
  if (_panTF.text.length < kDesiredPanLength) {
    return;
  }
  
  if (_expireCCVTFHidden) {
    
    [self setExpireCCVTFHidden:NO animated:YES completion:^{

      [_cvvTF setNeedsDisplay];
      [_expireTF becomeFirstResponder];
      
    }];
    
  }
  else {
    [_expireTF becomeFirstResponder];
  }
  
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
      0 == _expireTF.text.length) {
    
    [self setExpireCCVTFHidden:YES animated:YES completion:^{
      [_panTF becomeFirstResponder];
    }];
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
