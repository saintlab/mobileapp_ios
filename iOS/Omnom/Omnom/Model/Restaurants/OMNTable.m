//
//  OMNTable.m
//  restaurants
//
//  Created by tea on 14.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNTable.h"

@implementation OMNTable

- (instancetype)initWithJsonData:(id)data {
  self = [super init];
  if (self) {
    self.restaurantId = data[@"restaurantId"];
    self.tableId = data[@"tableId"];
  }
  return self;
}

@end
