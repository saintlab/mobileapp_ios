//
//  OMNDemoStandWaiterTests.m
//  omnom
//
//  Created by tea on 22.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Kiwi.h>
#import "OMNRestaurantManager.h"
#import "OMNAuthorization.h"
#import "OMNTable+omn_network.h"

SPEC_BEGIN(OMNDemoStandWaiterTests)

describe(@"waiter call tests", ^{
  
  __block OMNRestaurant *_restaurant = nil;
  
  beforeAll(^{
    
    [[[OMNAuthorization authorisation].token should] beNonNil];
    
    OMNBeacon *demoBeacon = [OMNBeacon demoBeacon];
    
    [OMNRestaurantManager decodeBeacons:@[demoBeacon] withCompletion:^(NSArray *restaurants) {
      
      _restaurant = [restaurants firstObject];
      
    } failureBlock:^(OMNError *error) {
      
    }];
    
    [[expectFutureValue(_restaurant) shouldEventuallyBeforeTimingOutAfter(10.0)] beNonNil];

  });
  
  it(@"should new guest", ^{
    
    OMNTable *table = [_restaurant.tables firstObject];
    __block NSNumber *is_new_guest = nil;
    [table newGuestWithCompletion:^{
      
      is_new_guest = @(YES);
      
    }];
    [[expectFutureValue(is_new_guest) shouldEventuallyBeforeTimingOutAfter(10.0)] beNonNil];
    
  });
  
  it(@"should call waiter", ^{
#warning should call waiter
//    _visitor.waiterIsCalled = NO;
//    [_visitor waiterCallWithFailure:^(NSError *error) {
//    }];
//    [[expectFutureValue(@(_visitor.waiterIsCalled)) shouldEventuallyBeforeTimingOutAfter(10.0f)] equal:@(YES)];
    
  });
  
  it(@"should stop waiter", ^{
    
#warning should stop waiter
//    _visitor.waiterIsCalled = YES;
//    [_visitor waiterCallStopWithFailure:^(NSError *error) {
//      
//    }];
//    [[expectFutureValue(@(_visitor.waiterIsCalled)) shouldEventuallyBeforeTimingOutAfter(10.0f)] equal:@(NO)];

  });
  
});

SPEC_END