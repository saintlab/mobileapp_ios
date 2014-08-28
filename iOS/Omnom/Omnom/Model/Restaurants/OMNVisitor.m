//
//  OMNDecodeBeacon.m
//  restaurants
//
//  Created by tea on 14.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNVisitor.h"
#import "OMNOperationManager.h"

@interface NSArray (omn_restaurants)

- (NSArray *)decodeOrdersWithError:(NSError **)error;

@end

@implementation OMNVisitor {
  id _decodeBeaconData;
}

- (instancetype)initWithJsonData:(id)data {
  self = [super init];
  if (self) {
    _decodeBeaconData = data;
    _beacon = [[OMNBeacon alloc] initWithJsonData:data[@"beacon"]];
    _restaurant = [[OMNRestaurant alloc] initWithJsonData:data[@"restaurant"]];
    _table = [[OMNTable alloc] initWithJsonData:data[@"table"]];
    _foundDate = [NSDate date];
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

- (NSString *)id {
  if (self.beacon) {
    return self.beacon.key;
  }
  return @"";
}

- (NSString *)description {
  return [NSString stringWithFormat:@"table = %@\nrestaurant = %@", self.table.id, self.restaurant.id];
}

- (void)getOrders:(OMNOrdersBlock)ordersBlock error:(void(^)(NSError *error))errorBlock {
  
  if (kUseStubOrdersData) {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"orders" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSArray *ordersData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSArray *orders = [ordersData decodeOrdersWithError:nil];
    self.orders = orders;
    ordersBlock(orders);
    return;
  }
  __weak typeof(self)weakSelf = self;
  NSString *path = [NSString stringWithFormat:@"/restaurants/%@/tables/%@/orders", self.restaurant.id, self.table.id];
  
  [[OMNOperationManager sharedManager] GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id response) {
    
    [operation.responseData writeToFile:[@"~/Documents/1.json" stringByExpandingTildeInPath] atomically:YES];
    
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
  
  NSString *path = [NSString stringWithFormat:@"/restaurants/%@/tables/%@/new/guest", self.restaurant.id, self.table.id];
  
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


