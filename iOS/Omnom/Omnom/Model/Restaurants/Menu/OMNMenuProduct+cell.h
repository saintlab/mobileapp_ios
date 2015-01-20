//
//  OMNMenuItem+OMNMenuItem_cell.h
//  omnom
//
//  Created by tea on 20.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMenuProduct.h"

@interface OMNMenuProduct (cell)

- (CGFloat)heightForTableView:(UITableView *)tableView;
- (UITableViewCell *)cellForTableView:(UITableView *)tableView;

@end
