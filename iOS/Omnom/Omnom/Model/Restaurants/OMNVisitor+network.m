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
#import "OMNOrder+network.h"

NSString * const OMNVisitorNotificationLaunchKey = @"OMNVisitorNotificationLaunchKey";

@implementation  OMNVisitor (omn_network)

- (void)updateWithVisitor:(OMNVisitor *)visitor {
  
  if (nil == visitor.table.id) {
    return;
  }
  
  if (NO == [self.table.id isEqualToString:visitor.table.id]) {
    
    self.orders = nil;
    
    self.table = visitor.table;
    
    [self newGuestWithCompletion:^{
      
    } failure:^(NSError *error) {
      
    }];
    
  }
  
}

- (void)updateOrdersIfNeeded {
  
  if (nil == self.orders) {
    return;
  }
  
  __weak typeof(self)weakSelf = self;
  [self getOrders:^(NSArray *orders) {
    
    [weakSelf updateOrdersWithOrders:orders];
    
  } error:^(NSError *error) {
  }];
  
}

- (void)getOrders:(OMNOrdersBlock)ordersBlock error:(void(^)(NSError *error))errorBlock {
  
  if ([OMNConstants useStubOrdersData]) {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"orders" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSArray *ordersData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSArray *orders = [ordersData omn_decodeOrdersWithError:nil];
    self.orders = orders;
    ordersBlock(orders);
    return;
  }
  
  __weak typeof(self)weakSelf = self;
  NSString *path = [NSString stringWithFormat:@"/restaurants/%@/tables/%@/orders", self.restaurant.id, self.table.id];
  [[OMNOperationManager sharedManager] GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id response) {
    
    if ([response isKindOfClass:[NSArray class]]) {
      
      NSArray *ordersData = response;
      NSArray *orders = [ordersData omn_decodeOrdersWithError:nil];
      if (0 == orders.count) {
        
        [[OMNAnalitics analitics] logDebugEvent:@"NO_ORDERS" jsonRequest:path responseOperation:operation];
        
      }
      weakSelf.orders = orders;
      ordersBlock(orders);
      
    }
    else {
      
      [[OMNAnalitics analitics] logDebugEvent:@"ERROR_GET_ORDERS" jsonRequest:path responseOperation:operation];
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

- (void)tableInWithFailure:(void(^)(NSError *error))failureBlock {
  
  if (nil == self.table.id) {
    return;
  }
  
  NSString *path = [NSString stringWithFormat:@"/restaurants/%@/tables/%@/in", self.restaurant.id, self.table.id];
  [[OMNOperationManager sharedManager] POST:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    if ([responseObject[@"status"] isEqualToString:@"success"]) {
      failureBlock(nil);
    }
    else {
      [[OMNAnalitics analitics] logDebugEvent:@"ERROR_TABLE_IN" jsonRequest:path jsonResponse:responseObject];
      failureBlock(nil);
    }
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    [[OMNAnalitics analitics] logDebugEvent:@"ERROR_TABLE_IN" jsonRequest:path responseOperation:operation];
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

- (BOOL)readyForPush {
  
  if (UIApplicationStateActive == [UIApplication sharedApplication].applicationState) {
    return NO;
  }
  
  BOOL readyForPush = ([[NSDate date] timeIntervalSinceDate:self.foundDate] > 4*60*60);
  return readyForPush;
  
}

- (void)showGreetingPush {
  
  if (NO == self.readyForPush) {
    return;
  }
  
  OMNPushText *at_entrance = self.restaurant.mobile_texts.at_entrance;
  UILocalNotification *localNotification = [[UILocalNotification alloc] init];
  
  localNotification.alertBody = at_entrance.greeting;
  localNotification.alertAction = at_entrance.open_action;
  localNotification.soundName = kPushSoundName;
  [[OMNAnalitics analitics] logDebugEvent:@"push_sent" parametrs:@{@"text" : (at_entrance.greeting ? (at_entrance.greeting) : (@""))}];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
  //    if ([localNotification respondsToSelector:@selector(category)]) {
  //      [localNotification performSelector:@selector(setCategory:) withObject:@"incomingCall"];
  //    }
#pragma clang diagnostic pop
  
  localNotification.userInfo =
  @{
    OMNVisitorNotificationLaunchKey : [NSKeyedArchiver archivedDataWithRootObject:self],
    };
  [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
  
}

@end
