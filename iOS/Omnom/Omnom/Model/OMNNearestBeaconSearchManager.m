//
//  OMNBeaconSearchManager.m
//  beacon
//
//  Created by tea on 16.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNNearestBeaconSearchManager.h"
#import <CBCentralManager+omn_promise.h>
#import "OMNRestaurantManager.h"
#import <OMNBeaconsSearchManager.h>

@implementation OMNNearestBeaconSearchManager

+ (PMKPromise *)findAndProcessNearestBeacons {
  
  UIBackgroundTaskIdentifier searchBeaconTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
  }];
  
  return [PMKPromise new:^(PMKFulfiller fulfill, PMKRejecter reject) {
    
    [CBCentralManager omn_bluetoothEnabled].then(^{
      
      return [OMNBeaconsSearchManager searchBeacons];
      
    }).then(^(NSArray *nearestBeacons) {
      
      return [OMNRestaurantManager processBackgroundBeacons:nearestBeacons];
      
    }).catch(^(OMNError *error) {
      
      reject(error);
      
    }).finally(^{
      
      [[UIApplication sharedApplication] endBackgroundTask:searchBeaconTask];
      
    });
    
  }];
  
}

@end
