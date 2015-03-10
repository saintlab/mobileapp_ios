//
//  OMNCallBillTests.m
//  omnom
//
//  Created by tea on 26.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Kiwi.h>
#import "OMNAuthorization.h"
#import "NSObject+omn_order.h"
#import "NSString+omn_json.h"
#import <OMNBeacon.h>
#import "OMNRestaurantManager.h"
#import "OMNRestaurant+omn_network.h"

SPEC_BEGIN(OMNRestaurantTests)

describe(@"visitor test", ^{
  
  __block OMNBeacon *_demoBeacon = nil;
  
  beforeAll(^{
    
    _demoBeacon = [OMNBeacon demoBeacon];

    
    [OMNRestaurantManager stub:@selector(decodeBeacons:withCompletion:failureBlock:) withBlock:^id(NSArray *params) {
      
      OMNRestaurantsBlock restaurantsBlock = params[1];
      id response = [@"decodeBeacons.json" omn_jsonObjectNamedForClass:self.class];
      NSArray *restaurants = [response omn_restaurants];
      restaurantsBlock(restaurants);
      return nil;
      
    }];
    
  });

  it(@"should check beacon", ^{
    
    [[_demoBeacon should] beNonNil];
    [[_demoBeacon.UUIDString should] beNonNil];
    [[_demoBeacon.major should] beNonNil];
    [[_demoBeacon.minor should] beNonNil];
    
  });
  
  it(@"should check restaurants", ^{
    
    [OMNRestaurantManager decodeBeacons:@[_demoBeacon] withCompletion:^(NSArray *restaurants) {
      
      [[@(restaurants.count) should] equal:@(1)];
      OMNRestaurant *restaurant = [restaurants firstObject];
      
      [[restaurant should] beNonNil];
      [[restaurant.id should] beNonNil];
      [[@(restaurant.is_demo) should] beNo];
      [[restaurant.title should] beNonNil];
      [[restaurant.Description should] beNonNil];
      [[restaurant.phone should] beNonNil];
      [[@(restaurant.tables.count) should] equal:@(1)];
      [[@(restaurant.orders.count) should] equal:@(0)];
      [[restaurant.decoration should] beNonNil];
      [[restaurant.address should] beNonNil];
      [[restaurant.mobile_texts should] beNonNil];
      [[restaurant.settings should] beNonNil];
      [[restaurant.schedules should] beNonNil];
      [[restaurant.info should] beNil];
      
    } failureBlock:^(OMNError *error) {
      
    }];
    
  });

  it(@"should get restaurant info", ^{
    
    [OMNRestaurantManager decodeBeacons:@[_demoBeacon] withCompletion:^(NSArray *restaurants) {
      
      OMNRestaurant *restaurant = [restaurants firstObject];
      [restaurant advertisement:^(OMNRestaurantInfo *restaurantInfo) {

        [[restaurant.info should] beNonNil];
        [[restaurantInfo should] beNonNil];
        
      } error:^(NSError *error) {
        
      }];
      
    } failureBlock:^(OMNError *error) {
      
    }];
    
  });
  
});

SPEC_END
