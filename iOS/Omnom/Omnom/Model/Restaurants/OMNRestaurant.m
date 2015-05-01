//
//  GRestaurant.m
//  restaurants
//
//  Created by tea on 13.03.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNRestaurant.h"

NSString * const OMNRestaurantNotificationLaunchKey = @"OMNRestaurantNotificationLaunchKey";

@interface OMNRestaurant ()

@property (nonatomic, assign) OMNRestaurantMode entrance_mode;

@end

@implementation OMNRestaurant {
  
  id _jsonData;

}

OMNRestaurantMode entranceModeFromString(NSString *string) {

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
      @"restaurant" : @(kRestaurantModeIn),
      };
  });
  
  OMNRestaurantMode enteranceMode = (OMNRestaurantMode)[modes[string] integerValue];
  return enteranceMode;
  
}

- (instancetype)initWithJsonData:(id)jsonData {
  
  self = [super init];
  
  if (![jsonData isKindOfClass:[NSDictionary class]]) {
    return self;
  }

  if (self) {
    
    _jsonData = jsonData;
    _id = [jsonData[@"id"] omn_stringValueSafe];
    _is_demo = [jsonData[@"is_demo"] omn_boolValueSafe];
    _available = (jsonData[@"available"]) ? ([jsonData[@"available"] boolValue]) : (YES);
    _entrance_mode = entranceModeFromString([jsonData[@"entrance_mode"] omn_stringValueSafe]);
    _title = [jsonData[@"title"] omn_stringValueSafe];
    _Description = [jsonData[@"description"] omn_stringValueSafe];
    _distance = [jsonData[@"distance"] omn_doubleValueSafe];
    _decoration = [[OMNRestaurantDecoration alloc] initWithJsonData:jsonData[@"decoration"]];
    _mobile_texts = [[OMNPushTexts alloc] initWithJsonData:jsonData[@"mobile_texts"]];
    _settings = [[OMNRestaurantSettings alloc] initWithJsonData:jsonData[@"settings"]];
    _phone = [jsonData[@"phone"] omn_stringValueSafe];
    _address = [[OMNRestaurantAddress alloc] initWithJsonData:jsonData[@"address"]];
    _schedules = [[OMNRestaurantSchedules alloc] initWithJsonData:jsonData[@"schedules"]];
    
    _tables = [jsonData[@"tables"] omn_tables];
    _orders = [jsonData[@"orders"] omn_orders];;
    
    NSString *orders_paid_url = [jsonData[@"orders_paid_url"] omn_stringValueSafe];
    if (orders_paid_url.length) {
      _orders_paid_url = [NSURL URLWithString:orders_paid_url];
    }
    
#warning TODO delivery_dates
//    _entrance_mode = kRestaurantModeNone;
    _delivery_dates =
    @[
      @"1/04/2015",
      @"2/04/2015",
      @"3/04/2015",
      @"4/04/2015",
      @"5/04/2015",
      @"6/04/2015",
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
      kRestaurantModePreorder == self.entrance_mode ||
      kRestaurantModeIn == self.entrance_mode) {
    
    return YES;
    
  }

  return NO;
  
}

- (NSString *)description {
  return [NSString stringWithFormat:@"%@, %@", _title, _id];
}

@end




