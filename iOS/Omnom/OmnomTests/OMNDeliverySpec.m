//
//  OMNDeliverySpec.m
//  omnom
//
//  Created by tea on 07.04.15.
//  Copyright 2015 tea. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "OMNDelivery.h"
#import "NSString+omn_json.h"
#import "OMNRestaurant+omn_network.h"

SPEC_BEGIN(OMNDeliverySpec)

describe(@"OMNDelivery", ^{

  it(@"should check empty delivery", ^{
    
    OMNDelivery *delivery = [OMNDelivery delivery];
    [[delivery.address should] beNil];
    [[@(delivery.readyForLunch) should] equal:@(NO)];
    [[@(delivery.minutes) should] equal:@(0)];
    [[delivery.parameters should] beNonNil];
    
  });
  
  it(@"should check preorder delivery", ^{
    
    OMNDelivery *delivery = [OMNDelivery deliveryWithMinutes:15];
    [[delivery.address should] beNil];
    [[@(delivery.readyForLunch) should] equal:@(NO)];
    [[@(delivery.minutes) should] equal:@(15)];
    [[delivery.parameters should] beNonNil];
    
  });
  
  it(@"should check lunch delivery", ^{
    
    id response = [@"decodeBeacons.json" omn_jsonObjectNamedForClass:self.class];
    NSArray *restaurants = [response[@"restaurants"] omn_restaurants];
    OMNRestaurant *restaurant = [restaurants firstObject];
    OMNDelivery *delivery = [OMNDelivery deliveryWithAddress:restaurant.address date:@"1/1/2015"];
    [[delivery.address should] beNonNil];
    [[@(delivery.readyForLunch) should] equal:@(YES)];
    [[@(delivery.minutes) should] equal:@(0)];
    [[delivery.parameters should] beNonNil];
    
  });
  
});

SPEC_END
