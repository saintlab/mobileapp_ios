//
//  OMNTableUserInfoItem.m
//  omnom
//
//  Created by tea on 03.12.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNTableUserInfoItem.h"
#import <OMNStyler.h>
#import "OMNTableButton.h"
#import "OMNChangeTableAlertVC.h"

@implementation OMNTableUserInfoItem {
  
  OMNRestaurantMediator *_restaurantMediator;
  
}

- (instancetype)initWithMediator:(OMNRestaurantMediator *)restaurantMediator {
  
  self = [super initWithTitle:kOMN_USER_INFO_TABLE_TITLE actionBlock:^(UIViewController *vc, UITableView *__weak tv, NSIndexPath *indexPath) {
    
    [tv deselectRowAtIndexPath:indexPath animated:YES];
    OMNChangeTableAlertVC *changeTableAlertVC = [[OMNChangeTableAlertVC alloc] initWithTable:restaurantMediator.table];
    changeTableAlertVC.didCloseBlock = ^{
      
      [vc dismissViewControllerAnimated:YES completion:nil];
      
    };
    changeTableAlertVC.didRequestRescanBlock = ^{

      [restaurantMediator rescanTable];
      
    };
    [vc presentViewController:changeTableAlertVC animated:YES completion:nil];
    
  }];
  if (self) {
    
    _restaurantMediator = restaurantMediator;

  }
  return self;
}

- (UITableViewCell *)cellForTableView:(UITableView *)tableView {
  
  UITableViewCell *cell = [super cellForTableView:tableView];
  NSString *tableName = _restaurantMediator.table.name;
  if (tableName) {
    
    OMNTableButton *tableButton = [OMNTableButton buttonWithColor:[OMNStyler blueColor]];
    NSString *title = [NSString stringWithFormat:kOMN_TABLE_UPDATE_BUTTON_FORMAT, tableName];
    [tableButton setText:title];
    tableButton.userInteractionEnabled = NO;
    cell.accessoryView = tableButton;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
  }
  else {
    
    cell.accessoryView = nil;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
  }
  
  
  return cell;
  
}

@end
