//
//  NSString+omn_date.m
//  omnom
//
//  Created by tea on 02.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "NSString+omn_date.h"

@implementation NSString (omn_date)

- (NSDateFormatter *)omn_dateFormatter {
  
  static NSDateFormatter *dateFormatter = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd/MM/yyyy";
  });
  return dateFormatter;
  
}

- (NSDate *)omn_dateFromddMMyyyy {
  return [[self omn_dateFormatter] dateFromString:self];
}

- (NSString *)omn_localizedWeekday {
  
  NSDate *date = [self omn_dateFromddMMyyyy];
  NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
  NSDateComponents *nextDayComponents = [gregorian components:NSWeekdayCalendarUnit fromDate:date];
  NSDictionary *weekdays =
  @{
    @(1) : kOMN_WEEKDAY_SUNDAY,
    @(2) : kOMN_WEEKDAY_MONDAY,
    @(3) : kOMN_WEEKDAY_TUESDAY,
    @(4) : kOMN_WEEKDAY_WEDNESDAY,
    @(5) : kOMN_WEEKDAY_THURSDAY,
    @(6) : kOMN_WEEKDAY_FRIDAY,
    @(7) : kOMN_WEEKDAY_SATURDAY,
    };
  NSString *displayDateString = weekdays[@(nextDayComponents.weekday)];
  return displayDateString;
  
}

- (NSString *)omn_localizedInWeekday {
  
  NSDate *date = [self omn_dateFromddMMyyyy];
  NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
  NSDateComponents *nextDayComponents = [gregorian components:NSWeekdayCalendarUnit fromDate:date];
  NSDictionary *weekdays =
  @{
    @(1) : kOMN_WEEKDAY_IN_SUNDAY,
    @(2) : kOMN_WEEKDAY_IN_MONDAY,
    @(3) : kOMN_WEEKDAY_IN_TUESDAY,
    @(4) : kOMN_WEEKDAY_IN_WEDNESDAY,
    @(5) : kOMN_WEEKDAY_IN_THURSDAY,
    @(6) : kOMN_WEEKDAY_IN_FRIDAY,
    @(7) : kOMN_WEEKDAY_IN_SATURDAY,
    };
  NSString *displayDateString = weekdays[@(nextDayComponents.weekday)];
  return displayDateString;
  
}

- (BOOL)omn_isTomorrow {

  NSDate *date = [[self omn_dateFormatter] dateFromString:self];
  NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
  
  unsigned components = (NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear);
  NSDateComponents *dayComponents = [gregorian components:components fromDate:date];
  NSDateComponents *todayComponents = [gregorian components:components fromDate:[NSDate date]];

  BOOL dateIsTomorrow =
  (dayComponents.day == todayComponents.day + 1 &&
   dayComponents.month == todayComponents.month &&
   dayComponents.year == todayComponents.year);
  
  return dateIsTomorrow;
  
}

+ (NSString *)omn_takeAfterIntervalString:(NSInteger)minutes {
  
  NSString *text = nil;
  const NSInteger kMinutesInHour = 60;
  if (minutes < kMinutesInHour) {
    text = [NSString stringWithFormat:kOMN_PREORDER_IN_MINUTES_FORMAT, minutes];
  }
  else if (kMinutesInHour == minutes) {
    text = kOMN_PREORDER_IN_HOUR_TEXT;
  }
  else {
    
    static NSNumberFormatter *numberFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      numberFormatter = [NSNumberFormatter new];
      numberFormatter.positiveFormat = @"0.#";
    });
    text = [NSString stringWithFormat:kOMN_PREORDER_IN_HOURS_FORMAT, [numberFormatter stringFromNumber:@((double)minutes/kMinutesInHour)]];
    
  }

  return text;
  
}

@end
