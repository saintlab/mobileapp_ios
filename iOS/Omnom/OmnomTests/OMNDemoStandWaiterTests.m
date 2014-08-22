//
//  OMNDemoStandWaiterTests.m
//  omnom
//
//  Created by tea on 22.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Kiwi.h>
#import "OMNDecodeBeaconManager.h"
#import "OMNAuthorisation.h"

SPEC_BEGIN(OMNDemoStandWaiterTests)

describe(@"waiter call tests", ^{
  
  __block OMNDecodeBeacon *_decodeBeacon = nil;
  
  beforeAll(^{
    
    [[[OMNAuthorisation authorisation].token should] beNonNil];
    
    NSString *aCafeUUID = @"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0+A+1";
    __block NSArray *_decodeBeacons = nil;
    
    [[OMNDecodeBeaconManager manager] decodeBeacons:@[@{@"uuid" : aCafeUUID}] success:^(NSArray *decodeBeacons) {
      
      _decodeBeacons = decodeBeacons;
      
    } failure:^(NSError *error) {
      
    }];
    
    [[expectFutureValue(_decodeBeacons) shouldEventuallyBeforeTimingOutAfter(5)] beNonNil];
    
    _decodeBeacon = [_decodeBeacons firstObject];
    [[_decodeBeacon should] beNonNil];
    
    [[_decodeBeacon.uuid should] equal:aCafeUUID];
    
  });
  
  it(@"should new guest", ^{
    
    __block NSNumber *is_new_guest = nil;
    [_decodeBeacon.restaurant newGuestForTableID:_decodeBeacon.table_id completion:^{
      
      is_new_guest = @(YES);
      
    } failure:^(NSError *error) {
      
    }];
    
    [[expectFutureValue(is_new_guest) shouldEventuallyBeforeTimingOutAfter(5)] beNonNil];
    
  });
  
  it(@"should call waiter", ^{
    
    __block NSNumber *is_called = nil;
    [_decodeBeacon.restaurant waiterCallForTableID:_decodeBeacon.table_id completion:^{
      
      is_called = @(YES);
      
    } failure:^(NSError *error) {
      
    } stop:^{
      
    }];
    
    [[expectFutureValue(is_called) shouldEventuallyBeforeTimingOutAfter(5)] beNonNil];
    
  });
  
  it(@"should stop waiter", ^{
    
    __block NSNumber *is_stopped = nil;
    [_decodeBeacon.restaurant waiterCallStopCompletion:^{
      
      is_stopped = @(YES);
      
    } failure:^(NSError *error) {
      
    }];
    [[expectFutureValue(is_stopped) shouldEventuallyBeforeTimingOutAfter(5)] beNonNil];
    
  });
  
});

SPEC_END