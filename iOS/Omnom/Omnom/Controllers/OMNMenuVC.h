//
//  OMNMenuVC.h
//  omnom
//
//  Created by tea on 19.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNBackgroundVC.h"
#import "OMNRestaurantMediator.h"

@interface OMNMenuVC : OMNBackgroundVC

@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, copy) dispatch_block_t didCloseBlock;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, strong, readonly) UIView *fadeView;
@property (nonatomic, strong, readonly) UIView *navigationFadeView;
@property (nonatomic, strong, readonly) UIView *menuHeaderView;

- (instancetype)initWithMediator:(OMNRestaurantMediator *)restaurantMediator;

@end
