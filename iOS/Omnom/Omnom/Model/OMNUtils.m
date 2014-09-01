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
    currencyNumberFormatter = [self commaNumberFormatter];
    currencyNumberFormatter.currencySymbol = kRubleSign;
  }
  
  return [currencyNumberFormatter stringFromNumber:@(kop/100.)];
}

+ (NSNumberFormatter *)commaNumberFormatter {
  NSNumberFormatter *commaNumberFormatter = [[NSNumberFormatter alloc] init];
  commaNumberFormatter.locale = [NSLocale currentLocale];
  commaNumberFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"ru"];
  commaNumberFormatter.numberStyle = kCFNumberFormatterCurrencyStyle;
  commaNumberFormatter.usesGroupingSeparator = YES;
  commaNumberFormatter.minimumFractionDigits = 0;
  commaNumberFormatter.maximumFractionDigits = 2;
  commaNumberFormatter.currencySymbol = @"";
  commaNumberFormatter.currencyDecimalSeparator = @".";
  commaNumberFormatter.currencyGroupingSeparator = @" ";
  return commaNumberFormatter;
}

+ (NSString *)evenCommaStringFromKop:(long long)kop {
  static NSNumberFormatter *currencyNumberFormatter = nil;
  if (nil == currencyNumberFormatter) {
    currencyNumberFormatter = [self commaNumberFormatter];
  }
  return [currencyNumberFormatter stringFromNumber:@(ceil(kop/100.))];
}

+ (NSString *)commaStringFromKop:(long long)kop {
  
  static NSNumberFormatter *currencyNumberFormatter = nil;
  if (nil == currencyNumberFormatter) {
    currencyNumberFormatter = [self commaNumberFormatter];
  }
  
  return [currencyNumberFormatter stringFromNumber:@(kop/100.)];
}

@end
