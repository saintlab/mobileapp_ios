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



@implementation OMNVisitor {
  id _decodeBeaconData;
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithJsonData:(id)data {
  self = [super init];
  if (self) {
    
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

- (void)waiterCallDone:(NSNotification *)n {
  self.waiterIsCalled = NO;
}

- (void)orderDidChange:(NSNotification *)n {
  
  OMNOrder *newOrder = [[OMNOrder alloc] initWithJsonData:n.userInfo[OMNOrderDataKey]];
  
  [_orders enumerateObjectsUsingBlock:^(OMNOrder *order, NSUInteger idx, BOOL *stop) {
    
    if ([newOrder.id isEqualToString:order.id]) {
      [order updateWithOrder:newOrder];
      [[NSNotificationCenter defaultCenter] postNotificationName:OMNOrderDidChangeNotification
                                                          object:self
                                                        userInfo:@{OMNOrderKey : order}];
      *stop = YES;
    }
    
  }];
}

- (void)orderDidClose:(NSNotification *)n {
  
  OMNOrder *closeOrder = [[OMNOrder alloc] initWithJsonData:n.userInfo[OMNOrderDataKey]];
  
  [_orders enumerateObjectsUsingBlock:^(OMNOrder *order, NSUInteger idx, BOOL *stop) {
    
    if ([closeOrder.id isEqualToString:order.id]) {
      
      [[NSNotificationCenter defaultCenter] postNotificationName:OMNOrderDidCloseNotification
                                                          object:self
                                                        userInfo:@{OMNOrderKey : order,
                                                                   OMNOrderIndexKey : @(idx)}];
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


