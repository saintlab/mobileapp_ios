//
//  NSObject+omn_safe_creation.m
//  omnom
//
//  Created by tea on 01.05.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "NSObject+omn_safe_creation.h"

@implementation NSObject (omn_safe_creation)

- (NSInteger)omn_integerValueSafe {
  if ([self respondsToSelector:@selector(integerValue)]) {
    return [(id)self integerValue];
  }
  else {
    return 0;
  }
}

- (NSString *)omn_stringValueSafe {
  if ([self respondsToSelector:@selector(description)] &&
      ![self isEqual:[NSNull null]]) {
    return [self description];
  }
  else {
    return @"";
  }
}

- (BOOL)omn_boolValueSafe {
  if ([self respondsToSelector:@selector(boolValue)]) {
    return [(id)self boolValue];
  }
  else {
    return NO;
  }
}

- (double)omn_doubleValueSafe {
  if ([self respondsToSelector:@selector(doubleValue)]) {
    return [(id)self doubleValue];
  }
  else {
    return 0.0;
  }
}

- (long long)omn_longLongValueSafe {
  if ([self respondsToSelector:@selector(doubleValue)]) {
    return [(id)self longLongValue];
  }
  else {
    return 0ll;
  }
}

@end
