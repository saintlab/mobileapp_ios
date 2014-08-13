//
//  OMNRestaurantInfoVC.m
//  omnom
//
//  Created by tea on 11.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNRestaurantInfoVC.h"
#import "OMNRestaurantInfoCell.h"
#import <AFNetworking.h>

@implementation OMNRestaurantInfoVC {
  BOOL _selected;
  NSArray *_info;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  UIButton *closeButton = [[UIButton alloc] init];
  [closeButton setImage:[UIImage imageNamed:@"back_button_icon"] forState:UIControlStateNormal];
  [closeButton addTarget:self action:@selector(closeTap) forControlEvents:UIControlEventTouchUpInside];
  [closeButton sizeToFit];
  self.navigationItem.titleView = closeButton;
  
  [self.navigationItem setHidesBackButton:YES animated:NO];
  
  
  [self.tableView registerClass:[OMNRestaurantInfoCell class] forCellReuseIdentifier:@"cell"];
  [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"defaultCell"];
  
  _info = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"restaurantInfo" ofType:@"json"]] options:0 error:nil];
  
}

- (void)closeTap {
  [self.delegate restaurantInfoVCDidFinish:self];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return _info.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  NSInteger numberOfRows = 0;
  
  switch (section) {
    case 0: {
      NSArray *items = _info[0][@"items"];
      numberOfRows = (_selected) ? (items.count + 1) : (1);
    } break;
  }
  
  return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  UITableViewCell *cell = nil;
  if (0 == indexPath.row) {
    cell = [tableView dequeueReusableCellWithIdentifier:@"defaultCell" forIndexPath:indexPath];
  }
  else {
    cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
  }
  [self configureCell:cell forRowAtIndexPath:indexPath];
  
  return cell;
}

- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
  
  NSDictionary *info = _info[indexPath.section];
  
  if (indexPath.row == 0) {
    
    cell.textLabel.text = info[@"title"];
    
  }
  else {
    NSArray *items = info[@"items"];
    NSDictionary *item = items[indexPath.row - 1];
    OMNRestaurantInfoCell *restaurantInfoCell = (OMNRestaurantInfoCell *)cell;
    [restaurantInfoCell setItem:item];
    
  }
  
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  if (0 == indexPath.row &&
      0 == indexPath.section) {
    _selected = !_selected;
    
    NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:5];
    
    NSArray *items = _info[0][@"items"];
    for (NSInteger row = 1; row <= items.count; row++) {
      [indexPaths addObject:[NSIndexPath indexPathForRow:row inSection:0]];
    }
    
    if (_selected) {
      [tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else {
      [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    }
    
  }
  
}

@end
