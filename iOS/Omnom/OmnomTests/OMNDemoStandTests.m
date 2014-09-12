//
//  OMNDemoStandTests.m
//  omnom
//
//  Created by tea on 21.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Kiwi.h>
#import "OMNAuthorisation.h"
#import "OMNVisitorManager.h"
#import <OMNMailRuAcquiring.h>
#import "OMNOrder+omn_mailru.h"
#import "OMNBankCard.h"

SPEC_BEGIN(OMNDemoStandTest)

describe(@"demo stand test", ^{

  __block OMNVisitor *_visitor = nil;
  __block OMNOrder *_order = nil;
  __block OMNUser *_user = nil;
  
  OMNBeacon *demoBeacon = [OMNBeacon demoBeacon];
  
  beforeAll(^{
    
    [[[OMNAuthorisation authorisation].token should] beNonNil];
    
    [[OMNVisitorManager manager] decodeBeacon:demoBeacon success:^(OMNVisitor *visitor) {
      
      _visitor = visitor;
      
    } failure:^(NSError *error) {
      
    }];
    
    [[expectFutureValue(_visitor) shouldEventuallyBeforeTimingOutAfter(10.0)] beNonNil];

    __block NSArray *_orders = nil;
    [_visitor getOrders:^(NSArray *orders) {
      
      _orders = orders;
      
    } error:^(NSError *error) {
      
    }];
    
    [[expectFutureValue(_orders) shouldEventuallyBeforeTimingOutAfter(10.0)] beNonNil];
    _order = [_orders firstObject];
    
    [OMNUser userWithToken:[OMNAuthorisation authorisation].token user:^(OMNUser *user) {
      
      _user = user;
      
    } failure:^(NSError *error) {
      
    }];
    
    [[expectFutureValue(_user) shouldEventuallyBeforeTimingOutAfter(10.0)] beNonNil];
    
  });
  
  it(@"should check initial conditions", ^{
    
    [[_visitor should] beNonNil];

    [[_order should] beNonNil];

    [[_user.id should] equal:@"1"];
    [[_user.email should] equal:@"egor@saintlab.com"];
    
  });
  
});

SPEC_END
