//
//  OMNRestaurantInfo.m
//  omnom
//
//  Created by tea on 13.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNRestaurantInfo.h"
#import "OMNFeedItem.h"

@implementation OMNRestaurantInfo

- (instancetype)initWithJsonData:(id)jsonData {
  self = [super init];
  if (self) {
    self.title = jsonData[@"title"];
    NSArray *rawFeedItems = jsonData[@"feedItems"];
    NSMutableArray *feedItems = [NSMutableArray arrayWithCapacity:rawFeedItems.count];
    [rawFeedItems enumerateObjectsUsingBlock:^(id feedItemData, NSUInteger idx, BOOL *stop) {
      OMNFeedItem *feedItem = [[OMNFeedItem alloc] initWithJsonData:feedItemData];
      [feedItems addObject:feedItem];
    }];
    
    self.feedItems = [feedItems copy];
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
