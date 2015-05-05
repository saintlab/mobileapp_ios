//
//  OMNUserInfoModel.h
//  seocialtest
//
//  Created by tea on 25.06.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNUser.h"
#import "OMNUserInfoItem.h"
#import "OMNRestaurantMediator.h"

typedef UIViewController *(^OMNUserInfoDidSelectBlock)(UITableView *tableView, NSIndexPath *indexPath);

@interface OMNUserInfoModel : NSObject
<UITableViewDataSource,
UITableViewDelegate>

@property (nonatomic, copy) OMNUserInfoDidSelectBlock didSelectBlock;

- (instancetype)initWithMediator:(OMNRestaurantMediator *)restaurantMediator;
- (void)configureTableView:(UITableView *)tableView;
- (void)update;

@end
