//
//  OMNTravelersLaunch.m
//  omnom
//
//  Created by tea on 20.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNTravelersLaunch.h"
#import "OMNRestaurant+omn_network.h"

@implementation OMNTravelersLaunch

- (NSString *)customConfigName {
  return @"config_staging";
}

- (PMKPromise *)getRestaurants {

  return [PMKPromise new:^(PMKFulfiller fulfill, PMKRejecter reject) {
    
    [OMNRestaurant restaurantWithID:@"travelerscoffee-nsk-at-karla-marksa-7" withCompletion:^(OMNRestaurant *restaurant) {
      
      fulfill(@[restaurant]);
      
    } failure:^(OMNError *error) {
      
      fulfill(nil);
      
    }];
    
  }];
  
}

@end
