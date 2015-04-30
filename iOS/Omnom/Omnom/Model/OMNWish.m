//
//  OMNWith.m
//  omnom
//
//  Created by tea on 28.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNWish.h"
#import <BlocksKit.h>
#import "OMNUtils.h"
#import <OMNStyler.h>

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
    if ([jsonData[@"created_unix"] respondsToSelector:@selector(doubleValue)]) {
      _createdDate = [NSDate dateWithTimeIntervalSince1970:[jsonData[@"created_unix"] doubleValue]];
    }
    
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
#warning TODO: update wish texts
- (NSAttributedString *)statusText {
  return [[NSAttributedString alloc] initWithString:@"Ваш заказ готов" attributes:[OMNUtils textAttributesWithFont:FuturaOSFOmnomRegular(30.0f) textColor:[OMNStyler greenColor] textAlignment:NSTextAlignmentCenter]];
}
- (NSString *)descriptionText {
  return @"Чтобы получить свой заказ, покажите бармену этот экран, или назовите ему номер и пин-код заказа.";
}


@end