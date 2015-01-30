//
//  OMNMenuProduct+cell.h
//  omnom
//
//  Created by tea on 27.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMenuProduct.h"
#import "OMNMenuCellItemProtocol.h"

@interface OMNMenuProduct (cell)
<OMNMenuCellItemProtocol>

- (CGFloat)preorderHeightForTableView:(UITableView *)tableView;

@end
