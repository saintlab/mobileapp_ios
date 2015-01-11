//
//  OMNRestaurantMediatorTests1.m
//  omnom
//
//  Created by tea on 11.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Kiwi.h>
#import "OMNAuthorization.h"
#import "NSString+omn_json.h"
#import "OMNRestaurant+omn_network.h"
#import "OMNRestaurantMediator.h"

SPEC_BEGIN(OMNRestaurantMediatorTests)

describe(@"visitor test", ^{
  
  __block OMNRestaurant *_restaurant = nil;
  
  beforeAll(^{
    
    id restaurantsData = [@"decodeBeacons.json" omn_jsonObjectNamedForClass:self.class];
    NSArray *restaurants = [restaurantsData omn_restaurants];
    _restaurant = [restaurants firstObject];
    
  });
  
});

SPEC_END
