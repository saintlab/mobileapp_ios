//
//  OMNRestaurantCell.h
//  omnom
//
//  Created by tea on 23.12.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMNRestaurantCellItem.h"

@interface OMNRestaurantCell : UITableViewCell

@property (nonatomic, strong) OMNRestaurantCellItem *item;

@end

@interface OMNRestaurantView : UIView

@property (nonatomic, strong) OMNRestaurant *restaurant;

@end