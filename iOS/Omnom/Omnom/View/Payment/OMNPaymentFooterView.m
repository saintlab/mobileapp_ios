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
#import "OMNEditAmountControl.h"
#import "OMNEditPercentControl.h"
#import "UIView+frame.h"
#import "OMNConstants.h"
#import "OMNUtils.h"
#import <OMNStyler.h>
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
  
  __weak IBOutlet OMNEditAmountControl *_amountControl;
  __weak IBOutlet OMNEditPercentControl *_percentControl;
  
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
  [_editButton addTarget:_amountControl action:@selector(becomeFirstResponder) forControlEvents:UIControlEventTouchUpInside];
  
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
  [_percentControl bk_addEventHandler:^(OMNEditAmountControl *sender) {
    
    [weakSelf updateAmountForPercentLabel];
    
  } forControlEvents:UIControlEventValueChanged|UIControlEventEditingDidBegin];

  [self setKeyboardShown:NO];

}

- (void)configureWithColor:(UIColor *)color antogonistColor:(UIColor *)antogonistColor {
  
  UIImage *image = [[UIImage imageNamed:@"red_roundy_button"] omn_tintWithColor:antogonistColor];
  [_payButton setBackgroundImage:[image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 20.0f, 0.0f, 20.0f)] forState:UIControlStateNormal];
  [_payButton setTitleColor:color forState:UIControlStateNormal];
  [_amountControl configureWithColor:color antogonistColor:antogonistColor];
  
}

- (void)setOrder:(OMNOrder *)order {
  
  [_order removeObserver:self forKeyPath:NSStringFromSelector(@selector(selectedTipIndex))];
  _order = order;
  [_order addObserver:self forKeyPath:NSStringFromSelector(@selector(selectedTipIndex)) options:(NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew) context:NULL];
  
  [_tipsSelector setOrder:order];
  _payAmountLabel.text = (_order.paid.net_amount) ? ([NSString stringWithFormat:NSLocalizedString(@"ALREADY_PAID_AMOUNT %@", @"Уже оплачено: {amount}"), [OMNUtils formattedMoneyStringFromKop:_order.paid.net_amount]]) : (@"");
  
  _amountControl.amount = _order.enteredAmount;
  _percentControl.percent = _order.customTip.percent;
  
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

  long long amount = _order.enteredAmount*_percentControl.percent/100.0;
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
    _amountControl.alpha = 0.0f;
    _percentControl.alpha = 1.0f;
    _amountForPercentLabel.alpha = 1.0f;
    
  }
  else {
    
    _amountControl.alpha = 1.0f;
    _percentControl.alpha = 0.0f;
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
  
  [_amountControl layoutIfNeeded];
  
  if (!keyboardShown) {
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
  [_amountControl resignFirstResponder];
  [_percentControl resignFirstResponder];
  
}

- (IBAction)doneEdidtingTap:(id)sender {
  
  if (self.tipsMode) {

    [_order setCustomTipPercent:_percentControl.percent];
    [_percentControl resignFirstResponder];

  }
  else {
    
    [self.delegate paymentFooterView:self didSelectAmount:_amountControl.amount];
    [_amountControl resignFirstResponder];
    
  }
  
}

#pragma mark - OMNTipSelectorDelegate

- (void)tipSelectorStartCustomTipEditing:(OMNTipSelector *)tipSelector {
  
  self.tipsMode = YES;
  _percentControl.percent = _order.customTip.percent;
  [_percentControl becomeFirstResponder];
  
}

@end
