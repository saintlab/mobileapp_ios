//
//  GAmountPercentControl.m
//  seocialtest
//
//  Created by tea on 20.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNAmountPercentControl.h"
#import <TSCurrencyTextField.h>
#import <UIControl+BlocksKit.h>
#import "UIView+frame.h"
#import "OMNConstants.h"

@interface OMNAmountPercentControl ()
<UIPickerViewDataSource,
UIPickerViewDelegate,
UITextFieldDelegate>

@end

@implementation OMNAmountPercentControl {
  TSCurrencyTextField *_amountTF;
  TSCurrencyTextField *_percentTF;
  UIImageView *_chequeBottomBg;
  
  UIPickerView *_percentPicker;
  BOOL _isFirstResponder;
}

@dynamic selectedPercent;
@dynamic selectedAmount;

- (instancetype)initWithCoder:(NSCoder *)coder {
  self = [super initWithCoder:coder];
  if (self) {
    [self setup];
  }
  return self;
}

- (TSCurrencyTextField *)createCurrencyTextField {
  TSCurrencyTextField *currencyTextField = [[TSCurrencyTextField alloc] init];
  currencyTextField.currencyNumberFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"ru"];
  currencyTextField.currencyNumberFormatter.maximumFractionDigits = 0;
  currencyTextField.font = ALSRublFont(25);
  currencyTextField.textColor = [UIColor whiteColor];
  currencyTextField.adjustsFontSizeToFitWidth = YES;
  currencyTextField.textAlignment = NSTextAlignmentLeft;
  currencyTextField.delegate = self;
  currencyTextField.amount = @(0);
  [self addSubview:currencyTextField];
  return currencyTextField;
}

- (void)setup {
  
  self.clipsToBounds = YES;
  self.backgroundColor = [UIColor clearColor];
  
  _percentTF = [self createCurrencyTextField];
  _percentTF.currencyNumberFormatter.currencySymbol = @"%";
  _percentTF.textAlignment = NSTextAlignmentCenter;
  
  _amountTF = [self createCurrencyTextField];
  _amountTF.textAlignment = NSTextAlignmentRight;
  _amountTF.currencyNumberFormatter.positiveSuffix = @"i";
  _amountTF.currencyNumberFormatter.currencySymbol = @"i";
  _amountTF.currencyNumberFormatter.currencyGroupingSeparator = @" ";
  
  _percentPicker = [[UIPickerView alloc] init];
  _percentPicker.delegate = self;
  _percentPicker.dataSource = self;
  _percentTF.inputView = _percentPicker;
  
  _amountTF.keyboardType = UIKeyboardTypeNumberPad;

  [_amountTF bk_addEventHandler:^(TSCurrencyTextField *sender) {
    
    [self updatePercentValue];
    
  } forControlEvents:UIControlEventEditingChanged];
 
  [_percentTF bk_addEventHandler:^(TSCurrencyTextField *sender) {
    
    [self updateAmountValue];
    
  } forControlEvents:UIControlEventEditingChanged];
  
  _chequeBottomBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"enter_price_bg"]];
  _chequeBottomBg.bottom = self.height;
  _chequeBottomBg.left = 60.0f;
  [self addSubview:_chequeBottomBg];
  
}

- (double)expectedAmount {
  
  return [self.delegate expectedValueForAmountPercentControl:self];
  
}

- (void)updatePercentValue {
  
  double percentValue = (self.expectedAmount > 0) ? (100 * [_amountTF.amount doubleValue] / self.expectedAmount) : (0.);
  
  if (percentValue < [_percentPicker numberOfRowsInComponent:0]) {
    
    [_percentPicker selectRow:(NSInteger)percentValue inComponent:0 animated:NO];
    
  }
  else {
    
    [_percentPicker selectRow:[_percentPicker numberOfRowsInComponent:0] - 1 inComponent:0 animated:NO];
    
  }
  
  _percentTF.amount = @(percentValue);
  
}

- (BOOL)isFirstResponder {
  return _isFirstResponder;
  
}

- (BOOL)becomeFirstResponder {
  _isFirstResponder = YES;
  BOOL result = [_amountTF becomeFirstResponder];
  
  [self updateAmountValue];
  [self updatePercentValue];
  
  return result;
  
}

- (BOOL)resignFirstResponder {
  _isFirstResponder = NO;
  BOOL result = [_amountTF resignFirstResponder] || [_percentTF resignFirstResponder];
  return result;
  
}

- (void)reset {
  
  _amountTF.amount = @([self.delegate enteredValueForAmountPercentControl:self]);
  [self updatePercentValue];
  
}

- (void)updateAmountValue {
  
  _amountTF.amount = @(self.expectedAmount * _percentTF.amount.doubleValue / 100.);
  
}

- (void)setCurrentAmount:(double)currentAmount {
  _currentAmount = currentAmount;
  
  _amountTF.amount = @(_currentAmount);
  [self updatePercentValue];
  
}

- (double)selectedAmount {
  
  return [_amountTF.amount doubleValue];
  
}

- (double)selectedPercent {
  
  return [_percentTF.amount doubleValue];
  
}

- (void)layoutSubviews {
  [super layoutSubviews];
  
  if (self.isFirstResponder) {

    CGRect frame = self.bounds;
    frame.origin.x = 10.0f;
    frame.size.width = 160.0f;
    _amountTF.frame = frame;
    
    frame.origin.x = 180.0f;
    frame.size.width = 100.0f;
    _percentTF.frame = frame;
    _percentTF.alpha = 1.0f;
    _chequeBottomBg.alpha = 1.0f;
  }
  else {
    
    CGRect frame = self.bounds;
    frame.origin.x = 80.0f;
    frame.size.width = 160.0f;
    _amountTF.frame = frame;

    frame.origin.x = self.width;
    _percentTF.frame = frame;
    _percentTF.alpha = 0.0f;
    _chequeBottomBg.alpha = 0.0f;
  }
  
  
}

#pragma mark - UIPickerView

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
  
  return [NSString stringWithFormat:@"%ld", (long)row];
  
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
  return 101;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
  return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
  
  double percentValue = row;
  _percentTF.amount = @(percentValue);
  [_percentTF sendActionsForControlEvents:UIControlEventEditingChanged];

}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
  _isFirstResponder = YES;
}

@end
