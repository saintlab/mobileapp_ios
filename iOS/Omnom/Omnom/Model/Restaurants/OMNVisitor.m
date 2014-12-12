//
//  OMNDecodeBeacon.m
//  restaurants
//
//  Created by tea on 14.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNVisitor.h"
#import "OMNSocketManager.h"

NSString * const OMNOrderDidChangeNotification = @"OMNOrderDidChangeNotification";
NSString * const OMNOrderDidCloseNotification = @"OMNOrderDidCloseNotification";
NSString * const OMNOrderDidPayNotification = @"OMNOrderDidPayNotification";

NSString * const OMNOrderKey = @"OMNOrderKey";
NSString * const OMNOrderIndexKey = @"OMNOrderIndexKey";

NSString * const OMNVisitorOrdersDidChangeNotification = @"OMNVisitorOrdersDidChangeNotification";

@implementation OMNVisitor {
  id _decodeBeaconData;
  dispatch_semaphore_t _visitorLock;
}

- (void)dealloc {
  
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  
}

- (instancetype)initWithJsonData:(id)data {
  self = [super init];
  if (self) {
    
//    NSData *data1 = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:nil];
//    NSLog(@"%@", [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding]);

    
    _foundDate = [NSDate date];
    _decodeBeaconData = data;
    _beacon = [[OMNBeacon alloc] initWithJsonData:data[@"beacon"]];
    _restaurant = [[OMNRestaurant alloc] initWithJsonData:data[@"restaurant"]];
    _table = [[OMNTable alloc] initWithJsonData:data[@"table"]];
    _qr = [[OMNQR alloc] initWithJsonData:data[@"qr"]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(waiterCallDone:) name:OMNSocketIOWaiterCallDoneNotification object:[OMNSocketManager manager]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderDidChange:) name:OMNSocketIOOrderDidChangeNotification object:[OMNSocketManager manager]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderDidChange:) name:OMNSocketIOOrderDidPayNotification object:[OMNSocketManager manager]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderDidClose:) name:OMNSocketIOOrderDidCloseNotification object:[OMNSocketManager manager]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderDidCreate:) name:OMNSocketIOOrderDidCreateNotification object:[OMNSocketManager manager]];
    
    _visitorLock = dispatch_semaphore_create(1);
    
  }
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  _decodeBeaconData = [aDecoder decodeObjectForKey:@"decodeBeaconData"];
  self = [self initWithJsonData:_decodeBeaconData];
  if (self) {
    _foundDate = [aDecoder decodeObjectForKey:@"foundDate"];
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
  
  [aCoder encodeObject:self.foundDate forKey:@"foundDate"];
  [aCoder encodeObject:_decodeBeaconData forKey:@"decodeBeaconData"];
  
}

- (void)updateOrder:(OMNOrder *)changedOrder {
  
  [_orders enumerateObjectsUsingBlock:^(OMNOrder *order, NSUInteger idx, BOOL *stop) {
    
    if ([changedOrder.id isEqualToString:order.id]) {
      [order updateWithOrder:changedOrder];
      [[NSNotificationCenter defaultCenter] postNotificationName:OMNOrderDidChangeNotification
                                                          object:self
                                                        userInfo:@{OMNOrderKey : order}];
      *stop = YES;
    }
    
  }];
  
}

- (BOOL)isSameRestaurant:(OMNVisitor *)visitor {
  
  return [self.restaurant.id isEqualToString:visitor.restaurant.id];
  
}

- (void)subscribeForTableEvents {
  
  [[OMNSocketManager manager] join:self.table.id];
  
}

- (void)setTable:(OMNTable *)table {
  
  if (NO == [_table.id isEqualToString:table.id]) {
    [[OMNSocketManager manager] leave:_table.id];
    [[OMNSocketManager manager] join:table.id];
  }
  
  _table = table;
  
}

