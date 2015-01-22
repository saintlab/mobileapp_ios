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
#import "OMNNoOrdersVC.h"
#import "OMNPreorderConfirmVC.h"
#import "OMNNavigationController.h"

@interface OMNRestaurantMediator ()
<OMNOrdersVCDelegate,
OMNOrderCalculationVCDelegate>

@end

@implementation OMNRestaurantMediator {
  
  __weak OMNOrdersVC *_ordersVC;
  BOOL _ordersDidShow;
  dispatch_semaphore_t _ordersLock;

}

- (void)dealloc {
  
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  if (!_restaurant.is_demo) {
    
    [[OMNSocketManager manager] disconnectAndLeaveAllRooms:YES];
    
  }
  
}

- (instancetype)initWithRestaurant:(OMNRestaurant *)restaurant rootViewController:(__weak OMNRestaurantActionsVC *)restaurantActionsVC {
  self = [super init];
  if (self) {
    
    _restaurantActionsVC = restaurantActionsVC;
    _restaurant = restaurant;
    self.table = [_restaurant.tables firstObject];
    self.orders = [NSArray arrayWithArray:_restaurant.orders];
    _ordersLock = dispatch_semaphore_create(1);

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(waiterCallDone:) name:OMNSocketIOWaiterCallDoneNotification object:[OMNSocketManager manager]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderDidChange:) name:OMNSocketIOOrderDidChangeNotification object:[OMNSocketManager manager]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderDidChange:) name:OMNSocketIOOrderDidPayNotification object:[OMNSocketManager manager]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderDidClose:) name:OMNSocketIOOrderDidCloseNotification object:[OMNSocketManager manager]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderDidCreate:) name:OMNSocketIOOrderDidCreateNotification object:[OMNSocketManager manager]];
    
    [self startListeningRestaurantEvents];
    
  }
  return self;
}

#pragma mark - notifications

- (void)applicationDidBecomeActive:(NSNotification *)n {
  
  [self updateOrdersIfNeeded];
  
}

- (void)startListeningRestaurantEvents {
  
  if (!_restaurant.is_demo) {
    
    [[OMNSocketManager manager] connectWithToken:[OMNAuthorization authorisation].token completion:^{
    }];
    
  }
  
}

- (void)updateOrdersIfNeeded {
  
  __weak typeof(self)weakSelf = self;
  [self.table getOrders:^(NSArray *orders) {

    [weakSelf updateOrdersWithOrders:orders];
    
  } error:^(OMNError *error) {
  }];

}

- (void)waiterCallDone:(NSNotification *)n {
  
  self.waiterIsCalled = NO;
  
}

- (void)orderDidChange:(NSNotification *)n {
  
  OMNOrder *newOrder = [[OMNOrder alloc] initWithJsonData:n.userInfo[OMNOrderDataKey]];
  [self updateOrder:newOrder];
  
}

- (void)orderDidClose:(NSNotification *)n {
  
  OMNOrder *removedOrder = [[OMNOrder alloc] initWithJsonData:n.userInfo[OMNOrderDataKey]];
  [self removeOrder:removedOrder];
  
}

- (void)orderDidCreate:(NSNotification *)n {
  
  OMNOrder *newOrder = [[OMNOrder alloc] initWithJsonData:n.userInfo[OMNOrderDataKey]];
  [self addOrder:newOrder];
  
}

- (void)updateOrder:(OMNOrder *)changedOrder {
  
  dispatch_semaphore_wait(_ordersLock, DISPATCH_TIME_FOREVER);
  
  NSString *selectedOrderID = self.selectedOrder.id;
  NSMutableArray *orders = [self.orders mutableCopy];
  __block BOOL ordersDidChange = NO;
  [self.orders enumerateObjectsUsingBlock:^(OMNOrder *order, NSUInteger idx, BOOL *stop) {
    
    if ([changedOrder.id isEqualToString:order.id]) {
      [orders replaceObjectAtIndex:idx withObject:changedOrder];
      ordersDidChange = YES;
      *stop = YES;
    }
    
  }];
  
  if (ordersDidChange) {

    if ([changedOrder.id isEqualToString:selectedOrderID]) {
      
      self.selectedOrder = changedOrder;
      
    }
    self.orders = orders;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:OMNOrderDidChangeNotification
                                                        object:self
                                                      userInfo:@{OMNOrderKey : changedOrder}];
    [[NSNotificationCenter defaultCenter] postNotificationName:OMNRestaurantOrdersDidChangeNotification
                                                        object:self];

    
  }
  dispatch_semaphore_signal(_ordersLock);
  
}

