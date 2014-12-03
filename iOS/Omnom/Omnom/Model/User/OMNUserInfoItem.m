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
  self = [super init];
  if (self) {
    self.textAlignment = NSTextAlignmentLeft;
    self.titleColor = [UIColor blackColor];
  }
  return self;
}

- (instancetype)initWithTitle:(NSString *)title actionBlock:(OMNUserInfoItemBlock)actionBlock {
  self = [self init];
  if (self) {
    
    self.title = title;
    self.actionBlock = actionBlock;
    
  }
  return self;
}

- (CGFloat)height {
  
  return 50.0f;
  
}

- (UITableViewCell *)cellForTableView:(UITableView *)tableView {
  
  NSString *reuseIdentifier = NSStringFromClass(self.class);
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
  if (nil == cell) {
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    cell.textLabel.textColor = colorWithHexString(@"000000");
    cell.textLabel.opaque = YES;
    cell.textLabel.backgroundColor = [UIColor whiteColor];
    cell.textLabel.font = FuturaOSFOmnomRegular(18.0f);
        
    UIView *downSeporator = [[UIView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetHeight(cell.frame)-0.5f, CGRectGetWidth(cell.frame), 0.5f)];
    downSeporator.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.2f];
    downSeporator.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin);
    [cell addSubview:downSeporator];
    
  }

  cell.accessoryType = self.cellAccessoryType;
  cell.textLabel.text = self.title;
  cell.textLabel.textAlignment = self.textAlignment;
  cell.textLabel.textColor = self.titleColor;
  
  return cell;
  
}

@end
