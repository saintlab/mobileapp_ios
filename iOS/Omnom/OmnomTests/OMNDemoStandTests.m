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
#import "OMNUser.h"
#import "OMNUser+network.h"
#import "NSString+omn_json.h"

SPEC_BEGIN(OMNDemoStandTest)

describe(@"demo stand test", ^{

  __block OMNVisitor *_visitor = nil;
  __block OMNOrder *_order = nil;
  
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

    [OMNUser stub:@selector(userWithToken:user:failure:) withBlock:^id(NSArray *params) {
      
      OMNUserBlock userBlock = params[1];
      id response = [@"user_stub.json" omn_jsonObjectNamedForClass:self.class];
      OMNUser *user = [[OMNUser alloc] initWithJsonData:response[@"user"]];
      userBlock(user);
      return nil;
      
    }];
    
  });
  
  it(@"should check initial conditions", ^{

    
    
    [[_visitor should] beNonNil];

    [[_order should] beNonNil];

    [OMNUser userWithToken:[OMNAuthorisation authorisation].token user:^(OMNUser *user) {
      
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
