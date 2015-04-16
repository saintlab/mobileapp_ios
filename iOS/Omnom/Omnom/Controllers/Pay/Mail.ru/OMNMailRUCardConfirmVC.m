//
//  OMNMailRUCardConfirmVC.m
//  omnom
//
//  Created by tea on 04.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNMailRUCardConfirmVC.h"
#import <OMNMailRuAcquiring.h>
#import "OMNBankCardInfo.h"
#import "OMNAuthorization.h"
#import "OMNErrorTextField.h"
#import "OMNUtils.h"
#import "OMNAnalitics.h"
#import "OMNOperationManager.h"
#import "OMNLabeledTextField.h"
#import <OMNStyler.h>
#import "OMNCardEnterErrorLabel.h"
#import "UIBarButtonItem+omn_custom.h"
#import "UIView+omn_autolayout.h"
#import "OMNMoneyQuestionVC.h"
#import "OMNBankCardInfo+omn_mailRuBankCardInfo.h"
#import "OMNUser+omn_mailRu.h"

@interface OMNMailRUCardConfirmVC ()
<UITextFieldDelegate,
TTTAttributedLabelDelegate>

@end

@implementation OMNMailRUCardConfirmVC {
  
  UIScrollView *_scrollView;
  OMNBankCardInfo *_bankCardInfo;
  OMNErrorTextField *_cardHoldValueTF;
  OMNCardEnterErrorLabel *_errorLabel;
  NSString *_detailedText;
  
}

- (void)dealloc {
  
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  
}

- (instancetype)initWithCardInfo:(OMNBankCardInfo *)bankCardInfo {
  self = [super init];
  if (self) {
    
    _bankCardInfo = [bankCardInfo copy];
    
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.navigationItem.title = kOMN_CARD_CONFIRM_NAVIGATION_TITLE;
  self.view.backgroundColor = [UIColor whiteColor];
  self.automaticallyAdjustsScrollViewInsets = NO;
  
  [self setupView];
    
  _detailedText = [NSString stringWithFormat:@" %@", kRubleSign];
  [(OMNLabeledTextField *)_cardHoldValueTF.textField setDetailedText:_detailedText];
  _cardHoldValueTF.textField.placeholder = [NSString stringWithFormat:@"00%@00 %@", omnCommaString(), kRubleSign];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
  
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];

  if (_bankCardInfo.card_id) {
    
    [self setCard_id:_bankCardInfo.card_id];
    
  }
  else {
    
    [self registerCard];
    
  }

}

- (void)startLoader {
  
  [_cardHoldValueTF setErrorText:nil];
  self.navigationItem.rightBarButtonItem = [UIBarButtonItem omn_loadingItem];
  
}

- (void)addDoneButton {
  [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:kOMN_BANK_CARD_ADD_BUTTON_TITLE style:UIBarButtonItemStylePlain target:self action:@selector(validateTap)] animated:YES];
}

