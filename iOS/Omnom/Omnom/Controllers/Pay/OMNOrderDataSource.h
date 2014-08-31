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

- (instancetype)initWithOrder:(OMNOrder *)order;

- (void)registerCellsForTableView:(UITableView *)tableView;

@end
