//
//  OMNRestaurantCell.h
//  omnom
//
//  Created by tea on 23.12.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMNRestaurant.h"

@interface OMNRestaurantCell : UITableViewCell

@property (nonatomic, strong) OMNRestaurant *restaurant;

+ (instancetype)cellForTableView:(UITableView *)tableView;

@end
