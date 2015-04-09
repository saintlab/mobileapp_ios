//
//  OMNTableReloadData.m
//  omnom
//
//  Created by tea on 09.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNTableReloadData.h"

@interface OMNTableReloadData ()

@property (nonatomic, strong) NSIndexSet *reloadIndexes;
@property (nonatomic, strong) NSIndexSet *deletedIndexes;
@property (nonatomic, strong) NSIndexSet *insertedIndexes;
@property (nonatomic, strong) NSArray *deletedIndexPaths;
@property (nonatomic, strong) NSArray *insertedIndexPaths;


@end

@implementation OMNTableReloadData

+ (instancetype)dataWithReloadIndexes:(NSIndexSet *)reloadIndexes deletedIndexes:(NSIndexSet *)deletedIndexes insertedIndexes:(NSIndexSet *)insertedIndexes {
  
  OMNTableReloadData *data = [[OMNTableReloadData alloc] init];
  data.reloadIndexes = reloadIndexes;
  data.deletedIndexes = deletedIndexes;
  data.insertedIndexes = insertedIndexes;
  return data;
  
}

- (instancetype)dataWithDeletedIndexPaths:(NSArray *)deletedIndexPaths insertedIndexPaths:(NSArray *)insertedIndexPaths {
  
  OMNTableReloadData *data = [[OMNTableReloadData alloc] init];
  data.reloadIndexes = [_reloadIndexes copy];
  data.deletedIndexes = [_deletedIndexes copy];
  data.insertedIndexes = [_insertedIndexes copy];
  data.deletedIndexPaths = [deletedIndexPaths copy];
  data.insertedIndexPaths = [insertedIndexPaths copy];
  return data;
  
}

- (void)updateTableView:(UITableView *)tableView {
  
  [tableView beginUpdates];
  if (self.deletedIndexPaths) {
    [tableView deleteRowsAtIndexPaths:self.deletedIndexPaths withRowAnimation:UITableViewRowAnimationFade];
  }
  if (self.deletedIndexes) {
    [tableView deleteSections:self.deletedIndexes withRowAnimation:UITableViewRowAnimationFade];
  }
  if (self.insertedIndexes) {
    [tableView insertSections:self.insertedIndexes withRowAnimation:UITableViewRowAnimationMiddle];
  }
  if (self.insertedIndexPaths) {
    [tableView insertRowsAtIndexPaths:self.insertedIndexPaths withRowAnimation:UITableViewRowAnimationFade];
  }
  [tableView endUpdates];
  
}

@end
