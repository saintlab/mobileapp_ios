//
//  GAmountPercentControl.m
//  seocialtest
//
//  Created by tea on 20.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNEditAmountControl.h"
#import <UIControl+BlocksKit.h>
#import "UIView+frame.h"
#import "OMNConstants.h"
#import <OMNStyler.h>
#import "OMNUtils.h"
#import "OMNDotTextField.h"
#import "OMNLabeledTextField.h"

const long long kMaxEnteredValue = 999999ll;

@interface OMNEditAmountControl ()
<UITextFieldDelegate>

@end

@implementation OMNEditAmountControl {
  
  OMNLabeledTextField *_amountTF;
  UIView *_flexibleBottomView;
  
}

- (instancetype)initWithCoder:(NSCoder *)coder {
  self = [super initWithCoder:coder];
  if (self) {
    [self setup];
  }
  return self;
}

- (void)configureWithColor:(UIColor *)color antogonistColor:(UIColor *)antogonistColor {
  
  _amountTF.tintColor = antogonistColor;
  
}

- (BOOL)becomeFirstResponder {
  
  return [_amountTF becomeFirstResponder];
  
}

- (BOOL)resignFirstResponder {
  
  [super resignFirstResponder];
  BOOL result = [_amountTF resignFirstResponder];
  [self sendActionsForControlEvents:UIControlEventEditingDidEnd];
  return result;
  
}

- (void)setAmount:(long long)amount {
  
  _amount = amount;
  [self updateTextField];
  
}

- (void)updateTextField {
  
  _amountTF.text = [[OMNUtils commaStringFromKop:self.amount] omn_moneyFormattedStringWithMaxValue:kMaxEnteredValue];
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
    [_amountTF invalidateIntrinsicContentSize];
    [self layoutIfNeeded];
    
  });
  
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
  
  if ([textField isEqual:_amountTF]) {
    
    NSString *finalString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSString *moneyFormattedString = [finalString omn_moneyFormattedStringWithMaxValue:kMaxEnteredValue];
    self.amount = [finalString omn_MoneyAmount];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    textField.text = moneyFormattedString;
    
    return NO;
  }
  
  return YES;
}

- (void)setup {
  
  self.backgroundColor = [UIColor clearColor];
  
  _amountTF = [[OMNLabeledTextField alloc] init];
  _amountTF.translatesAutoresizingMaskIntoConstraints = NO;
  _amountTF.textAlignment = NSTextAlignmentCenter;
  _amountTF.keyboardType = UIKeyboardTypeDecimalPad;
  _amountTF.textColor = colorWithHexString(@"FFFFFF");
  _amountTF.adjustsFontSizeToFitWidth = YES;
  _amountTF.minimumFontSize = 10.0f;
  _amountTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
  _amountTF.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
  _amountTF.font = FuturaLSFOmnomLERegular(50.0f);
  _amountTF.delegate = self;
  
  //https://github.com/saintlab/mobileapp_ios/issues/466
  if (OMN_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
    
    [_amountTF setDetailedText:[NSString stringWithFormat:@" %@\uFEFF", kRubleSign]];
    
  }

  [self addSubview:_amountTF];
  
  _flexibleBottomView = [[UIView alloc] init];
  _flexibleBottomView.translatesAutoresizingMaskIntoConstraints = NO;
  _flexibleBottomView.backgroundColor = colorWithHexString(@"FFFFFF");
  [self addSubview:_flexibleBottomView];
  
  NSDictionary *views =
  @{
    @"amountTF" : _amountTF,
    @"flexibleBottomView" : _flexibleBottomView,
    };
  
  NSDictionary *metrics =
  @{
    };
  
  [self addConstraint:[NSLayoutConstraint constraintWithItem:_amountTF attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  [self addConstraint:[NSLayoutConstraint constraintWithItem:_amountTF attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0.0f]];
  
  [self addConstraint:[NSLayoutConstraint constraintWithItem:_flexibleBottomView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_amountTF attribute:NSLayoutAttributeWidth multiplier:1.0f constant:10.0f]];
  [self addConstraint:[NSLayoutConstraint constraintWithItem:_flexibleBottomView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  [self addConstraint:[NSLayoutConstraint constraintWithItem:_flexibleBottomView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0f constant:180.0f]];
  
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[amountTF]-2-[flexibleBottomView(1)]|" options:kNilOptions metrics:metrics views:views]];
  
}

@end
