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
#import "OMNRestaurantMediator.h"

SPEC_BEGIN(OMNDemoStandWaiterTests)

describe(@"waiter call tests", ^{
  
  __block OMNRestaurant *_restaurant = nil;
  __block OMNRestaurantMediator *_restaurantMediator = nil;
  
  beforeAll(^{
    
    [[[OMNAuthorization authorisation].token should] beNonNil];
    
    OMNBeacon *demoBeacon = [OMNBeacon demoBeacon];
    
    [OMNRestaurantManager decodeBeacons:@[demoBeacon] withCompletion:^(NSArray *restaurants) {
      
      _restaurant = [restaurants firstObject];
      
    } failureBlock:^(OMNError *error) {
      
    }];
    
    [[expectFutureValue(_restaurant) shouldEventuallyBeforeTimingOutAfter(10.0)] beNonNil];

    _restaurantMediator = [[OMNRestaurantMediator alloc] initWithRestaurant:_restaurant rootViewController:nil];
    
  });
  
  it(@"should check initial conditions", ^{
    
    [[_restaurant should] beNonNil];
    [[_restaurantMediator should] beNonNil];
    [[_restaurantMediator.table should] beNonNil];
    
  });
  
  it(@"should new guest", ^{
    
    __block NSNumber *is_new_guest = nil;
    [_restaurantMediator.table newGuestWithCompletion:^{
      
      is_new_guest = @(YES);
      
    }];
    [[expectFutureValue(is_new_guest) shouldEventuallyBeforeTimingOutAfter(10.0)] beNonNil];
    
  });
  
  it(@"should call waiter", ^{
    
    _restaurantMediator.waiterIsCalled = NO;
    [_restaurantMediator waiterCallWithCompletion:^{}];
    [[expectFutureValue(@(_restaurantMediator.waiterIsCalled)) shouldEventuallyBeforeTimingOutAfter(10.0f)] equal:@(YES)];
    
  });
  
  it(@"should stop waiter", ^{
    
    _restaurantMediator.waiterIsCalled = YES;
    [_restaurantMediator waiterCallStopWithCompletion:^{}];
    [[expectFutureValue(@(_restaurantMediator.waiterIsCalled)) shouldEventuallyBeforeTimingOutAfter(10.0f)] equal:@(NO)];

  });
  
});

SPEC_END