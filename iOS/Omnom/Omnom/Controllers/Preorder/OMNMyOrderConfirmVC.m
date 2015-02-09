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
#import "OMNMenu+wish.h"

@interface OMNMyOrderConfirmVC ()
<OMNPreorderActionCellDelegate>

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

- (void)didCreateWish:(OMNWish *)wish {
  
  [_restaurantMediator.menu resetSelection];

  OMNPreorderDoneVC *preorderDoneVC = [[OMNPreorderDoneVC alloc] init];
  preorderDoneVC.backgroundImage = [self.view omn_screenshot];
  preorderDoneVC.didCloseBlock = self.didCloseBlock;
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
      
      OMNPreorderActionCell *preorderActionCell = [tableView dequeueReusableCellWithIdentifier:@"OMNPreorderActionCell" forIndexPath:indexPath];
      preorderActionCell.delegate = self;
      preorderActionCell.actionButton.enabled = (_products.count > 0);
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

#pragma mark - OMNPreorderActionCellDelegate

- (void)preorderActionCellDidOrder:(__weak OMNPreorderActionCell *)preorderActionCell {
  
  preorderActionCell.actionButton.enabled = NO;
  self.navigationItem.rightBarButtonItem = [UIBarButtonItem omn_loadingItem];
  
  NSArray *selectedWishItems = [_restaurantMediator.menu selectedWishItems];
  __weak typeof(self)weakSelf = self;
  [_restaurantMediator.restaurant createWishForTableID:_restaurantMediator.table.id products:selectedWishItems completionBlock:^(OMNWish *wish) {
    
    [self stopLoading:preorderActionCell.actionButton];
    [weakSelf didCreateWish:wish];
    
  } failureBlock:^(OMNError *error) {
    
    [self stopLoading:preorderActionCell.actionButton];
    
  }];
  
}

- (void)stopLoading:(__weak  UIButton *)actionButton {
  
  self.navigationItem.rightBarButtonItem = nil;
  actionButton.enabled = YES;
  
}

- (void)preorderActionCellDidClear:(OMNPreorderActionCell *)preorderActionCell {
  
  [_restaurantMediator.menu resetSelection];
  
  NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:_products.count];
  for (NSInteger row = 0; row < _products.count; row++) {
    
    [indexPaths addObject:[NSIndexPath indexPathForRow:row inSection:0]];
    
  }
  [_products removeAllObjects];
  [self.tableView beginUpdates];
  [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
  [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
  [self.tableView endUpdates];
  
}

@end
