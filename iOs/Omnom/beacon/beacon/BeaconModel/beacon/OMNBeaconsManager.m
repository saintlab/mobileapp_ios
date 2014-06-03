//
//  OMNBeaconsManager.m
//  beacon
//
//  Created by tea on 10.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNBeaconsManager.h"
#import <CoreLocation/CoreLocation.h>
#import "OMNBeacon.h"
#import "CLBeacon+GBeaconAdditions.h"
#import "OMNBeaconRangingManager.h"
#import "OMNFoundBeacons.h"

NSString * const OMNBeaconsManagerDidChangeBeaconsNotification = @"OMNBeaconsManagerDidChangeBeaconsNotification";


@interface OMNBeaconsManager ()

@end

@implementation OMNBeaconsManager {
  
  dispatch_semaphore_t _addBeaconLock;

  BOOL _ragingMonitorEnabled;

  OMNFoundBeaconsBlock _foundBeaconsBlock;
  OMNBeaconRangingManager *_beaconRangingManager;

}

- (instancetype)init {
  self = [super init];
  if (self) {
    
    _addBeaconLock = dispatch_semaphore_create(1);
    
    __weak typeof(self)weakSelf = self;
    _beaconRangingManager = [[OMNBeaconRangingManager alloc] initWithAuthorizationStatus:^(CLAuthorizationStatus status) {
      
      switch (status) {
        case kCLAuthorizationStatusDenied:
        case kCLAuthorizationStatusRestricted: {
          
          [weakSelf stopMonitoring];
          
        } break;
        default: {
        } break;
      }
      
    }];
    
  }
  return self;
}

- (void)startMonitoring:(OMNFoundBeaconsBlock)block {
  NSAssert(block != nil, @"please provide block");
  _ragingMonitorEnabled = YES;
  _foundBeaconsBlock = block;
  [self startRagingMonitoring];
  
}

- (void)startRagingMonitoring {
  
  if (!_ragingMonitorEnabled) {
    NSLog(@"Ranging is not avaliable");
    return;
  }
  
  __weak typeof(self)weakSelf = self;
  [_beaconRangingManager rangeNearestBeacons:^(NSArray *beacons) {
    
    [weakSelf processBeacons:beacons];
    
  } failure:^(NSError *error) {
    
    NSLog(@"error>%@", error);
    [weakSelf stopMonitoring];
    
  }];
  
}

- (void)stopMonitoring {
  
  _foundBeaconsBlock = nil;
  _ragingMonitorEnabled = NO;
  [_beaconRangingManager stop];
  
}

- (void)processBeacons:(NSArray *)newBeacons {
  
  dispatch_semaphore_wait(_addBeaconLock, DISPATCH_TIME_FOREVER);
  NSLog(@"%@", newBeacons);
  NSMutableArray *foundBeacons = [NSMutableArray arrayWithCapacity:newBeacons.count];
  [newBeacons enumerateObjectsUsingBlock:^(CLBeacon *beacon, NSUInteger idx, BOOL *stop) {
    
    [foundBeacons addObject:[beacon omn_beacon]];
    
  }];
  
  if (_foundBeaconsBlock) {
    _foundBeaconsBlock(foundBeacons);
  }
  
  dispatch_semaphore_signal(_addBeaconLock);
  
}

@end
