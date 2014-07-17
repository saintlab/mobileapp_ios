//
//  GGOrderItem.m
//  seocialtest
//
//  Created by tea on 15.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNOrderItem.h"

@implementation OMNOrderItem

- (instancetype)initWithData:(id)data {
  self = [super init];
  if (self) {
    self.name = data[@"title"];
    self.price = [data[@"pricePerItem"] doubleValue];
  }
  return self;
}

- (instancetype)copyWithZone:(NSZone *)zone {
  
  OMNOrderItem *orderItem = [[[self class] allocWithZone:zone] init];
  orderItem.name = self.name;
  orderItem.price = self.price;
  orderItem.selected = self.selected;
  orderItem.icon = self.icon;
  
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
