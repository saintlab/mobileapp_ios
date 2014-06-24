//
//  GRestaurantMenuVC.m
//  restaurants
//
//  Created by tea on 13.03.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNRestaurantMenuVC.h"
#import "OMNMenu.h"
#import "OMNOrdersVC.h"
#import "OMNOrderVCDelegate.h"
#import "OMNSearchTableVC.h"
#import "UINavigationController+omn_replace.h"
#import "OMNPaymentVC.h"
#import "OMNAssetManager.h"
#import "OMNUserInfoTransitionDelegate.h"
#import "OMNUserInfoVC.h"

@interface OMNRestaurantMenuVC ()
<OMNOrdersVCDelegate,
OMNUserInfoVCDelegate>

@end

@implementation OMNRestaurantMenuVC {
  OMNRestaurant *_restaurant;
  OMNTable *_table;
  OMNMenu *_menu;
  
  NSMutableArray *_products;
  UIRefreshControl *_refreshControl;

  OMNUserInfoTransitionDelegate *_transitionDelegate;
}

- (instancetype)initWithRestaurant:(OMNRestaurant *)restaurant table:(OMNTable *)table {
  self = [super init];
  if (self)
  {
    _restaurant = restaurant;
    _table = table;
    _products = [NSMutableArray array];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
//  self.tableView.allowsMultipleSelection = YES;
  
  [self setup];

  _refreshControl = [[UIRefreshControl alloc] init];
  [_refreshControl addTarget:self action:@selector(refreshOrders) forControlEvents:UIControlEventValueChanged];
//  self.refreshControl = _refreshControl;
  [self refreshOrders];
  
  
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.navigationController setToolbarHidden:NO animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [self.navigationController setToolbarHidden:YES animated:animated];
}

- (void)setup {
 
  [self.navigationController.navigationBar setTitleTextAttributes:
   @{
     NSFontAttributeName : [OMNAssetManager manager].navBarTitleFont
     }];
  
  [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"white_pixel"] forBarMetrics:UIBarMetricsDefault];
  
  UIImageView *backgroundIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background_blur"]];
  backgroundIV.center = self.view.center;
  [self.view insertSubview:backgroundIV atIndex:0];

  UIBarButtonItem *createOrderButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"User", nil) style:UIBarButtonItemStylePlain target:self	action:@selector(userProfileTap)];
  self.navigationItem.rightBarButtonItems = @[createOrderButton];
  
  UIBarButtonItem *getOrdersButton = [[UIBarButtonItem alloc] initWithTitle:@"Заказы" style:UIBarButtonItemStylePlain target:self	action:@selector(getOrdersTap)];
  getOrdersButton.accessibilityLabel = @"order_button";
  UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
  UIBarButtonItem *callWaiterButton = [[UIBarButtonItem alloc] initWithTitle:@"Официант" style:UIBarButtonItemStylePlain target:self	action:@selector(callWaiterTap)];
  
  self.toolbarItems = @[getOrdersButton, flex, callWaiterButton];
  
}

- (void)userProfileTap {
  
  _transitionDelegate = [[OMNUserInfoTransitionDelegate alloc] init];
  
  OMNUserInfoVC *userInfoVC = [[OMNUserInfoVC alloc] init];
  userInfoVC.delegate = self;
  UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:userInfoVC];
  navVC.transitioningDelegate = _transitionDelegate;
  navVC.modalPresentationStyle = UIModalPresentationCustom;
  [self presentViewController:navVC animated:YES completion:nil];

  return;
#ifdef __IPHONE_8_0
  if (&UIApplicationOpenSettingsURLString) {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
  }
#endif
  
}

#pragma mark - OMNUserInfoVCDelegate

- (void)userInfoVCDidFinish:(OMNUserInfoVC *)userInfoVC {
  
  [self dismissViewControllerAnimated:YES completion:nil];
  
}

