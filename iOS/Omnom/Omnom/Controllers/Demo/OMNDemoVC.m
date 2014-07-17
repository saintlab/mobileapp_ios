//
//  OMNDemoVC.m
//  restaurants
//
//  Created by tea on 11.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNDemoVC.h"
#import "GAppDelegate.h"
#import "OMNBluetoothManager.h"

@interface OMNDemoVC ()

@end

@implementation OMNDemoVC {
  
  NSArray *_demoViewControllers;
  
}

- (void)dealloc {
  
}

- (instancetype)init {
  self = [super init];
  if (self) {
  }
  return self;
}

- (void)viewDidLoad {
  
  [super viewDidLoad];
  
  __weak typeof(self)weakSelf = self;
  [[OMNBluetoothManager manager] getBluetoothState:^(CBCentralManagerState state) {
    
    [weakSelf updateBluetoothState:state];
    
  }];
  
}

- (void)updateBluetoothState:(CBCentralManagerState)state {
  
  BOOL beaconEnabled = NO;
  
  switch (state) {
    case CBCentralManagerStatePoweredOn: {
      beaconEnabled = YES;
    } break;
    case CBCentralManagerStateUnauthorized:
    case CBCentralManagerStatePoweredOff: {
      NSLog(@"The app is not authorized to use Bluetooth Low Energy.");
    } break;
    case CBCentralManagerStateUnsupported: {
      NSLog(@"The platform doesn't support Bluetooth Low Energy.");
    } break;
    case CBCentralManagerStateResetting:
    case CBCentralManagerStateUnknown: {
    } break;
  }
  
//  OMNDemoBlueToothVC *demoBlueToothVC = _demoViewControllers[0];
//  demoBlueToothVC.beaconEnabled = beaconEnabled;
  
}



@end
