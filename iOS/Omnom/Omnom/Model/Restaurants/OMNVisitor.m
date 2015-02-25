//
//  OMNVisitor.m
//  omnom
//
//  Created by tea on 18.02.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNVisitor.h"
#import <BlocksKit.h>
#import "OMNTable+omn_network.h"
#import "OMNSocketManager.h"
#import "OMNAuthorization.h"

@implementation OMNVisitor {
  
  dispatch_semaphore_t _ordersLock;
  
}

- (void)dealloc {
  
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  if (!_restaurant.is_demo) {
    
    [[OMNSocketManager manager] disconnectAndLeaveAllRooms:YES];
    
  }
  
}

- (instancetype)initWithRestaurant:(OMNRestaurant *)restaurant {
  self = [super init];
  if (self) {
    
    _restaurant = restaurant;
    self.table = [_restaurant.tables firstObject];
    self.orders = [NSArray arrayWithArray:restaurant.orders];
    
    _ordersLock = dispatch_semaphore_create(1);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderDidChange:) name:OMNSocketIOOrderDidChangeNotification object:[OMNSocketManager manager]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderDidChange:) name:OMNSocketIOOrderDidPayNotification object:[OMNSocketManager manager]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderDidClose:) name:OMNSocketIOOrderDidCloseNotification object:[OMNSocketManager manager]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderDidCreate:) name:OMNSocketIOOrderDidCreateNotification object:[OMNSocketManager manager]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(waiterCallDone:) name:OMNSocketIOWaiterCallDoneNotification object:[OMNSocketManager manager]];

    [self startListeningRestaurantEventsIfPossible];
    
  }
  return self;
}

- (NSString *)tableName {
  
  return _table.internal_id;
  
}

- (void)startListeningRestaurantEventsIfPossible {
  
  if (!_restaurant.is_demo) {
    
    [[OMNSocketManager manager] connectWithToken:[OMNAuthorization authorisation].token completion:^{
    }];
    
  }
  
}

- (NSUInteger)selectedOrderIndex {
  
  return [self.orders indexOfObject:self.selectedOrder];
  
}

- (BOOL)hasOrders {
  
  @synchronized(self) {
    
    return (_orders.count > 0);
    
  }
  
}

