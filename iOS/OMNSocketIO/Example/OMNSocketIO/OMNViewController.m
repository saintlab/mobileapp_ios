//
//  OMNViewController.m
//  OMNSocketIO
//
//  Created by teanet on 07/23/2014.
//  Copyright (c) 2014 teanet. All rights reserved.
//

#import "OMNViewController.h"
#import <OMNSocketIO.h>
#import <Socket.h>

@interface OMNViewController ()

@property (nonatomic, assign) BOOL joined;

@end

@implementation OMNViewController {
  __block OMNSocketIO *_io;
  Socket *_socket;
  
  __weak IBOutlet UIButton *_joinButton;
  __weak IBOutlet UIButton *_startButton;
  
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  _joinButton.enabled = NO;
}

- (void)setJoined:(BOOL)joined {
  _joined = joined;
  
  if (_joined) {
    [_joinButton setTitle:NSLocalizedString(@"Leave", nil) forState:UIControlStateNormal];
  }
  else {
    [_joinButton setTitle:NSLocalizedString(@"Join", nil) forState:UIControlStateNormal];
  }
  
}

- (void)connect:(NSString *)url token:(NSString *)token {
  
  _io = [[OMNSocketIO alloc] init];
  NSString *url = @"http://echo.laaaab.com";
  NSString *token = @"c97b82073c997234223573e5623f7c89317272b8ba8a61a25f38c71b6ac5ec09";

  __weak typeof(self)weakSelf = self;
  [_io once:@"ready" listener:^{
    
    NSString *query = [NSString stringWithFormat:@"token=%@", token];
    _socket = [_io of:url and:@{@"query" : query}];
    
    [_socket emit:@"handshake", nil];
    
    [_socket on:@"handshake" listener:^(id data) {
      
      NSLog(@"handshake response %@, %@", data, [data class]);
      dispatch_async(dispatch_get_main_queue(), ^{
        _joinButton.enabled = YES;
      });
      
    }];
    
    [_socket on:@"join" listener:^(id data) {
      
      NSLog(@"join response %@, %@", data, [data class]);
      dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.joined = YES;
      });
//      [_socket emit:@"room" args:@[@"message"]];
//
      
    }];
    
    [_socket on:@"room" listener:^(id data) {
      
      NSLog(@"room response %@, %@", data, [data class]);
      
    }];
    
    
    [_socket on:@"leave" listener:^(id data) {
      
      NSLog(@"leave response %@, %@", data, [data class]);
      dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.joined = NO;
      });
      
    }];
    
  }];

  
}

- (IBAction)startTap:(id)sender {
  NSString *url = @"http://echo.laaaab.com";
  NSString *token = @"c97b82073c997234223573e5623f7c89317272b8ba8a61a25f38c71b6ac5ec09";
  [self connect:url token:token];
}

- (IBAction)joinTap:(id)sender {
  
  if (_joined) {
    
    [_socket emit:@"leave" args:@[@"room1"]];
    
  }
  else {
    
    [_socket emit:@"join" args:@[@"room1"]];
    
  }
  
  
}


@end
