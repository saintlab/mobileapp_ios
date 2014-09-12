//
//  OMNSocketTest.m
//  omnom
//
//  Created by tea on 12.09.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OMNSocketManager.h"
#import "OMNAuthorisation.h"
#import <Kiwi.h>

SPEC_BEGIN(OMNSocketTests)

describe(@"check initial state", ^{
  
  beforeAll(^{
  });
  
  
  it(@"should check socket connection", ^{

    __block NSNumber *_didConnect = nil;
    [[OMNSocketManager manager] connectWithToken:[OMNAuthorisation authorisation].token completion:^{
      _didConnect = @(YES);
    }];
    [[expectFutureValue(_didConnect) shouldEventuallyBeforeTimingOutAfter(10)] equal:@(YES)];

  });
  
});

SPEC_END
