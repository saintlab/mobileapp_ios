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

@interface OMNMailRUCardConfirmVC ()
<UITextFieldDelegate>

@property (nonatomic, strong) NSString *card_id;

@end

@implementation OMNMailRUCardConfirmVC {
  UIScrollView *_scrollView;
  OMNBankCardInfo *_bankCardInfo;
  OMNErrorTextField *_cardHoldValueTF;
  UILabel *_textLabel;
  UIButton *_commaButton;
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
  
  _cardHoldValueTF = [[OMNErrorTextField alloc] initWithWidth:140.0f];
  _cardHoldValueTF.textField.textAlignment = NSTextAlignmentCenter;
  _cardHoldValueTF.textField.placeholder = NSLocalizedString(@"00.00 Р", nil);
  _cardHoldValueTF.textField.keyboardType = UIKeyboardTypeNumberPad;
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
  
  _commaButton = [UIButton buttonWithType:UIButtonTypeCustom];
  _commaButton.frame = CGRectMake(0, 163, 106, 53);
  _commaButton.adjustsImageWhenHighlighted = NO;
  _commaButton.titleLabel.font = [UIFont systemFontOfSize:25.0f];
  [_commaButton addTarget:self action:@selector(commaTap:) forControlEvents:UIControlEventTouchUpInside];
  [_commaButton setTitle:kCommaString forState:UIControlStateNormal];
  [_commaButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  [_commaButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];

  dispatch_async(dispatch_get_main_queue(), ^{
    
    UIView *keyboardView = [[[UIApplication sharedApplication] windows] lastObject];
    [_commaButton setFrame:CGRectMake(0, keyboardView.frame.size.height - 53, 106, 53)];
    [keyboardView addSubview:_commaButton];
    [keyboardView bringSubviewToFront:_commaButton];

  });
  
  CGRect keyboardFrame = [n.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
  UIEdgeInsets insets = UIEdgeInsetsMake(0.0f, 0.0f, CGRectGetHeight(keyboardFrame), 0.0f);
  _scrollView.scrollIndicatorInsets = insets;
  _scrollView.contentInset = insets;
  
}

- (void)keyboardWillHide:(NSNotification *)n {
  
  _scrollView.scrollIndicatorInsets = UIEdgeInsetsZero;
  _scrollView.contentInset = UIEdgeInsetsZero;

  [_commaButton removeFromSuperview];
  _commaButton = nil;
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

  double value = [_cardHoldValueTF.textField.text doubleValue];
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
#warning register card stub
  NSDictionary *cardInfo =
//  @{
////    @"pan" : @"4111111111111111",
////    @"pan" : @"6011000000000004",
//    @"pan" : @"639002000000000003",
//    @"exp_date" : @"12.2015",
//    @"cvv" : @"123",
//    };

//  @{
//    @"pan" : @"5213243739794467",
//    @"exp_date" : @"12.2016",
//    @"cvv" : @"602",
//    };
  
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

- (void)commaTap:(UIButton *)button {
  
  if (NSNotFound == [_cardHoldValueTF.textField.text rangeOfString:kCommaString].location) {

    _cardHoldValueTF.textField.text = [_cardHoldValueTF.textField.text stringByAppendingString:kCommaString];
    
  }
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
  
  NSString *finalString = [textField.text stringByReplacingCharactersInRange:range withString:string];
  
  if (NSNotFound == [finalString rangeOfString:kCommaString].location) {
    textField.text = finalString;
  }
  else {
    
    NSString *fractionalString = @"";
    NSArray *components = [finalString componentsSeparatedByString:kCommaString];
    if (2 == components.count) {

      fractionalString = components[1];
      if (fractionalString.length > 2) {
        fractionalString = [fractionalString substringToIndex:2];
      }
      
    }
    
    textField.text = [@[components[0], fractionalString] componentsJoinedByString:kCommaString];
    
  }
  
  return NO;
}

@end
