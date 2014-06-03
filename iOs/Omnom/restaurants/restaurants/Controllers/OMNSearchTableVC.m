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
#import "OMNTablePositionVC.h"

@interface OMNSearchTableVC ()
<OMNTablePositionVCDelegate>

@end

@implementation OMNSearchTableVC {
  OMNBeaconsManager *_beaconManager;
  OMNSearchTableVCBlock _didFindTableBlock;
}

- (instancetype)initWithBlock:(OMNSearchTableVCBlock)block {
  self = [super initWithNibName:@"OMNSearchTableVC" bundle:nil];
  if (self) {
    _didFindTableBlock = block;
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
  [self startSearchingTables];
  
}

- (void)startSearchingTables {
  
  __weak typeof(self)weakSelf = self;
  [_beaconManager startMonitoring:^(NSArray *foundBeacons) {
    
    if (foundBeacons.count) {
      [weakSelf findNearestBeacon:foundBeacons];
    }
    
  }];
  
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  if (kUseStubBeacon) {
    
    OMNDecodeBeacon *decodeBeacon = [[OMNDecodeBeacon alloc] init];
    decodeBeacon.restaurantId = @"riba-ris";
    decodeBeacon.tableId = @"1005";
    _didFindTableBlock(decodeBeacon);
    
  }
  
}

- (void)findNearestBeacon:(NSArray *)beacons {
  
  if (beacons.count > 1) {
    
#warning TODO
    //TODO: handle more than one beacon
    
  }
  else {
    
    
    
  }
  [_beaconManager stopMonitoring];
  
  [self determineDeviceFaceUpPosition];
  return;
  
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
  
  
  [OMNDecodeBeacon decodeBeacons:@[nearestBeacon] success:^(NSArray *decodeBeacons) {
    
    OMNDecodeBeacon *decodeBeacon = [decodeBeacons firstObject];
    if (_didFindTableBlock) {
      _didFindTableBlock(decodeBeacon);
    }
    NSLog(@"decodeBeacons>%@", decodeBeacons);
    
  } failure:^(NSError *error) {
    
    NSLog(@"error>%@", error);
    
  }];
  
  NSLog(@"%@", nearestBeacon);
  
}

- (void)determineDeviceFaceUpPosition {
  
  OMNTablePositionVC *tablePositionVC = [[OMNTablePositionVC alloc] init];
  tablePositionVC.delegate = self;
  [self presentViewController:[[UINavigationController alloc] initWithRootViewController:tablePositionVC] animated:YES completion:nil];
  
}

#pragma mark - OMNTablePositionVCDelegate

- (void)tablePositionVCDidPlaceOnTable:(OMNTablePositionVC *)tablePositionVC {

  __weak typeof(self)weakSelf = self;
  [self dismissViewControllerAnimated:YES completion:^{
    [weakSelf startSearchingTables];
  }];
  
}

- (void)tablePositionVCDidCancel:(OMNTablePositionVC *)tablePositionVC {
  
  _didFindTableBlock(nil);
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
