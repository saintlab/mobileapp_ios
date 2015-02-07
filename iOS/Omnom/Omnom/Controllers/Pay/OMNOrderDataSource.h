//
//  GPaymentVCDataSource.h
//  seocialtest
//
//  Created by tea on 13.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNOrderItem.h"

@class OMNOrder;

@interface OMNOrderDataSource : NSObject
<UITableViewDataSource,
UITableViewDelegate>

@property (nonatomic, strong) OMNOrder *order;
@property (nonatomic, assign) BOOL fadeNonSelectedItems;

@property (nonatomic, copy) void(^didSelectBlock)(UITableView *tableView, NSIndexPath *indexPath);
@property (nonatomic, copy) dispatch_block_t didScrollToTopBlock;

- (OMNOrderItem *)orderItemAtIndexPath:(NSIndexPath *)indexPath;
+ (void)registerCellsForTableView:(UITableView *)tableView;
- (void)updateTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)lastIndexPath;

@end
