//
//  OMNUser+networkSpec.m
//  omnom
//
//  Created by tea on 28.05.15.
//  Copyright 2015 tea. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "OMNUser+network.h"
#import "OMNAuthorizationManager.h"
#import "OMNAuthorization.h"
#import "NSString+omn_json.h"

#define kOMNAuthorizationManagerToken @"pp1bYBnLolNskiI9lnPcDMe5klb01jAX"

SPEC_BEGIN(OMNUser_networkSpec)

describe(@"OMNUser+network", ^{

  beforeAll(^{
    [[OMNAuthorization authorization] stub:@selector(token) andReturn:kOMNAuthorizationManagerToken];
    [OMNAuthorizationManager setupWithURL:@"http://cerberus.staging.saintlab.com" headers:@{}];
  });
  
  afterAll(^{
    [[OMNAuthorization authorization] clearStubs];
    [OMNAuthorizationManager setupWithURL:nil headers:@{}];
  });
  
//  https://github.com/saintlab/backend/blob/omnom/refactoring/README.md#cerberus
  context(@"get user", ^{
    
    it(@"should get user", ^{
      
      __block OMNUser *_user = nil;
      [OMNUser userWithToken:[OMNAuthorization authorization].token].then(^(OMNUser *user) {
        
        _user = user;
        
      });
      
      [[expectFutureValue(_user) shouldEventuallyBeforeTimingOutAfter(5.0)] beNonNil];
      [[_user.id should] beNonNil];
      [[_user.phone should] beNonNil];
      
    });
    
  });
  
  context(@"user update", ^{
    
    it(@"should update user", ^{
      
      NSString * const kUserName = @"test";
      NSString * const kUserEmail = @"test@test.com";
      
      id userData = [@"user_with_null_stub.json" omn_jsonObjectNamedForClass:self.class];
      OMNUser *user = [[OMNUser alloc] initWithJsonData:userData[@"user"]];
      user.name =kUserName;
      user.email = kUserEmail;
      
      __block OMNUser *_newUser = nil;
      [user updateUserInfo].then(^(OMNUser *newUser) {

        _newUser = newUser;
        
      }).catch(^(OMNError *error) {
        
        [[error should] beNil];
        
      });
      
      [[expectFutureValue(_newUser) shouldEventuallyBeforeTimingOutAfter(5.0)] beNonNil];
      [[_newUser.name should] equal:kUserName];
      [[_newUser.email should] equal:kUserEmail];
      
    });
    
  });
  
});

SPEC_END
