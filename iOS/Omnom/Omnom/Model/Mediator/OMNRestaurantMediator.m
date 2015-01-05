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
#import "OMNVisitor+network.h"
#import "OMNSearchRestaurantsVC.h"
#import "OMNAuthorization.h"
#import "OMNPushPermissionVC.h"
#import "OMNOrdersVC.h"
#import "OMNPayOrderVC.h"
#import "OMNError.h"
#import "OMNRestaurantManager.h"
#import "OMNTable+omn_network.h"
#import "UINavigationController+omn_replace.h"
#import "OMNSocketManager.h"
#import "OMNScanTableQRCodeVC.h"

@interface OMNRestaurantMediator ()
<OMNUserInfoVCDelegate,
OMNOrdersVCDelegate,
OMNPayOrderVCDelegate>

@end

@implementation OMNRestaurantMediator {
  
  __weak OMNRestaurantActionsVC *_restaurantActionsVC;
  __weak OMNOrdersVC *_ordersVC;
  BOOL _ordersDidShow;
  
}

- (instancetype)initWithRestaurant:(OMNRestaurant *)restaurant rootViewController:(__weak OMNRestaurantActionsVC *)restaurantActionsVC {
  self = [super init];
  if (self) {
    
    _restaurantActionsVC = restaurantActionsVC;
    _restaurant = restaurant;
    
  }
  return self;
}

- (void)setTable:(OMNTable *)table {
  
  if (_table.id) {
    
    [[OMNSocketManager manager] leave:_table.id];
    
  }
  
  _table = table;
  
  if (_table.id) {
    
    [[OMNSocketManager manager] join:_table.id];
    
  }
  
}

- (void)checkTableAndOrders {
  
  if (self.table) {
    return;
  }

  if (_restaurant.orders &&
      !_ordersDidShow) {
    
    _ordersDidShow = YES;
    [self showOrders];
    
  }
  else {
    
    if (1 == _restaurant.tables.count) {
      
      self.table = [_restaurant.tables firstObject];
      
    }
    else {
      
      [self selectTable];
      
    }
    
  }
  
}

- (void)selectTable {
#warning selectTable
  OMNScanTableQRCodeVC *scanTableQRCodeVC = [[OMNScanTableQRCodeVC alloc] init];
  [_restaurantActionsVC.navigationController presentViewController:scanTableQRCodeVC animated:YES completion:nil];
  
}

- (void)popToRootViewControllerAnimated:(BOOL)animated {
  
  [_restaurantActionsVC.navigationController popToViewController:_restaurantActionsVC animated:animated];
  
}

- (void)pushViewController:(UIViewController *)vc {
  
  [_restaurantActionsVC.navigationController pushViewController:vc animated:YES];
  
}

- (void)showUserProfile {

  OMNUserInfoVC *userInfoVC = [[OMNUserInfoVC alloc] initWithMediator:self];
  userInfoVC.delegate = self;
  UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:userInfoVC];
  navigationController.delegate = _restaurantActionsVC.navigationController.delegate;
  [_restaurantActionsVC.navigationController presentViewController:navigationController animated:YES completion:nil];
  
}

- (void)exitRestaurant {
  
  [_restaurantActionsVC.delegate restaurantActionsVCDidFinish:_restaurantActionsVC];
  
}

- (BOOL)checkVisitor:(OMNVisitor *)visitor {

#warning 123
  return YES;
//  if ([self.visitor isSameRestaurant:visitor]) {
//    
//    [self.visitor updateWithVisitor:visitor];
//    return YES;
//    
//  }
//  else {
//    
//    return NO;
//    
//  }

}

- (void)visitorDidChange:(OMNVisitor *)visitor {
  
#warning visitorDidChange
//  [self.restaurantActionsVC.delegate restaurantActionsVC:self.restaurantActionsVC didChangeVisitor:visitor];
  
}

- (void)callWaiterAction:(__weak UIButton *)button {
  
  button.enabled = NO;
  [[OMNRestaurantManager sharedManager] waiterCallWithFailure:^(NSError *error) {
    
    button.enabled = YES;
    
  }];

#warning addd loading
//  [self searchVisitorWithIcon:[UIImage imageNamed:@"bell_ringing_icon_white_big"] completion:^(OMNSearchRestaurantsVC *searchBeaconVC, NSArray *restaurants) {

}

- (void)callBillAction:(__weak UIButton *)button {
  
  if (!self.table) {
    return;
  }
  
  button.enabled = NO;
  __weak typeof(self)weakSelf = self;
  [self.table getOrders:^(NSArray *orders) {
    
    button.enabled = YES;
    [weakSelf checkPushNotificationAndProcessOrders:orders];
    
  } error:^(NSError *error) {
    
    [weakSelf popToRootViewControllerAnimated:YES];
    button.enabled = YES;
    
  }];
  
}

