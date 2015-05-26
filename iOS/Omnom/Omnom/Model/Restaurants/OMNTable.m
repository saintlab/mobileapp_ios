//
//  OMNTable.m
//  restaurants
//
//  Created by tea on 14.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNTable.h"
#import <BlocksKit.h>
#import "OMNSocketManager.h"
#import "OMNTable+omn_network.h"

NSString * const OMNTableOrdersDidChangeNotification = @"OMNTableOrdersDidChangeNotification";


@implementation OMNTable {
  
  dispatch_semaphore_t _ordersLock;
  
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [[OMNSocketManager manager] leave:self.id];
}

- (instancetype)initWithJsonData:(id)data {
  self = [super init];
  if (self) {

    self.id = [data[@"id"] description];
    self.internal_id = data[@"internal_id"];
    self.restaurant_id = data[@"restaurant_id"];
    _ordersLock = dispatch_semaphore_create(1);

  }
  return self;
}

- (NSString *)name {
  return self.internal_id;
}

- (void)join {
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderDidChange:) name:OMNSocketIOOrderDidChangeNotification object:[OMNSocketManager manager]];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderDidChange:) name:OMNSocketIOOrderDidPayNotification object:[OMNSocketManager manager]];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderDidClose:) name:OMNSocketIOOrderDidCloseNotification object:[OMNSocketManager manager]];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderDidCreate:) name:OMNSocketIOOrderDidCreateNotification object:[OMNSocketManager manager]];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(waiterCallDone:) name:OMNSocketIOWaiterCallDoneNotification object:[OMNSocketManager manager]];

  [[OMNSocketManager manager] join:self.id];
  [self tableIn];
  [self newGuest];
  
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
  
  [self getOrders].then(^(NSArray *orders) {
    
    [self updateOrdersWithOrders:orders];
    
  });
  
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
  
  if (![changedOrder.restaurant_id isEqualToString:self.restaurant_id]) {
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
  [[NSNotificationCenter defaultCenter] postNotificationName:OMNTableOrdersDidChangeNotification
                                                      object:self];
  
  
  dispatch_semaphore_signal(_ordersLock);
  
}

- (void)removeOrder:(OMNOrder *)removedOrder {
  
  if (removedOrder &&
      [removedOrder.restaurant_id isEqualToString:self.restaurant_id]) {
    
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
  
  @weakify(self)
  [orders enumerateObjectsUsingBlock:^(OMNOrder *newOrder, NSUInteger idx, BOOL *stop) {
    
    OMNOrder *existingOrder = existingOrdersDictionary[newOrder.id];
    [newOrdersIDs addObject:newOrder.id];
    if (existingOrder &&
        [existingOrder.modifiedTime isEqualToString:newOrder.modifiedTime]) {
      
      [newOrders addObject:existingOrder];
      
    }
    else {
      
      @strongify(self)
      if ([newOrder.id isEqualToString:selectedOrderId]) {
        
        self.selectedOrder = newOrder;
        
      }
      [newOrders addObject:newOrder];
      [[NSNotificationCenter defaultCenter] postNotificationName:OMNOrderDidChangeNotification object:self userInfo:@{OMNOrderKey : newOrder}];
      
    }
    
  }];
  
  [existingOrders enumerateObjectsUsingBlock:^(OMNOrder *existingOrder, NSUInteger idx, BOOL *stop) {
    
    if (![newOrdersIDs containsObject:existingOrder.id]) {
      
      @strongify(self)
      [[NSNotificationCenter defaultCenter] postNotificationName:OMNOrderDidCloseNotification object:self userInfo:@{OMNOrderKey : existingOrder}];
      
    }
    
  }];
  
  self.orders = newOrders;
  [[NSNotificationCenter defaultCenter] postNotificationName:OMNTableOrdersDidChangeNotification object:self];
  
  dispatch_semaphore_signal(_ordersLock);
  
}

- (void)setOrders:(NSArray *)orders {
  
  _orders = [orders bk_select:^BOOL(OMNOrder *order) {
    
    return order.hasProducts;
    
  }];
  
}

- (void)waiterCall {
  
  @weakify(self)
  [self waiterCallWithCompletion:^(OMNError *error) {
    
    @strongify(self)
    self.waiterIsCalled = (nil == error);
    
  }];
  
}

- (void)waiterCallStop {
  
  @weakify(self)
  [self waiterCallStopWithFailure:^(OMNError *error) {
    
    @strongify(self)
    self.waiterIsCalled = (nil != error);
    
  }];
  
}

@end

@implementation NSObject (omn_tables)

- (NSArray *)omn_tables {
  
  if (![self isKindOfClass:[NSArray class]]) {
    return @[];
  }
  
  NSArray *tablesData = (NSArray *)self;
  NSArray *tables = [tablesData bk_map:^id(id tableData) {
    
    return [[OMNTable alloc] initWithJsonData:tableData];
    
  }];
  return tables;
  
}

@end