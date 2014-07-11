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
#import "OMNAskNavigationPermissionsVC.h"
#import "OMNBluetoothManager.h"
#import "OMNScanQRCodeVC.h"
#import "OMNTurnOnBluetoothVC.h"
#import "OMNDecodeBeaconManager.h"

@interface OMNSearchTableVC ()
<OMNTablePositionVCDelegate,
OMNAskNavigationPermissionsVCDelegate,
OMNScanQRCodeVCDelegate>

@end

@implementation OMNSearchTableVC {
  OMNBeaconsManager *_beaconManager;
  OMNSearchTableVCBlock _didFindTableBlock;
  dispatch_block_t _cancelBlock;
  
  __weak IBOutlet UILabel *_searchLabel;
  
}

- (instancetype)initWithBlock:(OMNSearchTableVCBlock)block cancelBlock:(dispatch_block_t)cancelBlock {
  self = [super initWithNibName:@"OMNSearchTableVC" bundle:nil];
  if (self) {
    _cancelBlock = cancelBlock;
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
  
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Закрыть", nil) style:UIBarButtonItemStylePlain target:self action:@selector(cancelTap)];
  
  UIBarButtonItem *stubBeaconButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Stub table", nil) style:UIBarButtonItemStylePlain target:self action:@selector(useStubBeacon)];
  UIBarButtonItem *qrcodeButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"QR code", nil) style:UIBarButtonItemStylePlain target:self action:@selector(useQRCode)];
  self.navigationItem.rightBarButtonItems = @[stubBeaconButton, qrcodeButton];
  
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  self.navigationController.navigationBar.shadowImage = nil;
  [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"white_pixel"] forBarMetrics:UIBarMetricsDefault];
  [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
#if TARGET_IPHONE_SIMULATOR
  
  [self checkBluetoothState];
  
#else

  if (kCLAuthorizationStatusNotDetermined == [CLLocationManager authorizationStatus]) {
    [self processNotDeterminedLocationManagerSituation];
  }
  else {
    [self checkBluetoothState];
  }

#endif
  
}

- (void)processNotDeterminedLocationManagerSituation {
  
  OMNAskNavigationPermissionsVC *askNavigationPermissionsVC = [[OMNAskNavigationPermissionsVC alloc] init];
  askNavigationPermissionsVC.delegate = self;
  [self.navigationController pushViewController:askNavigationPermissionsVC animated:YES];
  
}

- (void)checkBluetoothState {
  
  __weak typeof(self)weakSelf = self;

  [[OMNBluetoothManager manager] getBluetoothState:^(CBCentralManagerState state) {
    
    switch (state) {
      case CBCentralManagerStatePoweredOn: {
        
        [weakSelf startSearchingTables];
        
      } break;
      case CBCentralManagerStateUnsupported: {
        
        [weakSelf useQRCode];
        [[OMNBluetoothManager manager] stop];
        
      } break;
      case CBCentralManagerStatePoweredOff: {
        
        [weakSelf processBLEOffSituation];
        
      } break;
      case CBCentralManagerStateUnauthorized: {
        
        [weakSelf processBLEUnauthorizedSituation];
        
      } break;
      case CBCentralManagerStateResetting:
      case CBCentralManagerStateUnknown: {
        //do noithing
      } break;
    }
    
  }];
  
}

- (void)useQRCode {
  
  OMNScanQRCodeVC *scanQRCodeVC = [[OMNScanQRCodeVC alloc] init];
  scanQRCodeVC.delegate = self;
  [self.navigationController pushViewController:scanQRCodeVC animated:YES];
  
}

#pragma mark - OMNScanQRCodeVCDelegate

- (void)scanQRCodeVC:(OMNScanQRCodeVC *)scanQRCodeVC didScanCode:(NSString *)code {
  
  [scanQRCodeVC stopScanning];
  [self useStubBeacon];
  
}

- (void)scanQRCodeVCDidCancel:(OMNScanQRCodeVC *)scanQRCodeVC {
  
  [scanQRCodeVC stopScanning];
  [self.navigationController popToViewController:self animated:YES];
  
}

- (void)processBLEOffSituation {
  
  [_beaconManager stopMonitoring];
  
  OMNTurnOnBluetoothVC *turnOnBluetoothVC = [[OMNTurnOnBluetoothVC alloc] init];
  [self.navigationController pushViewController:turnOnBluetoothVC animated:YES];
  
}

- (void)processBLEUnauthorizedSituation {
  //do nothing at this moment
}

- (void)cancelTap {
  
  if (_cancelBlock) {
    _cancelBlock();
  }
  
}

- (void)useStubBeacon {
  
  OMNBeacon *beacon = [[OMNBeacon alloc] init];
  beacon.UUIDString = @"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0";
  beacon.major = @(1);
  beacon.minor = @(3);
  
  [self decodeBeacons:@[beacon]];

}

- (void)startSearchingTables {
  
  [self.navigationController popToViewController:self animated:YES];
  
  if (nil == _beaconManager) {
    _beaconManager = [[OMNBeaconsManager alloc] init];
  }
  
  if (_beaconManager.ragingMonitorEnabled) {
    return;
  }
  
  __weak typeof(self)weakSelf = self;
  [_beaconManager startMonitoringNearestBeacons:^(NSArray *foundBeacons) {

    [weakSelf checkNearestBeacons:foundBeacons];
    
  } status:^(CLAuthorizationStatus status) {
    
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
  
  _cancelBlock();
  
}

- (void)processStatus:(CLAuthorizationStatus)status {
  
  switch (status) {
    case kCLAuthorizationStatusAuthorized: {
      
    } break;
    case kCLAuthorizationStatusDenied: {
      
      [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Нет прав на использование геопозиции", nil) message:@"kCLAuthorizationStatusDenied" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
      
    } break;
    case kCLAuthorizationStatusNotDetermined: {
      
    } break;
    case kCLAuthorizationStatusRestricted: {

      [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Нет прав на использование геопозиции", nil) message:@"kCLAuthorizationStatusRestricted" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
      
    } break;
    
  }
  
}

#pragma mark - OMNAskNavigationPermissionsVCDelegate

- (void)askNavigationPermissionsVCDidGrantPermission:(OMNAskNavigationPermissionsVC *)askNavigationPermissionsVC {
  [self.navigationController popToViewController:self animated:YES];
  [self startSearchingTables];
  
}

- (void)decodeBeacons:(NSArray *)beaconsToDecode {
  
  _searchLabel.text = NSLocalizedString(@"Получаем информацию о столе...", nil);
  
  if (kUseStubData) {
    OMNDecodeBeacon *decodeBeacon = [[OMNDecodeBeacon alloc] init];
    decodeBeacon.uuid = @"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0+1+3";
    decodeBeacon.tableId = @"3";
    decodeBeacon.restaurantId = @"riba-ris";
    _didFindTableBlock(decodeBeacon);
    return;
  }
  
  [[OMNDecodeBeaconManager manager] decodeBeacons:beaconsToDecode success:^(NSArray *decodeBeacons) {
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
