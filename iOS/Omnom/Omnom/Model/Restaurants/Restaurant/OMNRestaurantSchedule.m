//
//  OMNRestaurantSchedule.m
//  omnom
//
//  Created by tea on 25.12.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNRestaurantSchedule.h"
#import "NSDate+omn_custom.h"

@implementation OMNRestaurantSchedule

- (instancetype)initWithJsonData:(id)jsonData {
  
  if (![jsonData isKindOfClass:[NSDictionary class]]) {
    return nil;
  }
  
  self = [super init];
  if (self) {
    
    NSMutableDictionary *days = [NSMutableDictionary dictionaryWithCapacity:[jsonData count]];
    [jsonData enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {

      OMNRestaurantScheduleDay *day = [[OMNRestaurantScheduleDay alloc] initWithJsonData:obj];
      if (day) {
        days[key] = day;
      }
      
    }];
    
    _days = [days copy];
    _title = jsonData[@"title"];
    NSLog(@"%@", self.title);
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
