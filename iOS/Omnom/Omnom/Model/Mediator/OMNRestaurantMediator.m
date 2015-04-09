//
//  OMNRestaurantMenuMediator.m
//  restaurants
//
//  Created by tea on 04.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNRestaurantMediator.h"
#import "OMNUserInfoVC.h"
#import "OMNRestaurantActionsVC.h"
#import "OMNSearchRestaurantsVC.h"
#import "OMNAuthorization.h"
#import "OMNPushPermissionVC.h"
#import "OMNOrdersVC.h"
#import "OMNOrderCalculationVC.h"
#import "OMNTable+omn_network.h"
#import "UINavigationController+omn_replace.h"
#import "OMNSocketManager.h"
#import "OMNNoOrdersVC.h"
#import "OMNMyOrderConfirmVC.h"
#import "OMNNavigationController.h"
#import "OMNLaunchHandler.h"
#import "OMNRestaurant+omn_network.h"
#import "OMNNavigationControllerDelegate.h"
#import "OMNOrdersLoadingVC.h"
#import "OMNWishMediator.h"
#import "UIBarButtonItem+omn_custom.h"
#import "OMNTransactionPaymentVC.h"

@interface OMNRestaurantMediator ()
<OMNOrdersVCDelegate,
OMNOrderCalculationVCDelegate>

@end

@implementation OMNRestaurantMediator {
  
  __weak OMNOrdersVC *_ordersVC;
  BOOL _shouldShowOrdersOnLaunch;
  BOOL _pushPermissionRequested;
  
}

- (void)dealloc {
  
  if (!_restaurant.is_demo) {
  
    [[OMNSocketManager manager] leave:_table.id];
    [[OMNSocketManager manager] disconnectAndLeaveAllRooms:YES];
    
  }
  
}

- (instancetype)initWithVisitor:(OMNVisitor *)visitor rootViewController:(OMNRestaurantActionsVC *)restaurantActionsVC {
  self = [super init];
  if (self) {

    _restaurantActionsVC = restaurantActionsVC;
    _visitor = visitor;
    _restaurant = visitor.restaurant;
    
    if (!_restaurant.is_demo) {
      
      [[OMNSocketManager manager] connectWithToken:[OMNAuthorization authorisation].token completion:^{
      }];
      
    }
    
    if (_restaurant.tables.count) {
      
      OMNTable *table = [_restaurant.tables firstObject];
      table.orders = _restaurant.orders;
      [self setTable:table];
      
    }
    _shouldShowOrdersOnLaunch = (_restaurant.orders.count > 0);
    @weakify(self)
    [_restaurant getMenuWithCompletion:^(OMNMenu *menu) {
      
      @strongify(self)
      self.menu = menu;
      
    }];
    
  }
  return self;
}

- (void)setTable:(OMNTable *)table {
  
  _table = table;
  if (!_restaurant.is_demo) {
    
    [_table join];
    
  }
  
}

- (void)checkStartConditions {
  
  if (_shouldShowOrdersOnLaunch &&
      _table.hasOrders) {
    
    [self showOrders];
    
  }
  else if ([OMNLaunchHandler sharedHandler].launchOptions.showTableOrders) {
    
    [OMNLaunchHandler sharedHandler].launchOptions.showTableOrders = NO;
    [self showTableOrders];
    
  }
  else if (!self.skipRequestPushNotificationPermission) {
    
    @weakify(self)
    [self showPushPermissionVCWithCompletion:^{
      
      @strongify(self)
      [self popToRootViewControllerAnimated:YES];
      
    }];
    
  }
  else {
    
    [_table updateOrdersIfNeeded];
    
  }
  
}

- (long long)totalOrdersAmount {
  
  return _table.ordersTotalAmount;
  
}

- (void)popToRootViewControllerAnimated:(BOOL)animated {
  
  [_restaurantActionsVC.navigationController popToViewController:_restaurantActionsVC animated:animated];
  
}

- (void)pushViewController:(UIViewController *)vc {
  
  [_restaurantActionsVC.navigationController pushViewController:vc animated:YES];
  
}

- (void)showUserProfile {

  OMNUserInfoVC *userInfoVC = [[OMNUserInfoVC alloc] initWithMediator:self];
  @weakify(self)
  userInfoVC.didCloseBlock = ^{
    
    @strongify(self)
    [self.restaurantActionsVC.navigationController dismissViewControllerAnimated:YES completion:nil];
    
  };
  UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:userInfoVC];
  navigationController.delegate = [OMNNavigationControllerDelegate sharedDelegate];
  [_restaurantActionsVC.navigationController presentViewController:navigationController animated:YES completion:nil];
  
}

- (void)exitRestaurant {
  
  if (_restaurantActionsVC.didCloseBlock) {
    _restaurantActionsVC.didCloseBlock();
  }
  
}

- (void)rescanTable {
  
  if (_restaurantActionsVC.rescanTableBlock) {
    
    _restaurantActionsVC.rescanTableBlock();
    
  }
  
}

- (void)didFinishPayment {
  [self popToRootViewControllerAnimated:YES];
}

- (void)showPreorders {
  
  OMNMyOrderConfirmVC *preorderConfirmVC = [[OMNMyOrderConfirmVC alloc] initWithRestaurantMediator:self];
  @weakify(self)
  preorderConfirmVC.didFinishBlock = ^{
    
    @strongify(self)
    [self.restaurantActionsVC.navigationController dismissViewControllerAnimated:YES completion:nil];
    
  };
  [_restaurantActionsVC.navigationController presentViewController:[[OMNNavigationController alloc] initWithRootViewController:preorderConfirmVC] animated:YES completion:nil];
  
}

