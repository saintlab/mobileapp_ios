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
#import <AudioToolbox/AudioToolbox.h>

NSString * const OMNSocketIODidReceiveCardIdNotification = @"OMNSocketIODidReceiveCardIdNotification";
NSString * const OMNSocketIODidPayNotification = @"OMNSocketIODidPayNotification";
NSString * const OMNSocketIOWaiterCallDoneNotification = @"OMNSocketIOWaiterCallDoneNotification";
NSString * const OMNSocketIOBillCallDoneNotification = @"OMNSocketIOBillCallDoneNotification";

@implementation OMNSocketManager {
  OMNSocketIO *_io;
  Socket *_socket;
  SystemSoundID _soundID;
  NSMutableSet *_rooms;
  NSString *_token;
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
    NSString *path = [[NSBundle mainBundle] pathForResource:@"pay_done" ofType:@"caf"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &_soundID);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
  }
  return self;
}

- (void)willEnterForeground {
  
  if (0 == _token.length) {
    return;
  }
  
  [self connectWithToken:_token completion:^{
    
    [_rooms enumerateObjectsUsingBlock:^(id roomId, BOOL *stop) {
      [self join:roomId];
    }];
    
  }];
  
}

- (void)didEnterBackground {
  [self disconnect];
}

- (void)safeConnectWithToken:(NSString *)token  completion:(dispatch_block_t)completionBlock {
  
  NSString *query = [NSString stringWithFormat:@"token=%@", token];
  _socket = [_io of:[OMNConstants baseUrlString] and:@{@"query" : query}];
  
  [_socket emit:@"handshake", nil];
  
  [_socket on:@"handshake" listener:^(id data) {
    
    if (completionBlock &&
        [data isKindOfClass:[NSString class]] &&
        [data isEqualToString:@"authentication success"]) {
      completionBlock();
    }
    NSLog(@"handshake response %@, %@", data, [data class]);
    
  }];
  
  __weak typeof(self)weakSelf = self;
  [_socket on:@"payment" listener:^(id data) {

    NSLog(@"payment response %@, %@", data, [data class]);
    dispatch_async(dispatch_get_main_queue(), ^{
      [weakSelf paymentDone:data];
      
    });
    
  }];
  
  [_socket on:@"waiter_call_done" listener:^(id data) {
    
    NSLog(@"waiter_call_done response %@, %@", data, [data class]);
    dispatch_async(dispatch_get_main_queue(), ^{
      [[NSNotificationCenter defaultCenter] postNotificationName:OMNSocketIOWaiterCallDoneNotification object:nil userInfo:data];
    });
    
  }];
  
  [_socket on:@"bill_call_done" listener:^(id data) {
    
    NSLog(@"bill_call_done response %@, %@", data, [data class]);
    dispatch_async(dispatch_get_main_queue(), ^{
      
      [[NSNotificationCenter defaultCenter] postNotificationName:OMNSocketIOBillCallDoneNotification object:nil userInfo:data];


    });
    
  }];
  
  [_socket on:@"card_register" listener:^(id data) {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:OMNSocketIODidReceiveCardIdNotification object:nil userInfo:data];
    NSLog(@"card_register response %@, %@", data, [data class]);
    
  }];
  
}

- (void)paymentDone:(id)data {
  
  [[NSNotificationCenter defaultCenter] postNotificationName:OMNSocketIODidPayNotification object:nil userInfo:data];
  AudioServicesPlaySystemSound(_soundID);
  
}

- (void)join:(NSString *)roomId {
  
  if (roomId.length) {
    [_rooms addObject:roomId];
    [_socket emit:@"join", roomId, nil];
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
    [self safeConnectWithToken:token completion:completionBlock];
  }
  else {
    _io = [[OMNSocketIO alloc] init];
    __weak typeof(self)weakSelf = self;
    [_io once:@"ready" listener:^{
      [weakSelf safeConnectWithToken:token completion:completionBlock];
    }];
  }
  
}

- (void)disconnect {

  [_socket emit:@"disconnect", nil];
  _socket = nil;
  _io = nil;
  
}

@end
