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

@interface OMNMailRUCardConfirmVC ()

@end

@implementation OMNMailRUCardConfirmVC {
  OMNBankCardInfo *_bankCardInfo;
  UIActivityIndicatorView *_spinner;
  UIButton *_validateButton;
  NSString *_card_id;
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
  
  _validateButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
  _validateButton.enabled = NO;
  _validateButton.center = CGPointMake(50.0f, 100.0f);
  [_validateButton addTarget:self action:@selector(validateTap) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:_validateButton];
  
  [self registerCard];
  
}

- (void)validateTap {
  
  OMNUser *user = [OMNAuthorisation authorisation].user;
  [[OMNMailRuAcquiring acquiring] cardVerify:1.04 user_login:user.id card_id:_card_id];

}

- (void)didReceiveCardId:(NSNotification *)n {
  
  _card_id = n.userInfo[@"card_id"];
  if (_card_id) {
    _validateButton.enabled = YES;
  }
  NSLog(@"%@", n);
}

- (void)registerCard {
  NSDictionary *cardInfo =
  @{
    @"pan" : @"4111111111111111",
    @"exp_date" : @"12.2015",
    @"cvv" : @"123",
    
//    @"pan" : @"6011000000000004",
//    @"exp_date" : @"12.2015",
//    @"cvv" : @"123",
    
//    @"pan" : @"639002000000000003",
//    @"exp_date" : @"12.2015",
//    @"cvv" : @"123",
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
  
  if (response) {
    
  }
  else {
    
  }
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

@end
