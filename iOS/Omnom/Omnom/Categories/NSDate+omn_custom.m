//
//  NSDate+omn_custom.m
//  omnom
//
//  Created by tea on 24.12.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "NSDate+omn_custom.h"

@implementation NSDate (omn_custom)

- (NSString *)omn_weekDay {
  
  static NSDictionary *weekDays = nil;
  static NSCalendar *calendar = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [calendar setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];
    weekDays =
    @{
      @(1) : @"sunday",
      @(2) : @"monday",
      @(3) : @"tuesday",
      @(4) : @"wednesday",
      @(5) : @"thursday",
      @(6) : @"friday",
      @(7) : @"saturday",
      };
  });
  
  NSDateComponents *dateComponents = [calendar components:NSWeekdayCalendarUnit|NSDayCalendarUnit fromDate:self];
  NSString *weekday = weekDays[@(dateComponents.weekday)];
  return weekday;
  
}

@end
