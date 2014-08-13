//
//  OMNRestaurantInfoItem.m
//  omnom
//
//  Created by tea on 13.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNRestaurantInfoItem.h"

@implementation OMNRestaurantInfoItem

- (instancetype)initWithJsonData:(id)jsonData {
  self = [super init];
  if (self) {
    self.value = jsonData[@"value"];
    self.title = jsonData[@"title"];
    self.type = typeFromString(jsonData[@"type"]);
  }
  return self;
}

RestaurantInfoItemType typeFromString(NSString *s) {
  
  static NSDictionary *types = nil;
  if (nil == types) {
    types =
    @{
      @"time": @(kRestaurantInfoItemTypeTime),
      @"wifi": @(kRestaurantInfoItemTypeWifi),
      @"address": @(kRestaurantInfoItemTypeAddress),
      @"schedule": @(kRestaurantInfoItemTypeSchedule),
      @"phone": @(kRestaurantInfoItemTypePhone),
      };
  }
  if (0 == s.length) {
    return kRestaurantInfoItemTypeText;
  }
  
  return [types[s] integerValue];
  
}

- (UIImage *)icon {
  UIImage *icon = nil;
  
  switch (self.type) {
    case kRestaurantInfoItemTypeAddress: {
      icon = [UIImage imageNamed:@"map_marker_icon"];
    } break;
    case kRestaurantInfoItemTypePhone: {
      icon = [UIImage imageNamed:@"phone_icon"];
    } break;
    case kRestaurantInfoItemTypeSchedule: {
      icon = [UIImage imageNamed:@"external_link_icon"];
    } break;
    case kRestaurantInfoItemTypeTime: {
      icon = [UIImage imageNamed:@"clock_icon"];
    } break;
    case kRestaurantInfoItemTypeWifi: {
      icon = [UIImage imageNamed:@"wifi_icon"];
    } break;
    case kRestaurantInfoItemTypeText: {
    } break;
  }
  return icon;
}

@end