- (BOOL)expired {
  
  if (self.foundDate) {
    NSTimeInterval timeElapsed = [[NSDate date] timeIntervalSinceDate:self.foundDate];
    return (timeElapsed > 20*60);
  }
  else {
    return YES;
  }
  
}

- (NSString *)id {
  if (self.beacon) {
    return self.beacon.key;
  }
  return @"";
}

- (NSString *)description {
  return [NSString stringWithFormat:@"table = %@\nrestaurant = %@", self.table.id, self.restaurant.id];
}

#pragma mark - notifications

- (void)waiterCallDone:(NSNotification *)n {
  
  self.waiterIsCalled = NO;
  
}

- (void)orderDidChange:(NSNotification *)n {
  
  OMNOrder *newOrder = [[OMNOrder alloc] initWithJsonData:n.userInfo[OMNOrderDataKey]];
  [self updateOrder:newOrder];
  
}


- (void)orderDidCreate:(NSNotification *)n {
  
  OMNOrder *newOrder = [[OMNOrder alloc] initWithJsonData:n.userInfo[OMNOrderDataKey]];
  
  if ([newOrder.restaurant_id isEqualToString:self.restaurant.id]) {
    
    [self addNewOrder:newOrder];

  }
  
}

- (void)orderDidClose:(NSNotification *)n {
  
  OMNOrder *closeOrder = [[OMNOrder alloc] initWithJsonData:n.userInfo[OMNOrderDataKey]];
  
  NSMutableArray *orders = [_orders mutableCopy];
  
  __block OMNOrder *realClosedOrder = nil;
  [_orders enumerateObjectsUsingBlock:^(OMNOrder *order, NSUInteger idx, BOOL *stop) {
    
    if ([closeOrder.id isEqualToString:order.id]) {
      realClosedOrder = order;
      [orders removeObjectAtIndex:idx];
      *stop = YES;
    }
    
  }];
  
  if (realClosedOrder) {
    
    [self updateOrdersWithOrders:orders];
    [[NSNotificationCenter defaultCenter] postNotificationName:OMNOrderDidCloseNotification
                                                        object:self
                                                      userInfo:@{OMNOrderKey : realClosedOrder}];
    
  }
  
}

- (void)addNewOrder:(OMNOrder *)order {
  
  dispatch_semaphore_wait(_visitorLock, DISPATCH_TIME_FOREVER);
  
  self.orders = [self.orders arrayByAddingObject:order];
  [[NSNotificationCenter defaultCenter] postNotificationName:OMNVisitorOrdersDidChangeNotification object:self];
  
  dispatch_semaphore_signal(_visitorLock);
  
}

- (void)updateOrdersWithOrders:(NSArray *)orders {
 
  dispatch_semaphore_wait(_visitorLock, DISPATCH_TIME_FOREVER);
  
  NSString *selectedOrderId = self.selectedOrder.id;
  __weak typeof(self)weakSelf = self;
  [orders enumerateObjectsUsingBlock:^(OMNOrder *order, NSUInteger idx, BOOL *stop) {
    
    if ([order.id isEqualToString:selectedOrderId]) {
      weakSelf.selectedOrder = order;
      *stop = YES;
    }
    
  }];
  
  self.orders = orders;
  [[NSNotificationCenter defaultCenter] postNotificationName:OMNVisitorOrdersDidChangeNotification object:self];
  
  dispatch_semaphore_signal(_visitorLock);
  
}

@end




@implementation NSArray (omn_visitor)

- (NSArray *)omn_visitors {
  NSMutableArray *visitors = [NSMutableArray arrayWithCapacity:self.count];
  [self enumerateObjectsUsingBlock:^(id visitorData, NSUInteger idx, BOOL *stop) {
    
    OMNVisitor *visitor = [[OMNVisitor alloc] initWithJsonData:visitorData];
    [visitors addObject:visitor];
    
  }];
  return [visitors copy];
}

@end


