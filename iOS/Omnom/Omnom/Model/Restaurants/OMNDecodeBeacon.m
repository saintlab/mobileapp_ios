//
//  OMNDecodeBeacon.m
//  restaurants
//
//  Created by tea on 14.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNDecodeBeacon.h"
#import "OMNOperationManager.h"

@interface NSArray (omn_restaurants)

- (NSArray *)decodeOrdersWithError:(NSError **)error;

@end

@implementation OMNDecodeBeacon {
  id _decodeBeaconData;
}

- (instancetype)initWithJsonData:(id)data {
  self = [super init];
  if (self) {
#warning _demo
    _demo = [data[@"is_demo"] boolValue];
    _decodeBeaconData = data;
    _uuid = [data[@"uuid"] description];
    _tableId = [data[@"table_id"] description];
    _restaurantId = [data[@"restaurant_id"] description];
    _foundDate = [NSDate date];
    _restaurant = [[OMNRestaurant alloc] initWithJsonData:data[@"restaurant"]];
  }
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  _decodeBeaconData = [aDecoder decodeObjectForKey:@"decodeBeaconData"];
  self = [self initWithJsonData:_decodeBeaconData];
  return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
  [aCoder encodeObject:_decodeBeaconData forKey:@"decodeBeaconData"];
}

- (BOOL)readyForPush {
  
  return ([[NSDate date] timeIntervalSinceDate:self.foundDate] > 4*60*60);
  
}

- (NSString *)description {
  return [NSString stringWithFormat:@"table = %@\nrestaurant = %@", _tableId, _restaurantId];
}

- (void)getOrders:(OMNOrdersBlock)ordersBlock error:(void(^)(NSError *error))errorBlock {
  
  if (kUseStubData) {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"orders.data" ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSArray *ordersData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    ordersBlock([ordersData decodeOrdersWithError:nil]);
    return;
  }
  __weak typeof(self)weakSelf = self;
  NSString *path = [NSString stringWithFormat:@"/restaurants/%@/tables/%@/orders", self.restaurantId, self.tableId];
  [[OMNOperationManager sharedManager] GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id response) {
    
    if ([response isKindOfClass:[NSArray class]]) {
      NSArray *ordersData = response;
      NSArray *orders = [ordersData decodeOrdersWithError:nil];
      weakSelf.orders = orders;
      ordersBlock(orders);
    }
    else {
      errorBlock(nil);
    }
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    errorBlock(error);
    
  }];
  
}


- (void)newGuestWithCompletion:(dispatch_block_t)completionBlock failure:(void(^)(NSError *error))failureBlock {
  
  NSString *path = [NSString stringWithFormat:@"/restaurants/%@/tables/%@/new/guest", self.restaurantId, self.tableId];
  
  [[OMNOperationManager sharedManager] POST:path parameters:nil success:^(AFHTTPRequestOperation *operation, NSArray *ordersData) {
    
    NSLog(@"newGuestForTableID>done");
    completionBlock();
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    NSLog(@"newGuestForTableID>%@", error);
    failureBlock(error);
    
  }];
  
}

@end


@implementation NSArray (omn_restaurants)

- (NSArray *)decodeOrdersWithError:(NSError **)error {
  
  NSMutableArray *orders = [NSMutableArray arrayWithCapacity:[self count]];
  for (id orderData in self) {
    
    OMNOrder *order = [[OMNOrder alloc] initWithJsonData:orderData];
    [orders addObject:order];
    
  }
  
  return [orders copy];
  
}

@end