- (void)setupView {
  
  _scrollView = [UIScrollView omn_autolayoutView];
  [self.view addSubview:_scrollView];
  
  UIColor *backgroundColor = [UIColor whiteColor];
  
  UIView *contentView = [UIView omn_autolayoutView];
  contentView.backgroundColor = backgroundColor;
  contentView.opaque = YES;
  [_scrollView addSubview:contentView];
  
  _cardHoldValueTF = [[OMNErrorTextField alloc] initWithWidth:140.0f textFieldClass:[OMNLabeledTextField class]];
  _cardHoldValueTF.textField.textAlignment = NSTextAlignmentCenter;
  _cardHoldValueTF.textField.keyboardType = UIKeyboardTypeDecimalPad;
  _cardHoldValueTF.textField.enabled = NO;
  _cardHoldValueTF.textField.delegate = self;
  [contentView addSubview:_cardHoldValueTF];
  
  _errorLabel = [OMNCardEnterErrorLabel omn_autolayoutView];
  _errorLabel.delegate = self;
  _errorLabel.backgroundColor = backgroundColor;
  _errorLabel.opaque = YES;
  [contentView addSubview:_errorLabel];
  
  NSDictionary *views =
  @{
    @"cardHoldValueTF" : _cardHoldValueTF,
    @"topLayoutGuide" : self.topLayoutGuide,
    @"scroll" : _scrollView,
    @"contentView" : contentView,
    @"errorLabel" : _errorLabel,
    };
  
  NSDictionary *metrics =
  @{
    @"leftOffset" : [[OMNStyler styler] leftOffset],
    };
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scroll]|" options:kNilOptions metrics:metrics views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topLayoutGuide][scroll]|" options:kNilOptions metrics:metrics views:views]];
  
  [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[cardHoldValueTF]-(10)-[errorLabel]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[cardHoldValueTF]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[errorLabel]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeLeft relatedBy:kNilOptions toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeRight relatedBy:kNilOptions toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
  
  [_scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[contentView]|" options:kNilOptions metrics:nil views:views]];
  
}

- (void)keyboardWillShow:(NSNotification *)n {
  
  CGRect keyboardFrame = [n.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
  UIEdgeInsets insets = UIEdgeInsetsMake(0.0f, 0.0f, CGRectGetHeight(keyboardFrame), 0.0f);
  _scrollView.scrollIndicatorInsets = insets;
  _scrollView.contentInset = insets;
  
}

- (void)keyboardWillHide:(NSNotification *)n {
  
  _scrollView.scrollIndicatorInsets = UIEdgeInsetsZero;
  _scrollView.contentInset = UIEdgeInsetsZero;

}

- (void)setCard_id:(NSString *)card_id {

  _bankCardInfo.card_id = card_id;
  if (card_id) {
    
    _cardHoldValueTF.textField.enabled = YES;
    [_cardHoldValueTF.textField becomeFirstResponder];
    [self addDoneButton];
    
    [UIView transitionWithView:_errorLabel duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
      
      [_errorLabel setHelpText];
      
    } completion:nil];
    
  }
  
}

- (void)validateTap {
  
  _bankCardInfo.numberOfRegisterAttempts++;

  double amount = [self.currentAmountString omn_doubleValue];
  [self startLoader];
  OMNUser *user = [OMNAuthorization authorisation].user;
  
  OMNBankCardInfo *bankCardInfo = _bankCardInfo;
  @weakify(self)
  [[OMNMailRuAcquiring acquiring] verifyCard:_bankCardInfo.card_id user_login:user.id amount:amount completion:^{
    
    @strongify(self)
    [self cardDidVerify];
    
  } failure:^(NSError *error) {
    
    [[OMNAnalitics analitics] logMailEvent:@"ERROR_MAIL_CARD_VERIFY" cardInfo:bankCardInfo error:error];
    NSError *omnomError = [OMNError omnnomErrorFromError:error];
    @strongify(self)
    [self processError:omnomError];
    
  }];
  
}

- (void)cardDidVerify {

  [_cardHoldValueTF setError:NO];
  _errorLabel.text = nil;
  _bankCardInfo.saveCard = YES;
  [_bankCardInfo logCardRegister];
  if (self.didFinishBlock) {
    self.didFinishBlock();
  }
  
}

- (void)processError:(NSError *)error {
  
  [self addDoneButton];
  [_cardHoldValueTF setError:YES];
  
  [UIView transitionWithView:_errorLabel duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
    
    if (OMNErrorWrongAmount == error.code) {
      
      [_errorLabel setWrongAmountError];
      
    }
    else if (kOMNErrorCodeUnknoun == error.code) {
      
      [_errorLabel setUnknownError];
      
    }
    else {

      [_errorLabel setErrorText:error.localizedDescription];
      
    }
    
  } completion:nil];
  
}

