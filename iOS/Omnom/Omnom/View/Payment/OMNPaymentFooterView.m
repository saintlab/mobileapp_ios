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
#import "UIImage+omn_helper.h"

@interface OMNPaymentFooterView ()
<OMNTipSelectorDelegate>

@property (nonatomic, assign) BOOL tipsMode;

@end

@implementation OMNPaymentFooterView {
  
  __weak IBOutlet UILabel *_tipsLabel;
  __weak IBOutlet UILabel *_payLabel;
  __weak IBOutlet UILabel *_payAmountLabel;
  __weak IBOutlet UILabel *_amountForPercentLabel;
  __weak IBOutlet OMNTipSelector *_tipsSelector;
  
  __weak IBOutlet UIButton *_payButton;
  
  __weak IBOutlet UIButton *_cancelEditingButton;
  __weak IBOutlet UIButton *_doneEditingButton;
  __weak IBOutlet UIButton *_editButton;
  __weak IBOutlet UIView *_sumEditingContainer;
  
  __weak IBOutlet OMNAmountPercentControl *_amountPercentControl;
  OMNAmountPercentValue *_tipAmountPercentValue;
  
  BOOL _keyboardShown;
  
}

- (void)dealloc {
  
  @try {
    
    [_order removeObserver:self forKeyPath:NSStringFromSelector(@selector(selectedTipIndex))];
    
  }
  @catch (NSException *exception) {}
  
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
  
  _tipsLabel.text = NSLocalizedString(@"PAYMENT_TIPS_LABEL", @"чаевые");
  _tipsLabel.font = FuturaOSFOmnomRegular(18.0f);
  _tipsLabel.textColor = colorWithHexString(@"FFFFFF");

  _payLabel.font = FuturaOSFOmnomRegular(18.0f);
  _payLabel.textColor = colorWithHexString(@"FFFFFF");

  _payAmountLabel.font = FuturaLSFOmnomLERegular(18.0f);
  _payAmountLabel.textColor = [colorWithHexString(@"FFFFFF") colorWithAlphaComponent:0.6f];
  
  _amountForPercentLabel.font = FuturaLSFOmnomLERegular(18.0f);
  _amountForPercentLabel.textColor = colorWithHexString(@"FFFFFF");
  
  [_doneEditingButton setImage:[UIImage imageNamed:@"done_editing_button"] forState:UIControlStateNormal];
  _doneEditingButton.tintColor = [UIColor whiteColor];
  
  [_cancelEditingButton setImage:[UIImage imageNamed:@"cancel_editing_button"] forState:UIControlStateNormal];
  _cancelEditingButton.tintColor = [UIColor whiteColor];

  [_editButton setImage:[UIImage imageNamed:@"edit_bill_sum_icon"] forState:UIControlStateNormal];
  _editButton.tintColor = [UIColor whiteColor];
  [_editButton addTarget:_amountPercentControl action:@selector(becomeFirstResponder) forControlEvents:UIControlEventTouchUpInside];
  
  _payButton.translatesAutoresizingMaskIntoConstraints = NO;
  _payButton.titleLabel.font = FuturaLSFOmnomLERegular(20.0f);
  [_payButton setBackgroundImage:[[UIImage imageNamed:@"red_roundy_button"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 20.0f, 0.0f, 20.0f)] forState:UIControlStateNormal];
  _payButton.contentEdgeInsets = UIEdgeInsetsMake(0.0f, 20.0f, 0.0f, 20.0f);
  [_payButton setTitleColor:colorWithHexString(@"FFFFFF") forState:UIControlStateNormal];
  [_payButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
  
  [self addConstraint:[NSLayoutConstraint constraintWithItem:_payButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:180.0f]];
  [self addConstraint:[NSLayoutConstraint constraintWithItem:_payButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  [self addConstraint:[NSLayoutConstraint constraintWithItem:_payButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0f constant:-10.0f]];
  
  _tipsSelector.delegate = self;
  
  __weak typeof(self)weakSelf = self;
  [_amountPercentControl bk_addEventHandler:^(id sender) {
    
    [weakSelf updatePercentAmountControl];
    
  } forControlEvents:UIControlEventEditingDidEnd];
  
  [_amountPercentControl bk_addEventHandler:^(OMNAmountPercentControl *sender) {
    
    [weakSelf updateAmountForPercentLabel];
    
  } forControlEvents:UIControlEventValueChanged];

  [self setKeyboardShown:NO];

}

- (void)configureWithColor:(UIColor *)color antogonistColor:(UIColor *)antogonistColor {
  
  UIImage *image = [[UIImage imageNamed:@"red_roundy_button"] omn_tintWithColor:antogonistColor];
  [_payButton setBackgroundImage:[image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 20.0f, 0.0f, 20.0f)] forState:UIControlStateNormal];
  [_payButton setTitleColor:color forState:UIControlStateNormal];
  [_amountPercentControl configureWithColor:color antogonistColor:antogonistColor];
  
}

- (void)updatePercentAmountControl {
  
  OMNAmountPercentValue *amountPercentValue = [[OMNAmountPercentValue alloc] init];
  amountPercentValue.amount = _order.enteredAmount;
  
  if (_order.expectedValue) {
    
    amountPercentValue.percent = 100.*(double)_order.enteredAmount/_order.expectedValue;
    
  }
  
  amountPercentValue.amount = _order.enteredAmount;
  _amountPercentControl.amountPercentValue = amountPercentValue;
  
  if (_order.paid.net_amount > 0) {
    
    _payAmountLabel.text = [NSString stringWithFormat:NSLocalizedString(@"ALREADY_PAID_AMOUNT %@", @"Уже оплачено: {amount}"), [OMNUtils formattedMoneyStringFromKop:_order.paid.net_amount]];
    
  }
  else {
    
    _payAmountLabel.text = @"";
    
  }
  
}

- (void)setOrder:(OMNOrder *)order {
  

  [_order removeObserver:self forKeyPath:NSStringFromSelector(@selector(selectedTipIndex))];
  _order = order;
  [_order addObserver:self forKeyPath:NSStringFromSelector(@selector(selectedTipIndex)) options:(NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew) context:NULL];
  
  [_tipsSelector setOrder:order];
  [self updatePercentAmountControl];
  
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  
  if ([object isEqual:_order] &&
      [keyPath isEqualToString:NSStringFromSelector(@selector(selectedTipIndex))]) {
    
    [self updateToPayButton];
    
  }
  else {
    
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    
  }
}

- (void)updateToPayButton {
  
  _payButton.enabled = (_order.enteredAmountWithTips > 0) ? (YES) : (NO);

  [UIView performWithoutAnimation:^{
    
    [_payButton setTitle:[NSString stringWithFormat:NSLocalizedString(@"TO_PAY_BUTTON_TEXT %@", @"Оплатить {AMOUNT}"),  [OMNUtils formattedMoneyStringFromKop:_order.enteredAmountWithTips]] forState:UIControlStateNormal];
    
  }];
  
}

- (void)updateAmountForPercentLabel {

  long long amount = _order.enteredAmount*_amountPercentControl.amountPercentValue.percent/100.0;
  _amountForPercentLabel.text = [NSString stringWithFormat:@"или %@%@", [OMNUtils evenCommaStringFromKop:amount], kRubleSign];
  
}

- (void)setKeyboardShown:(BOOL)keyboardShown {
  
  CGFloat editingAlpha = (keyboardShown) ? (1.0f) : (0.0f);
  CGFloat nonEditingAlpha = (keyboardShown) ? (0.0f) : (1.0f);
  
  _doneEditingButton.alpha = editingAlpha;
  _cancelEditingButton.alpha = editingAlpha;
  _editButton.alpha = nonEditingAlpha;
  _payButton.alpha = nonEditingAlpha;
  _tipsSelector.alpha = nonEditingAlpha;
  
  _sumEditingContainer.transform = (keyboardShown) ? (CGAffineTransformMakeTranslation(0, 63.0f)) : (CGAffineTransformIdentity);
  _payButton.transform = (keyboardShown) ? (CGAffineTransformMakeTranslation(0, 50.0f)) : (CGAffineTransformIdentity);
  
  if (self.tipsMode &&
      keyboardShown) {
    
    _payAmountLabel.alpha = 0.0f;
    _amountForPercentLabel.alpha = 1.0f;
    
  }
  else {
    
    _payAmountLabel.alpha = 1.0f;
    _amountForPercentLabel.alpha = 0.0f;
    
  }

  if (self.tipsMode) {
    
    _payLabel.alpha = (keyboardShown) ? (0.0f) : (1.0f);
    CGFloat deltaY = fabsf(_sumEditingContainer.top - _tipsLabel.top);
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
  
  
  BOOL amountEnteredOrEditing = (keyboardShown || _order.enteredAmountChanged);
  
  if (amountEnteredOrEditing) {

    _payLabel.text = NSLocalizedString(@"PAYMENT_DID_PAY_LABEL_TEXT", @"Я оплачу");
    
  }
  else {

    _payLabel.text = NSLocalizedString(@"PAYMENT_TO_PAY_LABEL_TEXT", @"к оплате");
    
  }
  
  [self updateToPayButton];
  
}

- (IBAction)cancelEditingTap:(id)sender {
  
  _order.selectedTipIndex = _tipsSelector.previousSelectedIndex;
  [_amountPercentControl resignFirstResponder];
  
}

- (IBAction)doneEdidtingTap:(id)sender {
  
  if (self.tipsMode) {
    
    _tipAmountPercentValue = _amountPercentControl.amountPercentValue;
    _order.customTip.percent = _tipAmountPercentValue.percent;
    _order.tipType = kTipTypeCustomPercent;
    _tipsSelector.order = _order;
#warning 123
  }
  else {
    
    [self.delegate paymentFooterView:self didSelectAmount:_amountPercentControl.amountPercentValue.amount];
    
  }
  
  [_amountPercentControl resignFirstResponder];
  
}

#pragma mark - OMNTipSelectorDelegate

- (void)tipSelectorStartCustomTipEditing:(OMNTipSelector *)tipSelector {
  
  self.tipsMode = YES;
  if (_tipAmountPercentValue) {
    
    _tipAmountPercentValue.amount = _order.enteredAmount;
    _amountPercentControl.amountPercentValue = _tipAmountPercentValue;
    
  }
  else {
    
    OMNAmountPercentValue *amountPercentValue = [[OMNAmountPercentValue alloc] init];
    amountPercentValue.percent = _order.customTip.percent;
    _amountPercentControl.amountPercentValue = amountPercentValue;
    
  }
  
  [_amountPercentControl beginPercentEditing];
  
}

@end
