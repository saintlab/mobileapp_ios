//
//  OMNSocketTest.m
//  omnom
//
//  Created by tea on 12.09.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OMNSocketManager.h"
#import "OMNAuthorization.h"
#import <Kiwi.h>

SPEC_BEGIN(OMNSocketTests)

describe(@"check initial state", ^{
  
  beforeEach(^{

    __block NSNumber *_didConnect = nil;
    [[OMNSocketManager manager] disconnectAndLeaveAllRooms:YES];
    [[OMNSocketManager manager] connectWithToken:[OMNAuthorization authorisation].token completion:^{
      _didConnect = @(YES);
    }];
    [[expectFutureValue(_didConnect) shouldEventuallyBeforeTimingOutAfter(10)] equal:@(YES)];
    
  });
  
  afterEach(^{
    
    [[OMNSocketManager manager] disconnectAndLeaveAllRooms:YES];
    
  });
  
  it(@"should check socket room connection", ^{

    [[OMNSocketManager manager] join:nil];
    [[@([OMNSocketManager manager].rooms.count) should] equal:@(0)];
    
    NSString *roomID1 = @"roomID1";
    NSString *roomID2 = @"roomID2";
    
    [[OMNSocketManager manager] join:roomID1];
    [[@([OMNSocketManager manager].rooms.count) should] equal:@(1)];

    [[OMNSocketManager manager] join:roomID1];
    [[@([OMNSocketManager manager].rooms.count) should] equal:@(1)];
    
    [[OMNSocketManager manager] leave:roomID2];
    [[@([OMNSocketManager manager].rooms.count) should] equal:@(1)];

    [[OMNSocketManager manager] join:roomID2];
    [[@([OMNSocketManager manager].rooms.count) should] equal:@(2)];

    [[OMNSocketManager manager] leave:roomID2];
    [[@([OMNSocketManager manager].rooms.count) should] equal:@(1)];
    
    [[OMNSocketManager manager] leave:roomID1];
    [[@([OMNSocketManager manager].rooms.count) should] equal:@(0)];
    
    [[OMNSocketManager manager] join:roomID2];
    [[@([OMNSocketManager manager].rooms.count) should] equal:@(1)];

  });
  
  it(@"shold check disconnection", ^{
    
    NSString *roomID1 = @"roomID1";
    
    [[OMNSocketManager manager] join:roomID1];
    [[@([OMNSocketManager manager].rooms.count) should] equal:@(1)];
    
    [[OMNSocketManager manager] disconnectAndLeaveAllRooms:NO];
    [[@([OMNSocketManager manager].rooms.count) should] equal:@(1)];

    __block NSNumber *_didConnect = nil;
    [[OMNSocketManager manager] connectWithToken:[OMNAuthorization authorisation].token completion:^{
      _didConnect = @(YES);
    }];
    [[expectFutureValue(_didConnect) shouldEventuallyBeforeTimingOutAfter(10)] equal:@(YES)];
    
    [[@([OMNSocketManager manager].rooms.count) should] equal:@(1)];
    
  });
  
});

SPEC_END
