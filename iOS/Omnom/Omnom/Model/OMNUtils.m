//
//  OMNUtils.m
//  omnom
//
//  Created by tea on 29.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNUtils.h"
#import "OMNConstants.h"

NSString * const kRubleSign = @"\u20BD";
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

+ (NSString *)unitStringFromDouble:(double)value {
  
  static NSNumberFormatter *unitNumberFormatter = nil;
  if (nil == unitNumberFormatter) {
    unitNumberFormatter = [[NSNumberFormatter alloc] init];
    [unitNumberFormatter setPositiveFormat:@"###0.###"];
  }
  return [unitNumberFormatter stringFromNumber:@(value)];
  
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

+ (NSString *)formatedStringFromRub:(long long)rub {
  static NSNumberFormatter *currencyNumberFormatter = nil;
  if (nil == currencyNumberFormatter) {
    currencyNumberFormatter = [self commaNumberFormatter];
  }
  return [currencyNumberFormatter stringFromNumber:@(rub)];
}

+ (NSString *)formattedMoneyStringFromKop:(long long)kop {
  static NSNumberFormatter *currencyNumberFormatter = nil;
  if (nil == currencyNumberFormatter) {
    currencyNumberFormatter = [self commaNumberFormatter];
  }
  currencyNumberFormatter.minimumFractionDigits = (kop%100ll == 0) ? (0) : (2);
  return [NSString stringWithFormat:@"%@%@", [currencyNumberFormatter stringFromNumber:@(kop/100.)], kRubleSign];
}

+ (NSNumberFormatter *)commaNumberFormatter {
  NSNumberFormatter *commaNumberFormatter = [[NSNumberFormatter alloc] init];
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

@implementation NSString (omn_money)

- (NSString *)omn_pureAmountString {
  
  static NSCharacterSet *charactersSet = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    charactersSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
  });
  NSString *finalString = [[self componentsSeparatedByCharactersInSet:charactersSet] componentsJoinedByString:@""];
  return finalString;
}

- (NSString *)omn_moneyFormattedString {
  return [self omn_moneyFormattedStringWithMaxValue:0];
}

- (long long)omn_MoneyAmount {
  
  NSArray *priceComponents = [self componentsSeparatedByString:omnCommaString()];
  NSString *evenComponent = [priceComponents firstObject];
  NSString *evenString = [evenComponent omn_pureAmountString];
  
  long long amount = 100ll*[evenString longLongValue];
  
  if (priceComponents.count > 1) {
    
    NSString *fractionalComponent = priceComponents[1];
    NSString *fractionalString = [fractionalComponent omn_pureAmountString];
    
    if (fractionalString.length == 1) {
      amount += 10ll*[fractionalString longLongValue];
    }
    else if (fractionalString.length >= 2) {
      fractionalString = [fractionalString substringToIndex:2];
      amount += [fractionalString longLongValue];
    }

  }
  
  return amount;
  
}

- (NSString *)omn_moneyFormattedStringWithMaxValue:(long long)maxValue {
  
  NSArray *priceComponents = [self componentsSeparatedByString:omnCommaString()];
  NSString *evenComponent = [priceComponents firstObject];
  NSString *evenString = [evenComponent omn_pureAmountString];
  
  long long evenAmount = 0ll;
  if (maxValue > 0) {
    evenAmount = MIN([evenString longLongValue], maxValue);
  }
  else {
    evenAmount = [evenString longLongValue];
  }
  
  NSMutableString *priceString = [NSMutableString stringWithString:[OMNUtils formatedStringFromRub:evenAmount]];
  NSString *fractionalString = nil;
  
  if (priceComponents.count > 1) {
    
    NSString *fractionalComponent = priceComponents[1];
    fractionalString = [fractionalComponent omn_pureAmountString];
    if (fractionalString.length > 2) {
      fractionalString = [fractionalString substringToIndex:2];
    }
    
    [priceString appendFormat:@"%@%@", omnCommaString(), fractionalString];
  }
  
  return [priceString copy];
  
}

@end

@implementation NSObject (omn_response)

- (BOOL)omn_isSuccessResponse {
  
  if (![self isKindOfClass:[NSDictionary class]]) {
    return NO;
  }
  NSDictionary *dictionary = (NSDictionary *)self;
  BOOL status = [dictionary[@"status"] isEqualToString:@"success"];
  return status;
  
}

- (NSTimeInterval)omn_timeStamp {
  
  if (![self isKindOfClass:[NSDictionary class]]) {
    return 0.0;
  }
  
  NSDictionary *dictionary = (NSDictionary *)self;
  NSTimeInterval timeStamp = [dictionary[@"time"] doubleValue];
  
  return timeStamp;
  
}

@end
