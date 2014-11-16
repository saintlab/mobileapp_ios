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
#import <OMNMailRuAcquiring.h>
#import "OMNSocketManager.h"
#import "OMNAuthorisation.h"
#import "OMNErrorTextField.h"
#import "OMNUtils.h"
#import "OMNAnalitics.h"
#import "OMNOperationManager.h"
#import "OMNDotTextField.h"
#import "OMNLabeledTextField.h"
#import <OMNStyler.h>
#import "OMNCardEnterErrorLabel.h"
#import "UIBarButtonItem+omn_custom.h"

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
    _bankCardInfo = bankCardInfo;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.navigationItem.title = NSLocalizedString(@"CARD_CONFIRM_NAVIGATION_TITLE", @"Привязка карты");
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
  
//  _cardHoldValueTF.textField.enabled = YES;
//  [_cardHoldValueTF.textField becomeFirstResponder];
//  [_errorTextView setWrongAmountError];
//  self.card_id = @"123";

}

- (void)startLoader {
  
  UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
  [spinner startAnimating];
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
  
}

- (void)addDoneButton {
  
  [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"CARD_CONFIRM_ENTER_BUTTON_TITLE", @"Привязать") style:UIBarButtonItemStylePlain target:self action:@selector(validateTap)] animated:YES];
  
}

- (void)setupView {
  
  _scrollView = [[UIScrollView alloc] init];
  _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view addSubview:_scrollView];
  
  UIColor *backgroundColor = [UIColor whiteColor];
  
  UIView *contentView = [[UIView alloc] init];
  contentView.backgroundColor = backgroundColor;
  contentView.opaque = YES;
  contentView.translatesAutoresizingMaskIntoConstraints = NO;
  [_scrollView addSubview:contentView];
  
  _cardHoldValueTF = [[OMNErrorTextField alloc] initWithWidth:140.0f textFieldClass:[OMNLabeledTextField class]];
  _cardHoldValueTF.textField.textAlignment = NSTextAlignmentCenter;
  _cardHoldValueTF.textField.keyboardType = UIKeyboardTypeDecimalPad;
  _cardHoldValueTF.textField.enabled = NO;
  _cardHoldValueTF.textField.delegate = self;
  [contentView addSubview:_cardHoldValueTF];
  
  _errorLabel = [[OMNCardEnterErrorLabel alloc] init];
  _errorLabel.delegate = self;
  _errorLabel.translatesAutoresizingMaskIntoConstraints = NO;
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
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scroll]|" options:0 metrics:metrics views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topLayoutGuide][scroll]|" options:0 metrics:metrics views:views]];
  
  [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[cardHoldValueTF]-(10)-[errorLabel]-|" options:0 metrics:metrics views:views]];
  [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[cardHoldValueTF]-(leftOffset)-|" options:0 metrics:metrics views:views]];
  [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[errorLabel]-(leftOffset)-|" options:0 metrics:metrics views:views]];
  
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeLeft relatedBy:0 toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeRight relatedBy:0 toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
  
  [_scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[contentView]|" options:0 metrics:nil views:views]];
  
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

  double value = [self.currentAmountString omn_doubleValue];
  [self startLoader];
  OMNUser *user = [OMNAuthorisation authorisation].user;
  __weak typeof(self)weakSelf = self;
  [[OMNMailRuAcquiring acquiring] cardVerify:value user_login:user.id card_id:_bankCardInfo.card_id completion:^{
    
    [weakSelf cardDidVerify];
    
  } failure:^(NSError *error, NSDictionary *debugInfo) {
    
    [[OMNAnalitics analitics] logDebugEvent:@"ERROR_MAIL_CARD_VERIFY" parametrs:debugInfo];
    [weakSelf processError:error];
    
  }];

}

- (void)cardDidVerify {

  [_cardHoldValueTF setError:NO];
  _errorLabel.attributedText = nil;
  [_bankCardInfo logCardRegister];
  if (self.didFinishBlock) {
    self.didFinishBlock();
  }
  
}

- (void)processError:(NSError *)error {
  
  [self addDoneButton];
  [_cardHoldValueTF setError:YES];
  
  [UIView transitionWithView:_errorLabel duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
    
    if (kOMNMailRuErrorCodeUnknown == error.code) {
      
      [_errorLabel setUnknownError];
      
    }
    else if (kOMNMailRuErrorCodeCardAmount == error.code) {
      
      [_errorLabel setWrongAmountError];
      
    }
    else {
      
      NSError *internetError = [error omn_internetError];
      [_errorLabel setErrorText:internetError.localizedDescription];
      
    }
    
  } completion:nil];
  
}

- (void)registerCard {

  [_cardHoldValueTF setErrorText:nil];

  NSDictionary *cardInfo =
  @{
    @"pan" : _bankCardInfo.pan,
    @"exp_date" : [OMNMailRuCardInfo exp_dateFromMonth:_bankCardInfo.expiryMonth year:_bankCardInfo.expiryYear],
    @"cvv" : _bankCardInfo.cvv,
    };
  
  __weak typeof(self)weakSelf = self;
  OMNUser *user = [OMNAuthorisation authorisation].user;
  [self startLoader];
  [[OMNMailRuAcquiring acquiring] registerCard:cardInfo user_login:user.id user_phone:user.phone completion:^(id response, NSString *cardId) {
    
    [weakSelf didFinishPostWithResponse:response cardId:cardId];
    
  }];
  
}

- (void)didFinishPostWithResponse:(id)response cardId:(NSString *)cardId {

  NSString *status = response[@"status"];
  if ([status isEqualToString:@"OK_FINISH"] &&
      cardId.length) {
    
    NSDictionary *parameters = @{@"card_id" : cardId};
    [[OMNAnalitics analitics] logDebugEvent:@"MAIL_CARD_REGISTER" parametrs:parameters];
    [[OMNOperationManager sharedManager] POST:@"/report/mail/register" parameters:parameters success:nil failure:nil];
    self.card_id = cardId;
    
  }
  else {
    
    if (cardId) {
      NSMutableDictionary *r = [NSMutableDictionary dictionaryWithDictionary:response];
      r[@"card_id"] = cardId;
      response = r;
    }
    
    [[OMNAnalitics analitics] logDebugEvent:@"ERROR_MAIL_CARD_REGISTER" parametrs:response];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem omn_barButtonWithImage:[UIImage imageNamed:@"repeat_icon_small"] color:[UIColor blackColor] target:self action:@selector(registerCard)];
    [_errorLabel setUnknownError];
    
  }

}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
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
      
      if (NO == [string isEqualToString:@""]) {
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
  UITextPosition *start = [_cardHoldValueTF.textField positionFromPosition:[_cardHoldValueTF.textField beginningOfDocument]
                                                                    offset:range.location];
  UITextPosition *end = [_cardHoldValueTF.textField positionFromPosition:start
                                                                  offset:range.length];
  
  [_cardHoldValueTF.textField setSelectedTextRange:[_cardHoldValueTF.textField textRangeFromPosition:start toPosition:end]];
}

#pragma mark - TTTAttributedLabelDelegate

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
  
  if (self.noSMSBlock) {
    self.noSMSBlock();
  }
  
}

@end
