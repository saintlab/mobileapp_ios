//
//  OMNRestaurantSchedules.m
//  omnom
//
//  Created by tea on 25.12.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNRestaurantSchedules.h"

@implementation OMNRestaurantSchedules

- (instancetype)initWithJsonData:(id)jsonData {
  
  if (![jsonData isKindOfClass:[NSDictionary class]]) {
    return nil;
  }
  
  self = [super init];
  if (self) {
    
    _work = [[OMNRestaurantSchedule alloc] initWithJsonData:jsonData[@"work"]];
    _breakfast = [[OMNRestaurantSchedule alloc] initWithJsonData:jsonData[@"breakfast"]];
    _lunch = [[OMNRestaurantSchedule alloc] initWithJsonData:jsonData[@"lunch"]];
    
  }
  return self;
}

@end
