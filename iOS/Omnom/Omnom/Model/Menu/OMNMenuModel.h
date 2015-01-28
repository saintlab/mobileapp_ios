//
//  OMNMenuModel.h
//  omnom
//
//  Created by tea on 19.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMNMenu.h"

typedef void(^OMNMenuCategoryDidSelectBlock)(OMNMenuCategory *menuCategory);

@interface OMNMenuModel : NSObject
<UITableViewDataSource,
UITableViewDelegate>

@property (nonatomic, copy) OMNMenuCategoryDidSelectBlock didSelectBlock;

- (instancetype)initWithMenu:(OMNMenu *)menu;
- (void)configureTableView:(UITableView *)tableView;

@end