- (void)refreshOrders {
  
  return;
  
  if (!_refreshControl.refreshing) {
    [_refreshControl beginRefreshing];
  }
  
  __weak OMNRestaurantMenuVC *weakSelf = self;
  [_restaurant getMenu:^(OMNMenu *menu) {
    
    [_refreshControl endRefreshing];
    [weakSelf finishLoadingMenu:menu];
    
  } error:^(NSError *error) {
    
    [_refreshControl endRefreshing];
    [[[UIAlertView alloc] initWithTitle:error.localizedDescription message:error.localizedRecoverySuggestion delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    
  }];
  
}


- (void)createOrderTap {
  
  if (0 == _products.count) {
    [[[UIAlertView alloc] initWithTitle:@"Нет продуктов" message:@"Добавьте хотя бы один продукт" delegate:nil cancelButtonTitle:@"Ок" otherButtonTitles:nil] show];
    return;
  }
  
  __weak typeof(self)weakSelf = self;

  [_restaurant createOrderForTableID:@"1" products:_products block:^(OMNOrder *order) {
    
    [weakSelf resetOrders];
    [[[UIAlertView alloc] initWithTitle:@"Заказ создан" message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    
  } error:^(NSError *error) {
    
    [[[UIAlertView alloc] initWithTitle:error.localizedDescription message:error.localizedRecoverySuggestion delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    
  }];
}

- (void)callWaiterTap {
  
  __weak typeof(self)weakSelf = self;
  [self searchTableWithBlock:^(OMNDecodeBeacon *decodeBeacon) {
    
    [_restaurant callWaiterForTableID:decodeBeacon.tableId success:^{
      
      dispatch_async(dispatch_get_main_queue(), ^{
        
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Официант успешно позван", nil) message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        
      });
      
    } error:^(NSError *error) {
      
      NSLog(@"error>%@", error);
      
    }];
    
    [weakSelf.navigationController popToViewController:self animated:YES];
    
  }];
  
}

- (void)searchTableWithBlock:(OMNSearchTableVCBlock)block {

  OMNSearchTableVC *searchTableVC = [[OMNSearchTableVC alloc] initWithBlock:block];
  [self.navigationController pushViewController:searchTableVC animated:YES];
  
}

- (void)resetOrders {
  [_products enumerateObjectsUsingBlock:^(OMNMenuItem *menuItem, NSUInteger idx, BOOL *stop) {
    menuItem.quantity = 0;
  }];
  [_products removeAllObjects];
//  [self.tableView reloadData];
}

- (void)getOrdersTap {
  
  __weak typeof(self)weakSelf = self;
  OMNRestaurant *restaurant = _restaurant;
  [self searchTableWithBlock:^(OMNDecodeBeacon *decodeBeacon) {
    
    if (nil == decodeBeacon) {
      return;
    }
    
    [restaurant getOrdersForTableID:decodeBeacon.tableId orders:^(NSArray *orders) {

      [weakSelf processOrders:orders];
      
    } error:^(NSError *error) {
      
      [[[UIAlertView alloc] initWithTitle:error.localizedDescription message:error.localizedRecoverySuggestion delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
      [weakSelf.navigationController popToViewController:weakSelf animated:YES];
      
    }];
    
  }];
  
  
}

- (void)processOrders:(NSArray *)orders {
  
  if (orders.count > 1) {

    [self selectOrderFromOrders:orders];
    
  }
  else if (1 == orders.count){

    [self showOrder:[orders firstObject]];
    
  }
  else {
    
    [self.navigationController popToViewController:self animated:YES];
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"На этом столике нет заказов", nil) message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    
  }
  
}

- (void)selectOrderFromOrders:(NSArray *)orders {
  
  OMNOrdersVC *ordersVC = [[OMNOrdersVC alloc] initWithOrders:orders];
  ordersVC.delegate = self;
  ordersVC.title = @"Заказы";
  [self.navigationController omn_replaceCurrentViewControllerWithController:ordersVC animated:YES];
  
}

#pragma mark - OMNOrdersVCDelegate

- (void)ordersVC:(OMNOrdersVC *)ordersVC didSelectOrder:(OMNOrder *)order {
  
  [self showOrder:order];
  
}

- (void)showOrder:(OMNOrder *)order {
  
  OMNPaymentVC *paymentVC = [[OMNPaymentVC alloc] initWithOrder:order];
  paymentVC.title = order.created;
  [self.navigationController omn_replaceCurrentViewControllerWithController:paymentVC animated:YES];
  
}

- (void)finishLoadingMenu:(OMNMenu *)menu {
  
  _menu = menu;
//  [self.tableView reloadData];
  
}

- (void)stepperValueChanged:(UIStepper *)stepper {
  
  OMNMenuItem *menuItem = _menu.items[stepper.tag];
  menuItem.quantity = stepper.value;
  
  if (![_products containsObject:menuItem]) {
    
    [_products addObject:menuItem];
    
  }
  
//  [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:stepper.tag inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return _menu.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *reuseIdentifier = @"reuseIdentifier";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
  
  if (nil == cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    UIStepper *stepper = [[UIStepper alloc] init];
    stepper.minimumValue = 0;
    [stepper addTarget:self action:@selector(stepperValueChanged:) forControlEvents:UIControlEventValueChanged];
    cell.accessoryView = stepper;
  }
  
  UIStepper *stepper = (UIStepper *)cell.accessoryView;
  stepper.tag = indexPath.row;
  
  OMNMenuItem *menuItem = _menu.items[indexPath.row];
  stepper.value = menuItem.quantity;

  cell.textLabel.text = menuItem.title;
  cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f = (%.1f * %.2f)", menuItem.price * menuItem.quantity, menuItem.quantity, menuItem.price];
  
  if (menuItem.quantity > 0) {
    
    [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    
  }
  else {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
  }
  
  return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//  GRestaurant *restaurant = self.restaurants[indexPath.row];
}

@end
