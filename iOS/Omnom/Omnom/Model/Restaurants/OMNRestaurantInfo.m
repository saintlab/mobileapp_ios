//
//  OMNRestaurantInfo.m
//  omnom
//
//  Created by tea on 13.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNRestaurantInfo.h"
#import "OMNFeedItem.h"
#import <BlocksKit.h>

@implementation OMNRestaurantInfo

- (instancetype)initWithJsonData:(id)jsonData {
  self = [super init];
  if (self) {
    self.title = jsonData[@"title"];
    NSArray *rawFeedItems = jsonData[@"feedItems"];
    self.feedItems = [rawFeedItems bk_map:^id(id feedItemData) {
    
      return [[OMNFeedItem alloc] initWithJsonData:feedItemData];
      
    }];
    self.shortItems = [self infoItemsFromData:jsonData[@"shortItems"]];
    self.fullItems = [self infoItemsFromData:jsonData[@"fullItems"]];
    
  }
  return self;
}

- (NSArray *)infoItemsFromData:(id)data {
  
  NSArray *rawItems = data;
  return [rawItems bk_map:^id(id obj) {
    
    return [[OMNRestaurantInfoItem alloc] initWithJsonData:obj];
    
  }];
  
}

@end
