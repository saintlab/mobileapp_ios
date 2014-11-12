//
//  OMNMailRuAcquiringTests.m
//  OMNMailRuAcquiringTests
//
//  Created by teanet on 07/08/2014.
//  Copyright (c) 2014 teanet. All rights reserved.
//

#import <OMNMailRuAcquiring.h>

SPEC_BEGIN(MailRuTests)

describe(@"register test", ^{
  
  NSString *user_id = @"20";
  NSString *user_phone = @"89833087335";
  __block NSString *_cardID = nil;

  it(@"should create new card", ^{
    
    
    NSDictionary *cardInfo =
    @{
      @"pan" : @"4111111111111111",
//      @"pan" : @"639002000000000003",
//      @"pan" : @"6011000000000004",
      @"exp_date" : @"12.2015",
      @"cvv" : @"123",
      };
    
    __block id cardRegisterResponse = nil;
    
    [[OMNMailRuAcquiring acquiring] registerCard:cardInfo user_login:user_id user_phone:user_phone completion:^(id response, NSString *cardId) {
      
      cardRegisterResponse = response;
      _cardID = cardId;
      
    }];
    
    [[expectFutureValue(cardRegisterResponse) shouldEventuallyBeforeTimingOutAfter(10.0)] beNonNil];
    [[expectFutureValue(_cardID) shouldEventuallyBeforeTimingOutAfter(10.0)] beNonNil];
    
    
  });

  it(@"should wait for mail.ru", ^{
  
    [NSThread sleepForTimeInterval:4];
    
  });
  
  it(@"should fail verify test card", ^{
    
    __block NSError *cardVerifyError = nil;
    [[OMNMailRuAcquiring acquiring] cardVerify:1.2 user_login:user_id card_id:_cardID completion:^{
      
    } failure:^(NSError *error, NSDictionary *debugInfo) {
      
      cardVerifyError = error;
      
    }];
    
    [[expectFutureValue(cardVerifyResponse) shouldEventuallyBeforeTimingOutAfter(10.0)] beNonNil];
    
    [[@(cardVerifyError.code) should] equal:@(kOMNMailRuErrorCodeCardAmount)];
    
  });
  
  it(@"should verify test card", ^{
    
    __block NSNumber *cardVerifyResponse = nil;
    [[OMNMailRuAcquiring acquiring] cardVerify:1.4 user_login:user_id card_id:_cardID completion:^{
      
      cardVerifyResponse = @(YES)
      
    } failure:^(NSError *error, NSDictionary *debugInfo) {
    }];
    
    [[expectFutureValue(cardVerifyResponse) shouldEventuallyBeforeTimingOutAfter(10.0)] beNonNil];
    [cardVerifyResponse should] equal:@(YES)];
    
  });
  
  it(@"should pay with card id", ^{
    
    OMNMailRuPaymentInfo *paymentInfo = [[OMNMailRuPaymentInfo alloc] init];
    paymentInfo.cardInfo.card_id = _cardID;
    paymentInfo.cardInfo.cvv = @"123";
    paymentInfo.user_login = user_id;
    paymentInfo.order_message = @"message";
    paymentInfo.order_id = @"1";
    paymentInfo.extra.tip = 0;
    paymentInfo.extra.restaurant_id = @"1";
    paymentInfo.order_amount = @(100.);
    
    __block id cardPayResponse = nil;
    [[OMNMailRuAcquiring acquiring] payWithInfo:paymentInfo completion:^(id response) {
      
      cardPayResponse = response;
      
      
    }];
    
    [[expectFutureValue(cardPayResponse) shouldEventuallyBeforeTimingOutAfter(10.0)] beNonNil];
    
  });
  

  it(@"should delete card", ^{
    
    __block id cardDeleteResponse = nil;
    [[OMNMailRuAcquiring acquiring] cardDelete:_cardID user_login:user_id completion:^(id response) {
      
      cardDeleteResponse = response;
      
    }];

    [[expectFutureValue(cardDeleteResponse) shouldEventuallyBeforeTimingOutAfter(10.0)] beNonNil];
    
  });

});

SPEC_END
