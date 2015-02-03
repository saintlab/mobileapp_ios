//
//  OMNMenuProductModifersModel.h
//  omnom
//
//  Created by tea on 02.02.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMNMenuProduct.h"

@interface OMNMenuProductModifersModel : NSObject
<UITableViewDelegate,
UITableViewDataSource>

@property (nonatomic, strong) OMNMenuProduct *menuProduct;
@property (nonatomic, copy) dispatch_block_t didSelectBlock;

+ (void)registerCellsForTableView:(UITableView *)tableView;
- (CGFloat)tableViewHeight;

@end
