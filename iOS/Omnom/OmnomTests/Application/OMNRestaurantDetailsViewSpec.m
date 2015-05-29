//
//  OMNRestaurantDetailsViewSpec.m
//  omnom
//
//  Created by tea on 01.05.15.
//  Copyright 2015 tea. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "OMNRestaurantDetailsView.h"


SPEC_BEGIN(OMNRestaurantDetailsViewSpec)

describe(@"OMNRestaurantDetailsView", ^{

  context(@"set restaurant", ^{
    
    it(@"should set empty restaurant", ^{
      
      OMNRestaurantDetailsView *view = [[OMNRestaurantDetailsView alloc] init];
      view.restaurant = nil;
      
    });
    
    it(@"should not crash", ^{
      
      OMNRestaurant *restaurant = [[OMNRestaurant alloc] initWithJsonData:[NSNull null]];
      OMNRestaurantDetailsView *view = [[OMNRestaurantDetailsView alloc] init];
      view.restaurant = restaurant;
      
    });
    
  });
  
  
});

SPEC_END