- (void)showTableOrders {
  
  if (!_table) {
    return;
  }

  OMNOrdersLoadingVC *ordersLoadingVC = [[OMNOrdersLoadingVC alloc] initWithMediator:self];
  @weakify(self)
  ordersLoadingVC.didLoadOrdersBlock = ^(NSArray *orders) {
    
    @strongify(self)
    [self checkPushNotificationAndProcessOrders:orders];
    
  };
  [_restaurantActionsVC.navigationController pushViewController:ordersLoadingVC animated:YES];
  
}

- (BOOL)skipRequestPushNotificationPermission {
  return (_restaurant.is_demo || [OMNAuthorization authorisation].pushNotificationsRequested || _pushPermissionRequested);
}

- (void)checkPushNotificationAndProcessOrders:(NSArray *)orders {
  
  _table.orders = orders;
  if ([self skipRequestPushNotificationPermission]) {
    
    [self showOrders];
    
  }
  else {
    
    @weakify(self)
    [self showPushPermissionVCWithCompletion:^{
      
      @strongify(self)
      [self showOrders];
      
    }];
    
  }
  
}

- (void)showPushPermissionVCWithCompletion:(dispatch_block_t)completionBlock {
  
  _pushPermissionRequested = YES;
  OMNPushPermissionVC *pushPermissionVC = [[OMNPushPermissionVC alloc] initWithParent:_restaurantActionsVC.r1VC];
  pushPermissionVC.completionBlock = completionBlock;
  [self pushViewController:pushPermissionVC];
  
}

- (void)showOrders {
  
  _shouldShowOrdersOnLaunch = NO;
//  https://github.com/saintlab/mobileapp_ios/issues/336
  if (!_table.ordersHasProducts) {
    
    [self processNoOrders];
    
    return;
  }
  
  NSMutableArray *controllers = [NSMutableArray arrayWithArray:_restaurantActionsVC.navigationController.viewControllers];
  
  OMNOrdersVC *ordersVC = [[OMNOrdersVC alloc] initWithMediator:self];
  ordersVC.delegate = self;
  [controllers addObject:ordersVC];
  _ordersVC = ordersVC;
  
  if (1 == _table.orders.count) {
    
    _table.selectedOrder = [_table.orders firstObject];
    OMNOrderCalculationVC *paymentVC = [[OMNOrderCalculationVC alloc] initWithMediator:self];
    paymentVC.delegate = self;
    [controllers addObject:paymentVC];
    
  }
  
  [_restaurantActionsVC.navigationController setViewControllers:controllers animated:YES];

}

- (void)processNoOrders {
  
  @weakify(self)
  OMNNoOrdersVC *noOrdersVC = [[OMNNoOrdersVC alloc] initWithMediator:self closeBlock:^{
    
    @strongify(self)
    [self popToRootViewControllerAnimated:YES];
    
  }];
  [self pushViewController:noOrdersVC];
  
}

#pragma mark - OMNOrdersVCDelegate

- (void)ordersVC:(OMNOrdersVC *)ordersVC didSelectOrder:(OMNOrder *)order {
  
  @weakify(self)
  [_restaurantActionsVC.navigationController omn_popToViewController:ordersVC animated:NO completion:^{
    
    @strongify(self)
    [self showOrder:order];
    
  }];
  
}

- (void)showOrder:(OMNOrder *)order {
  
  _table.selectedOrder = order;
  OMNOrderCalculationVC *paymentVC = [[OMNOrderCalculationVC alloc] initWithMediator:self];
  paymentVC.delegate = self;
  [self pushViewController:paymentVC];
  
}

- (void)ordersVCDidCancel:(OMNOrdersVC *)ordersVC {
  
  [self popToRootViewControllerAnimated:YES];
  
}

#pragma mark - OMNOrderCalculationVCDelegate

- (void)orderCalculationVCRequestOrders:(OMNOrderCalculationVC *)orderCalculationVC {
  
  if (_ordersVC) {
    
    [_restaurantActionsVC.navigationController popToViewController:_ordersVC animated:YES];
    
  }
  
}

- (void)orderCalculationVCDidCancel:(OMNOrderCalculationVC *)orderCalculationVC {
  
  if (_table) {
    
    [self popToRootViewControllerAnimated:YES];
    
  }
  else {
  
    [self exitRestaurant];
    
  }
  
}

- (UIBarButtonItem *)exitRestaurantButton {
  
  UIColor *color = self.restaurant.decoration.antagonist_color;
  return [UIBarButtonItem omn_barButtonWithImage:[UIImage imageNamed:@"back_button"] color:color target:self action:@selector(exitRestaurant)];
  
}

- (UIButton *)userProfileButton {
  
  UIColor *color = self.restaurant.decoration.antagonist_color;
  return [UIButton omn_barButtonWithImage:[UIImage imageNamed:@"user_settings_icon"] color:color target:self action:@selector(showUserProfile)];
  
}

- (UIView *)titleView {
  return nil;
}

- (BOOL)showTableButton {
  return (_table != nil);
}

- (BOOL)showPreorderButton {
  
  return
  (
   self.restaurant.settings.has_menu &&
   self.menu.hasPreorderedItems
   );
  
}

- (OMNWishMediator *)wishMediatorWithRootVC:(OMNMyOrderConfirmVC *)rootVC {
  return [[OMNWishMediator alloc] initWithRestaurantMediator:self rootVC:rootVC];
}

@end
