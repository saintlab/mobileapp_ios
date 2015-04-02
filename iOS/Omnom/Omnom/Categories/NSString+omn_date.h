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

- (BOOL)omn_isTomorrow;

@end
