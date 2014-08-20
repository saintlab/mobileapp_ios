//
//  OMNFeedItem.m
//  omnom
//
//  Created by tea on 20.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNFeedItem.h"

@implementation OMNFeedItem

- (instancetype)initWithJsonData:(id)jsonData {
  self = [super init];
  if (self) {
    self.title = jsonData[@"title"];
    self.price = jsonData[@"price"];
    self.imageURL = jsonData[@"imageURL"];
    self.Description = jsonData[@"description"];
    self.image = [UIImage imageNamed:@"promo_pic"];
  }
  return self;
}

@end
