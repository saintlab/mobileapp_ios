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
#import "OMNError.h"
#import "OMNRestaurantManager.h"
#import "OMNTable+omn_network.h"
#import "UINavigationController+omn_replace.h"
#import "OMNSocketManager.h"
#import "OMNScanTableQRCodeVC.h"
#import "OMNOperationManager.h"

@interface OMNRestaurantMediator ()
<OMNUserInfoVCDelegate,
OMNOrdersVCDelegate,
OMNOrderCalculationVCDelegate>

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

- (void)waiterCallWithCompletion:(dispatch_block_t)completionBlock {
  
  if (!self.table) {
    completionBlock();
    return;
  }
  
  __weak typeof(self)weakSelf = self;
  [self.table waiterCallWithCompletion:^(OMNError *error) {
    
    weakSelf.waiterIsCalled = (nil == error);
    completionBlock();
    
  }];
  
}

- (void)waiterCallStopWithCompletion:(dispatch_block_t)completionBlock {
  
  if (!self.table) {
    completionBlock();
    return;
  }

  __weak typeof(self)weakSelf = self;
  [self.table waiterCallStopWithFailure:^(OMNError *error) {
    
    weakSelf.waiterIsCalled = (nil != error);
    completionBlock();
    
  }];
  
}


- (void)callBillWithCompletion:(dispatch_block_t)completionBlock {
  
  if (!self.table) {
    return;
  }
  
  __weak typeof(self)weakSelf = self;
  [self.table getOrders:^(NSArray *orders) {
    
    [weakSelf checkPushNotificationAndProcessOrders:orders];
    completionBlock();
    
  } error:^(NSError *error) {
    
    [weakSelf processOrderError:error];
    completionBlock();
    
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
      
      self.selectedOrder = [_restaurant.orders firstObject];
      OMNOrderCalculationVC *paymentVC = [[OMNOrderCalculationVC alloc] initWithMediator:self];
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

- (void)processOrderError:(NSError *)error {
  
  OMNError *omnomError = [OMNError omnnomErrorFromError:error];
  
  OMNCircleRootVC *noInternetVC = [[OMNCircleRootVC alloc] initWithParent:_restaurantActionsVC.r1VC];
  noInternetVC.text = omnomError.localizedDescription;
  noInternetVC.faded = YES;
  noInternetVC.circleIcon = [UIImage imageNamed:@"unlinked_icon_big"];
  __weak typeof(self)weakSelf = self;
  noInternetVC.buttonInfo =
  @[
    [OMNBarButtonInfo infoWithTitle:NSLocalizedString(@"REPEAT_BUTTON_TITLE", @"Повторить") image:[UIImage imageNamed:@"repeat_icon_small"] block:^{
      
      [weakSelf callBillWithCompletion:^{}];
      
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
  OMNOrderCalculationVC *paymentVC = [[OMNOrderCalculationVC alloc] initWithMediator:self];
  paymentVC.delegate = self;
  [self pushViewController:paymentVC];
  
}

- (void)ordersVCDidCancel:(OMNOrdersVC *)ordersVC {
  
  [self popToRootViewControllerAnimated:YES];
  
}

#pragma mark - OMNOrderCalculationVCDelegate

- (void)orderCalculationVCDidFinish:(OMNOrderCalculationVC *)orderCalculationVC {

  if (_restaurant.is_demo) {
    
    [self exitRestaurant];
    
  }
  else {
    
    [self popToRootViewControllerAnimated:YES];
    
  }
  
}

- (void)orderCalculationVCRequestOrders:(OMNOrderCalculationVC *)orderCalculationVC {
  
  if (_ordersVC) {
    
    [_restaurantActionsVC.navigationController popToViewController:_ordersVC animated:YES];
    
  }
  
}

- (void)orderCalculationVCDidCancel:(OMNOrderCalculationVC *)orderCalculationVC {
  
  [self popToRootViewControllerAnimated:YES];
  
}

@end
