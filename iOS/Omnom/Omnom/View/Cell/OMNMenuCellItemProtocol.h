//
//  OMNMenuCellItemProtocol.h
//  omnom
//
//  Created by tea on 22.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OMNMenuCellItemProtocol <NSObject>

- (CGFloat)heightForTableView:(UITableView *)tableView;
- (UITableViewCell *)cellForTableView:(UITableView *)tableView;
+ (void)registerCellForTableView:(UITableView *)tableView;

@end
