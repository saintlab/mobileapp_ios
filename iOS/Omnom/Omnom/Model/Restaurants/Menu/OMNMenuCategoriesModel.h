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

@interface OMNMenuCategoriesModel : NSObject
<UITableViewDataSource,
UITableViewDelegate>

- (instancetype)initWithMenu:(OMNMenu *)menu delegate:(id<OMNMenuProductWithRecommedtationsCellDelegate>)delegate;

+ (void)registerCellsForTableView:(UITableView *)tableView;

@end
