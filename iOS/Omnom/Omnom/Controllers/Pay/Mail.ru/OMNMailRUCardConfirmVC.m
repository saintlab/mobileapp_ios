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
#import <OMNDeletedTextField.h>

@interface OMNMailRUCardConfirmVC ()
<UITextFieldDelegate>

@end

@implementation OMNMailRUCardConfirmVC {
  OMNBankCardInfo *_bankCardInfo;
  UIActivityIndicatorView *_spinner;
  UIButton *_validateButton;
  NSString *_card_id;
  OMNDeletedTextField *_sumTF;
  NSLayoutConstraint *_buttomConstraint;
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
  
  _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
  _spinner.hidesWhenStopped = YES;
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_spinner];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveCardId:) name:OMNSocketIODidReceiveCardIdNotification object:nil];

  [self setupView];
  [self registerCard];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
  
}

- (void)setupView {
  
  _validateButton = [[UIButton alloc] init];
  [_validateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  _validateButton.translatesAutoresizingMaskIntoConstraints = NO;
  [_validateButton setBackgroundImage:[UIImage imageNamed:@"roundy_button_white_black_border"] forState:UIControlStateNormal];
  [_validateButton setBackgroundImage:[UIImage imageNamed:@"roundy_button_white_light_grey_border"] forState:UIControlStateDisabled];
  [_validateButton setTitle:NSLocalizedString(@"Привязать", nil) forState:UIControlStateNormal];
  _validateButton.enabled = NO;
  [_validateButton addTarget:self action:@selector(validateTap) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:_validateButton];
  
  UILabel *textLabel = [[UILabel alloc] init];
  textLabel.translatesAutoresizingMaskIntoConstraints = NO;
  textLabel.numberOfLines = 0;
  textLabel.textAlignment = NSTextAlignmentCenter;
  textLabel.text = NSLocalizedString(@"С вашей карты списана случайная сумма до 30р. Введите сумму списания в это поле, чтобы привязать карту к вашему аккаунту", nil);
  textLabel.textColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
  textLabel.font = [UIFont fontWithName:@"Futura-OSF-Omnom-Regular" size:15.0f];
  [self.view addSubview:textLabel];
  
  _sumTF = [[OMNDeletedTextField alloc] init];
  _sumTF.textAlignment = NSTextAlignmentCenter;
  _sumTF.translatesAutoresizingMaskIntoConstraints = NO;
  _sumTF.placeholder = NSLocalizedString(@"00.00 Р", nil);
  _sumTF.keyboardType = UIKeyboardTypeNumberPad;
  _sumTF.delegate = self;
  [self.view addSubview:_sumTF];
  
  NSDictionary *views =
  @{
    @"validateButton" : _validateButton,
    @"textLabel" : textLabel,
    @"sumTF" : _sumTF,
    @"topLayoutGuide" : self.topLayoutGuide,
    };
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topLayoutGuide]-[sumTF(50)]-[textLabel]" options:0 metrics:0 views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[validateButton(40)]" options:0 metrics:0 views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[sumTF(140)]" options:0 metrics:0 views:views]];
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_sumTF attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[textLabel]-|" options:0 metrics:0 views:views]];
  
  _buttomConstraint = [NSLayoutConstraint constraintWithItem:_validateButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0f constant:-10.0f];
  [self.view addConstraint:_buttomConstraint];
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_validateButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  
}

- (void)keyboardWillShow:(NSNotification *)n {
  
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

- (void)validateTap {
  
  OMNUser *user = [OMNAuthorisation authorisation].user;
  [[OMNMailRuAcquiring acquiring] cardVerify:1.4 user_login:user.id card_id:_card_id completion:^(id response) {
    
  }];

}

- (void)didReceiveCardId:(NSNotification *)n {
  
  _card_id = n.userInfo[@"card_id"];
  if (_card_id) {
    _validateButton.enabled = YES;
  }

}

- (void)registerCard {
  [_spinner startAnimating];
  NSDictionary *cardInfo =
  @{
//    @"pan" : @"4111111111111112",
    @"pan" : @"6011000000000004",
//    @"pan" : @"639002000000000003",
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
  if (card_id) {
    
  }
  else {
    
  }
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
  textField.text = [textField.text stringByReplacingCharactersInRange:range withString:string];
  return NO;
}

@end
