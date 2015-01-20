//
//  OMNMenuModel.h
//  omnom
//
//  Created by tea on 19.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^OMNMenuItemDidSelectBlock)(UITableView *tableView, NSIndexPath *indexPath);

@interface OMNMenuModel : NSObject
<UITableViewDataSource,
UITableViewDelegate>

@property (nonatomic, copy) OMNMenuItemDidSelectBlock didSelectBlock;

- (void)configureTableView:(UITableView *)tableView;

@end