- (void)addOrder:(OMNOrder *)newOrder {
  
  dispatch_semaphore_wait(_ordersLock, DISPATCH_TIME_FOREVER);
  
  if (newOrder &&
      [newOrder.restaurant_id isEqualToString:self.restaurant.id]) {
    
    self.orders = [self.orders arrayByAddingObject:newOrder];
    [[NSNotificationCenter defaultCenter] postNotificationName:OMNRestaurantOrdersDidChangeNotification object:self];
    
  }
  
  dispatch_semaphore_signal(_ordersLock);
  
}

- (void)removeOrder:(OMNOrder *)removedOrder {
  
  if (removedOrder &&
      [removedOrder.restaurant_id isEqualToString:self.restaurant.id]) {
    
    dispatch_semaphore_wait(_ordersLock, DISPATCH_TIME_FOREVER);
    
    NSMutableArray *orders = [_orders mutableCopy];
    
    __block OMNOrder *realClosedOrder = nil;
    [_orders enumerateObjectsUsingBlock:^(OMNOrder *order, NSUInteger idx, BOOL *stop) {
      
      if ([removedOrder.id isEqualToString:order.id]) {
        realClosedOrder = order;
        [orders removeObjectAtIndex:idx];
        *stop = YES;
      }
      
    }];
    
    dispatch_semaphore_signal(_ordersLock);
    
    if (realClosedOrder) {
      
      [self updateOrdersWithOrders:orders];
      
    }
    
  }
  
}

- (void)updateOrdersWithOrders:(NSArray *)orders {
  
  dispatch_semaphore_wait(_ordersLock, DISPATCH_TIME_FOREVER);
  
  NSString *selectedOrderId = self.selectedOrder.id;
  __block OMNOrder *selectedOrder = nil;
  NSMutableSet *existingOrdersIDs = [NSMutableSet setWithCapacity:orders.count];
  [orders enumerateObjectsUsingBlock:^(OMNOrder *order, NSUInteger idx, BOOL *stop) {
    
    [existingOrdersIDs addObject:order.id];
    if ([order.id isEqualToString:selectedOrderId]) {
      
      selectedOrder = order;
      
    }
    
  }];
  
  self.selectedOrder = selectedOrder;
  
  __weak typeof(self)weakSelf = self;
  [self.orders enumerateObjectsUsingBlock:^(OMNOrder *order, NSUInteger idx, BOOL *stop) {
    
    if ([existingOrdersIDs containsObject:order.id]) {
      
      [[NSNotificationCenter defaultCenter] postNotificationName:OMNOrderDidChangeNotification object:weakSelf userInfo:@{OMNOrderKey : order}];

    }
    else {
      
      [[NSNotificationCenter defaultCenter] postNotificationName:OMNOrderDidCloseNotification object:weakSelf userInfo:@{OMNOrderKey : order}];

    }
    
  }];
  
  self.orders = orders;
  [[NSNotificationCenter defaultCenter] postNotificationName:OMNRestaurantOrdersDidChangeNotification object:self];
  
  dispatch_semaphore_signal(_ordersLock);
  
}

- (void)setTable:(OMNTable *)table {

  [[OMNSocketManager manager] leave:_table.id];
  
  _table = table;
  if (!_restaurant.is_demo) {
    
    [[OMNSocketManager manager] join:_table.id];
    [_table tableIn];
    [_table newGuestWithCompletion:^{}];
    
  }
  
}

- (void)checkOrders {
  
  if (self.orders.count &&
      !_ordersDidShow) {
    
    [self showOrders];
    
  }
  else if ([OMNLaunchHandler sharedHandler].launchOptions.showTableOrders) {
    
    [OMNLaunchHandler sharedHandler].launchOptions.showTableOrders = NO;
    [self callBill];
    
  }
  
}

