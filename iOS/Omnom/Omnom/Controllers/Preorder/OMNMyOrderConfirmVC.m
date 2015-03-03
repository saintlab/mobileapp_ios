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
#import "OMNMenu+wish.h"
#import "OMNTable+omn_network.h"
#import <OMNStyler.h>
#import "OMNOrderToolbarButton.h"
#import <BlocksKit.h>
#import "OMNPreorderConfirmCellItem.h"
#import "OMNPreorderActionCellItem.h"

@interface OMNMyOrderConfirmVC ()
<OMNPreorderActionCellDelegate,
UITableViewDelegate,
UITableViewDataSource,
OMNPreorderConfirmCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation OMNMyOrderConfirmVC {
  
  OMNRestaurantMediator *_restaurantMediator;
  OMNVisitor *_visitor;
  NSArray *_tableProductsIds;

  NSArray *_model;
  OMNPreorderActionCellItem *_preorderActionCellItem;
  
}

- (instancetype)initWithRestaurantMediator:(OMNRestaurantMediator *)restaurantMediator {
  self = [super init];
  if (self) {
    
    _restaurantMediator = restaurantMediator;
    _visitor = restaurantMediator.visitor;
    
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  _preorderActionCellItem = [[OMNPreorderActionCellItem alloc] init];
  
  [self omn_setup];
  
  _tableView.delegate = self;
  _tableView.dataSource = self;
  
  [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"upper_bar_wish"] forBarMetrics:UIBarMetricsDefault];
  
  self.navigationItem.leftBarButtonItem = [UIBarButtonItem omn_barButtonWithTitle:NSLocalizedString(@"PREORDER_CONFIRM_CLOSE_BUTTON_TITLE", @"Закрыть") color:[UIColor whiteColor] target:self action:@selector(closeTap)];
  
  if (_restaurantMediator.restaurant.settings.has_table_order) {
    
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
  
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  [self updateTableViewAnimated:NO];
  [self loadTableProductItemsWithCompletion:nil];
  
}

- (void)loadTableProductItemsWithCompletion:(dispatch_block_t)completionBlock {
  
  @weakify(self)
  [_visitor.table getProductItems:^(NSArray *productItems) {
    
    @strongify(self)
    [self didLoadTableProductItems:productItems];
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
    
    if (product.preordered) {
      
      [products addObject:[[OMNPreorderConfirmCellItem alloc] initWithMenuProduct:product]];
      
    }
    
  }];
  
  NSMutableArray *tableProducts = [NSMutableArray arrayWithCapacity:_tableProductsIds.count];
  [_tableProductsIds enumerateObjectsUsingBlock:^(id tableProductId, NSUInteger idx, BOOL *stop) {
    
    OMNMenuProduct *menuProduct = _restaurantMediator.menu.products[tableProductId];
    if (menuProduct) {
      
      [tableProducts addObject:[[OMNPreorderConfirmCellItem alloc] initWithMenuProduct:menuProduct]];
      
    }
    
  }];

  _model =
  @[
    products,
    @[_preorderActionCellItem],
    tableProducts,
    ];
  
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
  
  return _model.count;
  
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
  NSArray *rowItems = _model[section];
  return rowItems.count;
  
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath {
  
  NSArray *rowItems = _model[indexPath.section];
  id item = rowItems[indexPath.row];
  return item;
  
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = nil;
  
  id<OMNCellItemProtocol> item = [self itemAtIndexPath:indexPath];
  
  if ([item conformsToProtocol:@protocol(OMNCellItemProtocol)]) {
    
    cell = [item cellForTableView:tableView];
    
    if ([cell isKindOfClass:[OMNPreorderConfirmCell class]]) {
      
      OMNPreorderConfirmCell *preorderConfirmCell = (OMNPreorderConfirmCell *)cell;
      preorderConfirmCell.delegate = self;
      preorderConfirmCell.hidePrice = (indexPath.section > 0);
      
    }
    else if ([cell isKindOfClass:[OMNPreorderActionCell class]]) {
      
      [(OMNPreorderActionCell *)cell setDelegate:self];
      
    }
    
  }
  
  return cell;
  
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  id<OMNCellItemProtocol> item = [self itemAtIndexPath:indexPath];
  
  if ([item conformsToProtocol:@protocol(OMNCellItemProtocol)]) {
    
    return [item heightForTableView:tableView];
    
  }
  return 0.0f;
  
}

#pragma mark - OMNPreorderActionCellDelegate

- (void)preorderActionCellDidOrder:(__weak OMNPreorderActionCell *)preorderActionCell {
  
  preorderActionCell.actionButton.enabled = NO;
  self.navigationItem.rightBarButtonItem = [UIBarButtonItem omn_loadingItem];
  
  NSArray *selectedWishItems = [_restaurantMediator.menu selectedWishItems];
  @weakify(self)
  [_visitor.restaurant createWishForTable:_visitor.table products:selectedWishItems completionBlock:^(OMNWish *wish) {
    
    @strongify(self)
    [self stopLoading:preorderActionCell.actionButton];
    [self didCreateWish:wish];

  } failureBlock:^(OMNError *error) {
    
    @strongify(self)
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
  
  [OMNPreorderConfirmCellItem registerCellForTableView:_tableView];
  [OMNPreorderActionCellItem registerCellForTableView:_tableView];

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

- (void)preorderConfirmCellDidEdit:(OMNPreorderConfirmCell *)preorderConfirmCell {
  
  @weakify(self)
  [preorderConfirmCell.item editMenuProductFromController:self withCompletion:^{
    
    @strongify(self)
    [self updateTableViewAnimated:YES];
    
  }];
  
}

@end
