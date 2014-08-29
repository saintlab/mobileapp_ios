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
#import <OMNStyler.h>

@interface OMNAmountPercentControl ()
<UIPickerViewDataSource,
UIPickerViewDelegate,
UITextFieldDelegate>

@end

@implementation OMNAmountPercentControl {
  
  TSCurrencyTextField *_pureAmountTF;
  
  TSCurrencyTextField *_amountTF;
  TSCurrencyTextField *_percentTF;
  
  UIPickerView *_percentPicker;
  BOOL _isFirstResponder;
  UIView *_seporatorView;
  UIView *_flexibleBottomView;
  UIView *_bottomView;
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
  currencyTextField.translatesAutoresizingMaskIntoConstraints = NO;
  currencyTextField.clipsToBounds = NO;
  currencyTextField.currencyNumberFormatter.maximumFractionDigits = 0;
  currencyTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
  currencyTextField.font = [UIFont fontWithName:@"Futura-LSF-Omnom-Regular" size:40.0f];
  currencyTextField.textColor = [UIColor whiteColor];
  currencyTextField.adjustsFontSizeToFitWidth = YES;
  currencyTextField.minimumFontSize = 10.0f;
  currencyTextField.textAlignment = NSTextAlignmentLeft;
  currencyTextField.amount = @(0);
  [self addSubview:currencyTextField];
  return currencyTextField;
}

- (void)setup {
  
  self.backgroundColor = [UIColor clearColor];
  
  _percentTF = [self createCurrencyTextField];
  _percentTF.currencyNumberFormatter.currencySymbol = @"%";
  _percentTF.textAlignment = NSTextAlignmentRight;
  
  _pureAmountTF = [self createCurrencyTextField];
  _pureAmountTF.currencyNumberFormatter.minimumFractionDigits = 2;
  _pureAmountTF.currencyNumberFormatter.maximumFractionDigits = 2;
  _pureAmountTF.adjustsFontSizeToFitWidth = YES;
  _pureAmountTF.textAlignment = NSTextAlignmentCenter;
  _pureAmountTF.delegate = self;
  _pureAmountTF.currencyNumberFormatter.positiveSuffix = @"Р";
  _pureAmountTF.currencyNumberFormatter.currencyGroupingSeparator = @" ";
  
  _amountTF = [self createCurrencyTextField];
  _amountTF.textAlignment = NSTextAlignmentRight;
  _amountTF.currencyNumberFormatter.positiveSuffix = @"Р";
  _amountTF.currencyNumberFormatter.currencyGroupingSeparator = @" ";
  _amountTF.keyboardType = UIKeyboardTypeNumberPad;
  
  _percentPicker = [[UIPickerView alloc] init];
  _percentPicker.delegate = self;
  _percentPicker.dataSource = self;
  _percentTF.inputView = _percentPicker;
  

  [_amountTF bk_addEventHandler:^(TSCurrencyTextField *sender) {
    
    [self updatePercentValue];
    
  } forControlEvents:UIControlEventEditingChanged];
 
  [_percentTF bk_addEventHandler:^(TSCurrencyTextField *sender) {
    
    [self updateAmountValue];
    
  } forControlEvents:UIControlEventEditingChanged];
  
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
  [self addConstraint:[NSLayoutConstraint constraintWithItem:_amountTF attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0.57f constant:0.0f]];
  
  [self omn_setIsFirstResponder:NO];
  
}

- (double)expectedAmount {
  
  return [self.delegate expectedValueForAmountPercentControl:self];
  
}

- (void)updatePercentValue {
  
  double percentValue = (self.expectedAmount > 0) ? (100 * 100 * [_amountTF.amount doubleValue] / self.expectedAmount) : (0.);
  
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

- (void)omn_setIsFirstResponder:(BOOL)isFirstResponder {
  
  _isFirstResponder = isFirstResponder;
//  [self layoutIfNeeded];
}

- (BOOL)becomeFirstResponder {
  [self omn_setIsFirstResponder:YES];
  BOOL result = [_amountTF becomeFirstResponder];
  
  [self updateAmountValue];
  [self updatePercentValue];
  
  return result;
  
}

- (BOOL)resignFirstResponder {
  
  [self omn_setIsFirstResponder:NO];
  BOOL result = [_amountTF resignFirstResponder] || [_percentTF resignFirstResponder];
  return result;
  
}

- (void)reset {
  
  long long amount = [self.delegate enteredValueForAmountPercentControl:self];
  _amountTF.amount = @(amount/100);
  _pureAmountTF.amount = @(amount/100);
  [self updatePercentValue];
  
}

- (void)updateAmountValue {
  
  _amountTF.amount = @(self.expectedAmount * _percentTF.amount.doubleValue / 100. / 100.);
  _pureAmountTF.amount = @(self.expectedAmount * _percentTF.amount.doubleValue / 100. / 100.);
  
}

- (void)setCurrentAmount:(long long)currentAmount {
  _currentAmount = currentAmount;
  
  _amountTF.amount = @(_currentAmount/100);
  _pureAmountTF.amount = @(_currentAmount/100);
  [self updatePercentValue];
  
}

- (long long)selectedAmount {
  
  return [_amountTF.amount longLongValue]*100;
  
}

- (long long)selectedPercent {
  
  return [_percentTF.amount longLongValue]*100;
  
}

- (void)layoutSubviews {
  [super layoutSubviews];
  
  if (self.isFirstResponder) {
    _seporatorView.alpha = 1.0f;
    _amountTF.alpha = 1.0f;
    _percentTF.alpha = 1.0f;
    _pureAmountTF.alpha = 0.0f;
    _bottomView.alpha = 1.0f;
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

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
  [self omn_setIsFirstResponder:YES];
  _amountTF.alpha = 0.2;
  [_amountTF becomeFirstResponder];
  [UIView animateWithDuration:0.3 animations:^{
    [self setNeedsLayout];
  }];
  
  return NO;
}

@end
