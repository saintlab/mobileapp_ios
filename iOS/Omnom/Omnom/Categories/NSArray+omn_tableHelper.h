//
//  NSArray+omn_tableHelper.h
//  omnom
//
//  Created by tea on 07.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMNMenuCategorySectionItem.h"

typedef void(^OMNUpdatedIndexesBlock)(NSIndexSet *deletedIndexes, NSIndexSet *insertedIndexes, NSIndexSet *reloadIndexes);

@interface NSArray (omn_tableHelper)

- (void)omn_compareToArray:(NSArray *)array withCompletion:(OMNUpdatedIndexesBlock)updatedIndexesBlock;

@end