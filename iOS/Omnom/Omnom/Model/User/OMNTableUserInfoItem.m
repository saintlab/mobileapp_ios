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
  
  self = [super initWithTitle:NSLocalizedString(@"USER_INFO_TABLE_TITLE", @"Столик") actionBlock:^(UIViewController *__weak vc, UITableView *__weak tv, NSIndexPath *indexPath) {
    
    [tv deselectRowAtIndexPath:indexPath animated:YES];
    OMNChangeTableAlertVC *changeTableAlertVC = [[OMNChangeTableAlertVC alloc] initWithTable:restaurantMediator.visitor.table];
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
  OMNVisitor *_visitor = _restaurantMediator.visitor;
  if (_visitor.tableName) {
    
    OMNTableButton *tableButton = [OMNTableButton buttonWithColor:[OMNStyler blueColor]];
    NSString *title = [NSString stringWithFormat:NSLocalizedString(@"TABLE_UPDATE_BUTTON_TITLE %@", @"{table_number} Обновить"), _visitor.tableName];
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
