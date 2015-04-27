//
//  NSIndexSet+omn_helper.m
//  omnom
//
//  Created by tea on 27.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "NSIndexSet+omn_helper.h"

@implementation NSIndexSet (omn_helper)

+ (NSIndexSet *)omn_setWithIndexes:(NSArray *)indexes {
  
  NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
  [indexes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    
    [set addIndex:[obj integerValue]];
    
  }];
  
  return [set copy];
  
}

+ (NSIndexSet *)omn_setWithString:(NSString *)indexesString {
  
  NSArray *indexes = [indexesString componentsSeparatedByString:@","];
  return [self omn_setWithIndexes:indexes];
  
}

@end
