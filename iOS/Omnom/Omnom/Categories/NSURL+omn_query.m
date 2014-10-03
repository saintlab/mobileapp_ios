//
//  NSURL+omn_query.m
//  omnom
//
//  Created by tea on 03.10.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "NSURL+omn_query.h"

@implementation NSURL (omn_query)

- (NSDictionary *)omn_query {
  
  NSArray *components = [[self query] componentsSeparatedByString:@"&"];
  NSMutableDictionary *parametrs = [NSMutableDictionary dictionaryWithCapacity:components.count];
  [components enumerateObjectsUsingBlock:^(NSString *component, NSUInteger idx, BOOL *stop) {
    
    NSArray *keyValue = [component componentsSeparatedByString:@"="];
    if (keyValue.count == 2) {
      parametrs[keyValue[0]] = keyValue[1];
    }
    
  }];
  
  return parametrs;
  
}

@end
