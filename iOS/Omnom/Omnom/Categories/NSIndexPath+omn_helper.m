//
//  NSIndexPath+omn_helper.m
//  omnom
//
//  Created by tea on 27.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "NSIndexPath+omn_helper.h"

@implementation NSIndexPath (omn_helper)

+ (NSArray *)omn_indexPathsWithRows:(NSIndexSet *)rowsIndexes inSection:(NSInteger)section {
  
  NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:rowsIndexes.count];
  [rowsIndexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
    
    [indexPaths addObject:OMNIndexPath(idx, section)];
    
  }];
  
  return [indexPaths copy];
  
}

@end
