//
//  OMNWith.m
//  omnom
//
//  Created by tea on 28.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNWish.h"
#import <BlocksKit.h>

@implementation OMNWish

- (instancetype)initWithJsonData:(id)jsonData {
  self = [super init];
  if (self) {
    
    _id = jsonData[@"id"];
    _restaurant_id = jsonData[@"restaurant_id"];
    _created = jsonData[@"created"];
    _internal_table_id = jsonData[@"internal_table_id"];
    _person = jsonData[@"person"];
    _phone = jsonData[@"phone"];
    _table_id = jsonData[@"table_id"];
    
    _orderNumber = jsonData[@"internal_table_id"];
    _pin = jsonData[@"code"];
    
    NSArray *items = jsonData[@"items"];
    if ([items isKindOfClass:[NSArray class]]) {
      
      _items = [items bk_map:^id(id obj) {
        
        return [[OMNOrderItem alloc] initWithJsonData:obj];
        
      }];
      
    }
    
  }
  return self;
}

- (long long)totalAmount {
  
  __block long long total = 0ll;
  NSArray *items = [_items copy];
  [items enumerateObjectsUsingBlock:^(OMNOrderItem *orderItem, NSUInteger idx, BOOL *stop) {
    
    total += orderItem.price_total;
    
  }];
  
  return total;
}

@end

//curl -X POST  -H 'X-Authentication-Token: Ga7Rc1lBabcEIOoqd8MsSejzsroI01En' -H "Content-Type: application/json" -d '{ "internal_table_id":"2", "items":[{"id":"15ecf053-feea-46ae-ac94-9a4087a724a8-in-saintlab-iiko","quantity":"1", "modifiers": [{"id":"69c53de0-be11-4843-9628-fb1e01c9437e-in-saintlab-iiko","quantity":"1"}  ] }]}' http://omnom.laaaab.com/restaurants/saintlab-iiko/wishes