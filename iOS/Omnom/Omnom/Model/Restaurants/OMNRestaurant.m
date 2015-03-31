//
//  GRestaurant.m
//  restaurants
//
//  Created by tea on 13.03.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNRestaurant.h"

NSString * const OMNRestaurantNotificationLaunchKey = @"OMNRestaurantNotificationLaunchKey";
NSString * const OMNRestaurantOrdersDidChangeNotification = @"OMNRestaurantOrdersDidChangeNotification";

@interface OMNRestaurant ()

@property (nonatomic, assign) OMNRestaurantMode entrance_mode;
@property (nonatomic, strong) OMNRestaurantDelivery *delivery;

@end

@implementation OMNRestaurant {
  
  id _jsonData;

}

OMNRestaurantMode entranceModeFromString(NSString *string) {

#warning kRestaurantModeBar
//  return kRestaurantModeLunch;
//  return kRestaurantModeBar;
  
  if (0 == string.length) {
    return kRestaurantModeNone;
  }

  static dispatch_once_t onceToken;
  static NSDictionary *modes = nil;
  dispatch_once(&onceToken, ^{
    modes =
    @{
      @"none" : @(kRestaurantModeNone),
      @"bar" : @(kRestaurantModeBar),
      @"lunch" : @(kRestaurantModeLunch),
      };
  });
  
  OMNRestaurantMode enteranceMode = (OMNRestaurantMode)[modes[string] integerValue];
  return enteranceMode;
  
}

- (instancetype)initWithJsonData:(id)jsonData {
  
  if (![jsonData isKindOfClass:[NSDictionary class]]) {
    return nil;
  }
  
  self = [super init];
  if (self) {
    
    _jsonData = jsonData;
    _id = [jsonData[@"id"] description];
    _is_demo = [jsonData[@"is_demo"] boolValue];
    _available = (jsonData[@"available"]) ? ([jsonData[@"available"] boolValue]) : (YES);
    _entrance_mode = entranceModeFromString(jsonData[@"entrance_mode"]);
    self.title = jsonData[@"title"];
    self.Description = jsonData[@"description"];

    _distance = [jsonData[@"distance"] doubleValue];
    _decoration = [[OMNRestaurantDecoration alloc] initWithJsonData:jsonData[@"decoration"]];
    _mobile_texts = [[OMNPushTexts alloc] initWithJsonData:jsonData[@"mobile_texts"]];
    _settings = [[OMNRestaurantSettings alloc] initWithJsonData:jsonData[@"settings"]];
    _phone = jsonData[@"phone"];
    _address = [[OMNRestaurantAddress alloc] initWithJsonData:jsonData[@"address"]];
    _schedules = [[OMNRestaurantSchedules alloc] initWithJsonData:jsonData[@"schedules"]];
    
    _tables = [jsonData[@"tables"] omn_tables];
    _orders = [jsonData[@"orders"] omn_orders];;
    
    NSString *orders_paid_url = jsonData[@"orders_paid_url"];
    if (orders_paid_url) {
      _orders_paid_url = [NSURL URLWithString:orders_paid_url];
    }
    
    _delivery_dates =
    @[
      @"20/01/2015",
      @"22/01/2015",
      @"23/01/2015",
      @"24/01/2015",
      @"25/01/2015",
      @"26/01/2015",
      @"27/01/2015"
      ];
  }
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  id jsonData = [aDecoder decodeObjectForKey:@"jsonData"];
  self = [self initWithJsonData:jsonData];
  if (self) {
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
  
  [aCoder encodeObject:_jsonData forKey:@"jsonData"];
  
}

- (instancetype)restaurantWithMode:(OMNRestaurantMode)mode {
  
  OMNRestaurant *restaurant = [[[self class] alloc] initWithJsonData:_jsonData];
  restaurant.entrance_mode = mode;
  return restaurant;
  
}

- (instancetype)restaurantWithDelivery:(OMNRestaurantDelivery *)delivery {
  
  OMNRestaurant *restaurant = [[[self class] alloc] initWithJsonData:_jsonData];
  restaurant.delivery = delivery;
  restaurant.entrance_mode = kRestaurantModeLunch;
  return restaurant;
  
}

- (BOOL)hasTable {
  
  return (1 == self.tables.count);
  
}

- (BOOL)hasOrders {
  
  return (self.orders.count > 0);
  
}

- (BOOL)canProcess {
  
  if (!self.available) {
    return NO;
  }
  
  if (self.hasOrders ||
      self.hasTable) {
    
    return YES;
    
  }
  
  if (kRestaurantModeBar == self.entrance_mode ||
      kRestaurantModeLunch == self.entrance_mode ||
      kRestaurantModePreorder == self.entrance_mode) {
    
    return YES;
    
  }

  return NO;
  
}

- (NSString *)description {
  
  return [NSString stringWithFormat:@"%@, %@", _title, _id];
  
}

@end




