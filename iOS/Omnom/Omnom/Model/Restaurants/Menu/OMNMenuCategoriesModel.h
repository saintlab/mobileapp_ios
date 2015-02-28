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

@interface OMNMenuCategoriesModel : NSObject
<UITableViewDataSource,
UITableViewDelegate>

@property (nonatomic, strong, readonly) NSArray *categories;

- (instancetype)initWithMenu:(OMNMenu *)menu cellDelegate:(id<OMNMenuProductWithRecommedtationsCellDelegate>)cellDelegate headerDelegate:(id<OMNMenuCategoryHeaderViewDelegate>)headerDelegate;

+ (void)registerCellsForTableView:(UITableView *)tableView;

@end
