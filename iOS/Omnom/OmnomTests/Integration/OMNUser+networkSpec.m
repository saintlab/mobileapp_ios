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

#define kOMNAuthorizationManagerValidToken @"szJNu4MyKRrqPb0WyD7CE2q3j2llIePo"
#define kOMNAuthorizationManagerInvalidToken @"invalid token"

SPEC_BEGIN(OMNUser_networkSpec)

describe(@"OMNUser+network", ^{

  pending(@"should test at live", nil);
  
  beforeAll(^{
    [OMNAuthorizationManager setupWithURL:@"http://cerberus.staging.saintlab.com" headers:@{}];
  });

  afterAll(^{
    [OMNAuthorizationManager setupWithURL:nil headers:@{}];
  });
  
  OMNUser *(^stubUserWithToken)(NSString *token) = ^OMNUser *(NSString *token) {
    
    id userData = [@"user_with_null_stub.json" omn_jsonObjectNamedForClass:self.class];
    OMNUser *user = [[OMNUser alloc] initWithJsonData:userData[@"user"] token:token];
    return user;
    
  };
  
//  https://github.com/saintlab/backend/blob/omnom/refactoring/README.md#cerberus
  context(@"get user", ^{
    
    it(@"should not get user for invalid token", ^{
      
      __block OMNError *_error = nil;
      [OMNUser userWithToken:kOMNAuthorizationManagerInvalidToken].catch(^(OMNError *error) {
        
        _error = error;
        
      });
      
      [[expectFutureValue(_error) shouldEventuallyBeforeTimingOutAfter(3.0)] beNonNil];
      [[theValue(_error.code) should] equal:theValue(kOMNErrorInvalidUserToken)];
      
    });
    
    it(@"should not get user for nil token", ^{
      
      __block OMNError *_error = nil;
      [OMNUser userWithToken:nil].catch(^(OMNError *error) {
        
        _error = error;
        
      });
      
      [[expectFutureValue(_error) shouldEventuallyBeforeTimingOutAfter(3.0)] beNonNil];
      [[theValue(_error.code) should] equal:theValue(kOMNErrorInvalidUserToken)];
      
    });
    
    it(@"should get user for valid token", ^{
      
      __block OMNUser *_user = nil;
      [OMNUser userWithToken:kOMNAuthorizationManagerValidToken].then(^(OMNUser *user) {
        
        _user = user;
        
      });
      
      [[expectFutureValue(_user) shouldEventuallyBeforeTimingOutAfter(10.0)] beNonNil];
      [[_user.id should] beNonNil];
      [[_user.phone should] beNonNil];
      [[_user.token should] equal:kOMNAuthorizationManagerValidToken];
      
    });
    
  });
  
  context(@"user update", ^{
    
    it(@"should update user with valid token", ^{
      
      NSString * const kUserName = @"test";
      NSString * const kUserEmail = @"test@test.com";
      
      OMNUser *user = stubUserWithToken(kOMNAuthorizationManagerValidToken);
      user.name = kUserName;
      user.email = kUserEmail;
      user.birthDate = [NSDate date];
      
      __block OMNUser *_newUser = nil;
      [user updateUserInfo].then(^(OMNUser *newUser) {
        
        _newUser = newUser;
        
      }).catch(^(OMNError *error) {
        
        [[error should] beNil];
        
      });
      
      [[expectFutureValue(_newUser) shouldEventuallyBeforeTimingOutAfter(10.0)] beNonNil];
      [[_newUser.name should] equal:kUserName];
      [[_newUser.email should] equal:kUserEmail];
      [[_newUser.birthDateString shouldNot] beEmpty];
      
    });

    pending(@"should update birth date and receive it", ^{
      
      OMNUser *user = stubUserWithToken(kOMNAuthorizationManagerValidToken);
      user.birthDate = [NSDate dateWithTimeIntervalSince1970:1000000];
      NSString *birthDateSting = user.birthDateString;
      
      __block OMNUser *_newUser = nil;
      [user updateUserInfo].then(^(OMNUser *newUser) {
        
        _newUser = newUser;
        
      });
      [[expectFutureValue(_newUser) shouldEventuallyBeforeTimingOutAfter(10.0)] beNonNil];
      [[_newUser.birthDateString should] equal:birthDateSting];
      
      _newUser = nil;
      [OMNUser userWithToken:kOMNAuthorizationManagerValidToken].then(^(OMNUser *newUser) {
        
        _newUser = newUser;
        
      });
      [[expectFutureValue(_newUser) shouldEventuallyBeforeTimingOutAfter(10.0)] beNonNil];
      [[_newUser.birthDateString should] equal:birthDateSting];
      
    });
    
    it(@"should not update user with invalid token", ^{
      
      __block OMNError *_error = nil;

      OMNUser *user = stubUserWithToken(kOMNAuthorizationManagerInvalidToken);
      [user updateUserInfo].catch(^(OMNError *error) {
        
        _error = error;
        
      });
      
      [[expectFutureValue(_error) shouldEventuallyBeforeTimingOutAfter(10.0)] beNonNil];
      [[theValue(_error.code) should] equal:theValue(kOMNErrorCodeUnknoun)];
      
    });
    
  });
    
});

SPEC_END
