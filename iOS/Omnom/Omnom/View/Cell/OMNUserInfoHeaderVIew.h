//
//  OMNUserInfoHeaderVIew.h
//  omnom
//
//  Created by tea on 03.12.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <UIKit/UIKit.h>

#define OMNUserInfoHeaderViewIdentifier @"OMNUserInfoHeaderViewIdentifier"

@interface OMNUserInfoHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong, readonly) UILabel *label;

+ (void)registerForTableView:(UITableView *)tableView;

@end
