//
//  OMNRestaurantInfo.m
//  omnom
//
//  Created by tea on 13.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNRestaurantInfo.h"

@implementation OMNRestaurantInfo

- (instancetype)initWithJsonData:(id)jsonData {
  self = [super init];
  if (self) {
    self.title = jsonData[@"title"];
    self.feedItems = jsonData[@"feedItems"];
    
    self.shortItems = [self infoItemsFromData:jsonData[@"shortItems"]];
    self.fullItems = [self infoItemsFromData:jsonData[@"fullItems"]];
    
  }
  return self;
}

- (NSArray *)infoItemsFromData:(id)data {
  
  NSArray *rawItems = data;
  NSMutableArray *items = [NSMutableArray arrayWithCapacity:rawItems.count];
  [rawItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    OMNRestaurantInfoItem *restaurantInfoItem = [[OMNRestaurantInfoItem alloc] initWithJsonData:obj];
    [items addObject:restaurantInfoItem];
  }];
  return [items copy];
  
}

@end
