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

NSString *kCommaString = @".";

@interface OMNMailRUCardConfirmVC ()
<UITextFieldDelegate>

@property (nonatomic, strong) NSString *card_id;

@end

@implementation OMNMailRUCardConfirmVC {
  OMNBankCardInfo *_bankCardInfo;
  UIActivityIndicatorView *_spinner;
  UIButton *_validateButton;
  OMNErrorTextField *_cardHoldValueTF;
  NSLayoutConstraint *_buttomConstraint;
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
  
  _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
  _spinner.hidesWhenStopped = YES;
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_spinner];
  
  [self setupView];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
  
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];

  [self registerCard];

}

- (void)setupView {
  
  _validateButton = [[UIButton alloc] init];
  [_validateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  _validateButton.translatesAutoresizingMaskIntoConstraints = NO;
  [_validateButton setBackgroundImage:[[UIImage imageNamed:@"roundy_button_white_black_border"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 30.0f, 0.0f, 30.0f)] forState:UIControlStateNormal];
  [_validateButton setBackgroundImage:[[UIImage imageNamed:@"roundy_button_white_light_grey_border"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 30.0f, 0.0f, 30.0f)] forState:UIControlStateDisabled];
  _validateButton.titleLabel.font = [UIFont fontWithName:@"Futura-OSF-Omnom-Medium" size:20.0f];
  [_validateButton setTitle:NSLocalizedString(@"Привязать", nil) forState:UIControlStateNormal];
  _validateButton.enabled = NO;
  [_validateButton addTarget:self action:@selector(validateTap) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:_validateButton];
  
  _textLabel = [[UILabel alloc] init];
  _textLabel.translatesAutoresizingMaskIntoConstraints = NO;
  _textLabel.numberOfLines = 0;
  _textLabel.textAlignment = NSTextAlignmentCenter;
  _textLabel.textColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
  _textLabel.font = [UIFont fontWithName:@"Futura-OSF-Omnom-Regular" size:15.0f];
  [self.view addSubview:_textLabel];
  
  _cardHoldValueTF = [[OMNErrorTextField alloc] init];
  _cardHoldValueTF.textField.textAlignment = NSTextAlignmentCenter;
  _cardHoldValueTF.textField.placeholder = NSLocalizedString(@"00.00 Р", nil);
  _cardHoldValueTF.textField.keyboardType = UIKeyboardTypeNumberPad;
  _cardHoldValueTF.textField.enabled = NO;
  _cardHoldValueTF.textField.delegate = self;
  [self.view addSubview:_cardHoldValueTF];
  
  NSDictionary *views =
  @{
    @"validateButton" : _validateButton,
    @"textLabel" : _textLabel,
    @"cardHoldValueTF" : _cardHoldValueTF,
    @"topLayoutGuide" : self.topLayoutGuide,
    };
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topLayoutGuide]-[cardHoldValueTF]-[textLabel]" options:0 metrics:0 views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[validateButton(40)]" options:0 metrics:0 views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[cardHoldValueTF]-|" options:0 metrics:0 views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[textLabel]-|" options:0 metrics:0 views:views]];
  
  _buttomConstraint = [NSLayoutConstraint constraintWithItem:_validateButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0f constant:-10.0f];
  [self.view addConstraint:_buttomConstraint];
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_validateButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  
}

