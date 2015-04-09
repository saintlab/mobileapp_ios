//
//  NSArray+omn_tableHelper.h
//  omnom
//
//  Created by tea on 07.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMNTableReloadData.h"

@interface NSArray (omn_tableHelper)

- (void)omn_compareToArray:(NSArray *)array withCompletion:(OMNTableReloadDataBlock)updatedIndexesBlock;

@end