//
//  OMNMenuTableCellItemProtocol.h
//  omnom
//
//  Created by tea on 19.02.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OMNMenuTableCellItemProtocol <NSObject>

@property (nonatomic, assign) BOOL hidden;

- (CGFloat)heightForTableView:(UITableView *)tableView;
- (UITableViewCell *)cellForTableView:(UITableView *)tableView;
+ (void)registerCellForTableView:(UITableView *)tableView;

@end