- (void)keyboardWillShow:(NSNotification *)n {
  
  UIButton *commaButton = [UIButton buttonWithType:UIButtonTypeCustom];
  commaButton.frame = CGRectMake(0, 163, 106, 53);
  commaButton.adjustsImageWhenHighlighted = NO;
  commaButton.titleLabel.font = [UIFont systemFontOfSize:25.0f];
  [commaButton addTarget:self action:@selector(commaTap:) forControlEvents:UIControlEventTouchUpInside];
  [commaButton setTitle:kCommaString forState:UIControlStateNormal];
  [commaButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  [commaButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
  dispatch_async(dispatch_get_main_queue(), ^{
    
    UIView *keyboardView = [[[[[UIApplication sharedApplication] windows] lastObject] subviews] firstObject];
    [commaButton setFrame:CGRectMake(0, keyboardView.frame.size.height - 53, 106, 53)];
    [keyboardView addSubview:commaButton];
    [keyboardView bringSubviewToFront:commaButton];

  });
  
  CGRect keyboardFrame = [n.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
  _buttomConstraint.constant = -keyboardFrame.size.height - 10.0f;

  CGFloat animationDuration = [n.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
  [UIView animateWithDuration:animationDuration animations:^{
    [self.view layoutIfNeeded];
  }];
  
}

- (void)keyboardWillHide:(NSNotification *)n {
  
  _buttomConstraint.constant = 10.0f;
  CGFloat animationDuration = [n.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
  [UIView animateWithDuration:animationDuration animations:^{
    [self.view layoutIfNeeded];
  }];
  
}

- (void)setCard_id:(NSString *)card_id {
  _card_id = card_id;
  
  if (_card_id) {
    _textLabel.text = NSLocalizedString(@"С вашей карты списана случайная сумма до 30р. Введите сумму списания в это поле, чтобы привязать карту к вашему аккаунту", nil);
    _cardHoldValueTF.textField.enabled = YES;
    [_cardHoldValueTF.textField becomeFirstResponder];
    _validateButton.enabled = YES;
  }
  
}

- (void)validateTap {
  
  double value = [_cardHoldValueTF.textField.text doubleValue];
  _validateButton.enabled = NO;
  [_spinner startAnimating];
  OMNUser *user = [OMNAuthorisation authorisation].user;
  __weak typeof(self)weakSelf = self;
  [[OMNMailRuAcquiring acquiring] cardVerify:value user_login:user.id card_id:_card_id completion:^(id response) {
    
    [weakSelf cardDidVerify:response];
    
  }];

}

- (void)cardDidVerify:(id)response {

  [_spinner stopAnimating];
  _validateButton.enabled = YES;
  _cardHoldValueTF.textField.text = @"";
  
  if (response[@"error"]) {

    NSString *code = response[@"error"][@"code"];
    NSString *errorText = nil;
    if ([code isEqualToString:@"ERR_CARD_AMOUNT"]) {
      errorText = NSLocalizedString(@"Указана неверная проверочная сумма. Введите сумму ещё раз и нажмите \"Привязать\".", nil);
    }
    else {
      errorText = NSLocalizedString(@"Что-то пошло не так. Повторите попытку", nil);
    }
    
    [_cardHoldValueTF setError:errorText animated:YES];
    
  }
  else {
    
    [self.delegate mailRUCardConfirmVCDidFinish:self];
    
  }
  
}

- (void)didReceiveCardId:(NSNotification *)n {
  
  NSString *card_id = n.userInfo[@"card_id"];
  if (card_id) {
    dispatch_async(dispatch_get_main_queue(), ^{
      self.card_id = card_id;
    });
  }

}

- (void)registerCard {
  
  [_spinner startAnimating];
#warning register card stub
  NSDictionary *cardInfo =
  @{
//    @"pan" : @"4111111111111112",
//    @"pan" : @"6011000000000004",
    @"pan" : @"639002000000000003",
    @"exp_date" : @"12.2015",
    @"cvv" : @"123",
    };
  
  __weak typeof(self)weakSelf = self;
  OMNUser *user = [OMNAuthorisation authorisation].user;
  [[OMNMailRuAcquiring acquiring] registerCard:cardInfo user_login:user.id user_phone:user.phone completion:^(id response) {
    
    [weakSelf didFinishPostCardInfo:response];
    
  }];
  
}

- (void)didFinishPostCardInfo:(id)response {
  NSLog(@"registerCard>%@", response);
  [_spinner stopAnimating];
  
  NSString *card_id = response[@"card_id"];
  self.card_id = card_id;
  if (card_id) {
    
  }
  else {
    
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
