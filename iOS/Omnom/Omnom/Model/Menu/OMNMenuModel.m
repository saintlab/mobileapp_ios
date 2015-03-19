//
//  OMNMenuModel.m
//  omnom
//
//  Created by tea on 19.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMenuModel.h"
#import "OMNMenuItemCell.h"
#import "OMNMenuHeaderView.h"

const CGFloat kMenuTableTopOffset = 64.0f;

@implementation OMNMenuModel

- (void)configureTableView:(UITableView *)tableView {
  
  [tableView registerClass:[OMNMenuItemCell class] forCellReuseIdentifier:@"OMNMenuItemCell"];
  
  OMNMenuHeaderView *menuHeaderView = [[OMNMenuHeaderView alloc] init];
  [menuHeaderView addTarget:self action:@selector(menuTap) forControlEvents:UIControlEventTouchUpInside];
  tableView.tableHeaderView = menuHeaderView;
  tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  tableView.backgroundView = [[UIView alloc] init];
  tableView.backgroundView.backgroundColor = [UIColor clearColor];
  tableView.backgroundColor = [UIColor clearColor];
  tableView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
  tableView.delegate = self;
  tableView.dataSource = self;

}

- (void)menuTap {
  
  if (self.didSelectBlock) {
    self.didSelectBlock(nil);
  }
  
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return _menu.categories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  OMNMenuItemCell *menuItemCell = [tableView dequeueReusableCellWithIdentifier:@"OMNMenuItemCell" forIndexPath:indexPath];
  OMNMenuCategory *menuCategory = _menu.categories[indexPath.row];
  menuItemCell.label.text = menuCategory.name;
  return menuItemCell;
  
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  CGFloat heightForRow = 44.0f;
  return heightForRow;
  
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath  {
  
  if (self.didSelectBlock) {
    
    OMNMenuCategory *menuCategory = _menu.categories[indexPath.row];
    self.didSelectBlock(menuCategory);
    
  }
  else {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
  }
  
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
  
  if (self.didEndDraggingBlock) {
    self.didEndDraggingBlock((UITableView *)scrollView);
  }
  
}

@end
