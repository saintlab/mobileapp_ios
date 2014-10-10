//
//  OMNVisitor+network.m
//  omnom
//
//  Created by tea on 29.09.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNVisitor+network.h"
#import "OMNOperationManager.h"
#import "OMNAnalitics.h"

@interface NSArray (omn_restaurants)

- (NSArray *)decodeOrdersWithError:(NSError **)error;

@end

@implementation  OMNVisitor (omn_network)

- (void)updateWithVisitor:(OMNVisitor *)visitor {
  
  if (nil == visitor.table.id) {
    return;
  }
  
  if (NO == [self.table.id isEqualToString:visitor.table.id]) {
    self.table = visitor.table;
    
    [self newGuestWithCompletion:^{
      
    } failure:^(NSError *error) {
      
    }];
    
  }
  
}

- (void)getOrders:(OMNOrdersBlock)ordersBlock error:(void(^)(NSError *error))errorBlock {
  
  if ([OMNConstants useStubOrdersData]) {
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
    
    if ([response isKindOfClass:[NSArray class]]) {
      
      NSArray *ordersData = response;
      NSArray *orders = [ordersData decodeOrdersWithError:nil];
      if (0 == orders.count) {
        [[OMNAnalitics analitics] logDebugEvent:@"NO_ORDERS" jsonRequest:path jsonResponse:response];
      }
      weakSelf.orders = orders;
      ordersBlock(orders);
      
    }
    else {
      
      [[OMNAnalitics analitics] logDebugEvent:@"ERROR_GET_ORDERS" jsonRequest:path jsonResponse:response];
      errorBlock(nil);
      
    }
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    [[OMNAnalitics analitics] logDebugEvent:@"ERROR_GET_ORDERS" jsonRequest:path responseOperation:operation];
    errorBlock(error);
    
  }];
  
}


- (void)newGuestWithCompletion:(dispatch_block_t)completionBlock failure:(void(^)(NSError *error))failureBlock {
  
  NSString *path = [NSString stringWithFormat:@"/restaurants/%@/tables/%@/new/guest", self.restaurant.id, self.table.id];
  
  [[OMNOperationManager sharedManager] POST:path parameters:nil success:^(AFHTTPRequestOperation *operation, NSArray *ordersData) {
    
    completionBlock();
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    [[OMNAnalitics analitics] logDebugEvent:@"ERROR_NEW_GUEST" jsonRequest:path responseOperation:operation];
    failureBlock(error);
    
  }];
  
}

#pragma mark - waiter call

- (void)waiterCallWithFailure:(void(^)(NSError *error))failureBlock {
  
  NSString *path = [NSString stringWithFormat:@"/restaurants/%@/tables/%@/waiter/call", self.restaurant.id, self.table.id];
  __weak typeof(self)weakSelf = self;
  [[OMNOperationManager sharedManager] POST:path parameters:nil success:^(AFHTTPRequestOperation *operation, id response) {
    
    if ([response isKindOfClass:[NSDictionary class]] &&
        [response[@"status"] isEqualToString:@"success"]) {
      [[OMNAnalitics analitics] logDebugEvent:@"WAITER_CALL" parametrs:response];
      [weakSelf waiterDidCalled];
    }
    failureBlock(nil);
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    failureBlock(error);
    
  }];
  
}

- (void)waiterDidCalled {
  
  self.waiterIsCalled = YES;
}

- (void)stopWaiterCall {
  
  self.waiterIsCalled = NO;
  
}

- (void)waiterCallStopWithFailure:(void(^)(NSError *error))failureBlock {
  
  NSString *path = [NSString stringWithFormat:@"/restaurants/%@/tables/%@/waiter/call/stop", self.restaurant.id, self.table.id];
  __weak typeof(self)weakSelf = self;
  [[OMNOperationManager sharedManager] POST:path parameters:nil success:^(AFHTTPRequestOperation *operation, id response) {
    
    [weakSelf stopWaiterCall];
    [[OMNAnalitics analitics] logDebugEvent:@"WAITER_CALL_DONE" parametrs:response];
    failureBlock(nil);
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
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
