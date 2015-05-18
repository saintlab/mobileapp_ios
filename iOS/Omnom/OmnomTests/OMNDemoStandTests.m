//
//  OMNDemoStandTests.m
//  omnom
//
//  Created by tea on 21.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Kiwi.h>
#import "OMNAuthorization.h"
#import <OMNMailRuAcquiring.h>
#import "OMNBankCard.h"
#import "OMNUser.h"
#import "OMNUser+network.h"
#import "NSString+omn_json.h"
#import "OMNRestaurantManager.h"
#import "OMNTable+omn_network.h"

SPEC_BEGIN(OMNDemoStandTest)

describe(@"demo stand test", ^{

  __block OMNRestaurant *_restaurant = nil;
  __block OMNOrder *_order = nil;
  
  OMNBeacon *demoBeacon = [OMNBeacon demoBeacon];
  
  beforeAll(^{
    
    [[[OMNAuthorization authorization].token should] beNonNil];
    
    [OMNRestaurantManager decodeBeacons:@[demoBeacon]].then(^(NSArray *restaurants) {
      
      _restaurant = [restaurants firstObject];;
      
    });
    
    [[expectFutureValue(_restaurant) shouldEventuallyBeforeTimingOutAfter(10.0)] beNonNil];

    __block NSArray *_orders = nil;
    [[@(_restaurant.tables.count) should] equal:@(1)];
    OMNTable *table = [_restaurant.tables firstObject];
    
    [table getOrders].then(^(NSArray *orders) {
      
      _orders = orders;
      
    });
    _order = [_orders firstObject];

    [OMNUser stub:@selector(userWithToken:user:failure:) withBlock:^id(NSArray *params) {
      
      OMNUserBlock userBlock = params[1];
      id response = [@"user_stub.json" omn_jsonObjectNamedForClass:self.class];
      OMNUser *user = [[OMNUser alloc] initWithJsonData:response[@"user"]];
      userBlock(user);
      return nil;
      
    }];
    
  });
  
  it(@"should check initial conditions", ^{
    
    [[_restaurant should] beNonNil];

    [OMNUser userWithToken:[OMNAuthorization authorization].token user:^(OMNUser *user) {
      
      [[user should] beNonNil];
      [[user.id should] equal:@"12"];
      [[user.email should] equal:@"teanet@mail.ru"];
      [[user.name should] equal:@"123"];
      [[user.phone should] equal:@"79833087335"];
      
    } failure:^(NSError *error) {
      
    }];
    
    
  });
  
});

SPEC_END
