//
//  OMNRestaurantSettings.m
//  omnom
//
//  Created by tea on 11.12.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNRestaurantSettings.h"

@implementation OMNRestaurantSettings

- (instancetype)initWithJsonData:(id)jsonData {
  
  if (jsonData &&
      ![jsonData isKindOfClass:[NSDictionary class]]) {
    return nil;
  }
  
  self = [super init];
  if (self) {
    
    _has_menu = [jsonData[@"has_menu"] omn_boolValueSafe];
    _has_promo = [jsonData[@"has_promo"] omn_boolValueSafe];
    _has_waiter_call = [jsonData[@"has_waiter_call"] omn_boolValueSafe];
    _has_bar_tips = [jsonData[@"has_bar_tips"] omn_boolValueSafe];
    
    _has_bar = [jsonData[@"has_bar"] omn_boolValueSafe];
    _has_pre_order = [jsonData[@"has_pre_order"] omn_boolValueSafe];
    _has_table_order = [jsonData[@"has_table_order"] omn_boolValueSafe];
    _has_lunch = [jsonData[@"has_lunch"] omn_boolValueSafe];
    _has_restaurant_order = [jsonData[@"has_restaurant_order"] omn_boolValueSafe];
    
#if DEBUG && !OMN_TEST
#warning demo RestaurantSettings
    _has_bar = YES;
    _has_lunch = YES;
    _has_pre_order = YES;
    _has_table_order = YES;
    _has_restaurant_order = YES;
#endif
    
  }
  return self;
}

@end
