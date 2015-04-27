//
//  NSIndexSet+omn_helper.h
//  omnom
//
//  Created by tea on 27.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSIndexSet (omn_helper)

/**
 *  @param indexes array of numbers or strings representing desired indexes @[@1, @2] or @[@"1", @"2"]
 *
 *  @return index set with indexes in array
 */
+ (NSIndexSet *)omn_setWithIndexes:(NSArray *)indexes;

/**
 *  @param indexesString String like @"1,3,5,6"
 *
 *  @return index set with indexes in string
 */
+ (NSIndexSet *)omn_setWithString:(NSString *)indexesString;

@end
