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

@implementation OMNTableUserInfoItem {
  
  OMNTable *_table;
  
}

- (instancetype)initWithTable:(OMNTable *)table {
  
  self = [super initWithTitle:NSLocalizedString(@"USER_INFO_TABLE_TITLE", @"Столик") actionBlock:nil];
  if (self) {
    
    _table = table;
    
  }
  return self;
  
}

- (UITableViewCell *)cellForTableView:(UITableView *)tableView {
  
  UITableViewCell *cell = [super cellForTableView:tableView];
  
  if (_table) {
    
    UIButton *pinButton = [[UIButton alloc] init];
    UIColor *color = colorWithHexString(@"157EFB");
    pinButton.titleLabel.font = FuturaOSFOmnomRegular(20.0f);
    [pinButton setTitleColor:color forState:UIControlStateNormal];
    [pinButton setImage:[[UIImage imageNamed:@"table_marker_icon"] omn_tintWithColor:color] forState:UIControlStateNormal];
    [pinButton omn_centerButtonAndImageWithSpacing:2.0f];
    [pinButton setTitle:_table.internal_id forState:UIControlStateNormal];
    [pinButton sizeToFit];
    cell.accessoryView = pinButton;
    
  }
  else {
    
    cell.accessoryView = nil;
    
  }
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  
  return cell;
  
}

@end
