//
//  OMNMailRUPayVC.m
//  omnom
//
//  Created by tea on 12.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNMailRUPayVC.h"
#import "OMNBankCardInfo.h"
#import <OMNMailRuAcquiring.h>
#import <OMNDeletedTextField.h>
#import <OMNAuthorisation.h>
#import "OMNOrder.h"

@interface OMNMailRUPayVC()
<UITextFieldDelegate>

@end

@implementation OMNMailRUPayVC {
  UILabel *_bankCardDescriptionLabel;
  UILabel *_bankCardLabel;
  UIView *_bankCardDescriptionView;
  UILabel *_errorLabel;
  
  UILabel *_offerLabel;
  UITextField *_cvvTF;
  UIButton *_offer1Button;
  UIButton *_offer2Button;
  UIButton *_payButton;
  
  UIScrollView *_scrollView;
  
  OMNOrder *_order;
  OMNBankCardInfo *_bankCardInfo;
  OMNBill *_bill;
}

- (instancetype)initWithOrder:(OMNOrder *)order bankCardInfo:(OMNBankCardInfo *)bankCardInfo {
  self = [super init];
  if (self) {
    _order = order;
    _bankCardInfo = bankCardInfo;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor whiteColor];
  
  [self setup];
  
  _cvvTF.hidden = (nil == _bankCardInfo.card_id);
  _cvvTF.placeholder = NSLocalizedString(@"CVV", nil);
  
  _bankCardDescriptionLabel.text = NSLocalizedString(@"Банковская карта", nil);
  _bankCardLabel.text = NSLocalizedString(@"Банковская карта", nil);
  _errorLabel.text = @"";
  _offerLabel.text = NSLocalizedString(@"Оплата счета и чаевых будет произведена двумя транзакциями, по причине ...", nil);
  [_offer1Button setTitle:NSLocalizedString(@"Ссылка N1 на оферту", nil) forState:UIControlStateNormal];
  [_offer2Button setTitle:NSLocalizedString(@"Ссылка N2 на оферту", nil) forState:UIControlStateNormal];
  [_payButton setTitle:NSLocalizedString(@"Оплатить", nil) forState:UIControlStateNormal];
  [_payButton addTarget:self action:@selector(payTap) forControlEvents:UIControlEventTouchUpInside];
  
}

- (void)payTap {
  
  if (_bill) {
    [self billDidCreated:_bill];
    return;
  }
  
  __weak typeof(self)weakSelf = self;
  [_order createBill:^(OMNBill *bill) {
    
    [weakSelf billDidCreated:bill];
    
  } failure:^(NSError *error) {
    
    _errorLabel.text = error.localizedDescription;
    
  }];
  
}

- (void)billDidCreated:(OMNBill *)bill {
  
  _bill = bill;
  
  OMNMailRuPaymentInfo *paymentInfo = [[OMNMailRuPaymentInfo alloc] init];
  
  if (_bankCardInfo.card_id) {
    
    if (_cvvTF.text.length != 3) {
      return;
    }
    
    paymentInfo.cardInfo.card_id = _bankCardInfo.card_id;
    paymentInfo.cardInfo.cvv = _cvvTF.text;
    
  }
  else {
    
    paymentInfo.cardInfo.pan = @"6011000000000004";
    paymentInfo.cardInfo.exp_date = @"12.2015";
    paymentInfo.cardInfo.cvv = @"123";
    
  }
  paymentInfo.cardInfo.add_card = _bankCardInfo.saveCard;
  paymentInfo.extra.tip = _order.tipAmount;
  paymentInfo.extra.restaurant_id = @"1";
  
  paymentInfo.order_id = _bill.id;
  paymentInfo.user_phone = [OMNAuthorisation authorisation].user.phone;
  paymentInfo.user_login = [OMNAuthorisation authorisation].user.id;
  paymentInfo.order_amount = @(_order.toPayAmount/100.);
  paymentInfo.order_message = @"";
  
  [[OMNMailRuAcquiring acquiring] payWithInfo:paymentInfo completion:^(id response) {
    
    NSLog(@"payWithCardInfo>%@", response);
    
  }];
  
}

