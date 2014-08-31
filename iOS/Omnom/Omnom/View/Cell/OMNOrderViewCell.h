//
//  OMNOrderItemCell.h
//  restaurants
//
//  Created by tea on 02.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNOrder.h"

@interface OMNOrderViewCell : UICollectionViewCell

@property (nonatomic, strong) OMNOrder *order;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UITableView *tableView;

@end
