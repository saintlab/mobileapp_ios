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
    
    _has_menu = [jsonData[@"has_menu"] boolValue];
    _has_promo = [jsonData[@"has_promo"] boolValue];
    _has_waiter_call = [jsonData[@"has_waiter_call"] boolValue];
    _has_bar = [jsonData[@"has_bar"] boolValue];
    _has_pre_order = [jsonData[@"has_pre_order"] boolValue];
    _has_table_order = [jsonData[@"has_table_order"] boolValue];
    _has_lunch = [jsonData[@"has_lunch"] boolValue];
    
#warning 123
//    _has_bar = YES;
//  _has_lunch = YES;
//    _has_pre_order = YES;
//    _has_table_order = YES;
  }
  return self;
}

@end
