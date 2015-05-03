//
//  OMNBluetoothManager.m
//  beacon
//
//  Created by tea on 24.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "CBCentralManager+omn_promise.h"

@interface OMNCentralManager : CBCentralManager
<CBCentralManagerDelegate>

+ (PMKPromise *)promise;

@end

@implementation CBCentralManager (omn_promise)

+ (PMKPromise *)omn_bluetoothEnabled {
  return [OMNCentralManager promise];
}

@end

@implementation OMNCentralManager {
  PMKFulfiller fulfiller;   // void (^)(id)
  PMKRejecter rejecter;     // void (^)(NSError *)
}

+ (PMKPromise *)promise {
  OMNCentralManager *manager = [[OMNCentralManager alloc] initWithDelegate:nil queue:dispatch_get_main_queue() options:@{CBCentralManagerOptionShowPowerAlertKey:@(NO)}];
  manager.delegate = manager;

  PMKPromise *promise = [PMKPromise new:^(PMKFulfiller fulfill, PMKRejecter reject) {
    manager->fulfiller = fulfill;
    manager->rejecter = reject;
  }];
  promise.finally(^{
    manager.delegate = nil;
  });
  // NOTE: we don’t return the promise returned by finally.
  // This way we don’t risk premature deallocation of the manager.
  return promise;
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
  
  if (CBCentralManagerStatePoweredOn == central.state) {
    fulfiller(nil);
  }
  else {
    rejecter(nil);
  }
  
}

@end