- (void)setup {
  
  _scrollView = [[UIScrollView alloc] init];
  _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view addSubview:_scrollView];
  
  UIView *contentView = [[UIView alloc] init];
  contentView.translatesAutoresizingMaskIntoConstraints = NO;
  [_scrollView addSubview:contentView];
  
  _bankCardDescriptionLabel = [[UILabel alloc] init];
  _bankCardDescriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
  [contentView addSubview:_bankCardDescriptionLabel];
  
  _bankCardLabel = [[UILabel alloc] init];
  _bankCardLabel.translatesAutoresizingMaskIntoConstraints = NO;
  [contentView addSubview:_bankCardLabel];
  
  _bankCardDescriptionView = [[UIView alloc] init];
  _bankCardDescriptionView.translatesAutoresizingMaskIntoConstraints = NO;
  [contentView addSubview:_bankCardDescriptionView];
  
  _cvvTF = [[OMNDeletedTextField alloc] init];
  _cvvTF.textAlignment = NSTextAlignmentCenter;
  _cvvTF.keyboardType = UIKeyboardTypeNumberPad;
  _cvvTF.delegate = self;
  _cvvTF.translatesAutoresizingMaskIntoConstraints = NO;
  [contentView addSubview:_cvvTF];
  
  _errorLabel = [[UILabel alloc] init];
  _errorLabel.numberOfLines = 0;
  _errorLabel.textColor = [UIColor redColor];
  _errorLabel.translatesAutoresizingMaskIntoConstraints = NO;
  [contentView addSubview:_errorLabel];
  
  _offerLabel = [[UILabel alloc] init];
  _offerLabel.numberOfLines = 0;
  _offerLabel.textAlignment = NSTextAlignmentCenter;
  _offerLabel.translatesAutoresizingMaskIntoConstraints = NO;
  [contentView addSubview:_offerLabel];
  
  UIColor *offserButtonColor = [UIColor colorWithRed:57/255.0f  green:142/255.0f blue:225/255.0f alpha:1.0f];
  
  _offer1Button = [[UIButton alloc] init];
  [_offer1Button setTitleColor:offserButtonColor forState:UIControlStateNormal];
  _offer1Button.translatesAutoresizingMaskIntoConstraints = NO;
  [contentView addSubview:_offer1Button];

  _offer2Button = [[UIButton alloc] init];
  [_offer2Button setTitleColor:offserButtonColor forState:UIControlStateNormal];
  _offer2Button.translatesAutoresizingMaskIntoConstraints = NO;
  [contentView addSubview:_offer2Button];

  _payButton = [[UIButton alloc] init];
  _payButton.backgroundColor = [UIColor redColor];
  _payButton.translatesAutoresizingMaskIntoConstraints = NO;
  [contentView addSubview:_payButton];
  
  NSDictionary *views =
  @{
    @"contentView" : contentView,
    @"scrollView" : _scrollView,
    @"bankCardDescriptionLabel" : _bankCardDescriptionLabel,
    @"bankCardLabel" : _bankCardLabel,
    @"bankCardDescriptionView" : _bankCardDescriptionView,
    @"cvvTF" : _cvvTF,
    @"errorLabel" : _errorLabel,
    @"offerLabel" : _offerLabel,
    @"offer1Button" : _offer1Button,
    @"offer2Button" : _offer2Button,
    @"payButton" : _payButton,
    @"topLayoutGuide" : self.topLayoutGuide,
    };
  
  NSDictionary *metrics =
  @{
    @"height" : @(50.0f),
    @"cvvTFHeight" : @((_bankCardInfo.card_id) ? (50.0f) : (0.0f)),
    @"cvvTFWidth" : @(100.0f),
    };
  
  [self.view addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topLayoutGuide][scrollView]|" options:0 metrics:nil views:views]];
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scrollView]|" options:0 metrics:nil views:views]];
  
  [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[bankCardDescriptionLabel]-|" options:0 metrics:0 views:views]];
  [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[bankCardLabel]-|" options:0 metrics:0 views:views]];
  [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[cvvTF(cvvTFWidth)]" options:0 metrics:metrics views:views]];
  [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[errorLabel]-|" options:0 metrics:0 views:views]];
  [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[offerLabel]-|" options:0 metrics:0 views:views]];
  [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[offer1Button]-|" options:0 metrics:0 views:views]];
  [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[offer2Button]-|" options:0 metrics:0 views:views]];
  [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[payButton]-|" options:0 metrics:0 views:views]];
  [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[bankCardDescriptionLabel(height)][bankCardLabel(height)][cvvTF(cvvTFHeight)][bankCardDescriptionView][errorLabel(>=0)][offerLabel]-[offer1Button]-[offer2Button]-[payButton]-|" options:0 metrics:metrics views:views]];
  
  [_scrollView addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[contentView]|" options:0 metrics:metrics views:views]];
  
  
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_cvvTF
                                                        attribute:NSLayoutAttributeCenterX
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:contentView
                                                        attribute:NSLayoutAttributeCenterX
                                                       multiplier:1.0f
                                                         constant:0.0f]];
  
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:contentView
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                           toItem:_scrollView
                                                        attribute:NSLayoutAttributeHeight
                                                       multiplier:1.0f
                                                         constant:0.0f]];
  
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:contentView
                                                        attribute:NSLayoutAttributeTrailing
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.view
                                                        attribute:NSLayoutAttributeRight
                                                       multiplier:1.0f
                                                         constant:0.0f]];
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:contentView
                                                        attribute:NSLayoutAttributeLeading
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.view
                                                        attribute:NSLayoutAttributeLeft
                                                       multiplier:1.0f
                                                         constant:0.0f]];
}

- (void)updateViewConstraints {
  [super updateViewConstraints];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
  
  NSString *finalString = [textField.text stringByReplacingCharactersInRange:range withString:string];
  NSInteger kCVVLength = 3;
  if ([textField isEqual:_cvvTF]) {
    
    NSString *cvv = finalString;
    
    if (cvv.length > kCVVLength) {
      cvv = [cvv substringToIndex:kCVVLength];
    }
    
    textField.text = cvv;
    
    if (kCVVLength == cvv.length) {
      [textField resignFirstResponder];
    }
    return NO;
  }
  
  return YES;
}

@end
