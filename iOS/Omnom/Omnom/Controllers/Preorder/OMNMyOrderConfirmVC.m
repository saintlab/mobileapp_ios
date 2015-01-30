//
//  OMNPreorderConfirmVC.m
//  omnom
//
//  Created by tea on 19.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMyOrderConfirmVC.h"
#import "OMNPreorderConfirmCell.h"
#import "OMNPreorderActionCell.h"
#import "UIBarButtonItem+omn_custom.h"
#import "OMNPreorderDoneVC.h"
#import "UIView+screenshot.h"
#import "OMNRestaurant+omn_network.h"
#import "OMNMenuProduct+cell.h"

@interface OMNMyOrderConfirmVC ()

@end

@implementation OMNMyOrderConfirmVC {
  
  OMNRestaurantMediator *_restaurantMediator;
  NSMutableArray *_products;
}

- (instancetype)initWithRestaurantMediator:(OMNRestaurantMediator *)restaurantMediator {
  self = [super init];
  if (self) {
    
    _restaurantMediator = restaurantMediator;
    
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  _products = [NSMutableArray array];
  [_restaurantMediator.menu.products enumerateKeysAndObjectsUsingBlock:^(id key, OMNMenuProduct *product, BOOL *stop) {
    
    if (product.quantity > 0.0) {
    
      [_products addObject:product];
      
    }
    
  }];
  
  
  [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"upper_bar_wish"] forBarMetrics:UIBarMetricsDefault];
  
  self.tableView.tableFooterView = [[UIView alloc] init];
  [self.tableView registerClass:[OMNPreorderConfirmCell class] forCellReuseIdentifier:@"OMNPreorderConfirmCell"];
  [self.tableView registerClass:[OMNPreorderActionCell class] forCellReuseIdentifier:@"OMNPreorderActionCell"];
  
  self.tableView.tableFooterView = [[UIView alloc] init];
  self.navigationItem.leftBarButtonItem = [UIBarButtonItem omn_barButtonWithTitle:NSLocalizedString(@"PREORDER_CONFIRM_CLOSE_BUTTON_TITLE", @"Закрыть") color:[UIColor whiteColor] target:self action:@selector(closeTap)];
  
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
 
  
}

- (void)closeTap {
  
  if (self.didCloseBlock) {
    
    self.didCloseBlock();
    
  }
  
}

- (UIStatusBarStyle)preferredStatusBarStyle {
  
  return UIStatusBarStyleLightContent;
  
}

- (void)clearOrders {
  
  [_restaurantMediator.menu resetSelection];

  NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:_products.count];
  for (NSInteger row = 0; row < _products.count; row++) {
    
    [indexPaths addObject:[NSIndexPath indexPathForRow:row inSection:0]];
    
  }
  [_products removeAllObjects];
  [self.tableView beginUpdates];
  [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
  [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
  [self.tableView endUpdates];

}

- (void)preorderTap {
  
  return;
  NSArray *products =
  @[
    @{@"id":@"2084-in-riba-ris-nsk-at-aura", @"quantity":@(1)},
    @{@"id":@"2092-in-riba-ris-nsk-at-aura", @"quantity":@(1)},
    ];
  
  [_restaurantMediator.restaurant createWishForTableID:_restaurantMediator.table.id products:products block:^(OMNOrder *order) {
    
  } failureBlock:^(OMNError *error) {
    
  }];
  
  return;
  OMNPreorderDoneVC *preorderDoneVC = [[OMNPreorderDoneVC alloc] init];
  preorderDoneVC.backgroundImage = [self.view omn_screenshot];
  __weak typeof(self)weakSelf = self;
  preorderDoneVC.didCloseBlock = ^{
    
    [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
    
  };
  [self.navigationController presentViewController:preorderDoneVC animated:YES completion:nil];
  
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  
  return 3;
  
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
  NSInteger numberOfRows = 0;
  switch (section) {
    case 0: {
      numberOfRows = _products.count;
    } break;
    case 1: {
      numberOfRows = 1;
    } break;
    case 2: {
    } break;
  }
  
  return numberOfRows;
  
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = nil;
  
  switch (indexPath.section) {
    case 0: {
      
      OMNPreorderConfirmCell *preorderConfirmCell = [tableView dequeueReusableCellWithIdentifier:@"OMNPreorderConfirmCell" forIndexPath:indexPath];
      preorderConfirmCell.menuProduct = _products[indexPath.row];
      cell = preorderConfirmCell;
      
    } break;
    case 1: {
      
      __weak typeof(self)weakSelf = self;
      OMNPreorderActionCell *preorderActionCell = [tableView dequeueReusableCellWithIdentifier:@"OMNPreorderActionCell" forIndexPath:indexPath];
      preorderActionCell.actionButton.enabled = (_products.count > 0);
      preorderActionCell.didOrderBlock = ^{
      
        [weakSelf preorderTap];
        
      };
      preorderActionCell.didClearBlock = ^{
        
        [weakSelf clearOrders];
        
      };
      cell = preorderActionCell;
      
    } break;
    case 2: {
      
      cell = [tableView dequeueReusableCellWithIdentifier:@"OMNPreorderConfirmCell" forIndexPath:indexPath];
      
    } break;
  }
  
  return cell;
  
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  CGFloat heightForRow = 0.0f;
  switch (indexPath.section) {
    case 0: {
      
      OMNMenuProduct *menuProduct = _products[indexPath.row];
      heightForRow = [menuProduct preorderHeightForTableView:tableView];

    } break;
    case 1: {
      heightForRow = 140.0f;
    } break;
    case 2: {
      heightForRow = 86.0f;
    } break;
  }
  
  return heightForRow;
  
}

@end
