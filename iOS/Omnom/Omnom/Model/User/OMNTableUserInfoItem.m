//
//  OMNTableUserInfoItem.m
//  omnom
//
//  Created by tea on 03.12.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNTableUserInfoItem.h"
#import "OMNConstants.h"
#import <OMNStyler.h>
#import "UIImage+omn_helper.h"
#import "UIButton+omn_helper.h"
#import "OMNChangeTableAlertVC.h"

@implementation OMNTableUserInfoItem {
  
  OMNRestaurantMediator *_restaurantMediator;
  
}

- (instancetype)initWithMediator:(OMNRestaurantMediator *)restaurantMediator {
  
  self = [super initWithTitle:NSLocalizedString(@"USER_INFO_TABLE_TITLE", @"Столик") actionBlock:^(UIViewController *__weak vc, UITableView *__weak tv, NSIndexPath *indexPath) {
    
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
  
  if (_restaurantMediator.table) {
    
    NSString *title = [NSString stringWithFormat:NSLocalizedString(@"TABLE_UPDATE_BUTTON_TITLE %@", @"{table_number} Обновить"), _restaurantMediator.table.internal_id];
    UIButton *pinButton = [[UIButton alloc] init];
    pinButton.userInteractionEnabled = NO;
    UIColor *color = colorWithHexString(@"157EFB");
    pinButton.titleLabel.font = FuturaLSFOmnomLERegular(20.0f);
    [pinButton setTitleColor:color forState:UIControlStateNormal];
    [pinButton setImage:[[UIImage imageNamed:@"table_marker_icon"] omn_tintWithColor:color] forState:UIControlStateNormal];
    [pinButton omn_centerButtonAndImageWithSpacing:2.0f];
    [pinButton setTitle:title forState:UIControlStateNormal];
    [pinButton sizeToFit];
    cell.accessoryView = pinButton;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
  }
  else {
    
    cell.accessoryView = nil;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
  }
  
  
  return cell;
  
}

@end
