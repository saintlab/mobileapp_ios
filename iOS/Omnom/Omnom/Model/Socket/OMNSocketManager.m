//
//  OMNSocketManager.m
//  omnom
//
//  Created by tea on 30.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNSocketManager.h"
#import "SIOSocket.h"

NSString * const OMNSocketIOWaiterCallDoneNotification = @"OMNSocketIOWaiterCallDoneNotification";
NSString * const OMNSocketIOOrderDidChangeNotification = @"OMNSocketIOOrderDidChangeNotification";
NSString * const OMNSocketIOOrderDidCloseNotification = @"OMNSocketIOOrderDidCloseNotification";
NSString * const OMNSocketIOOrderDidPayNotification = @"OMNSocketIOOrderDidPayNotification";
NSString * const OMNSocketIOOrderDidCreateNotification = @"OMNSocketIOOrderDidCreateNotification";

NSString * const OMNOrderDataKey = @"OMNOrderDataKey";
NSString * const OMNPaymentDataKey = @"OMNPaymentDataKey";

@implementation OMNSocketManager {

  SIOSocket *_socket;
  NSString *_url;
  
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resumeConnection) name:UIApplicationDidBecomeActiveNotification object:nil];

  }
  return self;
}

- (void)willResignActive {
  [self disconnectAndLeaveAllRooms:NO];
}

- (void)resumeConnection {
  
  if (!_url) {
    return;
  }
  
  [self connect:_url withCompletion:^{
   DDLogDebug(@"socket did resume connection");
  }];
  
}

- (void)socketDidCreate:(SIOSocket *)socket {
  
  _socket = socket;
  [_socket on:@"order_close" callback:^(NSArray *args) {
    
    id data = [args firstObject];
    DDLogDebug(@"order_close %@, %@", data, [data class]);
    dispatch_async(dispatch_get_main_queue(), ^{
      
      if (data) {
        [[NSNotificationCenter defaultCenter] postNotificationName:OMNSocketIOOrderDidCloseNotification
                                                            object:self
                                                          userInfo:@{OMNOrderDataKey : data}];
      }
      
    });
    
  }];
  
  [_socket on:@"order_create" callback:^(NSArray *args) {
    
    id data = [args firstObject];
    DDLogDebug(@"order_create %@, %@", data, [data class]);
    dispatch_async(dispatch_get_main_queue(), ^{
      
      if (data) {
        [[NSNotificationCenter defaultCenter] postNotificationName:OMNSocketIOOrderDidCreateNotification
                                                            object:self
                                                          userInfo:@{OMNOrderDataKey : data}];
      }
      
    });
    
  }];
  
  [_socket on:@"order_update" callback:^(NSArray *args) {
    
    id data = [args firstObject];
    DDLogDebug(@"order_update %@, %@", data, [data class]);
    dispatch_async(dispatch_get_main_queue(), ^{
      
      if (data) {
        [[NSNotificationCenter defaultCenter] postNotificationName:OMNSocketIOOrderDidChangeNotification
                                                            object:self
                                                          userInfo:@{OMNOrderDataKey : data}];
      }
      
    });
    
  }];
  
  [_socket on:@"payment" callback:^(NSArray *args) {
    
    id data = [args firstObject];
    DDLogDebug(@"payment response %@, %@", data, [data class]);
    
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
  
  [_socket on:@"waiter_call_done" callback:^(NSArray *args) {
    
    id data = [args firstObject];
    DDLogDebug(@"waiter_call_done response %@, %@", data, [data class]);
    dispatch_async(dispatch_get_main_queue(), ^{
      
      [[NSNotificationCenter defaultCenter] postNotificationName:OMNSocketIOWaiterCallDoneNotification
                                                          object:self
                                                        userInfo:data];
      
    });
    
  }];
  
}

- (void)socketDidConnect {
  
  [_rooms enumerateObjectsUsingBlock:^(id roomId, BOOL *stop) {
    
    [self join:roomId];
    
  }];
  
}

- (void)connect:(NSString *)url withCompletion:(dispatch_block_t)completionBlock {

  _url = url;
  @weakify(self)
  [SIOSocket socketWithHost:url response:^(SIOSocket *socket) {
    
    [self socketDidCreate:socket];
    socket.onConnect = ^{
      
      NSLog(@"onConnect");
      @strongify(self)
      [self socketDidConnect];
      completionBlock();
      
    };
    
  }];
  
}

- (void)join:(NSString *)roomId {
  
  if (0 == roomId.length) {
    return;
  }
  
  [_rooms addObject:roomId];
  [_socket emit:@"join" args:@[roomId]];
  DDLogDebug(@"join:%@", roomId);
  
}

- (void)leave:(NSString *)roomId {
  
  if (0 == roomId.length) {
    return;
  }

  DDLogDebug(@"leave:%@", roomId);
  [_rooms removeObject:roomId];
  [_socket emit:@"leave" args:@[roomId]];

}

- (void)disconnectAndLeaveAllRooms:(BOOL)leave {

  if (leave) {
    
    NSSet *rooms = [_rooms copy];
    [rooms enumerateObjectsUsingBlock:^(id roomID, BOOL *stop) {
      [self leave:roomID];
    }];
    [_rooms removeAllObjects];
    
  }
  
  [_socket close];
  _socket = nil;
  
}

@end
