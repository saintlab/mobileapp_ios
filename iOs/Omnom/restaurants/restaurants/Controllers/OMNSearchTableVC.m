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
  __weak IBOutlet UILabel *_searchLabel;
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
  [_beaconManager startMonitoringNearestBeacons:^(NSArray *foundBeacons) {

    [weakSelf checkNearestBeacons:foundBeacons];
    
  }];
  
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  if (kUseStubBeacon) {
    
    OMNDecodeBeacon *decodeBeacon = [[OMNDecodeBeacon alloc] init];
    decodeBeacon.restaurantId = @"riba-ris";
//    decodeBeacon.tableId = @"4100";
    decodeBeacon.tableId = @"1005";
    _didFindTableBlock(decodeBeacon);
    
  }
  
}

- (void)checkNearestBeacons:(NSArray *)nearestBeacons {

  if (0 == nearestBeacons.count) {
    return;
  }
  NSLog(@"nearestBeacons>%@", nearestBeacons);
  
  [_beaconManager stopMonitoring];
  
  if (nearestBeacons.count > 1) {
    
    [self determineDeviceFaceUpPosition];
    
  }
  else {
    
    [self decodeBeacons:nearestBeacons];
    
  }
  
}

- (void)determineDeviceFaceUpPosition {
  
  OMNTablePositionVC *tablePositionVC = [[OMNTablePositionVC alloc] init];
  tablePositionVC.delegate = self;
  [self presentViewController:[[UINavigationController alloc] initWithRootViewController:tablePositionVC] animated:YES completion:nil];
  
}

- (void)decodeBeacons:(NSArray *)beaconsToDecode {
  
  _searchLabel.text = NSLocalizedString(@"Получаем информацию о столе...", nil);
  
  __weak typeof(self)weakSelf = self;
  [OMNDecodeBeacon decodeBeacons:beaconsToDecode success:^(NSArray *decodeBeacons) {
    
    OMNDecodeBeacon *decodeBeacon = [decodeBeacons firstObject];
    if (_didFindTableBlock) {
      _didFindTableBlock(decodeBeacon);
    }
    NSLog(@"decodeBeacons>%@", decodeBeacons);
    
  } failure:^(NSError *error) {
    
    _searchLabel.text = @"Server error";
//    [weakSelf decodeBeacons:beaconsToDecode];
    NSLog(@"error>%@", error);
    
  }];
  
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
