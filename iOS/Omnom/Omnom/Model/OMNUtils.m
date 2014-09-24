//
//  OMNUtils.m
//  omnom
//
//  Created by tea on 29.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNUtils.h"

NSString * const kRubleSign = @"\uf5fc";
NSString * const kGroupingSeparator = @" ";

NSString *omnCommaString() {
  static NSString *commaString = nil;
  
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    commaString = [[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator];
  });
  return commaString;
}

@implementation OMNUtils

+(instancetype)manager{
  static id manager = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    manager = [[[self class] alloc] init];
  });
  return manager;
}

+ (NSString *)moneyStringFromKop:(long long)kop {
  
  static NSNumberFormatter *currencyNumberFormatter = nil;
  if (nil == currencyNumberFormatter) {
    currencyNumberFormatter = [self commaNumberFormatter];
    currencyNumberFormatter.numberStyle = kCFNumberFormatterCurrencyStyle;
    currencyNumberFormatter.currencySymbol = kRubleSign;
    currencyNumberFormatter.currencyDecimalSeparator = omnCommaString();
    currencyNumberFormatter.minimumFractionDigits = 0;
    currencyNumberFormatter.maximumFractionDigits = 2;
  }
  return [currencyNumberFormatter stringFromNumber:@(kop/100.)];
}

+ (NSString *)formattedMoneyStringFromKop:(long long)kop {
  static NSNumberFormatter *currencyNumberFormatter = nil;
  if (nil == currencyNumberFormatter) {
    currencyNumberFormatter = [self commaNumberFormatter];
    currencyNumberFormatter.numberStyle = kCFNumberFormatterCurrencyStyle;
    currencyNumberFormatter.currencySymbol = kRubleSign;
    currencyNumberFormatter.currencyDecimalSeparator = omnCommaString();
  }
  currencyNumberFormatter.minimumFractionDigits = (kop%100ll == 0) ? (0) : (2);
  return [currencyNumberFormatter stringFromNumber:@(kop/100.)];
}

+ (NSNumberFormatter *)commaNumberFormatter {
  NSNumberFormatter *commaNumberFormatter = [[NSNumberFormatter alloc] init];
  commaNumberFormatter.locale = [NSLocale currentLocale];
  commaNumberFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"ru"];
  commaNumberFormatter.numberStyle = kCFNumberFormatterDecimalStyle;
  commaNumberFormatter.usesGroupingSeparator = YES;
  commaNumberFormatter.decimalSeparator = omnCommaString();
  commaNumberFormatter.currencyGroupingSeparator = kGroupingSeparator;
  commaNumberFormatter.maximumFractionDigits = 0;
  commaNumberFormatter.minimumFractionDigits = 0;
  commaNumberFormatter.currencySymbol = @"";
  return commaNumberFormatter;
}

+ (NSString *)evenCommaStringFromKop:(long long)kop {
  static NSNumberFormatter *currencyNumberFormatter = nil;
  if (nil == currencyNumberFormatter) {
    currencyNumberFormatter = [self commaNumberFormatter];
  }
  return [currencyNumberFormatter stringFromNumber:@(round(kop/100.))];
}

+ (NSString *)commaStringFromKop:(long long)kop {
  
  static NSNumberFormatter *currencyNumberFormatter = nil;
  if (nil == currencyNumberFormatter) {
    currencyNumberFormatter = [self commaNumberFormatter];
  }
  currencyNumberFormatter.minimumFractionDigits = (kop%100ll == 0) ? (0) : (2);
  return [currencyNumberFormatter stringFromNumber:@(kop/100.)];
}

@end
