//
//  NSString+omn_date.h
//  omnom
//
//  Created by tea on 02.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (omn_date)

/**
 convert date with format dd/MM/yyyy to localized weekday
 @returns localized weekday
 */
- (NSString *)omn_localizedWeekday;
- (NSString *)omn_localizedInWeekday;
- (NSString *)omn_localizedDate;
- (NSDate *)omn_dateFromddMMyyyy;
- (BOOL)omn_isTomorrow;
+ (NSString *)omn_takeAfterIntervalString:(NSInteger)minutes;

@end
