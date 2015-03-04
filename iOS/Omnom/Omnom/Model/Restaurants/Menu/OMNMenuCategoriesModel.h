//
//  OMNMenuCategoriesModel.h
//  omnom
//
//  Created by tea on 19.02.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMNMenu.h"
#import "OMNMenuProductWithRecommedtationsCell.h"
#import "OMNMenuCategoryHeaderView.h"

typedef void(^OMNMenuTableDidEndDraggingBlock)(UITableView *tableView);

@interface OMNMenuCategoriesModel : NSObject
<UITableViewDataSource,
UITableViewDelegate>

@property (nonatomic, strong, readonly) NSArray *categories;
@property (nonatomic, copy) OMNMenuTableDidEndDraggingBlock didEndDraggingBlock;

- (instancetype)initWithMenu:(OMNMenu *)menu cellDelegate:(id<OMNMenuProductWithRecommedtationsCellDelegate>)cellDelegate headerDelegate:(id<OMNMenuCategoryHeaderViewDelegate>)headerDelegate;

+ (void)registerCellsForTableView:(UITableView *)tableView;

@end
