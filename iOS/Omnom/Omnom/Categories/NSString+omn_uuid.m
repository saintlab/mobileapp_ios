//
//  NSString+omn_uuid.m
//  omnom
//
//  Created by tea on 26.12.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "NSString+omn_uuid.h"

@implementation NSString (omn_uuid)

+ (NSString *)omn_uuid {
  
  CFUUIDRef uuidRef = CFUUIDCreate(NULL);
  CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
  CFRelease(uuidRef);
  return (__bridge_transfer NSString *)uuidStringRef;
  
}

@end
