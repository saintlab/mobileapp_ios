//
//  OMNGuest.m
//  omnom
//
//  Created by tea on 10.10.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNGuest.h"
#import <BlocksKit.h>

@implementation OMNGuest

- (instancetype)initWithID:(NSString *)id index:(NSInteger)index orderItems:(NSArray *)orderItems {
  self = [super init];
  if (self) {
    self.id = id;
    _index = index;
    _items = orderItems;
    _selected = NO;
  }
  return self;
}

- (BOOL)hasSelectedItems {
  
  BOOL hasSelectedItems = [_items bk_any:^BOOL(OMNOrderItem *orderItem) {
    
    return orderItem.selected;
    
  }];
  return hasSelectedItems;
  
}

- (BOOL)hasProducts {
  
  return (self.items.count > 0);
  
}

- (void)deselectAllItems {
  
  [_items enumerateObjectsUsingBlock:^(OMNOrderItem *orderItem, NSUInteger idx, BOOL *stop) {
    
    orderItem.selected = NO;
    
  }];
  
}

- (long long)total {
  return [self totalForSelectedItems:NO];
}

- (long long)selectedItemsTotal {
  return [self totalForSelectedItems:YES];
}

- (long long)totalForSelectedItems:(BOOL)selectedItems {
  
  __block long long total = 0.;
  [_items enumerateObjectsUsingBlock:^(OMNOrderItem *orderItem, NSUInteger idx, BOOL *stop) {
    
    if (NO == selectedItems ||
        orderItem.selected) {
      total += orderItem.price_total;
    }
    
  }];
  
  return total;
  
}

- (void)setSelected:(BOOL)selected {
  _selected = selected;
  
  [_items enumerateObjectsUsingBlock:^(OMNOrderItem *orderItem, NSUInteger idx, BOOL *stop) {
    orderItem.selected = selected;
  }];
  
}

@end
