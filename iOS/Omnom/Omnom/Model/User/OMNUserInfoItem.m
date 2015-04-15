//
//  OMNUserInfoItem.m
//  seocialtest
//
//  Created by tea on 25.06.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNUserInfoItem.h"
#import "OMNUserInfoCell.h"

@implementation OMNUserInfoItem

+ (instancetype)itemWithTitle:(NSString *)title actionBlock:(OMNUserInfoItemBlock)actionBlock {
  
  return [[OMNUserInfoItem alloc] initWithTitle:title actionBlock:actionBlock];
  
}

- (instancetype)init {
  self = [self initWithTitle:nil actionBlock:nil];
  if (self) {
  }
  return self;
}

- (instancetype)initWithTitle:(NSString *)title actionBlock:(OMNUserInfoItemBlock)actionBlock {
  self = [super init];
  if (self) {
    
    self.title = title;
    self.actionBlock = actionBlock;
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.titleColor = [UIColor blackColor];
    
  }
  return self;
}

- (CGFloat)heightForTableView:(UITableView *)tableView {
  return 50.0f;
}

- (UITableViewCell *)cellForTableView:(UITableView *)tableView {
  
  OMNUserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OMNUserInfoCell class])];
  cell.item = self;
  return cell;
  
}

+ (void)registerCellForTableView:(UITableView *)tableView {
  [tableView registerClass:[OMNUserInfoCell class] forCellReuseIdentifier:NSStringFromClass([OMNUserInfoCell class])];
}

@end
