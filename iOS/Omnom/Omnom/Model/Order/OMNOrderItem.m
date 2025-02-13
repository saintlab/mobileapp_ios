//
//  GGOrderItem.m
//  seocialtest
//
//  Created by tea on 15.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNOrderItem.h"
#import "OMNUtils.h"

@interface OMNOrderItem ()

@property (nonatomic, copy) NSString *id;

@end

@implementation OMNOrderItem

- (instancetype)initWithJsonData:(id)data {
  self = [super init];
  if (self) {
    
    self.id = [data[@"id"] omn_stringValueSafe];
    self.name = [data[@"title"] omn_stringValueSafe];
    self.price_per_item = [data[@"price_per_item"] doubleValue]*100ll;
    self.price_total = [data[@"price_total"] doubleValue]*100ll;
    self.quantity = [data[@"quantity"] doubleValue];
    self.guest_id = (data[@"guest_id"]) ? (data[@"guest_id"]) : (@"");
    
  }
  return self;
}

- (instancetype)copyWithZone:(NSZone *)zone {
  
  OMNOrderItem *orderItem = [[[self class] allocWithZone:zone] init];
  orderItem.id = self.id;
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

- (NSString *)priceQuantityString {
  NSString *priceQuantityString = nil;
  if (self.quantity != 1.0) {
    
    priceQuantityString = [NSString stringWithFormat:@"%@ x %@", [OMNUtils unitStringFromDouble:self.quantity], [OMNUtils commaStringFromKop:self.price_per_item]];
    
  }
  else {
    
    priceQuantityString = [OMNUtils commaStringFromKop:self.price_total];
    
  }
  return priceQuantityString;
}

@end
