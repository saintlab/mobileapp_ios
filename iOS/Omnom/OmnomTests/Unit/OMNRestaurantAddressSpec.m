//
//  OMNRestaurantAddressSpec.m
//  omnom
//
//  Created by tea on 18.05.15.
//  Copyright 2015 tea. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "OMNRestaurantAddress.h"


SPEC_BEGIN(OMNRestaurantAddressSpec)

describe(@"OMNRestaurantAddress", ^{
  
  context(@"create", ^{

    id jsonData =
    @{
      @"name" : @"name",
      @"building" : @"1",
      @"city" : @"omsk",
      @"street" : @"street",
      @"floor" : @"1",
      };

    it(@"should create", ^{
      
      OMNRestaurantAddress *address = [[OMNRestaurantAddress alloc] initWithJsonData:jsonData];
      [[address should] beNonNil];
      [[address.name should] equal:@"name"];
      [[address.building should] equal:@"1"];
      [[address.city should] equal:@"omsk"];
      [[address.street should] equal:@"street"];
      [[address.floor should] equal:@"1"];
      [[address.jsonData should] beNonNil];
      [[address.text should] beKindOfClass:[NSString class]];
      
    });
    
  });
  
});

SPEC_END
