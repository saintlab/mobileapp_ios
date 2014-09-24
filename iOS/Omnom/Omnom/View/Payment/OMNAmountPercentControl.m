//
//  GAmountPercentControl.m
//  seocialtest
//
//  Created by tea on 20.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNAmountPercentControl.h"
#import <UIControl+BlocksKit.h>
#import "UIView+frame.h"
#import "OMNConstants.h"
#import <OMNStyler.h>
#import "OMNUtils.h"
#import "OMNDotTextField.h"

const long long kMaxEnteredValue = 99999999L;

@interface OMNAmountPercentControl ()
<UIPickerViewDataSource,
UIPickerViewDelegate,
UITextFieldDelegate>

@end

@implementation OMNAmountPercentControl {
  
  UITextField *_pureAmountTF;
  
  UITextField *_amountTF;
  UITextField *_percentTF;
  
  UIPickerView *_percentPicker;
  BOOL _isFirstResponder;
  UIView *_seporatorView;
  UIView *_flexibleBottomView;
  UIView *_bottomView;
  
}

@synthesize amountPercentValue=_amountPercentValue;

- (instancetype)initWithCoder:(NSCoder *)coder {
  self = [super initWithCoder:coder];
  if (self) {
    [self setup];
  }
  return self;
}

- (void)setup {
  
  self.backgroundColor = [UIColor clearColor];
  
  _pureAmountTF = [[UITextField alloc] init];
  _pureAmountTF.translatesAutoresizingMaskIntoConstraints = NO;
  _pureAmountTF.adjustsFontSizeToFitWidth = YES;
  _pureAmountTF.minimumFontSize = 10.0f;
  _pureAmountTF.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
  _pureAmountTF.textColor = colorWithHexString(@"FFFFFF");
  _pureAmountTF.font = FuturaLSFOmnomLERegular(50.0f);
  _pureAmountTF.textAlignment = NSTextAlignmentCenter;
  _pureAmountTF.delegate = self;
  [self addSubview:_pureAmountTF];
  
  _amountTF = [[OMNDotTextField alloc] init];
  _amountTF.tintColor = colorWithHexString(@"157EFB");
  _amountTF.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
  _amountTF.translatesAutoresizingMaskIntoConstraints = NO;
  _amountTF.adjustsFontSizeToFitWidth = YES;
  _amountTF.minimumFontSize = 10.0f;
  _amountTF.textColor = colorWithHexString(@"FFFFFF");
  _amountTF.delegate = self;
  _amountTF.font = FuturaLSFOmnomLERegular(30.0f);
  _amountTF.textAlignment = NSTextAlignmentRight;
  [_amountTF bk_addEventHandler:^(UITextField *sender) {
    
    [self calculateRelativePercentValue];
    
  } forControlEvents:UIControlEventEditingChanged];
  [self addSubview:_amountTF];
  
  _percentPicker = [[UIPickerView alloc] init];
  _percentPicker.backgroundColor = [UIColor whiteColor];
  _percentPicker.delegate = self;
  _percentPicker.dataSource = self;
  
  _percentTF = [[UITextField alloc] init];
  _percentTF.tintColor = colorWithHexString(@"157EFB");
  _percentTF.textAlignment = NSTextAlignmentCenter;
  _percentTF.inputView = _percentPicker;
  _percentTF.adjustsFontSizeToFitWidth = YES;
  _percentTF.minimumFontSize = 10.0f;
  _percentTF.translatesAutoresizingMaskIntoConstraints = NO;
  _percentTF.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
  _percentTF.font = FuturaLSFOmnomLERegular(30.0f);
  _percentTF.textColor = [UIColor whiteColor];
  [_percentTF bk_addEventHandler:^(UITextField *sender) {
    
    [self calculateRelativeAmountValue];
    
  } forControlEvents:UIControlEventEditingChanged];
  [self addSubview:_percentTF ];
  
  _bottomView = [[UIView alloc] init];
  _bottomView.translatesAutoresizingMaskIntoConstraints = NO;
  _bottomView.backgroundColor = colorWithHexString(@"979797");
  [self addSubview:_bottomView];
  
  _flexibleBottomView = [[UIView alloc] init];
  _flexibleBottomView.translatesAutoresizingMaskIntoConstraints = NO;
  _flexibleBottomView.backgroundColor = colorWithHexString(@"979797");
  [self addSubview:_flexibleBottomView];
  
  _seporatorView = [[UIView alloc] init];
  _seporatorView.translatesAutoresizingMaskIntoConstraints = NO;
  _seporatorView.backgroundColor = colorWithHexString(@"979797");
  [self addSubview:_seporatorView];
  
  NSDictionary *views =
  @{
    @"amountTF" : _amountTF,
    @"pureAmountTF" : _pureAmountTF,
    @"percentTF" : _percentTF,
    @"bottomView" : _bottomView,
    @"flexibleBottomView" : _flexibleBottomView,
    @"seporatorView" : _seporatorView,
    };
  
  NSDictionary *metrics =
  @{
    @"seporatorViewHeight" : @(11.0f),
    };
  
  [self addConstraint:[NSLayoutConstraint constraintWithItem:_pureAmountTF attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  [self addConstraint:[NSLayoutConstraint constraintWithItem:_pureAmountTF attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0f constant:-20.0f]];
  [self addConstraint:[NSLayoutConstraint constraintWithItem:_flexibleBottomView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  [self addConstraint:[NSLayoutConstraint constraintWithItem:_flexibleBottomView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_pureAmountTF attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0.0f]];
  [self addConstraint:[NSLayoutConstraint constraintWithItem:_flexibleBottomView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0f constant:180.0f]];
  
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[pureAmountTF]|" options:0 metrics:metrics views:views]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[amountTF]|" options:0 metrics:metrics views:views]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[percentTF]|" options:0 metrics:metrics views:views]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[seporatorView(seporatorViewHeight)]|" options:0 metrics:metrics views:views]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[flexibleBottomView(1)]|" options:0 metrics:metrics views:views]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[bottomView(1)]|" options:0 metrics:metrics views:views]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[bottomView]|" options:0 metrics:metrics views:views]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[amountTF]-[seporatorView(1)]-[percentTF]|" options:0 metrics:metrics views:views]];
  [self addConstraint:[NSLayoutConstraint constraintWithItem:_amountTF attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0.655f constant:0.0f]];
  
  [self omn_setIsFirstResponder:NO];
  
}

