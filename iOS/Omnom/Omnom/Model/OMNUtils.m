//
//  OMNUtils.m
//  omnom
//
//  Created by tea on 29.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNUtils.h"

@implementation OMNUtils

+ (NSString *)moneyStringFromKop:(long long)kop {
  
  static NSNumberFormatter *currencyNumberFormatter = nil;
  if (nil == currencyNumberFormatter) {
    currencyNumberFormatter = [[NSNumberFormatter alloc] init];
    currencyNumberFormatter.locale = [NSLocale currentLocale];
    currencyNumberFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"ru"];
    currencyNumberFormatter.numberStyle = kCFNumberFormatterCurrencyStyle;
    currencyNumberFormatter.usesGroupingSeparator = YES;
    currencyNumberFormatter.minimumFractionDigits = 2;
    currencyNumberFormatter.maximumFractionDigits = 2;
    currencyNumberFormatter.currencySymbol = @"Р";
    currencyNumberFormatter.currencyGroupingSeparator = @" ";
  }
  
  return [currencyNumberFormatter stringFromNumber:@(kop/100.)];
}

@end
