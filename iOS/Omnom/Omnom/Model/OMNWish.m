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

OMNWishStatus wishStatusFromString(NSString *string) {
  if (![string isKindOfClass:[NSString class]]) {
    return kWishStatusUnknown;
  }
  static NSDictionary *statuses = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    statuses =
    @{
      @"ready" : @(kWishStatusReady),
      @"canceled" : @(kWishStatusCanceled),
      };
  });
  return [statuses[string] integerValue];
}

@implementation OMNWish

- (instancetype)initWithJsonData:(id)jsonData; {
  self = [super init];
  if (self) {
    
    _id = [jsonData[@"id"] omn_stringValueSafe];
    _restaurant_id = [jsonData[@"restaurant_id"] omn_stringValueSafe];
    _created = [jsonData[@"created"] omn_stringValueSafe];
    _internal_table_id = [jsonData[@"internal_table_id"] omn_stringValueSafe];
    _person = [jsonData[@"person"] omn_stringValueSafe];
    _phone = [jsonData[@"phone"] omn_stringValueSafe];
    _table_id = [jsonData[@"table_id"] omn_stringValueSafe];
    _status = wishStatusFromString([jsonData[@"status"] omn_stringValueSafe]);
    _orderNumber = [jsonData[@"internal_table_id"] omn_stringValueSafe];
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
    
    _delivery = [OMNDelivery deliveryWithJsonData:jsonData[@"comments"]];
    
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

- (NSAttributedString *)statusText {
  
  NSString *text = @"";
  UIColor *color = [UIColor blackColor];
  if (kWishStatusReady == self.status) {
    text = kOMN_WISH_DONE_TEXT;
    color = [OMNStyler greenColor];
  }
  else if (kWishStatusCanceled) {
    text = kOMN_WISH_CANCELLED_TEXT;
    color = [OMNStyler redColor];
  }
  return [[NSAttributedString alloc] initWithString:text attributes:[OMNUtils textAttributesWithFont:FuturaOSFOmnomRegular(30.0f) textColor:color textAlignment:NSTextAlignmentCenter]];
  
}

- (NSString *)descriptionText {
  
  NSDictionary *descriptionTexts =
  @{
    @(kWishStatusReady) : kOMN_WISH_DONE_DESCRIPTION,
    @(kWishStatusCanceled) : kOMN_WISH_CANCELLED_DESCRIPTION,
    @(kWishStatusUnknown) : @""
    };

  return descriptionTexts[@(self.status)];
  
}

@end