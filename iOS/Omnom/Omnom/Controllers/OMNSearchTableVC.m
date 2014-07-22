//
//  OMNSearchTableVC.m
//  restaurants
//
//  Created by tea on 27.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNSearchTableVC.h"
#import "OMNBeacon.h"
#import "OMNTablePositionVC.h"
#import "OMNAskNavigationPermissionsVC.h"
#import "OMNScanQRCodeVC.h"
#import "OMNTurnOnBluetoothVC.h"
#import "OMNDecodeBeaconManager.h"

#import "OMNBeaconSearchManager.h"

@interface OMNSearchTableVC ()
<OMNTablePositionVCDelegate,
OMNScanQRCodeVCDelegate,
OMNBeaconSearchManagerDelegate>

@end

@implementation OMNSearchTableVC {

  OMNSearchTableVCBlock _didFindTableBlock;
  dispatch_block_t _cancelBlock;
  
  OMNBeaconSearchManager *_beaconSearchManager;
  
  __weak IBOutlet UILabel *_searchLabel;
  
}

- (instancetype)initWithBlock:(OMNSearchTableVCBlock)block cancelBlock:(dispatch_block_t)cancelBlock {
  self = [super initWithNibName:@"OMNSearchTableVC" bundle:nil];
  if (self) {
    NSAssert(block != nil, @"provide did find block");
    NSAssert(cancelBlock != nil, @"provide cancel block");
    _didFindTableBlock = block;
    _cancelBlock = cancelBlock;
  }
  return self;
}

- (void)dealloc {
  [_beaconSearchManager stop];
  _beaconSearchManager = nil;
}

- (void)viewDidLoad {
  
  [super viewDidLoad];
  
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Закрыть", nil) style:UIBarButtonItemStylePlain target:self action:@selector(cancelTap)];
  
  UIBarButtonItem *stubBeaconButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Stub table", nil) style:UIBarButtonItemStylePlain target:self action:@selector(useStubBeacon)];
  UIBarButtonItem *qrcodeButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"QR code", nil) style:UIBarButtonItemStylePlain target:self action:@selector(requestQRCode)];
  self.navigationItem.rightBarButtonItems = @[stubBeaconButton, qrcodeButton];
  
  _beaconSearchManager = [[OMNBeaconSearchManager alloc] init];
  _beaconSearchManager.delegate = self;
  
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  self.navigationController.navigationBar.shadowImage = nil;
  [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"white_pixel"] forBarMetrics:UIBarMetricsDefault];
  [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  [self startSearchingBeacon];
  
}

- (void)startSearchingBeacon {
  [_beaconSearchManager startSearching];
}

- (void)requestQRCode {
  
  OMNScanQRCodeVC *scanQRCodeVC = [[OMNScanQRCodeVC alloc] init];
  scanQRCodeVC.delegate = self;
  [self.navigationController pushViewController:scanQRCodeVC animated:YES];
  
}

#pragma mark - OMNScanQRCodeVCDelegate

- (void)scanQRCodeVC:(OMNScanQRCodeVC *)scanQRCodeVC didScanCode:(NSString *)code {
  
  [scanQRCodeVC stopScanning];
#warning scanQRCodeVC logic
  [self useStubBeacon];
  
}

- (void)scanQRCodeVCDidCancel:(OMNScanQRCodeVC *)scanQRCodeVC {
  
  [scanQRCodeVC stopScanning];
  [self.navigationController popToViewController:self animated:YES];
  
}

#pragma mark - OMNBeaconSearchManagerDelegate

- (void)beaconSearchManager:(OMNBeaconSearchManager *)beaconSearchManager didChangeState:(OMNSearchManagerState)state {
  
}

- (void)beaconSearchManager:(OMNBeaconSearchManager *)beaconSearchManager didFindBeacon:(OMNBeacon *)beacon {
  
  [self decodeBeacon:beacon];
  
}

- (void)beaconSearchManagerServerUnavaliableState:(OMNBeaconSearchManager *)beaconSearchManager {
  [[[UIAlertView alloc] initWithTitle:@"экран с ошибкой соединения" message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
}

- (void)beaconSearchManagerDidRequestLocationManagerPermission:(OMNBeaconSearchManager *)beaconSearchManager {
  
  OMNAskNavigationPermissionsVC *askNavigationPermissionsVC = [[OMNAskNavigationPermissionsVC alloc] init];
  [self.navigationController pushViewController:askNavigationPermissionsVC animated:YES];
  
}

- (void)beaconSearchManagerBLEUnsupported:(OMNBeaconSearchManager *)beaconSearchManager {
 
  [self requestQRCode];
  
}

- (void)beaconSearchManagerDidRequestTurnBLEOn:(OMNBeaconSearchManager *)beaconSearchManager {

  OMNTurnOnBluetoothVC *turnOnBluetoothVC = [[OMNTurnOnBluetoothVC alloc] init];
  [self.navigationController pushViewController:turnOnBluetoothVC animated:YES];

}

- (void)beaconSearchManagerDidRequestDeviceFaceUpPosition:(OMNBeaconSearchManager *)beaconSearchManager {

  OMNTablePositionVC *tablePositionVC = [[OMNTablePositionVC alloc] init];
  tablePositionVC.tablePositionDelegate = self;
  [self presentViewController:[[UINavigationController alloc] initWithRootViewController:tablePositionVC] animated:YES completion:nil];
  
}

#pragma mark - OMNTablePositionVCDelegate

- (void)tablePositionVCDidPlaceOnTable:(OMNTablePositionVC *)tablePositionVC {
  
  __weak typeof(self)weakSelf = self;
  [self dismissViewControllerAnimated:YES completion:^{
    [weakSelf startSearchingBeacon];
  }];
  
}

- (void)tablePositionVCDidCancel:(OMNTablePositionVC *)tablePositionVC {
  
  [self cancelTap];
  
}

- (void)beaconSearchManagerDidRequestCoreLocationDeniedPermission:(OMNBeaconSearchManager *)beaconSearchManager {
  
  [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Нет прав на использование геопозиции", nil) message:@"kCLAuthorizationStatusDenied" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
  
}

- (void)beaconSearchManagerDidRequestCoreLocationRestrictedPermission:(OMNBeaconSearchManager *)beaconSearchManager {
  
  [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Нет прав на использование геопозиции", nil) message:@"kCLAuthorizationStatusRestricted" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
  
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
  beacon.minor = @(1);
  
  [self decodeBeacon:beacon];

}

- (void)decodeBeacon:(OMNBeacon *)beaconToDecode {
  
  if (nil == beaconToDecode) {
    [self startSearchingBeacon];
    return;
  }
  
  _searchLabel.text = NSLocalizedString(@"Получаем информацию о столе...", nil);
  
  if (kUseStubData) {
    OMNDecodeBeacon *decodeBeacon = [[OMNDecodeBeacon alloc] init];
    decodeBeacon.uuid = @"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0+1+3";
    decodeBeacon.tableId = @"3";
    decodeBeacon.restaurantId = @"riba-ris";
    _didFindTableBlock(decodeBeacon);
    return;
  }
  
  __weak typeof(self)weakSelf = self;
  [[OMNDecodeBeaconManager manager] decodeBeacons:@[beaconToDecode] success:^(NSArray *decodeBeacons) {
    
    OMNDecodeBeacon *decodeBeacon = [decodeBeacons firstObject];
    
    if (decodeBeacon) {

      _didFindTableBlock(decodeBeacon);
      
    }
    else {
      
      _searchLabel.text = @"Нет информации о столе";
      [weakSelf startSearchingBeacon];
      
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
