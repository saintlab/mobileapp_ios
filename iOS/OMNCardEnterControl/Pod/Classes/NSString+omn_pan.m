//
//  NSString+omn_pan.m
//  omnom
//
//  Created by tea on 04.09.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "NSString+omn_pan.h"

NSString * const kMM_YYSeporator = @"/";
const NSInteger kPanGroupLength = 4;

@implementation NSString (omn_pan)

- (BOOL)omn_isValidPan {
  
  if (self.length != 16) {
    return NO;
  }
  
  NSUInteger panLength = self.length;
  NSInteger sum = 0;
  for (NSUInteger loc = 0; loc < panLength; loc++) {
    NSString *character = [self substringWithRange:NSMakeRange(panLength - loc - 1, 1)];
    NSInteger multiply = (loc%2 == 0) ? (1) : (2);
    NSInteger currentNumber = [character integerValue]*multiply;
    
    if (currentNumber > 9) {
      currentNumber-=9;
    }
    sum += currentNumber;
    
  }
  
  BOOL isValidPan = (sum%10 == 0);
  return isValidPan;
}

- (NSString *)omn_decimalString {
  
  NSArray *components = [self componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]];
  NSString *decimalString = [components componentsJoinedByString:@""];
  return decimalString;
  
}

- (NSString *)omn_panFormatedString {
  
  NSString *panString = [self omn_decimalString];
  
  NSMutableArray *panComponents = [NSMutableArray arrayWithCapacity:4];
  for (int component = 0; component < 4; component++) {
    
    NSInteger start = component*kPanGroupLength;
    
    if (start >= panString.length) {
      break;
    }
    
    NSString *componentString = [panString substringWithRange:NSMakeRange(start, MIN(panString.length - start, kPanGroupLength))];
    [panComponents addObject:componentString];
    
  }
  
  return [panComponents componentsJoinedByString:@" "];
  
}

- (NSArray *)omn_dateFormatedComponents {
  
  return nil;
  
}

- (BOOL)omn_isValidDate {
  
  NSArray *components = [self componentsSeparatedByString:kMM_YYSeporator];
  if (components.count != 2) {
    return NO;
  }
  
  NSString *yy = components[1];

  NSInteger year = [yy integerValue];
  
  NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
  NSDateComponents *dateComponents = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit fromDate:[NSDate date]];
  
  if (year < [dateComponents year]%100) {
    return NO;
  }

  NSString *mm = components[0];
  NSInteger month = [mm integerValue];
  
  if (month < [dateComponents month] ||
      month > 12) {
    return NO;
  }
  else {
    return year;
  }
  
}

@end
