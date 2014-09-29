//
//  OMNCallBillTests.m
//  omnom
//
//  Created by tea on 26.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Kiwi.h>
#import "OMNVisitorManager.h"
#import "OMNAuthorisation.h"
#import "OMNOrder+network.h"

SPEC_BEGIN(OMNDemoCallBillTests)

describe(@"call bill test", ^{
  
  __block OMNVisitor *_visitor = nil;
  __block OMNOrder *_order = nil;
  
  beforeAll(^{
    
    [[[OMNAuthorisation authorisation].token should] beNonNil];
    
    OMNBeacon *demoBeacon = [OMNBeacon demoBeacon];
    
    [[demoBeacon should] beNil];
    
    [[OMNVisitorManager manager] decodeBeacon:demoBeacon success:^(OMNVisitor *visitor) {
      
      _visitor = visitor;
      
    } failure:^(NSError *error) {
      
    }];
    
    [[expectFutureValue(_visitor) shouldEventuallyBeforeTimingOutAfter(10.0)] beNonNil];
    
    [[_visitor should] beNonNil];
    
    [[_visitor.beacon.UUIDString should] equal:demoBeacon.UUIDString];
    
    __block NSArray *_oredrs = nil;
    [_visitor getOrders:^(NSArray *orders) {
      
      _oredrs = orders;
      
    } error:^(NSError *error) {
      
    }];
    
    [[expectFutureValue(_oredrs) shouldEventuallyBeforeTimingOutAfter(10.0)] beNonNil];
    _order = [_oredrs firstObject];
    
  });
  
  it(@"should create bill", ^{
    
    __block OMNBill *_bill = nil;
    [_order createBill:^(OMNBill *bill) {
      
      _bill = bill;
      
    } failure:^(NSError *error) {
      
    }];
    
    [[expectFutureValue(_bill) shouldEventuallyBeforeTimingOutAfter(10.0)] beNonNil];
    [[_bill.table_id should] equal:_order.table_id];
    
  });
  
  it(@"should call bill", ^{

    [[_order should] beNonNil];
    
    __block NSNumber *is_billCall = nil;
    [_order billCall:^{
      
      is_billCall = @(YES);
      
    } failure:^(NSError *error) {
      
    }];
    
    [[expectFutureValue(is_billCall) shouldEventuallyBeforeTimingOutAfter(10.0)] beNonNil];
    
  });
  
  it(@"should stop call bill", ^{
    
    [[_order should] beNonNil];
    
    __block NSNumber *is_billCallStop = nil;
    __block NSError *_error = nil;
    [_order billCallStop:^{
      
      is_billCallStop = @(YES);
      
    } failure:^(NSError *error) {
      
      _error = error;
      NSLog(@"should stop call bill error> %@", error);
    }];
    
    
    [[expectFutureValue(is_billCallStop) shouldEventuallyBeforeTimingOutAfter(10.0)] beNonNil];
    [[expectFutureValue(_error) shouldEventuallyBeforeTimingOutAfter(10.0)] beNil];
    
  });
  
  
});

SPEC_END
