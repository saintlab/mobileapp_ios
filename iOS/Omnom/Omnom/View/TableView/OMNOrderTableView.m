//
//  OMNOrderTableView.m
//  omnom
//
//  Created by tea on 27.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNOrderTableView.h"
#import <OMNStyler.h>

@implementation OMNOrderTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
  self = [super initWithFrame:frame style:style];
  if (self) {
    [self setup];
  }
  return self;
}

- (void)awakeFromNib {
  [self setup];
}

- (void)setup {
  
  self.backgroundView = [[UIView alloc] init];
  self.backgroundView.backgroundColor = [UIColor clearColor];
  
  self.backgroundColor = [UIColor clearColor];
  self.separatorColor = [colorWithHexString(@"000000") colorWithAlphaComponent:0.2f];
  self.separatorInset = UIEdgeInsetsMake(0.0f, 20.0f, 0.0f, 12.0f);
  UIImageView *tableHeaderView = [[UIImageView alloc] initWithFrame:self.bounds];
  tableHeaderView.contentMode = UIViewContentModeBottom;
  tableHeaderView.image = [UIImage imageNamed:@"bill_placeholder_icon"];
  tableHeaderView.backgroundColor = [UIColor whiteColor];
  self.tableHeaderView = tableHeaderView;
  
  self.tableFooterView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bill_zubchiki"]];
}

@end
