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
#import "OMNAuthorization.h"

SPEC_BEGIN(OMNDemoStandWaiterTests)

describe(@"waiter call tests", ^{
  
  __block OMNVisitor *_visitor = nil;
  
  beforeAll(^{
    
    [[[OMNAuthorization authorisation].token should] beNonNil];
    
    OMNBeacon *demoBeacon = [OMNBeacon demoBeacon];
    
    [[OMNVisitorManager manager] decodeBeacon:demoBeacon success:^(OMNVisitor *visitor) {
      
      _visitor = visitor;
      
    } failure:^(NSError *error) {
      
    }];
    
    [[expectFutureValue(_visitor) shouldEventuallyBeforeTimingOutAfter(10.0)] beNonNil];
    
    [[_visitor should] beNonNil];
    
    [[_visitor.beacon.UUIDString should] equal:demoBeacon.UUIDString];

  });
  
  it(@"should new guest", ^{
    
    __block NSNumber *is_new_guest = nil;
    [_visitor newGuestWithCompletion:^{
      is_new_guest = @(YES);
    } failure:^(NSError *error) {
      
    }];
    
    [[expectFutureValue(is_new_guest) shouldEventuallyBeforeTimingOutAfter(10.0)] beNonNil];
    
  });
  
  it(@"should call waiter", ^{
    
    _visitor.waiterIsCalled = NO;
    [_visitor waiterCallWithFailure:^(NSError *error) {
    }];
    [[expectFutureValue(@(_visitor.waiterIsCalled)) shouldEventuallyBeforeTimingOutAfter(10.0f)] equal:@(YES)];
                        
  });
  
  it(@"should stop waiter", ^{
    
    _visitor.waiterIsCalled = YES;
    [_visitor waiterCallStopWithFailure:^(NSError *error) {
      
    }];
    [[expectFutureValue(@(_visitor.waiterIsCalled)) shouldEventuallyBeforeTimingOutAfter(10.0f)] equal:@(NO)];

  });
  
});

SPEC_END