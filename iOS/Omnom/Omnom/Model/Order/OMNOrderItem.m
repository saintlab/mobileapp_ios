//
//  GGOrderItem.m
//  seocialtest
//
//  Created by tea on 15.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNOrderItem.h"

@implementation OMNOrderItem

- (instancetype)initWithJsonData:(id)data {
  self = [super init];
  if (self) {
    self.name = data[@"title"];
    self.price = [data[@"price_per_item"] doubleValue];
    self.price_total = [data[@"price_per_item"] longLongValue];
    self.quantity = [data[@"quantity"] integerValue];
  }
  return self;
}

- (instancetype)copyWithZone:(NSZone *)zone {
  
  OMNOrderItem *orderItem = [[[self class] allocWithZone:zone] init];
  orderItem.name = self.name;
  orderItem.price = self.price;
  orderItem.selected = self.selected;
  orderItem.icon = self.icon;
  orderItem.quantity = self.quantity;
  orderItem.price_total = self.price_total;
  return orderItem;
}

- (UIImage *)icon {
  return [UIImage imageNamed:@"test_icon"];
}

- (void)changeSelection {
  _selected = !_selected;
}

- (void)deselect {
  _selected = NO;
}

@end
