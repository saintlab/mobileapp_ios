//
//  OMNOrderCell.h
//  restaurants
//
//  Created by tea on 29.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNOrderItem.h"

@interface OMNOrderItemCell : UITableViewCell

@property (nonatomic, strong) OMNOrderItem *orderItem;
@property (nonatomic, assign) BOOL fadeNonSelectedItems;

@end
