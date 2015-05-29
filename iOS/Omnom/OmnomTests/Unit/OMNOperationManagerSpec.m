//
//  OMNOperationManagerSpec.m
//  omnom
//
//  Created by tea on 20.05.15.
//  Copyright 2015 tea. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "OMNOperationManager.h"
#import "AFHTTPRequestOperationManager+omn_token.h"

#define kOMNOperationManagerTestToken @"token"
#define kOMNOperationManagerTestURL @"https://omnom.omnom.menu"

SPEC_BEGIN(OMNOperationManagerSpec)

describe(@"OMNOperationManager", ^{

  context(@"initial condition", ^{
    
    beforeAll(^{
      
      [OMNOperationManager setupWithURL:nil headers:nil];
      
    });
    
    it(@"should check initial condition", ^{
      
      [[[OMNOperationManager sharedManager] should] beNil];
      
    });
    
  });

  context(@"setup with token", ^{
    
    it(@"should check initial condition", ^{
      
      [OMNOperationManager setupWithURL:kOMNOperationManagerTestURL headers:@{@"test_header" : @"test_value"}];
      [OMNOperationManager setAuthenticationToken:kOMNOperationManagerTestToken];
      [[[OMNOperationManager sharedManager] should] beNonNil];
      [[[OMNOperationManager sharedManager].baseURL should] equal:[NSURL URLWithString:kOMNOperationManagerTestURL]];
      [[[[OMNOperationManager sharedManager].requestSerializer valueForHTTPHeaderField:kAuthenticationTokenKey] should] equal:kOMNOperationManagerTestToken];
      [[[[OMNOperationManager sharedManager].requestSerializer valueForHTTPHeaderField:@"test_header"] should] equal:@"test_value"];
      
    });
    
    it(@"shouls check reset", ^{
      
      [OMNOperationManager setAuthenticationToken:kOMNOperationManagerTestToken];
      [OMNOperationManager setupWithURL:nil headers:nil];
      [[[OMNOperationManager sharedManager] should] beNil];
      
      [OMNOperationManager setupWithURL:kOMNOperationManagerTestURL headers:nil];
      [[[[OMNOperationManager sharedManager].requestSerializer valueForHTTPHeaderField:kAuthenticationTokenKey] should] equal:kOMNOperationManagerTestToken];
      
    });
    
  });
  
  afterAll(^{
    
    [OMNOperationManager setupWithURL:nil headers:nil];
    
  });
  
});

SPEC_END
