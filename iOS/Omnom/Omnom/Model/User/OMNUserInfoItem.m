//
//  OMNUserInfoItem.m
//  seocialtest
//
//  Created by tea on 25.06.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNUserInfoItem.h"
#import <OMNStyler.h>
#import "OMNConstants.h"

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

- (CGFloat)height {
  
  return 50.0f;
  
}

- (UITableViewCell *)cellForTableView:(UITableView *)tableView {
  
  NSString *reuseIdentifier = NSStringFromClass(self.class);
  OMNUserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
  if (nil == cell) {
    
    cell = [[OMNUserInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    
  }

  cell.accessoryType = self.cellAccessoryType;
  [cell.button setTitle:self.title forState:UIControlStateNormal];
  cell.button.contentHorizontalAlignment = self.contentHorizontalAlignment;
  [cell.button setTitleColor:self.titleColor forState:UIControlStateNormal];
  
  return cell;
  
}

@end
