//
//  OMNDemoStandWaiterTests.m
//  omnom
//
//  Created by tea on 22.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Kiwi.h>
#import "OMNVisitorManager.h"
#import "OMNAuthorisation.h"

SPEC_BEGIN(OMNDemoStandWaiterTests)

describe(@"waiter call tests", ^{
  
  __block OMNVisitor *_visitor = nil;
  
  beforeAll(^{
    
    [[[OMNAuthorisation authorisation].token should] beNonNil];
    
    OMNBeacon *aCafeBeacon = [OMNBeacon aCafeBeacon];
    
    [[OMNVisitorManager manager] decodeBeacon:aCafeBeacon success:^(OMNVisitor *visitor) {
      
      _visitor = visitor;
      
    } failure:^(NSError *error) {
      
    }];
    
    [[expectFutureValue(_visitor) shouldEventuallyBeforeTimingOutAfter(5)] beNonNil];
    
    [[_visitor should] beNonNil];
    
    [[_visitor.beacon.UUIDString should] equal:aCafeBeacon.UUIDString];

  });
  
  it(@"should new guest", ^{
    
    __block NSNumber *is_new_guest = nil;
    [_visitor newGuestWithCompletion:^{
      is_new_guest = @(YES);
    } failure:^(NSError *error) {
      
    }];
    
    [[expectFutureValue(is_new_guest) shouldEventuallyBeforeTimingOutAfter(5)] beNonNil];
    
  });
  
  it(@"should call waiter", ^{
    
    __block NSNumber *is_called = nil;
    [_visitor.restaurant waiterCallForTableID:_visitor.table.id completion:^{
      
      is_called = @(YES);
      
    } failure:^(NSError *error) {
      
    } stop:^{
      
    }];
    
    [[expectFutureValue(is_called) shouldEventuallyBeforeTimingOutAfter(5)] beNonNil];
    
  });
  
  it(@"should stop waiter", ^{
    
    __block NSNumber *is_stopped = nil;
    [_visitor.restaurant waiterCallStopCompletion:^{
      
      is_stopped = @(YES);
      
    } failure:^(NSError *error) {
      
    }];
    [[expectFutureValue(is_stopped) shouldEventuallyBeforeTimingOutAfter(5)] beNonNil];
    
  });
  
});

SPEC_END