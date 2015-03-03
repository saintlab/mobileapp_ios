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

@implementation OMNRestaurant {
  
  id _jsonData;

}

OMNRestaurantMode enteranceModeFromString(NSString *string) {

//#warning kRestaurantMode2gis_dinner
//  return kRestaurantMode2gis_dinner;
//  
  OMNRestaurantMode enteranceMode = kRestaurantModeNone;
  
  if (string.length) {
    return enteranceMode;
  }
  
  static dispatch_once_t onceToken;
  static NSDictionary *modes = nil;
  dispatch_once(&onceToken, ^{
    modes =
    @{
      @"none" : @(kRestaurantModeNone),
      @"bar" : @(kRestaurantModeBar),
      @"2gis_dinner" : @(kRestaurantMode2gis_dinner),
      };
  });
  
  enteranceMode = [modes[string] integerValue];
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
    _enterance_mode = enteranceModeFromString(jsonData[@"enterance_mode"]);
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

- (NSString *)description {
  
  return [NSString stringWithFormat:@"%@, %@", _title, _id];
  
}

@end




