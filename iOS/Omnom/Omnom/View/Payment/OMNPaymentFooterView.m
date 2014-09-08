//
//  GPaymentFooterView.m
//  seocialtest
//
//  Created by tea on 13.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNPaymentFooterView.h"
#import <BlocksKit+UIKit.h>
#import "OMNTipSelector.h"
#import "OMNAmountPercentControl.h"
#import "UIView+frame.h"
#import "OMNConstants.h"
#import "OMNUtils.h"
#import <OMNStyler.h>
#import "OMNAmountPercentValue.h"

@interface OMNPaymentFooterView ()

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
  OMNAmountPercentValue *_tipAmountPercentValue;
  
  BOOL _keyboardShown;
}

- (instancetype)initWithFrame:(CGRect)frame {
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
  [_payButton setBackgroundImage:[UIImage imageNamed:@"red_roundy_button"] forState:UIControlStateNormal];
  [_payButton setTitleColor:colorWithHexString(@"FFFFFF") forState:UIControlStateNormal];
  [_payButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
  
  _tipsSelector.selectedIndex = 1;
  
  __weak typeof(self)weakSelf = self;
  [_tipsSelector bk_addEventHandler:^(OMNTipSelector *sender) {
    
    if (3 == sender.selectedIndex) {
      
      [weakSelf startTipEditing];
      
    }
    else {
      
      [weakSelf updateToPayButton];
      
    }
    
  } forControlEvents:UIControlEventValueChanged];

  [_amountPercentControl bk_addEventHandler:^(id sender) {
    
    [weakSelf updatePercentAmountControl];
    
  } forControlEvents:UIControlEventEditingDidEnd];
  
  [self setKeyboardShown:NO];
  
}

- (void)startTipEditing {
  
  self.tipsMode = YES;
  if (_tipAmountPercentValue) {
    _amountPercentControl.amountPercentValue = _tipAmountPercentValue;
  }
  else {
    OMNAmountPercentValue *amountPercentValue = [[OMNAmountPercentValue alloc] init];
    amountPercentValue.amount = _order.customTip.amount;
    amountPercentValue.percent = _order.customTip.percent;
    amountPercentValue.totalAmount = _order.enteredAmount;
    _amountPercentControl.amountPercentValue = amountPercentValue;
  }
  
  [_amountPercentControl becomeFirstResponder];
  
}

- (void)updatePercentAmountControl {
  
  OMNAmountPercentValue *amountPercentValue = [[OMNAmountPercentValue alloc] init];
  amountPercentValue.isAmountSelected = YES;
  amountPercentValue.amount = _order.enteredAmount;
  if (_order.expectedValue) {
    amountPercentValue.percent = 100.*(double)_order.enteredAmount/_order.expectedValue;
  }
  amountPercentValue.totalAmount = _order.expectedValue;
  _amountPercentControl.amountPercentValue = amountPercentValue;
  
}

- (void)setOrder:(OMNOrder *)order {
  
  _order = order;
  [_tipsSelector setOrder:order];
  [self updatePercentAmountControl];
  [self updateView];
  
}

- (void)updateToPayButton {

  _payButton.enabled = (_order.enteredAmountWithTips > 0) ? (YES) : (NO);
  [_payButton setTitle:[NSString stringWithFormat:@"Оплатить %@",  [OMNUtils commaStringFromKop:_order.enteredAmountWithTips]] forState:UIControlStateNormal];
  
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
  
}

- (IBAction)cancelEditingTap:(id)sender {
  
  _tipsSelector.selectedIndex = _tipsSelector.previousSelectedIndex;
  [_amountPercentControl resignFirstResponder];
  
}

- (IBAction)doneEdidtingTap:(id)sender {
  
  if (self.tipsMode) {

    _tipAmountPercentValue = _amountPercentControl.amountPercentValue;
    _tipAmountPercentValue.isAmountSelected = [_amountPercentControl isAmountSelected];
    OMNTip *customTip = _order.customTip;
    if (_tipAmountPercentValue.isAmountSelected) {
      customTip.amount = _tipAmountPercentValue.amount;
      customTip.percent = 0.0;
    }
    else {
      customTip.amount = 0;
      customTip.percent = _tipAmountPercentValue.percent;
    }
    _order.customTip = customTip;
    
  }
  else {

    _order.splitType = kSplitTypePercent;
    _order.enteredAmount = _amountPercentControl.amountPercentValue.amount;
    
  }
  
  [_amountPercentControl resignFirstResponder];

}

@end
