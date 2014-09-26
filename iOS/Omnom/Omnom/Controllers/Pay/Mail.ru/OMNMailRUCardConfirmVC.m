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
#import "OMNBorderedButton.h"
#import "OMNUtils.h"
#import "OMNAnalitics.h"
#import "OMNOperationManager.h"
#import "OMNDotTextField.h"

#define kCurrencyString @" руб."

@interface OMNMailRUCardConfirmVC ()
<UITextFieldDelegate>

@property (nonatomic, strong) NSString *card_id;

@end

@implementation OMNMailRUCardConfirmVC {
  UIScrollView *_scrollView;
  OMNBankCardInfo *_bankCardInfo;
  OMNErrorTextField *_cardHoldValueTF;
  UILabel *_textLabel;
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
  
  self.navigationItem.title = NSLocalizedString(@"Привязка карты", nil);
  self.view.backgroundColor = [UIColor whiteColor];
  
  [self setupView];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
  
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];

  [self registerCard];
//  _cardHoldValueTF.textField.enabled = YES;
//  [_cardHoldValueTF.textField becomeFirstResponder];
}

- (void)startLoader {
  UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
  [spinner startAnimating];
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
}

- (void)addDoneButton {
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Привязать", nil) style:UIBarButtonItemStylePlain target:self action:@selector(validateTap)];
}

- (void)setupView {
  
  _scrollView = [[UIScrollView alloc] init];
  _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view addSubview:_scrollView];
  
  UIView *contentView = [[UIView alloc] init];
  contentView.translatesAutoresizingMaskIntoConstraints = NO;
  [_scrollView addSubview:contentView];
  
  _textLabel = [[UILabel alloc] init];
  _textLabel.translatesAutoresizingMaskIntoConstraints = NO;
  _textLabel.numberOfLines = 0;
  _textLabel.textAlignment = NSTextAlignmentCenter;
  _textLabel.textColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
  _textLabel.font = [UIFont fontWithName:@"Futura-OSF-Omnom-Regular" size:15.0f];
  [contentView addSubview:_textLabel];
  
  _cardHoldValueTF = [[OMNErrorTextField alloc] initWithWidth:140.0f textFieldClass:[OMNDotTextField class]];
  _cardHoldValueTF.textField.textAlignment = NSTextAlignmentCenter;
  _cardHoldValueTF.textField.placeholder = [NSString stringWithFormat:@"00%@00%@", omnCommaString(), kCurrencyString];
  _cardHoldValueTF.textField.enabled = NO;
  _cardHoldValueTF.textField.delegate = self;
  [contentView addSubview:_cardHoldValueTF];
  
  NSDictionary *views =
  @{
    @"textLabel" : _textLabel,
    @"cardHoldValueTF" : _cardHoldValueTF,
    @"topLayoutGuide" : self.topLayoutGuide,
    @"scroll" : _scrollView,
    @"contentView" : contentView,
    };
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scroll]|" options:0 metrics:nil views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topLayoutGuide][scroll]|" options:0 metrics:nil views:views]];
  
  [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[cardHoldValueTF]-[textLabel]-|" options:0 metrics:0 views:views]];
  [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[cardHoldValueTF]-|" options:0 metrics:0 views:views]];
  [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[textLabel]-|" options:0 metrics:0 views:views]];
  
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
  _card_id = card_id;
  
  _bankCardInfo.card_id = card_id;
  if (_card_id) {
    _textLabel.text = NSLocalizedString(@"Для привязки карты вам нужно подтвердить, что вы её владелец. Мы списали с вашей карты секретную сумму (до 50 руб.), о чём вам должна прийти SMS от банка. Посмотрите в сообщении, сколько списано и укажите сумму в поле выше.", nil);
    _cardHoldValueTF.textField.enabled = YES;
    [_cardHoldValueTF.textField becomeFirstResponder];
    [self addDoneButton];
  }
  
}

- (void)validateTap {
  
  _bankCardInfo.numberOfRegisterAttempts++;

  double value = [self.currentAmountString omn_doubleValue];
  [self startLoader];
  OMNUser *user = [OMNAuthorisation authorisation].user;
  __weak typeof(self)weakSelf = self;
  [[OMNMailRuAcquiring acquiring] cardVerify:value user_login:user.id card_id:_card_id completion:^(id response) {
    
    [weakSelf cardDidVerify:response];
    
  }];

}

- (void)cardDidVerify:(id)response {

  if (response[@"error"] ||
      nil == response) {

    [self addDoneButton];
    
    NSString *code = response[@"error"][@"code"];
    NSString *errorText = nil;
    if ([code isEqualToString:@"ERR_CARD_AMOUNT"]) {
      errorText = NSLocalizedString(@"Введена неверная проверочная сумма.\nЗагляните в последние SMS. Там должно быть сообщение от банка. Введите сумму из SMS. Если сообщения нет, в банковской выписке посмотрите последнее списание.", nil);
    }
    else {
      errorText = NSLocalizedString(@"Что-то пошло не так. Повторите попытку", nil);
    }
    
    [[OMNAnalitics analitics] logEvent:@"ERROR_MAIL_CARD_VERIFY" parametrs:response];

    [_cardHoldValueTF setError:errorText];
    
  }
  else {
    
    [_bankCardInfo logCardRegister];
    [self.delegate mailRUCardConfirmVCDidFinish:self];
    
  }
  
}

- (void)registerCard {

  [_cardHoldValueTF setError:nil];

  NSDictionary *cardInfo =
  @{
    @"pan" : _bankCardInfo.pan,
    @"exp_date" : [NSString stringWithFormat:@"%2ld.20%2ld", (long)_bankCardInfo.expiryMonth, (long)_bankCardInfo.expiryYear],
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
    
    [[OMNOperationManager sharedManager] POST:@"/report/mail/register" parameters:@{@"card_id" : cardId} success:nil failure:nil];
    
    self.card_id = cardId;
  }
  else {
    
    if (cardId) {
      NSMutableDictionary *r = [NSMutableDictionary dictionaryWithDictionary:response];
      r[@"card_id"] = cardId;
      response = r;
    }
    
    [[OMNAnalitics analitics] logEvent:@"ERROR_MAIL_CARD_REGISTER" parametrs:response];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"repeat_icon_small"] style:UIBarButtonItemStylePlain target:self action:@selector(registerCard)];
    [_cardHoldValueTF setError:NSLocalizedString(@"Что-то пошло не так. Повторите попытку", nil)];
  }

}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (NSString *)currentAmountString {
  return [_cardHoldValueTF.textField.text stringByReplacingOccurrencesOfString:kCurrencyString withString:@""];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
  
  NSString *finalString = [textField.text stringByReplacingCharactersInRange:range withString:string];
  finalString = [finalString stringByReplacingOccurrencesOfString:kCurrencyString withString:@""];
  
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

  [_cardHoldValueTF setText:amountString description:kCurrencyString];
  
}

- (void)setSelectionRange:(NSRange)range {
  UITextPosition *start = [_cardHoldValueTF.textField positionFromPosition:[_cardHoldValueTF.textField beginningOfDocument]
                                                                    offset:range.location];
  UITextPosition *end = [_cardHoldValueTF.textField positionFromPosition:start
                                                                  offset:range.length];
  
  [_cardHoldValueTF.textField setSelectedTextRange:[_cardHoldValueTF.textField textRangeFromPosition:start toPosition:end]];
}

@end
