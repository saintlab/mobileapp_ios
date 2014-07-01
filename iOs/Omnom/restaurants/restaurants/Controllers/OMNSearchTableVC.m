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
  
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Stub table", nil) style:UIBarButtonItemStylePlain target:self action:@selector(useStubBeacon)];
  
  _beaconManager = [[OMNBeaconsManager alloc] init];
  [self startSearchingTables];
  
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)useStubBeacon {
  
  OMNBeacon *beacon = [[OMNBeacon alloc] init];
  beacon.UUIDString = @"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0";
  beacon.major = @(1);
  beacon.minor = @(3);
  
  [self decodeBeacons:@[beacon]];

}

- (void)startSearchingTables {
  
  __weak typeof(self)weakSelf = self;
  [_beaconManager startMonitoringNearestBeacons:^(NSArray *foundBeacons) {

    [weakSelf checkNearestBeacons:foundBeacons];
    
  } status:^(BeaconsManagerStatus status) {
    
    [weakSelf processStatus:status];
    
  }];
  
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

- (void)processStatus:(BeaconsManagerStatus)status {
  
  switch (status) {
    case kBeaconsManagerStatusDenied:
    case kBeaconsManagerStatusRestricted: {
      
      [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Нет прав на использование геопозиции", nil) message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
      
    } break;
    case kBeaconsManagerStatusBluetoothOff: {
      
      [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Включите блютус", nil) message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
      
    } break;
    case kBeaconsManagerStatusBluetoothUnsupported: {

#if TARGET_IPHONE_SIMULATOR
#else
      [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Данное устройство не поддерживает bluetooth", nil) message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
#endif
      
    } break;
    case kBeaconsManagerStatusBluetoothUnauthorized: {
      
      [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Нет прав на использование bluetooth", nil) message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
      
    } break;
    case kBeaconsManagerStatusEnabled:
    case kBeaconsManagerStatusNotDetermined: {
      //do nothing
    } break;
  }
  
}

- (void)decodeBeacons:(NSArray *)beaconsToDecode {
  
  _searchLabel.text = NSLocalizedString(@"Получаем информацию о столе...", nil);
  
  [OMNDecodeBeacon decodeBeacons:beaconsToDecode success:^(NSArray *decodeBeacons) {
    
    OMNDecodeBeacon *decodeBeacon = [decodeBeacons firstObject];
    
    if (decodeBeacon) {

      if (_didFindTableBlock) {
        _didFindTableBlock(decodeBeacon);
      }
      
    }
    else {
      
      _searchLabel.text = @"Нет информации о столе";
      [self startSearchingTables];
      
    }
    
    NSLog(@"decodeBeacons>%@", decodeBeacons);
    
  } failure:^(NSError *error) {
    
    _searchLabel.text = @"Server error";
//    [weakSelf decodeBeacons:beaconsToDecode];
    NSLog(@"error>%@", error);
    
  }];
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
