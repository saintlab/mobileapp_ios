//
//  NSObject+omn_safe_creation.h
//  omnom
//
//  Created by tea on 01.05.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (omn_safe_creation)

- (NSString *)omn_stringValueSafe;

- (NSInteger)omn_integerValueSafe;
- (BOOL)omn_boolValueSafe;
- (double)omn_doubleValueSafe;

@end
