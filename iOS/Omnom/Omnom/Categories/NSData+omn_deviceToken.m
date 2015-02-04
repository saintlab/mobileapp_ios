//
//  NSData+omn_deviceToken.m
//  omnom
//
//  Created by tea on 04.02.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "NSData+omn_deviceToken.h"

@implementation NSData (omn_deviceToken)

- (NSString *)omn_deviceTokenString {
  
  const unsigned char *buffer = (const unsigned char *)[self bytes];
  if (!buffer) {
    return @"";
  }
  NSMutableString *hex = [NSMutableString stringWithCapacity:(self.length * 2)];
  for (NSUInteger i = 0; i < self.length; i++) {
    [hex appendString:[NSString stringWithFormat:@"%02lx", (unsigned long)buffer[i]]];
  }
  
  return [NSString stringWithString:hex];
  
}

@end
