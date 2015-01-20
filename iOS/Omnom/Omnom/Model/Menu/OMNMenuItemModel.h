//
//  OMNMenuItmeModel.h
//  omnom
//
//  Created by tea on 20.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OMNMenuItemModel : NSObject
<UITableViewDataSource,
UITableViewDelegate>

- (void)configureTableView:(UITableView *)tableView;

@end
