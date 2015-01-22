//
//  GMenuItem.m
//  restaurants
//
//  Created by tea on 13.03.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNMenuProduct.h"

@implementation OMNMenuProduct

- (instancetype)initWithJsonData:(id)data {
  self = [super init];
  if (self) {
    self.internalId = data[@"internalId"];
    self.title = data[@"title"];
    self.price = [data[@"price"] doubleValue];
    self.parent = data[@"parent"];
    self.image = data[@"image"];    
  }
  return self;
}

@end