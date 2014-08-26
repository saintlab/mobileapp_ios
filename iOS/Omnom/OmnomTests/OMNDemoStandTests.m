//
//  OMNDemoStandTests.m
//  omnom
//
//  Created by tea on 21.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Kiwi.h>
#import "OMNAuthorisation.h"
#import "OMNDecodeBeaconManager.h"
#import <OMNMailRuAcquiring.h>
#import "OMNOrder+omn_mailru.h"
#import "OMNBankCard.h"

SPEC_BEGIN(OMNDemoStandTest)

describe(@"demo stand test", ^{

  __block OMNDecodeBeacon *_decodeBeacon = nil;
  __block OMNOrder *_order = nil;
  __block OMNUser *_user = nil;
  
  OMNBeacon *aCafeBeacon = [OMNBeacon aCafeBeacon];
  
  beforeAll(^{
    
    [[[OMNAuthorisation authorisation].token should] beNonNil];
    
    [[OMNDecodeBeaconManager manager] decodeBeacon:aCafeBeacon success:^(OMNDecodeBeacon *decodeBeacon) {
      
      _decodeBeacon = decodeBeacon;
      
    } failure:^(NSError *error) {
      
    }];
    
    [[expectFutureValue(_decodeBeacon) shouldEventuallyBeforeTimingOutAfter(5)] beNonNil];

    __block NSArray *_orders = nil;
    [_decodeBeacon getOrders:^(NSArray *orders) {
      
      _orders = orders;
      
    } error:^(NSError *error) {
      
    }];
    
    [[expectFutureValue(_orders) shouldEventuallyBeforeTimingOutAfter(5)] beNonNil];
    _order = [_orders firstObject];
    
    [OMNUser userWithToken:[OMNAuthorisation authorisation].token user:^(OMNUser *user) {
      
      _user = user;
      
    } failure:^(NSError *error) {
      
    }];
    
    [[expectFutureValue(_user) shouldEventuallyBeforeTimingOutAfter(5)] beNonNil];
    
  });
  
  it(@"should check initial conditions", ^{
    
    [[_decodeBeacon should] beNonNil];

    [[_order should] beNonNil];

    [[_user.id should] equal:@"1"];
    [[_user.email should] equal:@"egor@saintlab.com"];
    
  });
  
  __block NSString *_card_id = nil;
  it(@"should create new card", ^{
    
    NSDictionary *cardInfo =
    @{
      //      @"pan" : @"4111111111111112",
      //      @"pan" : @"639002000000000003",
      @"pan" : @"6011000000000004",
      @"exp_date" : @"12.2015",
      @"cvv" : @"123",
      };
    
    __block id cardRegisterResponse = nil;
    [[OMNMailRuAcquiring acquiring] registerCard:cardInfo user_login:_user.id user_phone:_user.phone completion:^(id response) {
      
      cardRegisterResponse = response;
      
    }];
    
    [[expectFutureValue(cardRegisterResponse) shouldEventuallyBeforeTimingOutAfter(5)] beNonNil];
    
    _card_id = cardRegisterResponse[@"card_id"];
    [[_card_id should] beNonNil];
    
  });
  
});

SPEC_END
