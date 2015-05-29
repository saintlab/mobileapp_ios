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
#import "OMNWish.h"

SPEC_BEGIN(OMNDeliverySpec)

describe(@"OMNDelivery", ^{

  __block OMNRestaurant *_restaurant = nil;
  
  beforeAll(^{
    
    id response = [@"decodeBeacons.json" omn_jsonObjectNamedForClass:self.class];
    NSArray *restaurants = [response[@"restaurants"] omn_restaurants];
    _restaurant = [restaurants firstObject];
    
  });
  
  it(@"should check empty delivery", ^{
    
    OMNDelivery *delivery = [OMNDelivery delivery];
    [[delivery.address should] beNil];
    [[@(delivery.readyForLunch) should] equal:@(NO)];
    [[@(delivery.minutes) should] equal:@(0)];
    [[delivery.parameters should] beNonNil];
    
  });
  
  it(@"should check preorder delivery", ^{
    
    OMNDelivery *delivery = [OMNDelivery deliveryWithAddress:_restaurant.address minutes:15];
    [[delivery.address should] beNonNil];
    [[delivery.address.text should] beKindOfClass:[NSString class]];
    [[@(delivery.readyForLunch) should] equal:@(NO)];
    [[@(delivery.minutes) should] equal:@(15)];
    [[delivery.parameters should] beNonNil];
    
  });
  
  it(@"should check lunch delivery", ^{
    
    OMNDelivery *delivery = [OMNDelivery deliveryWithAddress:_restaurant.address date:@"1/1/2015"];
    [[delivery.address should] beNonNil];
    [[delivery.address.text should] beKindOfClass:[NSString class]];
    [[@(delivery.readyForLunch) should] equal:@(YES)];
    [[@(delivery.minutes) should] equal:@(0)];
    [[delivery.parameters should] beNonNil];
    
  });
  
  context(@"json", ^{
  
    id data = [@"wish_stub.json" omn_jsonObjectNamedForClass:self.class];
    
    it(@"should create delivery with json", ^{
      
      OMNDelivery *delivery = [OMNDelivery deliveryWithJsonData:data[@"comments"]];
      [[delivery.address should] beNonNil];
      [[delivery.address.text should] beKindOfClass:[NSString class]];
      [[delivery.date should] beNonNil];
      [[@(delivery.minutes) should] equal:@(0)];
      
    });
    
  });
  
  
  
});

SPEC_END
