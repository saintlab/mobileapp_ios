//
//  GRestaurant.m
//  restaurants
//
//  Created by tea on 13.03.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNRestaurant.h"

NSString * const OMNRestaurantNotificationLaunchKey = @"OMNRestaurantNotificationLaunchKey";

@implementation OMNRestaurant {
  
  id _jsonData;

}

NSString *entranceModeFromString(NSString *string) {

  if (![string isKindOfClass:[NSString class]]) {
    return @"";
  }

  static dispatch_once_t onceToken;
  static NSDictionary *modes = nil;
  dispatch_once(&onceToken, ^{
    modes =
    @{
      @"bar" : kEntranceModeBar,
      @"lunch" : kEntranceModeLunch,
      @"restaurant" : kEntranceModeIn,
      };
  });
  
  if (modes[string]) {
    return modes[string];
  }
  else {
    return string;
  }
  
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

    if ([jsonData[@"entrance_modes"] isKindOfClass:[NSString class]]) {
      _entrance_modes = [jsonData[@"entrance_modes"] componentsSeparatedByString:@","];
    }
    else {
      _entrance_modes = [self entrance_modesFromSettings];
    }
    
    NSString *orders_paid_url = [jsonData[@"orders_paid_url"] omn_stringValueSafe];
    if (orders_paid_url.length) {
      _orders_paid_url = [NSURL URLWithString:orders_paid_url];
    }
    
#if DEBUG
#warning TODO delivery_dates
//    _entrance_mode = kEntranceModeOnTable;
#endif
    
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
  
  if (self.hasOrders || self.hasTable) {
    return YES;
  }
  
  return [@[kEntranceModeBar, kEntranceModeLunch, kEntranceModeTakeAway, kEntranceModeIn] containsObject:self.entrance_mode];
  
}

- (NSString *)description {
  return [NSString stringWithFormat:@"%@, %@", _title, _id];
}

- (NSArray *)entrance_modesFromSettings {
  NSMutableArray *entrance_modes = [NSMutableArray array];
  if (self.settings.has_bar) {
    [entrance_modes addObject:kEntranceModeBar];
  }
  if (self.settings.has_lunch) {
    [entrance_modes addObject:kEntranceModeLunch];
  }
  if (self.settings.has_restaurant_order) {
    [entrance_modes addObject:kEntranceModeIn];
  }
  if (self.settings.has_table_order) {
    [entrance_modes addObject:kEntranceModeOnTable];
  }
  if (self.settings.has_pre_order) {
    [entrance_modes addObject:kEntranceModeTakeAway];
  }
  return [entrance_modes copy];
}

@end
