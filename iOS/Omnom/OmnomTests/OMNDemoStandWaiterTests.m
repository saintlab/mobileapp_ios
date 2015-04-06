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
  
  __block OMNVisitor *_visitor = nil;
  __block OMNRestaurantMediator *_restaurantMediator = nil;
  
  beforeAll(^{
    
    [[[OMNAuthorization authorisation].token should] beNonNil];
    
    OMNBeacon *demoBeacon = [OMNBeacon demoBeacon];
    
    [OMNRestaurantManager decodeBeacons:@[demoBeacon] withCompletion:^(NSArray *restaurants) {
      
      OMNRestaurant *restaurant = [restaurants firstObject];
      _visitor = [OMNVisitor visitorWithRestaurant:restaurant delivery:[OMNDelivery delivery]];
      
    } failureBlock:^(OMNError *error) {
      
    }];
    
    [[expectFutureValue(_visitor) shouldEventuallyBeforeTimingOutAfter(10.0)] beNonNil];

    _restaurantMediator = [_visitor mediatorWithRootVC:nil];
    
  });
  
  it(@"should check initial conditions", ^{
    
    [[_visitor should] beNonNil];
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
    
    OMNTable *table = _restaurantMediator.table;
    table.waiterIsCalled = NO;
    [table waiterCall];
    [[expectFutureValue(@(table.waiterIsCalled)) shouldEventuallyBeforeTimingOutAfter(10.0f)] equal:@(YES)];
    
  });
  
  it(@"should stop waiter", ^{
    
    OMNTable *table = _restaurantMediator.table;
    table.waiterIsCalled = YES;
    [table waiterCallStop];
    [[expectFutureValue(@(table.waiterIsCalled)) shouldEventuallyBeforeTimingOutAfter(10.0f)] equal:@(NO)];

  });
  
});

SPEC_END