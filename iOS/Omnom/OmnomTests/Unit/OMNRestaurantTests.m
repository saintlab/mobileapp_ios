//
//  OMNCallBillTests.m
//  omnom
//
//  Created by tea on 26.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Kiwi.h>
#import "NSString+omn_json.h"
#import "OMNRestaurant+omn_network.h"

SPEC_BEGIN(OMNRestaurantTests)

describe(@"visitor test", ^{
  
  __block OMNRestaurant *_restaurant = nil;
  
  beforeAll(^{
    
    id response = [@"decodeBeacons.json" omn_jsonObjectNamedForClass:self.class];
    NSArray *restaurants = [response[@"restaurants"] omn_restaurants];
    _restaurant = [restaurants firstObject];
    
  });
  
  it(@"should check restaurants", ^{
    
    [[_restaurant.entrance_modes should] haveCountOf:0];
    [[_restaurant should] beNonNil];
    [[_restaurant.id should] beNonNil];
    [[@(_restaurant.is_demo) should] beNo];
    [[_restaurant.title should] beNonNil];
    [[_restaurant.Description should] beNonNil];
    [[_restaurant.phone should] beNonNil];
    [[@(_restaurant.tables.count) should] equal:@(1)];
    [[@(_restaurant.orders.count) should] equal:@(0)];
    [[_restaurant.decoration should] beNonNil];
    [[_restaurant.address should] beNonNil];
    [[_restaurant.mobile_texts should] beNonNil];
    [[_restaurant.settings should] beNonNil];
    [[_restaurant.schedules should] beNonNil];
    [[_restaurant.info should] beNil];
    
  });

  it(@"should get restaurant info", ^{
    
    [_restaurant advertisement:^(OMNRestaurantInfo *restaurantInfo) {
      
      [[restaurantInfo should] beNonNil];
      [[_restaurant.info should] beNonNil];
      
    } error:^(NSError *error) {
      
    }];
    
  });
  
});

SPEC_END
