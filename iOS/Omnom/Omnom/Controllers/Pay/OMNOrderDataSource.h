//
//  GPaymentVCDataSource.h
//  seocialtest
//
//  Created by tea on 13.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

@class OMNOrder;

@interface OMNOrderDataSource : NSObject
<UITableViewDataSource,
UITableViewDelegate>

@property (nonatomic, assign) BOOL showTotalView;
@property (nonatomic, strong) OMNOrder *order;
@property (nonatomic, copy) void(^didSelectBlock)(UITableView *tableView, NSIndexPath *indexPath);

- (instancetype)initWithOrder:(OMNOrder *)order;

- (void)registerCellsForTableView:(UITableView *)tableView;
- (void)updateTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath;

@end
