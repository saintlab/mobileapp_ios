//
//  OMNBluetoothManager.m
//  beacon
//
//  Created by tea on 24.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNBluetoothManager.h"

static CBCentralManager *_centralManager = nil;

@interface OMNBluetoothManager ()
<CBCentralManagerDelegate>

@end

@implementation OMNBluetoothManager {
  CBCentralManagerStateBlock _centralManagerStateBlock;
}

+ (instancetype)manager {
  static id manager = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    manager = [[[self class] alloc] init];
  });
  return manager;
}

- (void)getBluetoothState:(CBCentralManagerStateBlock)block {
  
  _centralManagerStateBlock = block;

  if (nil == _centralManager) {
    
    _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue() options:@{CBCentralManagerOptionShowPowerAlertKey:@(YES)}];
    [_centralManager scanForPeripheralsWithServices:nil options:nil];
  }
  else if(_centralManagerStateBlock){
    
    _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
    
  }
  
}

- (void)stop {

  _centralManagerStateBlock = nil;
  _centralManager.delegate = nil;
  _centralManager = nil;
  
}

#pragma mark - CBCentralManagerDelegate

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
  
  NSLog(@"%@ %@ %@", RSSI, peripheral.name, peripheral.identifier);
  
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
  
  if (_centralManagerStateBlock) {
    _centralManagerStateBlock(central.state);
  }
  
}

@end
