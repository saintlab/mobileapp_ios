//
//  OMNRestaurantDelivery.m
//  omnom
//
//  Created by tea on 31.03.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNDelivery.h"

@interface OMNDelivery ()

@property (nonatomic, strong) NSString *type;

@end

@implementation OMNDelivery

- (instancetype)init {
  self = [super init];
  if (self) {
    _type = @"restaurant";
  }
  return self;
}

+ (instancetype)delivery {
  return [[OMNDelivery alloc] init];
}

+ (instancetype)deliveryWithAddress:(OMNRestaurantAddress *)address date:(NSString *)date {
  
  OMNDelivery *delivery = [[OMNDelivery alloc] init];
  delivery.date = date;
  delivery.address = address;
  delivery.type = @"lunch";
  return delivery;
  
}

+ (instancetype)deliveryWithMinutes:(NSInteger)minutes {
  
  OMNDelivery *delivery = [[OMNDelivery alloc] init];
  delivery.minutes = minutes;
  delivery.type = @"pre_order";
  return delivery;

}

- (NSDictionary *)parameters {
  
  NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
  parameters[@"type"] = self.type;
  if (self.address) {
    parameters[@"delivery_address"] = self.addressData;
  }
  if (self.date) {
    parameters[@"delivery_date"] = self.date;
  }
  parameters[@"take_away_interval"] = @(self.minutes);
  return parameters;
  
}

- (BOOL)readyForLunch {
  return (self.date != nil) && (self.address != nil);
}

- (NSDictionary *)addressData {
  return (self.address.jsonData) ?: (@"");
}

@end
