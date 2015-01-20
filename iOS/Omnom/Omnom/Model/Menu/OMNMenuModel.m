//
//  OMNMenuModel.m
//  omnom
//
//  Created by tea on 19.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMenuModel.h"
#import "OMNMenuHeaderItemCell.h"
#import "OMNMenuItemCell.h"

@implementation OMNMenuModel {
  
  NSArray *_menuItems;
  
}

- (void)configureTableView:(UITableView *)tableView {
  
  [tableView registerClass:[OMNMenuHeaderItemCell class] forCellReuseIdentifier:@"OMNMenuHeaderItemCell"];
  [tableView registerClass:[OMNMenuItemCell class] forCellReuseIdentifier:@"OMNMenuItemCell"];
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
    
    _menuItems = @[@"Салаты", @"Салаты 2", @"Салаты 3", @"Салаты 4", @"Салаты 5", @"Салаты 5", @"Салаты 1", @"Салаты 2", @"Салаты 3", @"Салаты 4", @"Салаты 5", @"Салаты 5", @"Салаты 1", @"Салаты 2", @"Салаты 3", @"Салаты 4", @"Салаты 5"];
    
  }
  return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  
  return 2;
  
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
  NSInteger numberOfRows = 0;
  
  switch (section) {
    case 0: {
      numberOfRows = 1;
    } break;
    case 1: {
      numberOfRows = _menuItems.count;
    } break;
  }
  
  return numberOfRows;
  
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  UITableViewCell *cell = nil;
  
  switch (indexPath.section) {
    case 0: {

      cell = [tableView dequeueReusableCellWithIdentifier:@"OMNMenuHeaderItemCell" forIndexPath:indexPath];

    } break;
    case 1: {

      OMNMenuItemCell *menuItemCell = [tableView dequeueReusableCellWithIdentifier:@"OMNMenuItemCell" forIndexPath:indexPath];
      menuItemCell.label.text = _menuItems[indexPath.row];
      cell = menuItemCell;
      
    } break;
  }
  
  return cell;
  
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  return 50.0f;
  
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath  {
  
  
  if (self.didSelectBlock) {
    
    self.didSelectBlock(tableView, indexPath);
    
  }
  else {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
  }
  
}

@end