- (BOOL)ordersHasProducts {
  
  @synchronized(self) {
    
    BOOL ordersHasProducts = [self.orders bk_any:^BOOL(OMNOrder *order) {
      
      return order.hasProducts;
      
    }];
    
    return ordersHasProducts;
    
  }
  
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

- (long long)ordersTotalAmount {
  
  @synchronized(self) {
    
    NSArray *orders = [self.orders copy];
    __block long long ordersTotalAmount = 0ll;
    [orders enumerateObjectsUsingBlock:^(OMNOrder *order, NSUInteger idx, BOOL *stop) {
      
      ordersTotalAmount += order.expectedValue;
      
    }];
    
    return ordersTotalAmount;
    
  }
  
}

- (void)updateOrdersIfNeeded {
  
  if (!self.hasOrders) {
    
    [self updateOrders];
    
  }
  
}

- (void)updateOrders {
  
  __weak typeof(self)weakSelf = self;
  [self.table getOrders:^(NSArray *orders) {
    
    [weakSelf updateOrdersWithOrders:orders];
    
  } error:^(OMNError *error) {
  }];
  
}

#pragma mark - notifications

- (void)waiterCallDone:(NSNotification *)n {
  
  self.waiterIsCalled = NO;
  
}

- (void)applicationDidBecomeActive:(NSNotification *)n {
  
  [self updateOrders];
  
}

- (void)orderDidChange:(NSNotification *)n {
  
  OMNOrder *newOrder = [[OMNOrder alloc] initWithJsonData:n.userInfo[OMNOrderDataKey]];
  [self updateOrdersWithOrder:newOrder];
  
}

- (void)orderDidClose:(NSNotification *)n {
  
  OMNOrder *removedOrder = [[OMNOrder alloc] initWithJsonData:n.userInfo[OMNOrderDataKey]];
  [self removeOrder:removedOrder];
  
}

- (void)orderDidCreate:(NSNotification *)n {
  
  OMNOrder *newOrder = [[OMNOrder alloc] initWithJsonData:n.userInfo[OMNOrderDataKey]];
  [self updateOrdersWithOrder:newOrder];
  
}

- (void)updateOrdersWithOrder:(OMNOrder *)changedOrder {
  
  if (![changedOrder.restaurant_id isEqualToString:self.restaurant.id]) {
    return;
  }

  dispatch_semaphore_wait(_ordersLock, DISPATCH_TIME_FOREVER);
  
  NSString *selectedOrderID = self.selectedOrder.id;
  NSMutableArray *orders = [self.orders mutableCopy];
  __block BOOL ordersDidChange = NO;
  [self.orders enumerateObjectsUsingBlock:^(OMNOrder *order, NSUInteger idx, BOOL *stop) {
    
    if ([changedOrder.id isEqualToString:order.id]) {
      orders[idx] = changedOrder;
      ordersDidChange = YES;
      *stop = YES;
    }
    
  }];
  
  if (ordersDidChange) {
    
    if ([changedOrder.id isEqualToString:selectedOrderID]) {
      
      self.selectedOrder = changedOrder;
      
    }
    
  }
  else {
    
    [orders addObject:changedOrder];
    
  }

  self.orders = orders;
  
  [[NSNotificationCenter defaultCenter] postNotificationName:OMNOrderDidChangeNotification
                                                      object:self
                                                    userInfo:@{OMNOrderKey : changedOrder}];
  [[NSNotificationCenter defaultCenter] postNotificationName:OMNRestaurantOrdersDidChangeNotification
                                                      object:self];
  
  
  dispatch_semaphore_signal(_ordersLock);
  
}

- (void)removeOrder:(OMNOrder *)removedOrder {
  
  if (removedOrder &&
      [removedOrder.restaurant_id isEqualToString:self.restaurant.id]) {
    
    dispatch_semaphore_wait(_ordersLock, DISPATCH_TIME_FOREVER);
    
    NSMutableArray *orders = [_orders mutableCopy];
    [orders bk_performReject:^BOOL(OMNOrder *order) {
      
      return [order.id isEqualToString:removedOrder.id];
      
    }];
    
    dispatch_semaphore_signal(_ordersLock);
    
    if (orders.count != _orders.count) {
      
      [self updateOrdersWithOrders:orders];
      
    }
    
  }
  
}

- (void)updateOrdersWithOrders:(NSArray *)orders {

  dispatch_semaphore_wait(_ordersLock, DISPATCH_TIME_FOREVER);
  
  NSArray *existingOrders = [self.orders copy];
  
  NSMutableDictionary *existingOrdersDictionary = [NSMutableDictionary dictionaryWithCapacity:existingOrders.count];
  [existingOrders enumerateObjectsUsingBlock:^(OMNOrder *existingOrder, NSUInteger idx, BOOL *stop) {
    
    existingOrdersDictionary[existingOrder.id] = existingOrder;
    
  }];
  
  NSString *selectedOrderId = self.selectedOrder.id;
  NSMutableArray *newOrders = [NSMutableArray arrayWithCapacity:orders.count];
  NSMutableSet *newOrdersIDs = [NSMutableSet setWithCapacity:orders.count];
  
  __weak typeof(self)weakSelf = self;
  [orders enumerateObjectsUsingBlock:^(OMNOrder *newOrder, NSUInteger idx, BOOL *stop) {
    
    OMNOrder *existingOrder = existingOrdersDictionary[newOrder.id];
    [newOrdersIDs addObject:newOrder.id];
    if (existingOrder &&
        [existingOrder.modifiedTime isEqualToString:newOrder.modifiedTime]) {
      
      [newOrders addObject:existingOrder];
      
    }
    else {
      
      if ([newOrder.id isEqualToString:selectedOrderId]) {
        
        weakSelf.selectedOrder = newOrder;
        
      }
      [newOrders addObject:newOrder];
      [[NSNotificationCenter defaultCenter] postNotificationName:OMNOrderDidChangeNotification object:weakSelf userInfo:@{OMNOrderKey : newOrder}];
      
    }
    
  }];
  
  [existingOrders enumerateObjectsUsingBlock:^(OMNOrder *existingOrder, NSUInteger idx, BOOL *stop) {
    
    if (![newOrdersIDs containsObject:existingOrder.id]) {
      
      [[NSNotificationCenter defaultCenter] postNotificationName:OMNOrderDidCloseNotification object:weakSelf userInfo:@{OMNOrderKey : existingOrder}];
      
    }
    
  }];
  
  self.orders = newOrders;
  [[NSNotificationCenter defaultCenter] postNotificationName:OMNRestaurantOrdersDidChangeNotification object:self];
  
  dispatch_semaphore_signal(_ordersLock);
  
}

- (void)setOrders:(NSArray *)orders {
  
  _orders = [orders bk_select:^BOOL(OMNOrder *order) {
    
    return order.hasProducts;
    
  }];
  
}

- (void)waiterCall {
  
  __weak typeof(self)weakSelf = self;
  [self.table waiterCallWithCompletion:^(OMNError *error) {
    
    weakSelf.waiterIsCalled = (nil == error);
    
  }];
  
}

- (void)waiterCallStop {
  
  __weak typeof(self)weakSelf = self;
  [self.table waiterCallStopWithFailure:^(OMNError *error) {
    
    weakSelf.waiterIsCalled = (nil != error);
    
  }];
  
}


@end