- (void)checkPushNotificationAndProcessOrders:(NSArray *)orders {

  self.restaurant.orders = orders;
  if ([OMNAuthorization authorisation].pushNotificationsRequested) {
    
    [self showOrders];
    
  }
  else {
    
    if (!_restaurant.is_demo &&
        orders.count &&
        !TARGET_IPHONE_SIMULATOR) {
      
      OMNPushPermissionVC *pushPermissionVC = [[OMNPushPermissionVC alloc] initWithParent:_restaurantActionsVC.r1VC];
      __weak typeof(self)weakSelf = self;
      pushPermissionVC.completionBlock = ^{
        
        [weakSelf showOrders];
        
      };
      [self pushViewController:pushPermissionVC];
      
    }
    else {
      
      [self showOrders];
      
    }
    
  }
  
}

- (void)showOrders {
  
  NSInteger ordersCount = _restaurant.orders.count;
  NSMutableArray *pushedControllers = [NSMutableArray array];
  if (ordersCount) {
    
    OMNOrdersVC *ordersVC = [[OMNOrdersVC alloc] initWithMediator:self];
    ordersVC.delegate = self;
    [pushedControllers addObject:ordersVC];
    _ordersVC = ordersVC;
    
    if (1 == ordersCount) {
      
      OMNPayOrderVC *paymentVC = [[OMNPayOrderVC alloc] initWithMediator:self];
      paymentVC.delegate = self;
      [pushedControllers addObject:paymentVC];
      
    }

    NSArray *newControllers = [_restaurantActionsVC.navigationController.viewControllers arrayByAddingObjectsFromArray:pushedControllers];
    [_restaurantActionsVC.navigationController setViewControllers:newControllers animated:YES];
    
  }
  else {
    
    [self processNoOrders];
    
  }
  
}

- (void)processNoOrders {
  
  OMNCircleRootVC *noOrdersVC = [[OMNCircleRootVC alloc] initWithParent:_restaurantActionsVC.r1VC];
  noOrdersVC.faded = YES;
  noOrdersVC.text = NSLocalizedString(@"На этом столике нет заказов", nil);
  noOrdersVC.circleIcon = [UIImage imageNamed:@"bill_icon_white_big"];
  
  __weak typeof(self)weakSelf = self;
  noOrdersVC.buttonInfo =
  @[
    [OMNBarButtonInfo infoWithTitle:NSLocalizedString(@"Ок", nil) image:nil block:^{
      
      [weakSelf popToRootViewControllerAnimated:YES];
      
    }]
    ];
  [self pushViewController:noOrdersVC];
  
}

- (void)processOrderError:(NSError *)error forVisitor:(OMNVisitor *)visitor {
  
  OMNError *omnomError = [OMNError omnnomErrorFromError:error];
  
  OMNCircleRootVC *noInternetVC = [[OMNCircleRootVC alloc] initWithParent:_restaurantActionsVC.r1VC];
  noInternetVC.text = omnomError.localizedDescription;
  noInternetVC.faded = YES;
  noInternetVC.circleIcon = [UIImage imageNamed:@"unlinked_icon_big"];
  __weak typeof(self)weakSelf = self;
  noInternetVC.buttonInfo =
  @[
    [OMNBarButtonInfo infoWithTitle:NSLocalizedString(@"REPEAT_BUTTON_TITLE", @"Повторить") image:[UIImage imageNamed:@"repeat_icon_small"] block:^{
      
      [weakSelf callBillAction:nil];
      
    }]
    ];
  noInternetVC.didCloseBlock = ^{
    
    [weakSelf popToRootViewControllerAnimated:YES];
    
  };
  [self popToRootViewControllerAnimated:NO];
  [self pushViewController:noInternetVC];
  
}

#pragma mark - OMNUserInfoVCDelegate

- (void)userInfoVCDidFinish:(OMNUserInfoVC *)userInfoVC {
  
  [_restaurantActionsVC.navigationController dismissViewControllerAnimated:YES completion:nil];
  
}

#pragma mark - OMNOrdersVCDelegate

- (void)ordersVC:(OMNOrdersVC *)ordersVC didSelectOrder:(OMNOrder *)order {
  
  __weak typeof(self)weakSelf = self;
  [_restaurantActionsVC.navigationController omn_popToViewController:ordersVC animated:NO completion:^{
    
    [weakSelf showOrder:order];
    
  }];
  
}

- (void)showOrder:(OMNOrder *)order {
  
  self.selectedOrder = order;
  OMNPayOrderVC *paymentVC = [[OMNPayOrderVC alloc] initWithMediator:self];
  paymentVC.delegate = self;
  [self pushViewController:paymentVC];
  
}

- (void)ordersVCDidCancel:(OMNOrdersVC *)ordersVC {
  
  [self popToRootViewControllerAnimated:YES];
  
}

#pragma mark - OMNPayOrderVCDelegate

- (void)payOrderVCDidFinish:(OMNPayOrderVC *)payOrderVC {

  if (_restaurant.is_demo) {
    
    [self exitRestaurant];
    
  }
  else {
    
    [self popToRootViewControllerAnimated:YES];
    
  }
  
}

- (void)payOrderVCRequestOrders:(OMNPayOrderVC *)ordersVC {
  
  if (_ordersVC) {
    
    [_restaurantActionsVC.navigationController popToViewController:_ordersVC animated:YES];
    
  }
  
}

- (void)payOrderVCDidCancel:(OMNPayOrderVC *)payOrderVC {
  
  [self popToRootViewControllerAnimated:YES];
  
}

@end
