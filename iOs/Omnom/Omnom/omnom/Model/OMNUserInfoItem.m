//
//  OMNUserInfoItem.m
//  seocialtest
//
//  Created by tea on 25.06.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNUserInfoItem.h"

@implementation OMNUserInfoItem

+ (instancetype)itemWithTitle:(NSString *)title actionBlock:(OMNUserInfoItemBlock)actionBlock {
  
  OMNUserInfoItem *item = [[[self class] alloc] init];
  item.title = title;
  item.actionBlock = actionBlock;
  return item;
  
}

- (void)configureCell:(UITableViewCell *)cell {
  
  cell.textLabel.text = self.title;
  cell.accessoryType = self.cellAccessoryType;
  
}

@end