- (OMNAmountPercentValue *)amountPercentValue {
  return _amountPercentValue;
}

- (void)setAmountPercentValue:(OMNAmountPercentValue *)amountPercentValue {
  _amountPercentValue = amountPercentValue;
  [self update];
}

- (void)update {
  if (_amountPercentValue.isAmountSelected) {
    [self setAmountValue:_amountPercentValue.amount];
    [self calculateRelativePercentValue];
  }
  else {
    [self setPercentValue:_amountPercentValue.percent];
    [self calculateRelativeAmountValue];
  }
}

- (BOOL)isAmountSelected {
  return _amountTF.isFirstResponder;
}

- (BOOL)isFirstResponder {
  return _isFirstResponder;
  
}

- (void)omn_setIsFirstResponder:(BOOL)isFirstResponder {
  
  _isFirstResponder = isFirstResponder;
  
}

- (BOOL)becomeFirstResponder {
  
  [self omn_setIsFirstResponder:YES];
  BOOL result = [_amountTF becomeFirstResponder];
  return result;
  
}

- (BOOL)resignFirstResponder {
  
  [self omn_setIsFirstResponder:NO];
  BOOL result = [_amountTF resignFirstResponder] || [_percentTF resignFirstResponder];
  [self sendActionsForControlEvents:UIControlEventEditingDidEnd];
  return result;
  
}

- (void)calculateRelativeAmountValue {
  
  long long amount = _amountPercentValue.totalAmount * _amountPercentValue.percent / 100.;
  [self setAmountValue:amount];
  
}

- (void)calculateRelativePercentValue {
  
  double percentValue = 0.0f;
  if (_amountPercentValue.totalAmount) {
    percentValue = 100.*(double)_amountPercentValue.amount/_amountPercentValue.totalAmount;
  }
  [self setPercentValue:percentValue];
  
}

- (void)setAmountValue:(long long)amount {
  
  _amountTF.text = [OMNUtils moneyStringFromKop:amount];
  [self updateCaratPosition];
  _pureAmountTF.text = [OMNUtils formattedMoneyStringFromKop:amount];
  _amountPercentValue.amount = amount;
  
}

