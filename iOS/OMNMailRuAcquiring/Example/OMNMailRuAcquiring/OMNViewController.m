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
  NSString *_user_phone;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  _user_login = @"5";
  _user_phone = @"89833087335";
  
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
  
//  _cardId = @"30001197651493912571";
//  _cardInfo =
//  @{
//    @"pan" : @"639002000000000003",
//    @"exp_date" : @"12.2015",
//    @"cvv" : kOMNMailRu_cvv,
//    };
  
}

- (IBAction)payAndRegisterTap:(id)sender {
  
  OMNMailRuPaymentInfo *paymentInfo = [[OMNMailRuPaymentInfo alloc] init];
  
//  paymentInfo.cardInfo.card_id = @"6011000000000004";
  //    paymentInfo.cardInfo.pan = @"4111111111111112";
  //    paymentInfo.cardInfo.pan = @"639002000000000003",
  paymentInfo.cardInfo.exp_date = @"12.2015";
  paymentInfo.cardInfo.cvv = @"123";
  paymentInfo.user_login = _user_login;
  paymentInfo.order_message = @"message";
  paymentInfo.order_id = @"1";
  paymentInfo.extra.tip = 0;
  paymentInfo.extra.restaurant_id = @"1";
  paymentInfo.order_amount = @(100.);
  [[OMNMailRuAcquiring acquiring] payWithInfo:paymentInfo completion:^(id response) {
    
  }];

}

- (IBAction)registerTap:(id)sender {
  
  NSDictionary *cardInfo =
  @{
    //    @"pan" : @"4111111111111112",
    @"pan" : @"6011000000000004",
    //    @"pan" : @"639002000000000003",
    @"exp_date" : @"12.2015",
    @"cvv" : @"123",
    };
  
  [[OMNMailRuAcquiring acquiring] registerCard:cardInfo user_login:_user_login user_phone:_user_phone completion:^(id response, NSString *cardId) {

    NSLog(@"%@  %@", response, cardId);
    
  }];

}

- (IBAction)verifyTap:(id)sender {
  
//  _cardId = @"30008685803965102459";
  [[OMNMailRuAcquiring acquiring] cardVerify:1.02 user_login:_user_login card_id:_cardId completion:^(id response) {
    
    NSLog(@"cardVerify>%@", response);

  }];
}

- (IBAction)deleteCard:(id)sender {
  [[OMNMailRuAcquiring acquiring] cardDelete:_cardId user_login:_user_login completion:^(id response) {
    
  }];
}

- (IBAction)payWithCardID:(id)sender {
  
//  NSDictionary *cardInfo =
//  @{
//    @"card_id" : _cardId,
//    @"cvv" : @"123",
//    };
//  [[OMNMailRuAcquiring acquiring] payWithCardInfo:cardInfo  user_login:_user_login addCard:NO];
  
}

- (IBAction)payWithNewCard:(id)sender {
  
//  [[OMNMailRuAcquiring acquiring] payWithCardInfo:_cardInfo user_login:_user_login addCard:NO];
  
}

@end