- (void)popToRootViewControllerAnimated:(BOOL)animated {
  
  [_restaurantActionsVC.navigationController popToViewController:_restaurantActionsVC animated:animated];
  
}

- (void)pushViewController:(UIViewController *)vc {
  
  [_restaurantActionsVC.navigationController pushViewController:vc animated:YES];
  
}

- (void)showUserProfile {

  OMNUserInfoVC *userInfoVC = [[OMNUserInfoVC alloc] initWithMediator:self];
  __weak typeof(self)weakSelf = self;
  userInfoVC.didCloseBlock = ^{
    
    [weakSelf.restaurantActionsVC.navigationController dismissViewControllerAnimated:YES completion:nil];
    
  };
  UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:userInfoVC];
  navigationController.delegate = _restaurantActionsVC.navigationController.delegate;
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


- (void)callBill {
  
//  OMNPreorderConfirmVC *preorderConfirmVC = [[OMNPreorderConfirmVC alloc] init];
//  [_restaurantActionsVC.navigationController presentViewController:[[OMNNavigationController alloc] initWithRootViewController:preorderConfirmVC] animated:YES completion:nil];
//  return;
#warning
  if (!self.table) {
    return;
  }
  
  OMNLoadingCircleVC *loadingCircleVC = [[OMNLoadingCircleVC alloc] initWithParent:_restaurantActionsVC.r1VC];
  __weak typeof(self)weakSelf = self;
  loadingCircleVC.didCloseBlock = ^{
    
    [weakSelf popToRootViewControllerAnimated:YES];
    
  };
  loadingCircleVC.circleIcon = [UIImage imageNamed:@"bill_icon_white_big"];
  
  [_restaurantActionsVC.navigationController omn_pushViewController:loadingCircleVC animated:YES completion:^{
    
    [weakSelf getOrdersWithLoadingVC:loadingCircleVC];
    
  }];
  
}

- (void)getOrdersWithLoadingVC:(OMNLoadingCircleVC *)loadingCircleVC {
  
  __weak typeof(self)weakSelf = self;
  [_restaurantActionsVC.navigationController omn_popToViewController:loadingCircleVC animated:YES completion:^{
    
    [loadingCircleVC.loaderView startAnimating:10.0];
    [weakSelf.table getOrders:^(NSArray *orders) {
      
      [loadingCircleVC finishLoading:^{
        
        [weakSelf checkPushNotificationAndProcessOrders:orders];
        
      }];
      
    } error:^(OMNError *error) {
      
      [loadingCircleVC finishLoading:^{
        
        [loadingCircleVC showRetryMessageWithError:error retryBlock:^{
          
          [weakSelf getOrdersWithLoadingVC:loadingCircleVC];
          
        } cancelBlock:^{
          
          [weakSelf popToRootViewControllerAnimated:YES];
          
        }];
        
      }];
      
    }];
    
  }];
  
}

- (void)checkPushNotificationAndProcessOrders:(NSArray *)orders {

  self.orders = orders;
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
  
  _ordersDidShow = YES;
  NSInteger ordersCount = self.orders.count;
  NSMutableArray *pushedControllers = [NSMutableArray array];
  
//#warning ordersCount
//  ordersCount = 0;
  if (ordersCount) {
    
    OMNOrdersVC *ordersVC = [[OMNOrdersVC alloc] initWithMediator:self];
    ordersVC.delegate = self;
    [pushedControllers addObject:ordersVC];
    _ordersVC = ordersVC;
    
    if (1 == ordersCount) {
      
      self.selectedOrder = [self.orders firstObject];
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
  
  OMNNoOrdersVC *noOrdersVC = [[OMNNoOrdersVC alloc] initWithMediator:self];
  [self pushViewController:noOrdersVC];
  
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
  
  if (self.table) {
    
    [self popToRootViewControllerAnimated:YES];
    
  }
  else {
  
    [self exitRestaurant];
    
  }
  
}

@end
