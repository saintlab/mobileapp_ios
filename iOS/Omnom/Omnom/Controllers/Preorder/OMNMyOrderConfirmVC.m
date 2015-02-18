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
#import "OMNTable+omn_network.h"
#import <OMNStyler.h>
#import "OMNOrderToolbarButton.h"
#import "OMNMenuProduct+omn_edit.h"

@interface OMNMyOrderConfirmVC ()
<OMNPreorderActionCellDelegate,
UITableViewDelegate,
UITableViewDataSource,
OMNPreorderConfirmCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation OMNMyOrderConfirmVC {
  
  OMNRestaurantMediator *_restaurantMediator;
  NSMutableArray *_products;
  NSArray *_tableProductsIds;
  NSMutableArray *_tableProducts;
  
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
  
  [self omn_setup];
  
  _tableView.delegate = self;
  _tableView.dataSource = self;
  
  [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"upper_bar_wish"] forBarMetrics:UIBarMetricsDefault];
  
  self.navigationItem.leftBarButtonItem = [UIBarButtonItem omn_barButtonWithTitle:NSLocalizedString(@"PREORDER_CONFIRM_CLOSE_BUTTON_TITLE", @"Закрыть") color:[UIColor whiteColor] target:self action:@selector(closeTap)];
  
  [self addActionBoardIfNeeded];

  OMNOrderToolbarButton *callBillButton = [[OMNOrderToolbarButton alloc] initWithTotalAmount:_restaurantMediator.totalOrdersAmount target:self action:@selector(requestTableOrders)];
  self.bottomToolbar.hidden = NO;
  self.bottomToolbar.items =
  @[
    [UIBarButtonItem omn_flexibleItem],
    [[UIBarButtonItem alloc] initWithCustomView:callBillButton],
    [UIBarButtonItem omn_flexibleItem],
    ];
  
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  [self updateTableViewAnimated:NO];
  [self loadTableProductItemsWithCompletion:nil];
  
}

- (void)loadTableProductItemsWithCompletion:(dispatch_block_t)completionBlock {
  
  __weak typeof(self)weakSelf = self;
  [_restaurantMediator.table getProductItems:^(NSArray *productItems) {
    
    [weakSelf didLoadTableProductItems:productItems];
    if (completionBlock) {
      completionBlock();
    }
    
  } error:^(OMNError *error) {
    
    if (completionBlock) {
      completionBlock();
    }

  }];
  
}

- (void)didLoadTableProductItems:(NSArray *)items {
  
  _tableProductsIds = items;
  [self updateTableViewAnimated:YES];
  
}

- (void)updateTableViewAnimated:(BOOL)animated {
  
  NSMutableArray *products = [NSMutableArray array];
  [_restaurantMediator.menu.products enumerateKeysAndObjectsUsingBlock:^(id key, OMNMenuProduct *product, BOOL *stop) {
    
    if (product.quantity > 0.0) {
      
      [products addObject:product];
      
    }
    
  }];
  
  _products = products;
  
  NSMutableArray *tableProducts = [NSMutableArray arrayWithCapacity:_tableProductsIds.count];
  [_tableProductsIds enumerateObjectsUsingBlock:^(id tableProductId, NSUInteger idx, BOOL *stop) {
    
    OMNMenuProduct *menuProduct = _restaurantMediator.menu.products[tableProductId];
    if (menuProduct &&
        menuProduct.quantity == 0.0) {
      
      [tableProducts addObject:menuProduct];
      
    }
    
  }];
  _tableProducts = tableProducts;
  
  if (animated) {
    
    [_tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 3)] withRowAnimation:UITableViewRowAnimationFade];
    
  }
  else {
    
    [_tableView reloadData];
    
  }
  
}

- (void)requestTableOrders {
  
  [_restaurantMediator requestTableOrders];
  [self closeTap];
  
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
  preorderDoneVC.didCloseBlock = self.didCreateBlock;
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
      numberOfRows = _tableProducts.count;
    } break;
  }
  
  return numberOfRows;
  
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = nil;
  
  switch (indexPath.section) {
    case 0: {
      
      OMNPreorderConfirmCell *preorderConfirmCell = [tableView dequeueReusableCellWithIdentifier:@"OMNPreorderConfirmCell" forIndexPath:indexPath];
      preorderConfirmCell.delegate = self;
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
      
      OMNPreorderConfirmCell *preorderConfirmCell = [tableView dequeueReusableCellWithIdentifier:@"OMNPreorderConfirmCell" forIndexPath:indexPath];
      preorderConfirmCell.delegate = self;
      preorderConfirmCell.menuProduct = _tableProducts[indexPath.row];
      cell = preorderConfirmCell;
      
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

      OMNMenuProduct *menuProduct = _tableProducts[indexPath.row];
      heightForRow = [menuProduct preorderHeightForTableView:tableView];

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
  [_restaurantMediator.restaurant createWishForTable:_restaurantMediator.table products:selectedWishItems completionBlock:^(OMNWish *wish) {
    
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
  [self updateTableViewAnimated:YES];
  
}

- (void)preorderActionCellDidRefresh:(OMNPreorderActionCell *)preorderActionCell {
  
  preorderActionCell.refreshButton.enabled = NO;
  [self loadTableProductItemsWithCompletion:^{
    
    preorderActionCell.refreshButton.enabled = YES;

  }];
  
}

- (void)omn_setup {
  
  _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
  _tableView.translatesAutoresizingMaskIntoConstraints = NO;
  _tableView.tableFooterView = [[UIView alloc] init];
  _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  [self.view addSubview:_tableView];
  
  [_tableView registerClass:[OMNPreorderConfirmCell class] forCellReuseIdentifier:@"OMNPreorderConfirmCell"];
  [_tableView registerClass:[OMNPreorderActionCell class] forCellReuseIdentifier:@"OMNPreorderActionCell"];
  
  UIEdgeInsets insets = UIEdgeInsetsMake(0.0f, 0.0f, [OMNStyler styler].bottomToolbarHeight.floatValue, 0.0f);
  _tableView.contentInset = insets;
  _tableView.scrollIndicatorInsets = insets;
  
  NSDictionary *views =
  @{
    @"tableView" : _tableView,
    @"topLayoutGuide" : self.topLayoutGuide,
    };
  
  NSDictionary *metrics =
  @{
    };
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableView]|" options:kNilOptions metrics:metrics views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topLayoutGuide][tableView]|" options:kNilOptions metrics:metrics views:views]];
  
  [self.view layoutIfNeeded];
  
}

#pragma mark - OMNPreorderConfirmCellDelegate

- (void)preorderConfirmCell:(OMNPreorderConfirmCell *)preorderConfirmCell didEditMenuProduct:(OMNMenuProduct *)menuProduct {
  
  __weak typeof(self)weakSelf = self;
  [menuProduct editMenuProductFromController:self withCompletion:^{
    
    [weakSelf updateTableViewAnimated:YES];
    
  }];
  
}

@end
