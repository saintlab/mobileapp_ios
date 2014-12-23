//
//  OMNBluetoothManager.m
//  beacon
//
//  Created by tea on 24.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNBluetoothManager.h"

@interface OMNBluetoothManager ()
<CBCentralManagerDelegate>

@end

@implementation OMNBluetoothManager {
  
  CBCentralManagerStateBlock _centralManagerStateBlock;
  CBCentralManager *_centralManager;
  
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
    
    _state = CBCentralManagerStateUnknown;
    
  }
  return self;
}

- (void)getBluetoothState:(CBCentralManagerStateBlock)block {
  
  _centralManagerStateBlock = [block copy];
  if (nil == _centralManager) {
    
    _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue() options:@{CBCentralManagerOptionShowPowerAlertKey:@(NO)}];
    
  }

  if (_centralManager &&
      CBCentralManagerStateUnknown != _centralManager.state) {
    
    block(_centralManager.state);
    
  }
  
}

- (void)stop {

  _centralManagerStateBlock = nil;
  _centralManager.delegate = nil;
  _centralManager = nil;
  
}

#pragma mark - CBCentralManagerDelegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
  
  _state = central.state;
  if (_centralManagerStateBlock) {
    
    _centralManagerStateBlock(central.state);
    
  }

  if (CBCentralManagerStateUnsupported == central.state) {
    
    [self stop];
    
  }
  
}

@end
