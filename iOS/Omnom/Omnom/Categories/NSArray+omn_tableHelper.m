//
//  NSArray+omn_tableHelper.m
//  omnom
//
//  Created by tea on 07.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "NSArray+omn_tableHelper.h"

@implementation NSArray (omn_tableHelper)

- (void)omn_compareToArray:(NSArray *)array withCompletion:(OMNTableReloadDataBlock)updatedIndexesBlock {
  
  NSArray *compareArray = [array copy];
  
  NSMutableIndexSet *deletedSet = [NSMutableIndexSet indexSet];
  NSMutableIndexSet *reloadSet = [NSMutableIndexSet indexSet];
  NSArray *copySelf = [self copy];
  [copySelf enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    
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
  
  updatedIndexesBlock([OMNTableReloadData dataWithReloadIndexes:reloadSet deletedIndexes:deletedSet insertedIndexes:insertSet]);
  
}

@end
