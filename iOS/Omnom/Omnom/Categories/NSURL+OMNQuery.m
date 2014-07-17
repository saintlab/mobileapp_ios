//
//  NSURL+OMNQuery.m
//  restaurants
//
//  Created by tea on 23.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "NSURL+OMNQuery.h"

@implementation NSURL (OMNQuery)

- (NSDictionary *)omn_queryComponents
{
  NSArray *queryComponentsStrings = [[self query] componentsSeparatedByString:@"&"];
  NSMutableDictionary *queryComponents = [NSMutableDictionary dictionaryWithCapacity:queryComponentsStrings.count];
  [queryComponentsStrings enumerateObjectsUsingBlock:^(NSString *queryComponentsString, NSUInteger idx, BOOL *stop) {
    
    NSArray *keyValues = [queryComponentsString componentsSeparatedByString:@"="];
    
    if (keyValues.count == 2)
    {
      queryComponents[keyValues[0]] = keyValues[1];
    }
    
  }];
  
  return [queryComponents copy];
}

@end
