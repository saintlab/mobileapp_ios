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

+ (PMKPromise *)omn_getBluetoothState {
  return [OMNCentralManager promise];
}

@end

@implementation OMNCentralManager {
  PMKPromiseFulfiller fulfiller;   // void (^)(id)
  PMKPromiseRejecter rejecter;     // void (^)(NSError *)
}

+ (PMKPromise *)promise {
  OMNCentralManager *manager = [[OMNCentralManager alloc] initWithDelegate:nil queue:dispatch_get_main_queue() options:@{CBCentralManagerOptionShowPowerAlertKey:@(NO)}];
  manager.delegate = manager;
  PMKPromise *promise = [Promise new:^(PromiseFulfiller fulfiller, PromiseRejecter rejecter){
    manager->fulfiller = fulfiller;
    manager->rejecter = rejecter;
  }];
  promise.finally(^{
    manager.delegate = nil;
  });
  // NOTE: we don’t return the promise returned by finally.
  // This way we don’t risk premature deallocation of the manager.
  return promise;
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
  fulfiller(@(central.state));
}

@end
