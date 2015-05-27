//
//  OMNUserSpec.m
//  omnom
//
//  Created by tea on 19.05.15.
//  Copyright 2015 tea. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "OMNUser.h"
#import "OMNUser+network.h"
#import "NSString+omn_json.h"
#import "OMNAuthorizationManager.h"
#import "OHHTTPStubs+omn_helpers.h"

SPEC_BEGIN(OMNUserSpec)

describe(@"OMNUser", ^{
  
  beforeAll(^{
    
    [OMNAuthorizationManager setupWithURL:@"https://wicket.omnom.menu" headers:nil];
    
  });
  
  afterAll(^{
    
    [OMNAuthorizationManager setupWithURL:nil headers:nil];
    
  });
  
  context(@"zero user fields", ^{
    
    it(@"should parse user with zero fields", ^{
      
      __block id stub = [OHHTTPStubs omn_stubPath:@"user" jsonFile:@"user_with_null_stub.json"];
      [OMNUser userWithToken:@"valid token"].then(^(OMNUser *user) {
        
        [[user should] beNonNil];
        [[user.id should] equal:@"2"];
        [[user.email should] equal:@""];
        [[user.name should] equal:@""];
        [[user.phone should] equal:@"79833087335"];
        [[user.birthDate should] beNil];
        
      }).catch(^(OMNError *error) {
        
        [[error should] beNil];
        
      }).finally(^{
        
        [OHHTTPStubs removeStub:stub];
        stub = nil;
        
      });
      
      [[expectFutureValue(stub) shouldEventually] beNil];
      
    });
    
  });
  
  it(@"should get user with valid token", ^{
    
    __block id stub = [OHHTTPStubs omn_stubPath:@"user" jsonFile:@"user_stub.json"];
    [OMNUser userWithToken:@"valid token"].then(^(OMNUser *user) {
      
      [[user should] beNonNil];
      [[user.id should] equal:@"12"];
      [[user.email should] equal:@"teanet@mail.ru"];
      [[user.name should] equal:@"123"];
      [[user.phone should] equal:@"79833087335"];
      
    }).catch(^(OMNError *error) {
      
      [[error should] beNil];
      
    }).finally(^{
      
      [OHHTTPStubs removeStub:stub];
      stub = nil;
      
    });
    
    [[expectFutureValue(stub) shouldEventually] beNil];
    
  });
  
  it(@"should catch invalid token", ^{
    
    [OMNUser userWithToken:nil].then(^(OMNUser *user) {

      [[user should] beNil];
      
    }).catch(^(OMNError *error) {
      
      [[error should] beNonNil];
      [[@(error.code) should] equal:@(kOMNErrorNoUserToken)];
      
    });
    
  });
  
});

SPEC_END
