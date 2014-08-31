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
#import "OMNUtils.h"
#import <OMNStyler.h>

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
  
  _payButton.titleLabel.font = [UIFont fontWithName:@"Futura-LSF-Omnom-Regular" size:20.0f];
  [_payButton setBackgroundImage:[UIImage imageNamed:@"button_red"] forState:UIControlStateNormal];
  [_payButton setTitleColor:colorWithHexString(@"FFFFFF") forState:UIControlStateNormal];
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
  
  [_payButton setTitle:[NSString stringWithFormat:@"Оплатить %@",  [OMNUtils commaStringFromKop:_calculationAmount.totalValue]] forState:UIControlStateNormal];
  
}

- (void)setKeyboardShown:(BOOL)keyboardShown {
  
  _cancelEditingButton.alpha = (keyboardShown) ? (1.0f) : (0.0f);
  _doneEditingButton.alpha = (keyboardShown) ? (1.0f) : (0.0f);
  _payButton.alpha = (keyboardShown) ? (0.0f) : (1.0f);
  _tipsSelector.alpha = (keyboardShown) ? (0.0f) : (1.0f);
  
  CGAffineTransform buttonTransform = (keyboardShown) ? (CGAffineTransformIdentity) : (CGAffineTransformMakeTranslation(0, -50.0f));
  _cancelEditingButton.transform = buttonTransform;
  _doneEditingButton.transform = buttonTransform;

  _amountPercentControl.transform = (keyboardShown) ? (CGAffineTransformMakeTranslation(0, 97.0f)) : (CGAffineTransformIdentity);
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
  
  [_amountPercentControl layoutIfNeeded];
  
  if (NO == keyboardShown) {
    self.tipsMode = NO;
  }

  [self updateView];
  
}

- (void)updateView {

  [_tipsSelector update];
  [self updateToPayButton];
  [_amountPercentControl reset];
  
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

- (long long)expectedValueForAmountPercentControl:(OMNAmountPercentControl *)amountPercentControl {
  
  if (self.tipsMode) {
  
    return _calculationAmount.enteredAmount;
    
  }
  else {
    
    return _calculationAmount.expectedValue;
    
  }

}

- (long long)enteredValueForAmountPercentControl:(OMNAmountPercentControl *)amountPercentControl {
  long long enteredValue = 0;
  if (self.tipsMode) {
    
    enteredValue = _calculationAmount.customTipAmount;
    
  }
  else {
    
    enteredValue = _calculationAmount.enteredAmount;
    
  }
  return enteredValue;
}

@end
