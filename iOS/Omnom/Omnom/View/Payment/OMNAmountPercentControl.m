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
#import "OMNLabeledTextField.h"

const long long kMaxEnteredValue = 999999ll;

@interface OMNAmountPercentControl ()
<UIPickerViewDataSource,
UIPickerViewDelegate,
UITextFieldDelegate>

@end

@implementation OMNAmountPercentControl {
  
  OMNLabeledTextField *_amountTF;
  UITextField *_percentTF;
  
  UIPickerView *_percentPicker;
  UIView *_flexibleBottomView;
  
}

@synthesize amountPercentValue=_amountPercentValue;

- (instancetype)initWithCoder:(NSCoder *)coder {
  self = [super initWithCoder:coder];
  if (self) {
    [self setup];
  }
  return self;
}

- (OMNAmountPercentValue *)amountPercentValue {
  return _amountPercentValue;
}

- (void)setAmountPercentValue:(OMNAmountPercentValue *)amountPercentValue {
  
  _amountPercentValue = amountPercentValue;
  _amountTF.text = [[OMNUtils commaStringFromKop:_amountPercentValue.amount] omn_moneyFormattedStringWithMaxValue:kMaxEnteredValue];
  [self update];
  
}

- (void)update {
  
  _amountTF.adjustsFontSizeToFitWidth = YES;
  [self setPercentValue:_amountPercentValue.percent];
  
}

- (void)configureWithColor:(UIColor *)color antogonistColor:(UIColor *)antogonistColor {
  
  _amountTF.tintColor = antogonistColor;
  _percentTF.tintColor = antogonistColor;
  
}

- (BOOL)becomeFirstResponder {
  
  return [_amountTF becomeFirstResponder];
  
}

- (void)beginPercentEditing {
  
  _percentEditing = YES;
  [UIView animateWithDuration:0.3 animations:^{
    
    _percentTF.alpha = 1.0f;
    
  }];
  [_percentTF becomeFirstResponder];
  
}

- (BOOL)resignFirstResponder {
  
  _percentEditing = NO;
  BOOL result =
  [_amountTF resignFirstResponder] ||
  [_percentTF resignFirstResponder];
  [self sendActionsForControlEvents:UIControlEventEditingDidEnd];
  return result;
  
}

- (void)calculateRelativePercentValue {
  
  double percentValue = 0.0f;
  if (_amountPercentValue.totalAmount) {
    percentValue = 100.*(double)_amountPercentValue.amount/_amountPercentValue.totalAmount;
  }
  [self setPercentValue:percentValue];
  
}

- (void)setAmountValue:(long long)amount {
  
  _amountPercentValue.amount = amount;

}

- (void)setPureAmountValue:(long long)amount {
  
  _amountTF.text = [[OMNUtils commaStringFromKop:amount] omn_moneyFormattedStringWithMaxValue:kMaxEnteredValue];
  _amountPercentValue.amount = amount;
  
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
    [_amountTF invalidateIntrinsicContentSize];
    [self layoutIfNeeded];
    
  });
  
  [self sendActionsForControlEvents:UIControlEventValueChanged];
  
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
  
  [self sendActionsForControlEvents:UIControlEventValueChanged];
  
}

- (void)layoutSubviews {
  [super layoutSubviews];
  
  _amountTF.alpha = (_percentEditing) ? (0.0f) : (1.0f);
  _percentTF.alpha = (_percentEditing) ? (1.0f) : (0.0f);
  
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
  
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
  
  if ([textField isEqual:_amountTF]) {
    
    NSString *finalString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSString *moneyFormattedString = [finalString omn_moneyFormattedStringWithMaxValue:kMaxEnteredValue];
    long long amount = [finalString omn_MoneyAmount];
    [self setPureAmountValue:amount];
    
    textField.text = moneyFormattedString;
    
    return NO;
  }
  else if ([textField isEqual:_percentTF]) {
    return NO;
  }
  
  return YES;
}

- (void)setup {
  
  self.backgroundColor = [UIColor clearColor];
  
  _amountTF = [[OMNLabeledTextField alloc] init];
  _amountTF.keyboardType = UIKeyboardTypeDecimalPad;
  _amountTF.translatesAutoresizingMaskIntoConstraints = NO;
  _amountTF.minimumFontSize = 10.0f;
  _amountTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
  _amountTF.textColor = colorWithHexString(@"FFFFFF");
  _amountTF.font = FuturaLSFOmnomLERegular(50.0f);
  _amountTF.textAlignment = NSTextAlignmentCenter;
  _amountTF.delegate = self;
  [_amountTF setDetailedText:[NSString stringWithFormat:@" %@", kRubleSign]];
  [self addSubview:_amountTF];
  
  _percentPicker = [[UIPickerView alloc] init];
  _percentPicker.backgroundColor = [UIColor whiteColor];
  _percentPicker.delegate = self;
  _percentPicker.dataSource = self;
  
  _percentTF = [[UITextField alloc] init];
  _percentTF.textAlignment = NSTextAlignmentCenter;
  _percentTF.inputView = _percentPicker;
  _percentTF.adjustsFontSizeToFitWidth = YES;
  _percentTF.minimumFontSize = 10.0f;
  _percentTF.translatesAutoresizingMaskIntoConstraints = NO;
  _percentTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
  _percentTF.font = FuturaLSFOmnomLERegular(50.0f);
  _percentTF.textColor = [UIColor whiteColor];
  [self addSubview:_percentTF ];
  
  _flexibleBottomView = [[UIView alloc] init];
  _flexibleBottomView.translatesAutoresizingMaskIntoConstraints = NO;
  _flexibleBottomView.backgroundColor = colorWithHexString(@"FFFFFF");
  [self addSubview:_flexibleBottomView];
  
  NSDictionary *views =
  @{
    @"amountTF" : _amountTF,
    @"percentTF" : _percentTF,
    @"flexibleBottomView" : _flexibleBottomView,
    };
  
  NSDictionary *metrics =
  @{
    @"seporatorViewHeight" : @(11.0f),
    };
  
  [self addConstraint:[NSLayoutConstraint constraintWithItem:_amountTF attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  [self addConstraint:[NSLayoutConstraint constraintWithItem:_amountTF attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0.0f]];
  
  [self addConstraint:[NSLayoutConstraint constraintWithItem:_flexibleBottomView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_amountTF attribute:NSLayoutAttributeWidth multiplier:1.0f constant:10.0f]];
  [self addConstraint:[NSLayoutConstraint constraintWithItem:_flexibleBottomView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  [self addConstraint:[NSLayoutConstraint constraintWithItem:_flexibleBottomView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0f constant:180.0f]];
  
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[percentTF]-3-|" options:0 metrics:metrics views:views]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[amountTF]-2-[flexibleBottomView(1)]|" options:0 metrics:metrics views:views]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[percentTF]|" options:0 metrics:metrics views:views]];
  
}

@end
