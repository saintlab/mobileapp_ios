//
//  OMNMailRUCardConfirmVC.m
//  omnom
//
//  Created by tea on 04.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNMailRUCardConfirmVC.h"
#import <OMNMailRuAcquiring.h>
#import "OMNBankCard.h"

@interface OMNMailRUCardConfirmVC ()

@end

@implementation OMNMailRUCardConfirmVC {
  OMNBankCard *_cardInfo;
  UIActivityIndicatorView *_spinner;
}

- (instancetype)initWithCard:(OMNBankCard *)cardInfo {
  self = [super initWithNibName:@"OMNMailRUCardConfirmVC" bundle:nil];
  if (self) {
    _cardInfo = cardInfo;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.navigationItem.title = NSLocalizedString(@"Привязка карты", nil);
  
  _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
  _spinner.hidesWhenStopped = YES;
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_spinner];
  
  [self registerCard];
  
}

- (void)registerCard {
  NSDictionary *cardInfo =
  @{
    @"pan" : @"6011000000000004",
    @"exp_date" : @"12.2015",
    @"cvv" : @"123",
    };
  
  [_spinner startAnimating];
  
  __weak typeof(self)weakSelf = self;
  [[OMNMailRuAcquiring acquiring] registerCard:cardInfo completion:^(id response) {
    
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
