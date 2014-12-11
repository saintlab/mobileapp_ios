//
//  OMNCallBillTests.m
//  omnom
//
//  Created by tea on 20.11.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <Kiwi.h>
#import "OMNVisitorManager.h"
#import "OMNAuthorization.h"
#import "OMNOrder+network.h"
#import "NSString+omn_json.h"

SPEC_BEGIN(OMNOrderTests)

describe(@"visitor test", ^{
  
//  __block OMNOrder *_order = nil;
  __block OMNVisitor *_visitor = nil;
  beforeAll(^{
    
    [OMNAuthorization authorisation];
    
    _visitor = [OMNVisitor mock];

    [_visitor stub:@selector(getOrders:error:) withBlock:^id(NSArray *params) {
      
      id orderData = [@"orders_stub.json" omn_jsonObjectNamedForClass:self.class];
      NSArray *orders = [orderData omn_decodeOrdersWithError:nil];
      OMNOrdersBlock ordersBlock = params[1];
      ordersBlock(orders);
      return nil;
      
    }];
    
  });
  
  it(@"should check initial conditions", ^{
    
    [[_visitor should] beNonNil];
    [[[OMNAuthorization authorisation].token should] beNonNil];
    
  });
  
  it(@"should get orders", ^{
    
    [_visitor getOrders:^(NSArray *orders) {
      
      [[orders should] beNonNil];
      [[@(orders.count) should] beGreaterThan:@(0)];
      
    } error:^(NSError *error) {
      
    }];
    
  });
  
/*
  it(@"should get orders", ^{
    
    __block NSArray *_oredrs = nil;
    [_visitor getOrders:^(NSArray *orders) {
      
      _oredrs = orders;
      
    } error:^(NSError *error) {
      
    }];
    
  });
  
  it(@"should create bill", ^{
    
    __block OMNBill *_bill = nil;
    [_order createBill:^(OMNBill *bill) {
      
      _bill = bill;
      
    } failure:^(NSError *error) {
      
    }];
    
#warning    [[expectFutureValue(_bill) shouldEventuallyBeforeTimingOutAfter(10.0)] beNonNil];
#warning    [[_bill.table_id should] equal:_order.table_id];
    
  });
  
  it(@"should call bill", ^{
    
#warning    [[_order should] beNonNil];
    
    __block NSNumber *is_billCall = nil;
    [_order billCall:^{
      
      is_billCall = @(YES);
      
    } failure:^(NSError *error) {
      
    }];
    
#warning    [[expectFutureValue(is_billCall) shouldEventuallyBeforeTimingOutAfter(10.0)] beNonNil];
    
  });
  
  it(@"should stop call bill", ^{
    
#warning    [[_order should] beNonNil];
    
    __block NSNumber *is_billCallStop = nil;
    __block NSError *_error = nil;
    [_order billCallStop:^{
      
      is_billCallStop = @(YES);
      
    } failure:^(NSError *error) {
      
      _error = error;
      NSLog(@"should stop call bill error> %@", error);
    }];
    
    
#warning    [[expectFutureValue(is_billCallStop) shouldEventuallyBeforeTimingOutAfter(10.0)] beNonNil];
#warning    [[expectFutureValue(_error) shouldEventuallyBeforeTimingOutAfter(10.0)] beNil];
    
  });
  */
  
});

SPEC_END