//
//  OMNTableReloadData.h
//  omnom
//
//  Created by tea on 09.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OMNTableReloadData;

typedef void(^OMNTableReloadDataBlock)(OMNTableReloadData *tableReloadData);

@interface OMNTableReloadData : NSObject

@property (nonatomic, strong, readonly) NSIndexSet *reloadIndexes;
@property (nonatomic, strong, readonly) NSIndexSet *deletedIndexes;
@property (nonatomic, strong, readonly) NSIndexSet *insertedIndexes;
@property (nonatomic, strong, readonly) NSArray *deletedIndexPaths;
@property (nonatomic, strong, readonly) NSArray *insertedIndexPaths;

+ (instancetype)dataWithReloadIndexes:(NSIndexSet *)reloadIndexes deletedIndexes:(NSIndexSet *)deletedIndexes insertedIndexes:(NSIndexSet *)insertedIndexes;
- (instancetype)dataWithDeletedIndexPaths:(NSArray *)deletedIndexPaths insertedIndexPaths:(NSArray *)insertedIndexPaths;

- (void)updateTableView:(UITableView *)tableView;

@end
