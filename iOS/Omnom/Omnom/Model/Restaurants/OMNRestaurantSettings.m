//
//  OMNRestaurantSettings.m
//  omnom
//
//  Created by tea on 11.12.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNRestaurantSettings.h"

@implementation OMNRestaurantSettings

- (instancetype)initWithJsonData:(id)jsonData {
  
  if (![jsonData isKindOfClass:[NSDictionary class]]) {
    return nil;
  }
  
  self = [super init];
  if (self) {
    
    self.has_menu = [jsonData[@"has_menu"] boolValue];
    self.has_promo = [jsonData[@"has_promo"] boolValue];
    self.has_waiter_call = [jsonData[@"has_waiter_call"] boolValue];

  }
  return self;
}

@end
