//
//  OMNViewController.m
//  OMNMailRuAcquiring
//
//  Created by teanet on 07/08/2014.
//  Copyright (c) 2014 teanet. All rights reserved.
//

#import "OMNViewController.h"
#import <OMNMailRuAcquiring.h>

@interface OMNViewController ()

@end

@implementation OMNViewController {
  NSString *_cardId;
  NSDictionary *_cardInfo;
  NSString *_user_login;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  _user_login = @"5";
//  _cardId = @"30002847034833862453";
//  _cardInfo =
//  @{
//    @"pan" : @"4111111111111111",
//    @"exp_date" : @"12.2015",
//    @"cvv" : kOMNMailRu_cvv,
//    };
  
  _cardId = @"30001197651493912571";

  _cardInfo =
  @{
//    @"pan" : @"4111111111111112",
    @"pan" : @"639002000000000003",
    @"exp_date" : @"12.2015",
    @"cvv" : @"123",
    };
  .
//  _cardId = @"30001197651493912571";
//  _cardInfo =
//  @{
//    @"pan" : @"639002000000000003",
//    @"exp_date" : @"12.2015",
//    @"cvv" : kOMNMailRu_cvv,
//    };
  
}

- (IBAction)payAndRegisterTap:(id)sender {
  
  [[OMNMailRuAcquiring acquiring] payWithCardInfo:_cardInfo user_login:_user_login addCard:YES];
  
}

- (IBAction)registerTap:(id)sender {
  
  [[OMNMailRuAcquiring acquiring] registerCard:_cardInfo user_login:@"1" user_phone:@"89833087335" completion:^(id response) {
    NSLog(@"registerCard>%@", response);
  }];

}

- (IBAction)verifyTap:(id)sender {
  [[OMNMailRuAcquiring acquiring] cardVerify:1.4  user_login:_user_login card_id:_cardId];
}

- (IBAction)deleteCard:(id)sender {
  [[OMNMailRuAcquiring acquiring] cardDelete:_cardId user_login:_user_login];
}
- (IBAction)payWithCardID:(id)sender {
  
  NSDictionary *cardInfo =
  @{
    @"card_id" : _cardId,
    @"cvv" : @"123",
    };
  
  [[OMNMailRuAcquiring acquiring] payWithCardInfo:cardInfo  user_login:_user_login addCard:NO];
  
}

- (IBAction)payWithNewCard:(id)sender {
  
  [[OMNMailRuAcquiring acquiring] payWithCardInfo:_cardInfo user_login:_user_login addCard:NO];
  
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