- (void)registerCard {

  [self startLoader];
  
  OMNBankCardInfo *bankCardInfo = _bankCardInfo;
  @weakify(self)
  
  OMNMailRuTransaction *transaction = [[OMNMailRuTransaction alloc] init];
  transaction.cardInfo = [bankCardInfo omn_mailRuCardInfo];
  transaction.user = [[OMNAuthorization authorisation].user omn_mailRuUser];
  
  [[OMNMailRuAcquiring acquiring] registerCard:transaction completion:^(NSString *cardId) {
    
    [[OMNAnalitics analitics] logDebugEvent:@"MAIL_CARD_REGISTER" parametrs:bankCardInfo.debugInfo];
    @strongify(self)
    self.card_id = cardId;

  } failure:^(NSError *error) {
    
    [[OMNAnalitics analitics] logMailEvent:@"ERROR_MAIL_CARD_REGISTER" cardInfo:bankCardInfo error:error];
    @strongify(self)
    [self procsessCardRegisterError:[OMNError omnnomErrorFromError:error]];

  }];
  
}

- (void)procsessCardRegisterError:(NSError *)error {
  
  self.navigationItem.rightBarButtonItem = [UIBarButtonItem omn_barButtonWithImage:[UIImage imageNamed:@"repeat_icon_small"] color:[UIColor blackColor] target:self action:@selector(registerCard)];
  [_errorLabel setErrorText:error.localizedDescription];

}

- (NSString *)currentAmountString {
  return [_cardHoldValueTF.textField.text stringByReplacingOccurrencesOfString:kRubleSign withString:@""];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
  
  NSString *finalString = [textField.text stringByReplacingCharactersInRange:range withString:string];
  finalString = [finalString stringByReplacingOccurrencesOfString:_detailedText withString:@""];
  
  if ([string isEqualToString:omnCommaString()]) {
    
    if (NSNotFound == [self.currentAmountString rangeOfString:omnCommaString()].location) {
      
      [self setAmountString:finalString];
      
    }
    
  }
  else if (NSNotFound == [finalString rangeOfString:omnCommaString()].location) {
    
    if (finalString.length >= 2) {
      
      if (finalString.length > 4) {
        finalString = [finalString substringToIndex:4];
      }
      
      if (![string isEqualToString:@""]) {
        NSString *component1 = [finalString substringToIndex:2];
        NSString *component2 = [finalString substringFromIndex:2];
        finalString = [NSString stringWithFormat:@"%@%@%@", component1, omnCommaString(), component2];
      }
      
    }
    [self setAmountString:finalString];
    
  }
  else {
    
    NSString *fractionalString = @"";
    NSArray *components = [finalString componentsSeparatedByString:omnCommaString()];
    if (2 == components.count) {

      fractionalString = components[1];
      if (fractionalString.length > 2) {
        fractionalString = [fractionalString substringToIndex:2];
      }
      
    }
    
    [self setAmountString:[@[components[0], fractionalString] componentsJoinedByString:omnCommaString()]];
    
  }
  
  return NO;
}

- (void)setAmountString:(NSString *)amountString {
  _cardHoldValueTF.textField.text = amountString;
}

- (void)setSelectionRange:(NSRange)range {
  
  UITextPosition *start = [_cardHoldValueTF.textField positionFromPosition:[_cardHoldValueTF.textField beginningOfDocument] offset:range.location];
  UITextPosition *end = [_cardHoldValueTF.textField positionFromPosition:start offset:range.length];
  [_cardHoldValueTF.textField setSelectedTextRange:[_cardHoldValueTF.textField textRangeFromPosition:start toPosition:end]];
  
}

- (void)showMoneyQuestion {
  
  OMNMoneyQuestionVC *moneyQuestionVC = [[OMNMoneyQuestionVC alloc] init];
  @weakify(self)
  moneyQuestionVC.didCloseBlock = ^{
    
    @strongify(self)
    [self dismissViewControllerAnimated:YES completion:nil];
    
  };
  [self presentViewController:moneyQuestionVC animated:YES completion:nil];
  
}

#pragma mark - TTTAttributedLabelDelegate

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
  
  if ([url isEqual:kOMNMoneyQuestionURL]) {
    
    [self showMoneyQuestion];
    
  }
  else if ([url isEqual:kOMNNoSMSURL] && self.noSMSBlock) {
    
    self.noSMSBlock();
    
  }
  
}

@end
