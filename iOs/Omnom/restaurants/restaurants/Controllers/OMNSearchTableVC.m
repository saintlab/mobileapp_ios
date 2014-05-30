//
//  OMNSearchTableVC.m
//  restaurants
//
//  Created by tea on 27.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNSearchTableVC.h"
#import "OMNBeaconsManager.h"
#import "OMNBeacon.h"

@interface OMNSearchTableVC ()

@end

@implementation OMNSearchTableVC {
  OMNBeaconsManager *_beaconManager;
  OMNSearchTableVCBlock _block;
}

- (instancetype)initWithBlock:(OMNSearchTableVCBlock)block {
  self = [super initWithNibName:@"OMNSearchTableVC" bundle:nil];
  if (self) {
    _block = block;
  }
  return self;
}

- (void)dealloc {
  [_beaconManager stopMonitoring];
  _beaconManager = nil;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  if (kUseStubBeacon) {
    return;
  }
  
  _beaconManager = [[OMNBeaconsManager alloc] init];
  
  __weak typeof(self)weakSelf = self;
  [_beaconManager startMonitoring:^(OMNBeaconsManager *beaconsManager) {
    
    if (beaconsManager.atTheTableBeacons.count) {
      [weakSelf findNearestBeacon:beaconsManager.atTheTableBeacons];
    }
    
  }];
  
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  if (kUseStubBeacon) {
    OMNDecodeBeacon *decodeBeacon = [[OMNDecodeBeacon alloc] init];
    decodeBeacon.restaurantId = @"riba-ris";
    decodeBeacon.tableId = @"1005";
    
    _block(decodeBeacon);
  }
  
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
  
  [OMNDecodeBeacon decodeBeacons:@[nearestBeacon] success:^(NSArray *decodeBeacons) {
    
    OMNDecodeBeacon *decodeBeacon = [decodeBeacons firstObject];
    if (_block) {
      _block(decodeBeacon);
    }
    NSLog(@"decodeBeacons>%@", decodeBeacons);
    
  } failure:^(NSError *error) {
    
    NSLog(@"error>%@", error);
    
  }];
  
  NSLog(@"%@", nearestBeacon);
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
