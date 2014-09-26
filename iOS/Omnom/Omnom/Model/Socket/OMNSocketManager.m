//
//  OMNSocketManager.m
//  omnom
//
//  Created by tea on 30.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNSocketManager.h"
#import <OMNSocketIO.h>
#import "OMNConstants.h"

NSString * const OMNSocketIOWaiterCallDoneNotification = @"OMNSocketIOWaiterCallDoneNotification";
NSString * const OMNSocketIOOrderDidChangeNotification = @"OMNSocketIOOrderDidChangeNotification";
NSString * const OMNSocketIOOrderDidCloseNotification = @"OMNSocketIOOrderDidCloseNotification";
NSString * const OMNSocketIOOrderDidPayNotification = @"OMNSocketIOOrderDidPayNotification";

NSString * const OMNOrderDataKey = @"OMNOrderDataKey";
NSString * const OMNPaymentDataKey = @"OMNPaymentDataKey";

@implementation OMNSocketManager {
  OMNSocketIO *_io;
  Socket *_socket;
  NSString *_token;
  NSMutableDictionary *_listners;
}

+ (instancetype)manager {
  static id manager = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    manager = [[[self class] alloc] init];
  });
  return manager;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    _rooms = [NSMutableSet set];
    _listners = [NSMutableDictionary dictionary];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resumeConnection) name:UIApplicationDidBecomeActiveNotification object:nil];

  }
  return self;
}

- (void)willResignActive {
  [self disconnectAndLeaveAllRooms:NO];
}

- (void)resumeConnection {
  
  if (0 == _token.length ||
      _io) {
    return;
  }
  
  [self connectWithToken:_token completion:^{
    NSLog(@"socket did resume connection");
  }];
  
}

- (void)establishConnecttionWithToken:(NSString *)token completion:(dispatch_block_t)completionBlock {
  
  NSString *query = [NSString stringWithFormat:@"token=%@", token];
  _socket = [_io of:[OMNConstants baseUrlString] and:@{@"query" : query}];
  
  [_socket emit:@"handshake", nil];
  
  __weak typeof(self)weakSelf = self;
  [_socket on:@"handshake" listener:^(id data) {
    
    NSLog(@"handshake response %@, %@", data, [data class]);
    if (completionBlock &&
        [data isKindOfClass:[NSString class]] &&
        [data isEqualToString:@"authentication success"]) {
      
      [weakSelf socketDidAuthenticate];
      completionBlock();
      
    }
    
  }];

  [_socket on:@"order_close" listener:^(id data) {
    
    NSLog(@"order_close %@, %@", data, [data class]);
    dispatch_async(dispatch_get_main_queue(), ^{
      
      if (data) {
        [[NSNotificationCenter defaultCenter] postNotificationName:OMNSocketIOOrderDidCloseNotification
                                                            object:self
                                                          userInfo:@{OMNOrderDataKey : data}];
      }
      
    });
    
  }];
  
  [_socket on:@"order_update" listener:^(id data) {
    
    NSLog(@"order_update %@, %@", data, [data class]);
    dispatch_async(dispatch_get_main_queue(), ^{
      
      if (data) {
        [[NSNotificationCenter defaultCenter] postNotificationName:OMNSocketIOOrderDidChangeNotification
                                                            object:self
                                                          userInfo:@{OMNOrderDataKey : data}];
      }
      
    });
    
  }];
  
  [_socket on:@"payment" listener:^(id data) {

    NSLog(@"payment response %@, %@", data, [data class]);
    
    dispatch_async(dispatch_get_main_queue(), ^{
      
      id order = data[@"order"];
      if (order) {
        [[NSNotificationCenter defaultCenter] postNotificationName:OMNSocketIOOrderDidPayNotification
                                                            object:self
                                                          userInfo:@{OMNOrderDataKey : order,
                                                                     OMNPaymentDataKey : data}];
      }
      
    });
    
  }];
  
  [_socket on:@"waiter_call_done" listener:^(id data) {
    
    NSLog(@"waiter_call_done response %@, %@", data, [data class]);
    dispatch_async(dispatch_get_main_queue(), ^{
      
      [[NSNotificationCenter defaultCenter] postNotificationName:OMNSocketIOWaiterCallDoneNotification
                                                          object:self
                                                        userInfo:data];
      
    });
    
  }];
  
  [_socket on:@"bill_call_done" listener:^(id data) {
    NSLog(@"bill_call_done response %@, %@", data, [data class]);
  }];
  
  /*
  [_socket on:@"card_register" listener:^(id data) {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:OMNSocketIODidReceiveCardIdNotification
                                                        object:self
                                                      userInfo:data];
    NSLog(@"card_register response %@, %@", data, [data class]);
    
  }];
   */
  
}

- (void)socketDidAuthenticate {
  
  [_rooms enumerateObjectsUsingBlock:^(id roomId, BOOL *stop) {
    [self join:roomId];
  }];
  
}

- (void)subscribe:(NSString *)event block:(void (^)(id data))block {
  
  if (!_listners[event]) {
    _listners[event] = [NSMutableSet set];
  }
  [_listners[event] addObject:block];
  [_socket on:event listener:block];
  
}

- (void)unsubscribe:(NSString *)event {
  
  NSSet *listners = _listners[event];
  [listners enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
    [_socket removeListener:event listener:obj];
  }];
  
}

- (void)echo:(NSString *)message {
  
  [_socket emit:@"echo", message, nil];
  
}

- (void)join:(NSString *)roomId {
  
  if (roomId.length) {
    [_rooms addObject:roomId];
    [_socket emit:@"join", roomId, nil];
    NSLog(@"join:%@", roomId);
  }
  
}

- (void)leave:(NSString *)roomId {
  
  if (roomId) {
    [_rooms removeObject:roomId];
    [_socket emit:@"leave", roomId, nil];
  }
  
}

- (void)connectWithToken:(NSString *)token {
  [self connectWithToken:token completion:nil];
}

- (void)connectWithToken:(NSString *)token completion:(dispatch_block_t)completionBlock {
  
  if (0 == token.length) {
    return;
  }
  
  _token = token;
  if (_io) {
    [self establishConnecttionWithToken:token completion:completionBlock];
  }
  else {
    _io = [[OMNSocketIO alloc] init];
    __weak typeof(self)weakSelf = self;
    [_io once:@"ready" listener:^{
      [weakSelf establishConnecttionWithToken:token completion:completionBlock];
    }];
  }
  
}

- (void)disconnectAndLeaveAllRooms:(BOOL)leave {

  if (leave) {
    _token = nil;
    [_rooms removeAllObjects];
  }
  [_socket emit:@"disconnect", nil];
  _socket = nil;
  _io = nil;
  
}

@end
