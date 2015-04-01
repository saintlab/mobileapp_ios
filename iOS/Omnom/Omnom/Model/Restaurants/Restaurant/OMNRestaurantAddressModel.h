//
//  OMNRestaurantAddressModel.h
//  omnom
//
//  Created by tea on 01.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMNRestaurant.h"

typedef void(^OMNRestaurantAddressBlock)(OMNRestaurantAddress *restaurantAddress);

@interface OMNRestaurantAddressModel : NSObject
<UITableViewDataSource,
UITableViewDelegate>

@property (nonatomic, copy) OMNRestaurantAddressBlock didSelectRestaurantAddressBlock;

- (instancetype)initWithRestaurant:(OMNRestaurant *)restaurant;
- (void)registerTableView:(UITableView *)tableView;
- (OMNRestaurantAddress *)selectedAddress;
- (void)loadAddressesWithCompletion:(dispatch_block_t)completionBlock;

@end
