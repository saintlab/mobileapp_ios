//
//  OMNMailRuTransactionSpec.m
//  OMNMailRuAcquiring
//
//  Created by tea on 19.04.15.
//  Copyright 2015 teanet. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "OMNMailRuTransaction.h"

SPEC_BEGIN(OMNMailRuTransactionSpec)

describe(@"OMNMailRuTransaction", ^{

  NSDictionary *params =
  @{
    @"OMNMailRu_merch_id" : @"DGIS",
    @"OMNMailRu_vterm_id" : @"DGISMobile",
    @"OMNMailRu_cardholder" : @"Omnom",
    @"OMNMailRu_secret_key" : @"5FEgXKDjuaegndwVJugNVUTMov8AXR7kY6CFLdivveDpxn5XmF",
    @"OMNMailRuAcquiringBaseURL" : @"https://cpg.money.mail.ru/api/",
    @"OMNMailRuTestCVV" : @"",
    };
  OMNMailRuConfig *config = [OMNMailRuConfig configWithParametrs:params];

  OMNMailRuUser *user = [OMNMailRuUser userWithLogin:@"test" phone:@"+79833087335"];
  OMNMailRuExtra *extra = [OMNMailRuExtra extraWithRestaurantID:@"1" tipAmount:1 type:@"order"];
  OMNMailRuOrder *order = [OMNMailRuOrder orderWithID:@"1" amount:@(0.01)];
  
  OMNMailRuCard *newCard = [OMNMailRuCard cardWithPan:@"5213 2437 3843 1111" exp_date:[OMNMailRuCard exp_dateFromMonth:1 year:16] cvv:@"123"];
  OMNMailRuCard *existingCard = [OMNMailRuCard cardWithID:@"1"];
  
  context(@"config", ^{

    it(@"should create", ^{

      [[config should] beNonNil];
      [[config.merch_id should] beNonNil];
      [[config.vterm_id should] beNonNil];
      [[config.secret_key should] beNonNil];
      [[config.cardholder should] beNonNil];
      [[config.baseURL should] beNonNil];
      
    });

    it(@"should be valid", ^{
      
      [[@(config.isValid) should] equal:@(YES)];
      
    });
    
  });
  
  context(@"user", ^{
    
    it(@"should create", ^{
      
      [[user should] beNonNil];
      [[user.login should] equal:@"test"];
      [[user.phone should] equal:@"+79833087335"];
      
    });
    
  });
  
  context(@"card", ^{
    
    it(@"should check expire date", ^{
      
      [[[OMNMailRuCard exp_dateFromMonth:1 year:16] should] equal:@"01.2016"];
      [[[OMNMailRuCard exp_dateFromMonth:1 year:2016] should] equal:@"01.2016"];
      [[[OMNMailRuCard exp_dateFromMonth:12 year:14] should] equal:@"12.2014"];
      
    });
    
    it(@"should create with id", ^{
      
      [[existingCard.id should] equal:@"1"];
      [[existingCard.parameters should] equal:@{@"card_id" : @"1"}];
      
    });
    
    it(@"should create with pan exp_date cvv", ^{
      
      
      [[newCard.id should] equal:@""];
      [[newCard.pan should] equal:@"5213243738431111"];
      [[newCard.exp_date should] equal:@"01.2016"];
      [[newCard.cvv should] equal:@"123"];
      [[@(newCard.add_card) should] equal:@(NO)];
      
      [[newCard.parameters should] equal:
       @{
         @"pan" : newCard.pan,
         @"exp_date" : newCard.exp_date,
         @"add_card" : @(newCard.add_card),
         @"cvv" : newCard.cvv,
         }];
      
    });
    
  });
  
  context(@"extra", ^{
    
    it(@"should create", ^{
      
      [[extra should] beNonNil];
      [[extra.restaurant_id should] equal:@"1"];
      [[@(extra.tip) should] equal:@(1)];
      [[extra.type should] equal:@"order"];
      [[extra.text should] equal:@"{\"tip\":1,\"restaurant_id\":\"1\",\"type\":\"order\"}"];

    });
    
  });
  
  context(@"order", ^{
    
    it(@"should exist", ^{
      
      [[order should] beNonNil];
      [[order.id should] equal:@"1"];
      [[order.amount should] equal:@(0.01)];
      
    });
    
  });
  
});

SPEC_END
