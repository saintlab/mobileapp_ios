//
//  OMNCallBillTests.m
//  omnom
//
//  Created by tea on 26.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Kiwi.h>
#import "OMNDecodeBeaconManager.h"
#import "OMNAuthorisation.h"

SPEC_BEGIN(OMNDemoCallBillTests)

describe(@"call bill test", ^{
  
  __block OMNDecodeBeacon *_decodeBeacon = nil;
  __block OMNOrder *_order = nil;
  
  beforeAll(^{
    
    [[[OMNAuthorisation authorisation].token should] beNonNil];
    
    OMNBeacon *aCafeBeacon = [OMNBeacon aCafeBeacon];
    
    [[OMNDecodeBeaconManager manager] decodeBeacon:aCafeBeacon success:^(OMNDecodeBeacon *decodeBeacon) {
      
      _decodeBeacon = decodeBeacon;
      
    } failure:^(NSError *error) {
      
    }];
    
    [[expectFutureValue(_decodeBeacon) shouldEventuallyBeforeTimingOutAfter(5)] beNonNil];
    
    [[_decodeBeacon should] beNonNil];
    
    [[_decodeBeacon.uuid should] equal:aCafeBeacon.UUIDString];
    
    __block NSArray *_oredrs = nil;
    [_decodeBeacon getOrders:^(NSArray *orders) {
      
      _oredrs = orders;
      
    } error:^(NSError *error) {
      
    }];
    
    [[expectFutureValue(_oredrs) shouldEventuallyBeforeTimingOutAfter(5)] beNonNil];
    _order = [_oredrs firstObject];
    
  });
  
  it(@"should create bill", ^{
    
    __block OMNBill *_bill = nil;
    [_order createBill:^(OMNBill *bill) {
      
      _bill = bill;
      
    } failure:^(NSError *error) {
      
    }];
    
    [[expectFutureValue(_bill) shouldEventuallyBeforeTimingOutAfter(5)] beNonNil];
    [[_bill.table_id should] equal:_order.tableId];
    
  });
  
  it(@"should call bill", ^{

    [[_order should] beNonNil];
    
    __block NSNumber *is_billCall = nil;
    [_order billCall:^{
      
      is_billCall = @(YES);
      
    } failure:^(NSError *error) {
      
    }];
    
    [[expectFutureValue(is_billCall) shouldEventuallyBeforeTimingOutAfter(5)] beNonNil];
    
  });
  
  it(@"should stop call bill", ^{
    
    [[_order should] beNonNil];
    
    __block NSNumber *is_billCallStop = nil;
    [_order billCallStop:^{
      
      is_billCallStop = @(YES);
      
    } failure:^(NSError *error) {
      
    }];
    
    [[expectFutureValue(is_billCallStop) shouldEventuallyBeforeTimingOutAfter(5)] beNonNil];
    
  });
  
  
});

SPEC_END
