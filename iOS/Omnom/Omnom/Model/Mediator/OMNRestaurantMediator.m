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
#import "OMNPreorderMediator.h"
#import "UIBarButtonItem+omn_custom.h"
#import "OMNTransactionPaymentVC.h"

@interface OMNRestaurantMediator ()
<OMNOrdersVCDelegate,
OMNOrderCalculationVCDelegate>

@end

@implementation OMNRestaurantMediator {
  
  __weak OMNOrdersVC *_ordersVC;
  BOOL _shouldShowOrdersOnLaunch;

}

- (instancetype)initWithRestaurant:(OMNRestaurant *)restaurant rootViewController:(OMNRestaurantActionsVC *)restaurantActionsVC {
  self = [super init];
  if (self) {

    _restaurantActionsVC = restaurantActionsVC;
    _restaurant = restaurant;
    _visitor = [[OMNVisitor alloc] initWithRestaurant:restaurant];
    _shouldShowOrdersOnLaunch = (_restaurant.orders.count > 0);

    @weakify(self)
    [_restaurant getMenuWithCompletion:^(OMNMenu *menu) {
      
      @strongify(self)
      self.menu = menu;
      
    }];
    
  }
  return self;
}

- (void)checkStartConditions {
  
  if (_shouldShowOrdersOnLaunch &&
      _visitor.hasOrders) {
    
    [self showOrders];
    
  }
  else if ([OMNLaunchHandler sharedHandler].launchOptions.showTableOrders) {
    
    [OMNLaunchHandler sharedHandler].launchOptions.showTableOrders = NO;
    [self showTableOrders];
    
  }
  else {
    
    [_visitor updateOrdersIfNeeded];
    
  }
  
}

- (long long)totalOrdersAmount {
  
  return _visitor.ordersTotalAmount;
  
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

- (void)waiterCall {
  [_visitor waiterCall];
}

- (void)waiterCallStop {
  [_visitor waiterCallStop];
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
  
  if (!_visitor.table) {
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
  
  return (_restaurant.is_demo ||
          [OMNAuthorization authorisation].pushNotificationsRequested ||
          TARGET_IPHONE_SIMULATOR);
  
}

- (void)checkPushNotificationAndProcessOrders:(NSArray *)orders {
  
  _visitor.orders = orders;
  if ([self skipRequestPushNotificationPermission]) {
    
    [self showOrders];
    
  }
  else {
    
    OMNPushPermissionVC *pushPermissionVC = [[OMNPushPermissionVC alloc] initWithParent:_restaurantActionsVC.r1VC];
    @weakify(self)
    pushPermissionVC.completionBlock = ^{
      
      @strongify(self)
      [self showOrders];
      
    };
    [self pushViewController:pushPermissionVC];
    
  }
  
}

- (void)showOrders {
  
  _shouldShowOrdersOnLaunch = NO;
//  https://github.com/saintlab/mobileapp_ios/issues/336
  if (!_visitor.ordersHasProducts) {
    
    [self processNoOrders];
    
    return;
  }
  
  NSMutableArray *controllers = [NSMutableArray arrayWithArray:_restaurantActionsVC.navigationController.viewControllers];
  
  OMNOrdersVC *ordersVC = [[OMNOrdersVC alloc] initWithMediator:self];
  ordersVC.delegate = self;
  [controllers addObject:ordersVC];
  _ordersVC = ordersVC;
  
  if (1 == _visitor.orders.count) {
    
    _visitor.selectedOrder = [_visitor.orders firstObject];
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
  
  _visitor.selectedOrder = order;
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
  
  if (_visitor.table) {
    
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
  return (self.visitor.table != nil);
}

- (BOOL)showPreorderButton {
  
  return
  (
   self.restaurant.settings.has_menu &&
   self.menu.hasPreorderedItems
   );
  
}

- (OMNPreorderMediator *)preorderMediatorWithRootVC:(OMNMyOrderConfirmVC *)rootVC {
  return [[OMNPreorderMediator alloc] initWithRestaurantMediator:self rootVC:rootVC];
}

@end
