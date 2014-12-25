//
//  OMNRestaurantScheduleDay.m
//  omnom
//
//  Created by tea on 25.12.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNRestaurantScheduleDay.h"

@implementation OMNRestaurantScheduleDay

- (instancetype)initWithJsonData:(id)jsonData {
  
  if (![jsonData isKindOfClass:[NSDictionary class]]) {
    return nil;
  }
  
  self = [super init];
  if (self) {
    
    _open_time = jsonData[@"open_time"];
    _close_time = jsonData[@"close_time"];
    _is_closed = [jsonData[@"is_closed"] boolValue];
    
  }
  return self;
}

@end
