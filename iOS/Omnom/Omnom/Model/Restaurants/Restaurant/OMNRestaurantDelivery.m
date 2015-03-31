//
//  OMNRestaurantDelivery.m
//  omnom
//
//  Created by tea on 31.03.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNRestaurantDelivery.h"

@implementation OMNRestaurantDelivery

- (BOOL)readyForDelivery {
  
  return
  (self.date != nil) &&
  (self.address != nil);
  
}

@end
