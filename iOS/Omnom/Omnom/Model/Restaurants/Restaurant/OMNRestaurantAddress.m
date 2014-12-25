//
//  OMNRestaurantAddress.m
//  omnom
//
//  Created by tea on 24.12.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNRestaurantAddress.h"

@implementation OMNRestaurantAddress

- (instancetype)initWithJsonData:(id)jsonData {
  
  if (![jsonData isKindOfClass:[NSDictionary class]]) {
    return nil;
  }
  
  self = [super init];
  if (self) {
    
    self.building = [jsonData[@"building"] description];
    self.city = jsonData[@"city"];
    self.street = jsonData[@"street"];

  }
  return self;
}

@end
