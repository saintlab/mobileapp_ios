//
//  GSearchTableVC.m
//  beacon
//
//  Created by tea on 27.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "GSearchTableVC.h"
#import "OMNBeaconsManager.h"
#import "OMNBeacon.h"

@interface GSearchTableVC () {
  OMNBeaconsManager *_beaconManager;
}

@end

@implementation GSearchTableVC

- (void)dealloc {
  [_beaconManager stopMonitoring];
}

- (instancetype)init {
  self = [super init];
  if (self) {
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  _beaconManager = [[OMNBeaconsManager alloc] init];
  
  __weak typeof(self)weakSelf = self;
  [_beaconManager startMonitoring:^(OMNBeaconsManager *beaconsManager) {
    
    if (beaconsManager.atTheTableBeacons.count) {
      [weakSelf findNearestBeacon:beaconsManager.atTheTableBeacons];
    }
    
  }];

}

- (void)findNearestBeacon:(NSArray *)beacons {
  
  __block OMNBeacon *nearestBeacon = nil;
  [beacons enumerateObjectsUsingBlock:^(OMNBeacon *b, NSUInteger idx, BOOL *stop) {
    
    if (nil == nearestBeacon) {
      nearestBeacon = b;
    }
    else {
      
      if ([b totalRSSI] > [nearestBeacon totalRSSI]) {
        nearestBeacon = b;
      }
      
    }
    
  }];
  
  [_beaconManager stopMonitoring];
  _beaconManager = nil;
  
  NSLog(@"%@", nearestBeacon);
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}


@end
