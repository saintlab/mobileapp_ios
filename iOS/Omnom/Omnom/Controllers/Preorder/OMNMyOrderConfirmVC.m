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
#import "UIView+screenshot.h"
#import "OMNRestaurant+omn_network.h"
#import "OMNMenu+wish.h"
#import "OMNTable+omn_network.h"
#import <OMNStyler.h>
#import <BlocksKit+UIKit.h>
#import "OMNPreorderConfirmCellItem.h"
#import "OMNPreorderActionCellItem.h"
#import "OMNPreorderMediator.h"
#import "UIBarButtonItem+omn_custom.h"

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
  NSMutableArray *_preorderedProducts;
  OMNPreorderActionCellItem *_preorderActionCellItem;
  
  OMNPreorderMediator *_preorderMediator;
  
}

- (instancetype)initWithRestaurantMediator:(OMNRestaurantMediator *)restaurantMediator {
  self = [super init];
  if (self) {
    
    _restaurantMediator = restaurantMediator;
    _visitor = restaurantMediator.visitor;
    _preorderMediator = [_restaurantMediator preorderMediatorWithRootVC:self];
    
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  _preorderActionCellItem = [[OMNPreorderActionCellItem alloc] init];
  _preorderActionCellItem.actionText = [_preorderMediator refreshOrdersTitle];
  _preorderActionCellItem.delegate = self;
  
  [self omn_setup];
  
  _tableView.delegate = self;
  _tableView.dataSource = self;
  
  [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"upper_bar_wish"] forBarMetrics:UIBarMetricsDefault];
  
  self.navigationItem.leftBarButtonItem = [UIBarButtonItem omn_barButtonWithTitle:NSLocalizedString(@"PREORDER_CONFIRM_CLOSE_BUTTON_TITLE", @"Закрыть") color:[UIColor whiteColor] target:self action:@selector(closeTap)];
  
  [self setupBottomBar];

}

- (void)setupBottomBar {
  
  UIButton *button = [_preorderMediator bottomButton];
  if (!button) {
    return;
  }
  
  UIEdgeInsets insets = UIEdgeInsetsMake(0.0f, 0.0f, [OMNStyler styler].bottomToolbarHeight.floatValue, 0.0f);
  _tableView.contentInset = insets;
  _tableView.scrollIndicatorInsets = insets;
  
  [self addActionBoardIfNeeded];
  
  self.bottomToolbar.hidden = NO;
  self.bottomToolbar.items =
  @[
    [UIBarButtonItem omn_flexibleItem],
    [[UIBarButtonItem alloc] initWithCustomView:button],
    [UIBarButtonItem omn_flexibleItem],
    ];
  
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  [self updateTableViewAnimated:NO];
  [self loadTableProductItemsWithCompletion:^{}];
  
}

- (void)loadTableProductItemsWithCompletion:(dispatch_block_t)completionBlock {
  
  @weakify(self)
  [_visitor.table getProductItems:^(NSArray *productItems) {
    
    @strongify(self)
    [self didLoadTableProductItems:productItems];
    completionBlock();
    
  } error:^(OMNError *error) {
    
    completionBlock();

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
      
      OMNPreorderConfirmCellItem *orderedItem = [[OMNPreorderConfirmCellItem alloc] initWithMenuProduct:product];
      orderedItem.delegate = self;
      [products addObject:orderedItem];
      
    }
    
  }];
  
  NSMutableArray *tableProducts = [NSMutableArray arrayWithCapacity:_tableProductsIds.count];

  [_tableProductsIds enumerateObjectsUsingBlock:^(id tableProductId, NSUInteger idx, BOOL *stop) {
    
    OMNMenuProduct *menuProduct = _restaurantMediator.menu.products[tableProductId];
    if (menuProduct) {
      
      OMNPreorderConfirmCellItem *tableItem = [[OMNPreorderConfirmCellItem alloc] initWithMenuProduct:menuProduct];
      tableItem.hidePrice = YES;
      tableItem.delegate = self;
      [tableProducts addObject:tableItem];
      
    }
    
  }];

  _preorderedProducts = products;
  _preorderActionCellItem.enabled = (products.count > 0);
  
  _model =
  @[
    _preorderedProducts,
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

- (void)didCreateWish:(OMNWish *)wish {
  
  [_preorderMediator processWish:wish];
  
}

- (void)closeTap {
  
  if (self.didFinishBlock) {
    self.didFinishBlock();
  }
  
}

- (UIStatusBarStyle)preferredStatusBarStyle {
  
  return UIStatusBarStyleLightContent;
  
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  return (0 == indexPath.section);
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  
  if (indexPath.section != 0) {
    return;
  }
  
  OMNPreorderConfirmCellItem *orderedItem = _preorderedProducts[indexPath.row];
  [orderedItem.menuProduct resetSelection];
  [self updateTableViewAnimated:YES];
  
}

- (void)preorderItems {
  
  if (!_restaurantMediator.menu.hasPreorderedItems) {
    return;
  }
  
  _preorderActionCellItem.enabled = NO;
  self.navigationItem.rightBarButtonItem = [UIBarButtonItem omn_loadingItem];
  
  NSArray *selectedWishItems = [_restaurantMediator.menu selectedWishItems];
  @weakify(self)
  [_visitor.restaurant createWishForTable:_visitor.table products:selectedWishItems completionBlock:^(OMNWish *wish) {
    
    @strongify(self)
    [self stopLoading];
    [self didCreateWish:wish];
    
  } wrongIDsBlock:^(NSArray *wrongIDs) {
    
    @strongify(self)
    [self didFailCreateWithWithProductIDs:wrongIDs];
    
  } failureBlock:^(OMNError *error) {
    
    @strongify(self)
    [self stopLoading];
    
  }];
  
}

#pragma mark - OMNPreorderActionCellDelegate

- (void)preorderActionCellDidOrder:(OMNPreorderActionCell *)preorderActionCell {
  
  [self preorderItems];
  
}

- (void)didFailCreateWithWithProductIDs:(NSArray *)productIDs {
  
  NSMutableArray *productList = [NSMutableArray arrayWithCapacity:productIDs.count];
  
  [productIDs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    
    OMNMenuProduct *menuProduct = _restaurantMediator.menu.products[obj];
    if (menuProduct.name.length) {
      [productList addObject:menuProduct.name];
    }
    
  }];
  [self stopLoading];

  NSString *subtitle = [NSString stringWithFormat:kOMN_WISH_CREATE_ERROR_SUBTITLE, [productList componentsJoinedByString:@"\n"]];
  @weakify(self)
  [UIAlertView bk_showAlertViewWithTitle:kOMN_WISH_CREATE_ERROR_TITLE message:subtitle cancelButtonTitle:NSLocalizedString(@"Отменить", @"Отменить") otherButtonTitles:@[NSLocalizedString(@"Ok", @"OK")] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {

    @strongify(self)
    if (alertView.cancelButtonIndex != buttonIndex) {
      
      [self deselectProductsAndReload:productIDs];
      
    }
    
  }];
  
}

- (void)deselectProductsAndReload:(NSArray *)productIDs {
  
  [_restaurantMediator.menu deselectItems:productIDs];
  [self updateTableViewAnimated:NO];
  [self preorderItems];
  
}

- (void)stopLoading {
  
  self.navigationItem.rightBarButtonItem = nil;
  _preorderActionCellItem.enabled = YES;
  
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
