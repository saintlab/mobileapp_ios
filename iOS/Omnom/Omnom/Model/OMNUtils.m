//
//  OMNUtils.m
//  omnom
//
//  Created by tea on 29.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNUtils.h"
#import "OMNConstants.h"

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
    currencyNumberFormatter.numberStyle = kCFNumberFormatterCurrencyStyle;
    currencyNumberFormatter.currencySymbol = kRubleSign;
    currencyNumberFormatter.currencyDecimalSeparator = omnCommaString();
  }
  currencyNumberFormatter.minimumFractionDigits = (kop%100ll == 0) ? (0) : (2);
  return [currencyNumberFormatter stringFromNumber:@(kop/100.)];
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

+ (NSError *)errorFromCode:(NSInteger)code {
  
  NSString *description = @"";
  
  switch (code) {
    case OMNErrorNotConnectedToInternet: {
      description = NSLocalizedString(@"Нет доступа в интернет", nil);
    } break;
    case OMNErrorUnknoun:
    default: {
      description = NSLocalizedString(@"Что-то пошло не так. Повторите попытку", nil);
    } break;
  }
  
  return [NSError errorWithDomain:@"OMNError" code:code userInfo:@{NSLocalizedDescriptionKey : description}];
  
}

@end

@implementation NSError (omn_internet)

- (NSError *)omn_internetError {
  
  return [OMNUtils errorFromCode:self.code];
  
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
