//
//  OMNMenuItmeModel.m
//  omnom
//
//  Created by tea on 20.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMenuItemModel.h"

@implementation OMNMenuItemModel{
  
  NSArray *_menuItems;
  
}

- (void)configureTableView:(UITableView *)tableView {
  
//  [tableView registerClass:[OMNMenuHeaderItemCell class] forCellReuseIdentifier:@"OMNMenuHeaderItemCell"];
//  [tableView registerClass:[OMNMenuItemCell class] forCellReuseIdentifier:@"OMNMenuItemCell"];
  tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  tableView.backgroundView = [[UIView alloc] init];
  tableView.backgroundView.backgroundColor = [UIColor clearColor];
  tableView.backgroundColor = [UIColor clearColor];
  tableView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
  tableView.delegate = self;
  tableView.dataSource = self;
  
}

- (instancetype)init {
  self = [super init];
  if (self) {
    
  }
  return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  
  return 1;
  
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
  return _menuItems.count;
  
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  UITableViewCell *cell = nil;
  
//  OMNMenuItemCell *menuItemCell = [tableView dequeueReusableCellWithIdentifier:@"OMNMenuItemCell" forIndexPath:indexPath];
//  menuItemCell.label.text = _menuItems[indexPath.row];
//  cell = menuItemCell;
  
  return cell;
  
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  return 50.0f;
  
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath  {
  
  
//  if (self.didSelectBlock) {
//    
//    self.didSelectBlock(tableView, indexPath);
//    
//  }
//  else {
//    
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    
//  }
  
}

@end
