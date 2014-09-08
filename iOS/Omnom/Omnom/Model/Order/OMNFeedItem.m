//
//  OMNFeedItem.m
//  omnom
//
//  Created by tea on 20.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNFeedItem.h"
#import "OMNAnalitics.h"

@implementation OMNFeedItem {
  id _jsonData;
  BOOL _viewEventLogged;
}

- (instancetype)initWithJsonData:(id)jsonData {
  self = [super init];
  if (self) {
    
    self.title = jsonData[@"title"];
    self.price = jsonData[@"price"];
    self.imageURL = jsonData[@"image"];
    self.Description = jsonData[@"description"];
  }
  return self;
}

- (void)logClickEvent {
//  [[OMNAnalitics analitics] logEvent:@"USER_CLICK_FEED_ITEM" parametrs:_jsonData];
}

- (void)logViewEvent {
  if (!_viewEventLogged) {
    _viewEventLogged = YES;
//    [[OMNAnalitics analitics] logEvent:@"promolist_view" parametrs:_jsonData];
  }
}

@end
