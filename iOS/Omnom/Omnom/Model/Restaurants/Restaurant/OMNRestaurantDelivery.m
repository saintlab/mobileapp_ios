//
//  OMNRestaurantDelivery.m
//  omnom
//
//  Created by tea on 31.03.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNRestaurantDelivery.h"

@implementation OMNRestaurantDelivery

+ (instancetype)deliveryWithAddress:(OMNRestaurantAddress *)address date:(NSString *)date {
  
  OMNRestaurantDelivery *delivery = [[OMNRestaurantDelivery alloc] init];
  delivery.date = date;
  delivery.address = address;
  return delivery;
  
}

- (BOOL)readyForDelivery {
  
  return
  (self.date != nil) &&
  (self.address != nil);
  
}

- (NSDictionary *)addressData {
  
  return (self.address.jsonData) ?: (@"");
  
}

@end
