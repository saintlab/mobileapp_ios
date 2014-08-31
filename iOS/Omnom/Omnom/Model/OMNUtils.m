//
//  OMNUtils.m
//  omnom
//
//  Created by tea on 29.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNUtils.h"

//NSString * const kRubleSign = @"";
NSString * const kRubleSign = @"\uf5fc";
NSString * const kCommaString = @".";

@implementation OMNUtils

+ (NSString *)moneyStringFromKop:(long long)kop {
  
  static NSNumberFormatter *currencyNumberFormatter = nil;
  if (nil == currencyNumberFormatter) {
    currencyNumberFormatter = [[NSNumberFormatter alloc] init];
    currencyNumberFormatter.locale = [NSLocale currentLocale];
    currencyNumberFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"ru"];
    currencyNumberFormatter.numberStyle = kCFNumberFormatterCurrencyStyle;
    currencyNumberFormatter.usesGroupingSeparator = YES;
    currencyNumberFormatter.minimumFractionDigits = 0;
    currencyNumberFormatter.maximumFractionDigits = 2;
    currencyNumberFormatter.currencySymbol = kRubleSign;
    currencyNumberFormatter.currencyDecimalSeparator = @".";
    currencyNumberFormatter.currencyGroupingSeparator = @" ";
  }
  
  return [currencyNumberFormatter stringFromNumber:@(kop/100.)];
}

+ (NSString *)commaStringFromKop:(long long)kop {
  
  static NSNumberFormatter *currencyNumberFormatter = nil;
  if (nil == currencyNumberFormatter) {
    currencyNumberFormatter = [[NSNumberFormatter alloc] init];
    currencyNumberFormatter.locale = [NSLocale currentLocale];
    currencyNumberFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"ru"];
    currencyNumberFormatter.numberStyle = kCFNumberFormatterCurrencyStyle;
    currencyNumberFormatter.usesGroupingSeparator = YES;
    currencyNumberFormatter.minimumFractionDigits = 0;
    currencyNumberFormatter.maximumFractionDigits = 2;
    currencyNumberFormatter.currencySymbol = @"";
    currencyNumberFormatter.currencyDecimalSeparator = @".";
    currencyNumberFormatter.currencyGroupingSeparator = @" ";
  }
  
  return [currencyNumberFormatter stringFromNumber:@(kop/100.)];
}

@end
