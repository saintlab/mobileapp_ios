//
//  GPaymentFooterView.m
//  seocialtest
//
//  Created by tea on 13.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNPaymentFooterView.h"
#import <BlocksKit+UIKit.h>
#import <TSCurrencyTextField.h>
#import "OMNTipSelector.h"
#import "OMNAmountPercentControl.h"
#import "UIView+frame.h"
#import "OMNConstants.h"

@interface OMNPaymentFooterView ()
<GAmountPercentControlDelegate>

@property (nonatomic, assign) BOOL tipsMode;

@end

@implementation OMNPaymentFooterView {
  
  __weak IBOutlet UILabel *_tipsLabel;
  __weak IBOutlet UILabel *_payLabel;
  __weak IBOutlet OMNTipSelector *_tipsSelector;

  __weak IBOutlet UIButton *_payButton;
  
  __weak IBOutlet UIButton *_cancelEditingButton;
  __weak IBOutlet UIButton *_doneEditingButton;

  __weak IBOutlet OMNAmountPercentControl *_amountPercentControl;
  
  BOOL _keyboardShown;
}

- (void)dealloc {
  
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  
}

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    [self setup];
  }
  return self;
}

- (void)awakeFromNib {
  [self setup];
}

- (void)setup {
  
  self.clipsToBounds = YES;
  self.backgroundColor = [UIColor clearColor];
  
  _tipsLabel.textColor = [UIColor colorWithWhite:136 / 255. alpha:1];
  _payLabel.textColor = [UIColor colorWithWhite:136 / 255. alpha:1];
  
  [_doneEditingButton setImage:[UIImage imageNamed:@"done_editing_button"] forState:UIControlStateNormal];
  _doneEditingButton.tintColor = [UIColor whiteColor];
  [_cancelEditingButton setImage:[UIImage imageNamed:@"cancel_editing_button"] forState:UIControlStateNormal];
  _cancelEditingButton.tintColor = [UIColor whiteColor];
  
  _payButton.titleLabel.font = kPayButtonFont;
  _payButton.titleEdgeInsets = UIEdgeInsetsMake(3.0f, 0, 0, 0);
  [_payButton setBackgroundImage:[UIImage imageNamed:@"button_red"] forState:UIControlStateNormal];
  [_payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [_payButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
  [_payButton sizeToFit];
  
  _amountPercentControl.delegate = self;
  
  _tipsSelector.selectedIndex = 1;
  
  [_tipsSelector bk_addEventHandler:^(UISegmentedControl *sender) {

    [self updateToPayButton];
    
  } forControlEvents:UIControlEventValueChanged];
  
  __weak typeof(self)weakSelf = self;
  [_tipsSelector bk_addEventHandler:^(OMNTipSelector *sender) {
    
    __strong __typeof(weakSelf)strongSelf = weakSelf;
    if (3 == sender.selectedIndex) {
      
      strongSelf.tipsMode = YES;
      [_amountPercentControl becomeFirstResponder];
      
    }
    else {
      
      [strongSelf updateToPayButton];
      
    }
    
  } forControlEvents:UIControlEventValueChanged];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
  
  [self setKeyboardShown:NO];
  
  [self updateToPayButton];
  
}

- (void)setFrame:(CGRect)frame {
  [super setFrame:frame];
}

- (void)setCalculationAmount:(OMNCalculationAmount *)calculationAmount {
  
  _calculationAmount = calculationAmount;
  [_tipsSelector setCalculationAmount:calculationAmount];
  [self updateView];
  
}

- (void)updateToPayButton {

  _payButton.enabled = (_calculationAmount.totalValue > 0) ? (YES) : (NO);
  [_payButton setTitle:[NSString stringWithFormat:@"Оплатить %.0fi", _calculationAmount.totalValue] forState:UIControlStateNormal];
  
}

- (void)setKeyboardShown:(BOOL)keyboardShown {
  
  _cancelEditingButton.alpha = (keyboardShown) ? (1.0f) : (0.0f);
  _doneEditingButton.alpha = (keyboardShown) ? (1.0f) : (0.0f);
  _payButton.alpha = (keyboardShown) ? (0.0f) : (1.0f);
  _tipsSelector.alpha = (keyboardShown) ? (0.0f) : (1.0f);
  
  CGAffineTransform buttonTransform = (keyboardShown) ? (CGAffineTransformIdentity) : (CGAffineTransformMakeTranslation(0, -50.0f));
  _cancelEditingButton.transform = buttonTransform;
  _doneEditingButton.transform = buttonTransform;

  _amountPercentControl.transform = (keyboardShown) ? (CGAffineTransformMakeTranslation(0, 75.0f)) : (CGAffineTransformIdentity);
  
  _payButton.transform = (keyboardShown) ? (CGAffineTransformMakeTranslation(0, 50.0f)) : (CGAffineTransformIdentity);

  if (self.tipsMode) {
    
    _payLabel.alpha = (keyboardShown) ? (0.0f) : (1.0f);
    CGFloat deltaY = fabsf(_payLabel.y - _tipsLabel.y);
    _tipsLabel.transform = (keyboardShown) ? (CGAffineTransformMakeTranslation(0, -deltaY)) : (CGAffineTransformIdentity);

  }
  else {
    
    _tipsLabel.alpha = (keyboardShown) ? (0.0f) : (1.0f);
    _tipsLabel.transform = CGAffineTransformIdentity;
    
  }
  
  [_amountPercentControl setNeedsLayout];
  [_amountPercentControl layoutIfNeeded];
  
  if (NO == keyboardShown) {
    self.tipsMode = NO;
  }

  [self updateView];
  
}

- (void)updateView {

  [_tipsSelector update];
  [_amountPercentControl reset];
  [self updateToPayButton];
  
}

- (void)keyboardWillShow:(NSNotification *)n {
  
  NSTimeInterval duration = [n.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
  [UIView animateWithDuration:3 * duration animations:^{
    
    [self setKeyboardShown:YES];
    
  }];
  
}

- (void)keyboardWillHide:(NSNotification *)n {
  
  NSTimeInterval duration = [n.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
  [UIView animateWithDuration:3 * duration animations:^{
    
    [self setKeyboardShown:NO];
    
  }];
  
}

- (IBAction)cancelEditingTap:(id)sender {
  
  [_amountPercentControl resignFirstResponder];
  
}

- (IBAction)doneEdidtingTap:(id)sender {
  
  if (self.tipsMode) {

    _calculationAmount.customTipAmount = _amountPercentControl.selectedAmount;
   
  }
  else {

    _calculationAmount.enteredAmount = _amountPercentControl.selectedAmount;
    
  }
  
  [_amountPercentControl resignFirstResponder];

}

#pragma mark - GAmountPercentControlDelegate

- (double)expectedValueForAmountPercentControl:(OMNAmountPercentControl *)amountPercentControl {
  
  if (self.tipsMode) {
  
    return _calculationAmount.enteredAmount;
    
  }
  else {
    
    return _calculationAmount.expectedValue;
    
  }

}

- (double)enteredValueForAmountPercentControl:(OMNAmountPercentControl *)amountPercentControl {
 
  if (self.tipsMode) {
    
    return _calculationAmount.customTipAmount;
    
  }
  else {
    
    return _calculationAmount.enteredAmount;
    
  }
  
}

@end