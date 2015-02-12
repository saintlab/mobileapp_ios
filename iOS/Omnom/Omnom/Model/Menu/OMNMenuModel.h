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
typedef void(^OMNMenuTableDidEndDraggingBlock)(UITableView *tableView);

extern const CGFloat kMenuTableTopOffset;

@interface OMNMenuModel : NSObject
<UITableViewDataSource,
UITableViewDelegate>

@property (nonatomic, copy) OMNMenuCategoryDidSelectBlock didSelectBlock;
@property (nonatomic, copy) OMNMenuTableDidEndDraggingBlock didEndDraggingBlock;
@property (nonatomic, strong) OMNMenu *menu;

- (void)configureTableView:(UITableView *)tableView;

@end
