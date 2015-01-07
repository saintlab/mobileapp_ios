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
#import "OMNOrder+network.h"
#import "NSString+omn_json.h"
#import <OMNBeacon.h>

SPEC_BEGIN(OMNVisitorTests)

describe(@"visitor test", ^{
  
  __block OMNBeacon *_demoBeacon = nil;
  
  beforeAll(^{
    
    _demoBeacon = [OMNBeacon demoBeacon];

#warning visitor test
//    OMNVisitorManager *visitorManager = [OMNVisitorManager manager];
//    
//    [visitorManager stub:@selector(decodeBeacon:success:failure:) withBlock:^id(NSArray *params) {
//      
//      OMNVisitorBlock visitorBlock = params[1];
//
//      id response = [@"visitors_stub.json" omn_jsonObjectNamedForClass:self.class];
//      NSArray *visitors = [response omn_visitors];
//      visitorBlock([visitors firstObject]);
//      return nil;
//      
//    }];
    
  });

  it(@"should check beacon", ^{
    
    [[_demoBeacon should] beNonNil];
    [[_demoBeacon.UUIDString should] beNonNil];
    [[_demoBeacon.major should] beNonNil];
    [[_demoBeacon.minor should] beNonNil];
    
  });
  
  it(@"should check visitor", ^{
    
    #warning should check visitor
//    [[OMNVisitorManager manager] decodeBeacon:_demoBeacon success:^(OMNVisitor *visitor) {
//      
//      [[visitor should] beNonNil];
//      [[visitor.id should] beNonNil];
//      [[@(visitor.waiterIsCalled) should] equal:@(NO)];
//      [[@(visitor.expired) should] equal:@(NO)];
//      
//    } failure:^(NSError *error) {
//      
//    }];
    
  });

});

SPEC_END
