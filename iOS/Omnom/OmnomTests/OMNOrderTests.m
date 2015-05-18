//
//  OMNCallBillTests.m
//  omnom
//
//  Created by tea on 20.11.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <Kiwi.h>
#import "OMNAuthorization.h"
#import "OMNTable+omn_network.h"
#import "NSString+omn_json.h"
#import "NSObject+omn_order.h"
#import <OHHTTPStubs.h>

SPEC_BEGIN(OMNOrderTests)

describe(@"order test", ^{
  
  __block OMNOrder *_order = nil;
  beforeAll(^{
    
    [OMNAuthorization authorization];
    id orderData = [@"orders_stub.json" omn_jsonObjectNamedForClass:self.class];
    NSArray *orders = [orderData omn_decodeOrdersWithError:nil];
    _order = [orders firstObject];
    
  });
  
  it(@"should check initial conditions", ^{
    
    [[_order should] beNonNil];
    
  });
  
  it(@"should check tips initial conditions", ^{
    
    [[_order.tips should] beNonNil];
    [[@(_order.tips.count) should] equal:@(4)];
    [[@(_order.selectedTipIndex) should] equal:@(1)];
    [[_order.customTip should] beNonNil];
    [[@(_order.customTip.custom) should] equal:@(YES)];
    
  });
  
  it(@"should check initial entered amount", ^{
    
    [[@(_order.enteredAmount) should] equal:@(_order.totalAmount - _order.paid.net_amount)];
    
  });
  
  it(@"should check tips border values", ^{
    
    long long enterdAmount = 100ll;
    _order.enteredAmount = enterdAmount;
    [[@(_order.enteredAmount) should] equal:@(enterdAmount)];
    
    OMNTip *tip = _order.tips[_order.selectedTipIndex];
    [[@(_order.enteredAmountWithTips) should] equal:@([tip amountForValue:enterdAmount] + enterdAmount)];
    
    [tip.thresholds enumerateObjectsUsingBlock:^(NSNumber *threshold, NSUInteger idx, BOOL *stop) {
      
      NSNumber *tipAmount = tip.amounts[idx];
      [[@([tip amountForValue:threshold.longLongValue - 1ll]) should] equal:tipAmount];
      
    }];
    
    long long maxTheshold = [tip.thresholds.lastObject longLongValue];
    [[@([tip amountForValue:maxTheshold]) should] equal:@(maxTheshold*tip.percent*0.01)];
    
    [[@([tip amountForValue:maxTheshold - 1ll]) should] equal:[tip.amounts lastObject]];
    
  });
  
  it(@"should get orders", ^{
    
    OMNTable *table = [OMNTable mock];
    [table stub:@selector(getOrders) withBlock:^id(NSArray *params) {
      
      return [PMKPromise new:^(PMKFulfiller fulfill, PMKRejecter reject) {
        id orderData = [@"orders_stub.json" omn_jsonObjectNamedForClass:self.class];
        NSArray *orders = [orderData omn_decodeOrdersWithError:nil];
        fulfill(orders);
      }];
      
    }];

    
    [table getOrders].then(^(NSArray *orders) {
      
      [[orders should] beNonNil];
      [[@(orders.count) should] beGreaterThan:@(0)];
      
    });
    
  });
  
});

SPEC_END