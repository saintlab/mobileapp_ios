//
//  OMNUtils.h
//  omnom
//
//  Created by tea on 29.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kRubleSign;
extern NSString *omnCommaString();

#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)


@interface OMNUtils : NSObject

+ (NSString *)evenCommaStringFromKop:(long long)kop;
+ (NSString *)formattedMoneyStringFromKop:(long long)kop;
+ (NSString *)moneyStringFromKop:(long long)kop;
+ (NSString *)commaStringFromKop:(long long)kop;
+ (NSString *)formatedStringFromRub:(long long)rub;

+ (NSError *)errorFromCode:(NSInteger)code;

@end

@interface NSError (omn_internet)

- (NSError *)omn_internetError;

@end

@interface NSString (omn_money)

- (long long)omn_MoneyAmount;
- (NSString *)omn_pureAmountString;
- (NSString *)omn_moneyFormattedString;
- (NSString *)omn_moneyFormattedStringWithMaxValue:(long long)maxValue;

@end