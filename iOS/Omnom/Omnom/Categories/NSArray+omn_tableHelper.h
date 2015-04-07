//
//  NSArray+omn_tableHelper.h
//  omnom
//
//  Created by tea on 07.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^OMNUpdatedIndexesBlock)(NSIndexSet *deletedIndexes, NSIndexSet *insertedIndexes);

@interface NSArray (omn_tableHelper)

- (void)omn_compareToArray:(NSArray *)array withCompletion:(OMNUpdatedIndexesBlock)updatedIndexesBlock;

@end