//
//  NSString+omnScanner.m
//  omnom
//
//  Created by tea on 24.09.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "NSString+omnScanner.h"

@implementation NSString (omnScanner)

- (double)omn_doubleValue {
  
  return [[self stringByReplacingOccurrencesOfString:@"," withString:@"."] doubleValue];
  
}

@end

@implementation NSNumber (omnScanner)

- (double)omn_doubleValue {
  return [self doubleValue];
}

@end
