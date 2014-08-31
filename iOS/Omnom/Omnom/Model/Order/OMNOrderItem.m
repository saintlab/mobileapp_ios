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
    self.price_per_item = [data[@"price_per_item"] longLongValue]*100L;
    self.price_total = [data[@"price_per_item"] longLongValue]*100L;
    self.quantity = [data[@"quantity"] integerValue];
  }
  return self;
}

- (instancetype)copyWithZone:(NSZone *)zone {
  
  OMNOrderItem *orderItem = [[[self class] allocWithZone:zone] init];
  orderItem.name = self.name;
  orderItem.price_per_item = self.price_per_item;
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