- (void)setPercentValue:(double)percentValue {
  _percentTF.text = [NSString stringWithFormat:@"%.0f%%", percentValue];
  _amountPercentValue.percent = percentValue = MAX(0.0, percentValue);
  
  if (_amountPercentValue.percent < [_percentPicker numberOfRowsInComponent:0]) {
    
    [_percentPicker selectRow:(NSInteger)round(_amountPercentValue.percent) inComponent:0 animated:NO];
    
  }
  else {
    
    [_percentPicker selectRow:0 inComponent:0 animated:NO];
    
  }
  
}

- (long long)selectedAmount {
  NSString *pureAmount = [self pureAmountString:_amountTF.text];
  long long amount = 100ll*[pureAmount omn_doubleValue];
  return amount;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  if (self.isFirstResponder) {
    _seporatorView.alpha = 1.0f;
    _amountTF.alpha = 1.0f;
    _percentTF.alpha = 1.0f;
    _pureAmountTF.alpha = 0.0f;
    _bottomView.alpha = 1.0f;
    [self updateCaratPosition];
  }
  else {
    _seporatorView.alpha = 0.0f;
    _amountTF.alpha = 0.0f;
    _percentTF.alpha = 0.0f;
    _pureAmountTF.alpha = 1.0f;
    _bottomView.alpha = 0.0f;
  }
  
}

#pragma mark - UIPickerView

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
  
  return [NSString stringWithFormat:@"%ld%%", (long)row];
  
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
  return 201;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
  return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
  
  [self setPercentValue:(double)row];
  [_percentTF sendActionsForControlEvents:UIControlEventEditingChanged];
  
}

#pragma mark - UITextFieldDelegate

- (NSString *)pureAmountString:(NSString *)string {
  NSCharacterSet *charactersSet = [[NSCharacterSet characterSetWithCharactersInString:[NSString stringWithFormat:@"0123456789%@", omnCommaString()]] invertedSet];
  NSString *finalString = [[string componentsSeparatedByCharactersInSet:charactersSet] componentsJoinedByString:@""];
  return finalString;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
  
  if ([textField isEqual:_amountTF]) {
    
    if ([string isEqualToString:omnCommaString()]) {
      
      if (NSNotFound == [textField.text rangeOfString:omnCommaString()].location) {
        NSString *finalString = [textField.text stringByReplacingCharactersInRange:range withString:omnCommaString()];
        textField.text = finalString;
        [self updateCaratPosition];
      }
      
      return NO;
    }
    
    NSString *finalString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    finalString = [self pureAmountString:finalString];
    
    if (NSNotFound != [finalString rangeOfString:omnCommaString()].location) {
      NSString *fractionalString = @"";
      NSArray *components = [finalString componentsSeparatedByString:omnCommaString()];
      if (2 == components.count) {
        
        fractionalString = components[1];
        if (fractionalString.length > 2) {
          fractionalString = [fractionalString substringToIndex:2];
        }
        
      }
      
      finalString = [@[components[0], fractionalString] componentsJoinedByString:omnCommaString()];
    }
    long long value = round(100.0*[finalString omn_doubleValue]);
    value = MIN(value, kMaxEnteredValue);
    [self setAmountValue:value];
    [self calculateRelativePercentValue];
    return NO;
  }
  else if ([textField isEqual:_percentTF]) {
    return NO;
  }
  
  return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
  
  if ([textField isEqual:_pureAmountTF]) {
    [self omn_setIsFirstResponder:YES];
    _amountTF.alpha = 0.2;
    [_amountTF becomeFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
      [self setNeedsLayout];
    }];
    [self sendActionsForControlEvents:UIControlEventEditingDidBegin];
    return NO;
  }
  return YES;
}

- (void)updateCaratPosition {
  
  if (_amountTF.text.length >= 2) {
    [self setSelectionRange:NSMakeRange(_amountTF.text.length - 2, 0)];
  }
  
}

- (void)setSelectionRange:(NSRange) range {
  UITextPosition *start = [_amountTF positionFromPosition:[_amountTF beginningOfDocument]
                                                   offset:range.location];
  
  UITextPosition *end = [_amountTF positionFromPosition:start
                                                 offset:range.length];
  
  [_amountTF setSelectedTextRange:[_amountTF textRangeFromPosition:start toPosition:end]];
}

@end
