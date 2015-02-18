//
//  OMNRestaurantSchedule.m
//  omnom
//
//  Created by tea on 25.12.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNRestaurantSchedule.h"
#import "NSDate+omn_custom.h"
#import <BlocksKit.h>

@implementation OMNRestaurantSchedule

- (instancetype)initWithJsonData:(NSDictionary *)jsonData {
  
  if (![jsonData isKindOfClass:[NSDictionary class]]) {
    return nil;
  }
  
  self = [super init];
  if (self) {
    
    _days = [jsonData bk_map:^id(id key, id obj) {
      
      return [[OMNRestaurantScheduleDay alloc] initWithJsonData:obj];
      
    }];
    _title = jsonData[@"title"];

  }
  return self;
}

- (NSString *)fromToText {
  
  NSString *weekday = [[NSDate date] omn_weekDay];
  OMNRestaurantScheduleDay *day = _days[weekday];
  if (!day) {
    return nil;
  }
  
  NSString *fromToText = [NSString stringWithFormat:NSLocalizedString(@"WORKDAY_INTERVAL_TEXT %@ %@", @"c {open_time} до {close_time}"), day.open_time, day.close_time];
  return fromToText;
  
}

@end
