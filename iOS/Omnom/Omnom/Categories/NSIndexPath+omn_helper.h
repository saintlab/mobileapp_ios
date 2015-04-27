//
//  NSIndexPath+omn_helper.h
//  omnom
//
//  Created by tea on 27.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <Foundation/Foundation.h>

#define OMNIndexPath(__ROW__,__SECTION__) ([NSIndexPath indexPathForRow:__ROW__ inSection:__SECTION__])

@interface NSIndexPath (omn_helper)

+ (NSArray *)omn_indexPathsWithRows:(NSIndexSet *)rowsIndexes inSection:(NSInteger)section;

@end
