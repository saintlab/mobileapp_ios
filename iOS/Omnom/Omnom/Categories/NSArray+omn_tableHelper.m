//
//  NSArray+omn_tableHelper.m
//  omnom
//
//  Created by tea on 07.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "NSArray+omn_tableHelper.h"

@implementation NSArray (omn_tableHelper)

- (void)omn_compareToArray:(NSArray *)array withCompletion:(OMNUpdatedIndexesBlock)updatedIndexesBlock {
  
  NSArray *compareArray = [array copy];
  
  NSMutableIndexSet *deletedSet = [NSMutableIndexSet indexSet];
  NSMutableIndexSet *reloadSet = [NSMutableIndexSet indexSet];
  [[self copy] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    
    if (![compareArray containsObject:obj]) {
      [deletedSet addIndex:idx];
    }
    else {
      [reloadSet addIndex:idx];
    }
    
  }];
  
  NSMutableArray *removedSelf = [self mutableCopy];
  [removedSelf removeObjectsAtIndexes:deletedSet];
  
  NSMutableIndexSet *insertSet = [NSMutableIndexSet indexSet];
  [compareArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    
    if (![removedSelf containsObject:obj]) {
      [insertSet addIndex:idx];
    }
    
  }];
  
  updatedIndexesBlock(deletedSet, insertSet, reloadSet);
  
}

@end
