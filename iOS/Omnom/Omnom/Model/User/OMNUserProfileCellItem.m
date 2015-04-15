//
//  OMNUserProfileCellItem.m
//  omnom
//
//  Created by tea on 14.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNUserProfileCellItem.h"
#import "OMNUserProfileCell.h"
#import "OMNEditUserVC.h"

@implementation OMNUserProfileCellItem 

- (instancetype)init {
  self = [super init];
  if (self) {
    
    self.actionBlock = ^(UIViewController *vc, UITableView *tv, NSIndexPath *indexPath) {
      
      OMNEditUserVC *editUserVC = [[OMNEditUserVC alloc] init];
      editUserVC.didFinishBlock = ^{
        [vc.navigationController popToViewController:vc animated:YES];
      };
      editUserVC.editPhoto = YES;
      [vc.navigationController pushViewController:editUserVC animated:YES];
      
    };
    
  }
  return self;
}

- (CGFloat)heightForTableView:(UITableView *)tableView {
  
  static OMNUserProfileCell *cell = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    cell = [[OMNUserProfileCell alloc] initWithFrame:tableView.bounds];
    cell.hidden = YES;
  });
  
  cell.bounds = tableView.bounds;
  cell.item = self;
  [cell setNeedsLayout];
  [cell layoutIfNeeded];
  
  CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1.0f;
  return height;
  
}

- (UITableViewCell *)cellForTableView:(UITableView *)tableView {
  
  OMNUserProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OMNUserProfileCell class])];
  cell.item = self;
  return cell;
  
}

+ (void)registerCellForTableView:(UITableView *)tableView {
  [tableView registerClass:[OMNUserProfileCell class] forCellReuseIdentifier:NSStringFromClass([OMNUserProfileCell class])];
}

@end
