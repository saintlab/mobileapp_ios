//
//  OMNSocketManager.m
//  omnom
//
//  Created by tea on 30.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNSocketManager.h"
#import <OMNSocketIO.h>

NSString * const OMNSocketIODidReceiveCardIdNotification = @"OMNSocketIODidReceiveCardIdNotification";

NSString * const kSocketUrl = @"http://omnom.laaaab.com";

@implementation OMNSocketManager {
  OMNSocketIO *_io;
  Socket *_socket;
}

+ (instancetype)manager {
  static id manager = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    manager = [[[self class] alloc] init];
  });
  return manager;
}

- (void)safeConnectWithToken:(NSString *)token {
  
  NSString *query = [NSString stringWithFormat:@"token=%@", token];
  _socket = [_io of:kSocketUrl and:@{@"query" : query}];
  
  [_socket emit:@"handshake", nil];
  
  [_socket on:@"handshake" listener:^(id data) {
    
    NSLog(@"handshake response %@, %@", data, [data class]);
    
  }];
  
  [_socket on:@"payment" listener:^(id data) {
    
    dispatch_async(dispatch_get_main_queue(), ^{
      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[data[@"amount"] description] message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
      [alert show];
    });
    NSLog(@"payment response %@, %@", data, [data class]);
    
  }];
  
  [_socket on:@"card_register" listener:^(id data) {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:OMNSocketIODidReceiveCardIdNotification object:nil userInfo:data];
    NSLog(@"card_register response %@, %@", data, [data class]);
    
  }];
  
}

- (void)join:(NSString *)roomId {
  [_socket emit:@"join",roomId, nil];
}

- (void)leave:(NSString *)roomId {
  [_socket emit:@"leave", roomId, nil];
}

- (void)connectWithToken:(NSString *)token {
  
  if (_io) {
    [self safeConnectWithToken:token];
  }
  else {
    _io = [[OMNSocketIO alloc] init];
    __weak typeof(self)weakSelf = self;
    [_io once:@"ready" listener:^{
      [weakSelf safeConnectWithToken:token];
    }];
  }
  
}

@end
