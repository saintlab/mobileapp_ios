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
#import <OHHTTPStubs.h>
#import "NSString+omn_json.h"
#import "OMNAuthorizationManager.h"
SPEC_BEGIN(OMNUserSpec)

describe(@"OMNUser", ^{
  
  beforeAll(^{
    
    [OMNAuthorizationManager setupWithURL:@"https://wicket.omnom.menu"];
    
  });
  
  afterAll(^{
    
    [OMNAuthorizationManager setupWithURL:nil];
    
  });
  
  it(@"should get user with valid token", ^{
    
    __block id stub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
      return [request.URL.lastPathComponent isEqualToString:@"user"];
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
      id response = [@"user_stub.json" omn_jsonObjectNamedForClass:self.class];
      return [OHHTTPStubsResponse responseWithJSONObject:response statusCode:200 headers:@{}];
    }];
    
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
