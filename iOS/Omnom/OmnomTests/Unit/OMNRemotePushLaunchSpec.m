//
//  OMNRemotePushLaunchSpec.m
//  omnom
//
//  Created by tea on 01.05.15.
//  Copyright 2015 tea. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "OMNRemotePushLaunch.h"


SPEC_BEGIN(OMNRemotePushLaunchSpec)

describe(@"OMNRemotePushLaunch", ^{

  context(@"creation", ^{
    
    it(@"should handle worng creation", ^{
      
      id info = @[@1];
      OMNLaunch *launch = [[OMNRemotePushLaunch alloc] initWithRemoteNotification:info];
      [[launch should] beNonNil];
      [[launch.openURL should] beNil];
      [[launch.wishID should] beNil];
      [[launch.customConfigName should] equal:kOMNConfigNameProd];
      [[@(launch.showTableOrders) should] equal:@NO];
      [[@(launch.showRecommendations) should] equal:@NO];
      [[@(launch.applicationStartedBackground) should] equal:@NO];
      [[@(launch.shouldReload) should] equal:@NO];
      
    });
    
    it(@"should handle wishID and open_url", ^{
      
      id info =
      @{
        @"wish" : @{@"id":@"1"},
        @"open_url" : @"123",
        @"show_table_orders" : @1,
        @"show_recommendations" : @1,
        };
      OMNLaunch *launch = [[OMNRemotePushLaunch alloc] initWithRemoteNotification:info];
      [[launch should] beNonNil];
      [[launch.openURL should] beNonNil];
      [[launch.wishID should] beNonNil];
      [[launch.customConfigName should] equal:kOMNConfigNameProd];
      [[@(launch.showTableOrders) should] equal:@YES];
      [[@(launch.showRecommendations) should] equal:@YES];
      [[@(launch.applicationStartedBackground) should] equal:@NO];
      [[@(launch.shouldReload) should] equal:@NO];
      
    });
    
    it(@"should handle wrong parameters", ^{
      
      id info =
      @{
        @"wish" : [NSNull null],
        @"open_url" : [NSNull null],
        @"show_table_orders" : [NSNull null],
        @"show_recommendations" : [NSNull null],
        };
      OMNLaunch *launch = [[OMNRemotePushLaunch alloc] initWithRemoteNotification:info];
      [[launch should] beNonNil];
      [[launch.openURL should] beNil];
      [[launch.wishID should] beNil];
      [[launch.customConfigName should] equal:kOMNConfigNameProd];
      [[@(launch.showTableOrders) should] equal:@NO];
      [[@(launch.showRecommendations) should] equal:@NO];
      [[@(launch.applicationStartedBackground) should] equal:@NO];
      [[@(launch.shouldReload) should] equal:@NO];
      
    });
    
  });
  
});

SPEC_END
