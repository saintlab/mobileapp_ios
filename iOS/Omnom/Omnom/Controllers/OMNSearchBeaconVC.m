//
//  OMNSearchBeaconVC.m
//  omnom
//
//  Created by tea on 21.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNSearchBeaconVC.h"
#import "OMNOperationManager.h"
#import "OMNBeaconSearchManager.h"
#import "OMNAskNavigationPermissionsVC.h"
#import "OMNTablePositionVC.h"
#import "OMNNavigationPermissionsHelpVC.h"
#import "OMNSearchBeaconRootVC.h"

@interface OMNSearchBeaconVC ()
<OMNBeaconSearchManagerDelegate,
OMNTablePositionVCDelegate>

@end

@implementation OMNSearchBeaconVC {
  OMNBeaconSearchManager *_beaconSearchManager;
  
}

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title buttons:(NSArray *)buttons {
  self = [super initWithImage:image title:title buttons:buttons];
  if (self) {
    _beaconSearchManager = [[OMNBeaconSearchManager alloc] init];
    _beaconSearchManager.delegate = self;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  [self startSearchingBeacon];
  
}

- (void)startSearchingBeacon {
  [_beaconSearchManager startSearching];
}

- (void)requestQRCode {
  NSLog(@"requestQRCode");
}

#pragma mark - OMNBeaconSearchManagerDelegate

- (void)beaconSearchManager:(OMNBeaconSearchManager *)beaconSearchManager didFindBeacon:(OMNBeacon *)beacon {
  NSLog(@"didFindBeacon>>%@", beacon);
}

- (void)beaconSearchManagerOmnomUnavaliableState:(OMNBeaconSearchManager *)beaconSearchManager {
  
  [self showNoInternetErrorWithText:NSLocalizedString(@"нет доступа к серверам omnom.", nil)];
  
}

- (void)beaconSearchManagerInternetUnavaliableState:(OMNBeaconSearchManager *)beaconSearchManager {
  
  [self showNoInternetErrorWithText:NSLocalizedString(@"Нет соединения с интернетом.", nil)];
  
}

- (void)showNoInternetErrorWithText:(NSString *)text {
  
  OMNSearchBeaconRootVC *noInternetVC = [[OMNSearchBeaconRootVC alloc] initWithImage:[UIImage imageNamed:@"no_internet_icon"] title:text buttons:@[]];
  [self.navigationController pushViewController:noInternetVC animated:YES];
  
}

#pragma mark - OMNNoInternetVCDelegate

//- (void)noInternetVCDidConnect:(OMNNoInternetVC *)noInternetVC {
//  [self.navigationController popToViewController:self animated:YES];
//  [self startSearchingBeacon];
//}

- (void)beaconSearchManagerDidStartSearching:(OMNBeaconSearchManager *)beaconSearchManager {
  
  //in case there ask permission state
  [self.navigationController popToViewController:self animated:YES];
  
}

- (void)beaconSearchManagerDidRequestLocationManagerPermission:(OMNBeaconSearchManager *)beaconSearchManager {
  
  OMNAskNavigationPermissionsVC *askNavigationPermissionsVC = [[OMNAskNavigationPermissionsVC alloc] init];
  [self.navigationController pushViewController:askNavigationPermissionsVC animated:YES];
  
}

- (void)beaconSearchManagerDidRequestCoreLocationDeniedPermission:(OMNBeaconSearchManager *)beaconSearchManager {
  NSLog(@"beaconSearchManagerDidRequestCoreLocationDeniedPermission");
  OMNNavigationPermissionsHelpVC *navigationPermissionsHelpVC = [[OMNNavigationPermissionsHelpVC alloc] init];
  [self.navigationController pushViewController:navigationPermissionsHelpVC animated:YES];
  
}

- (void)beaconSearchManagerDidRequestCoreLocationRestrictedPermission:(OMNBeaconSearchManager *)beaconSearchManager {
  NSLog(@"beaconSearchManagerDidRequestCoreLocationRestrictedPermission");
}

- (void)beaconSearchManagerBLEDidOn:(OMNBeaconSearchManager *)beaconSearchManager {
  
  [self.navigationController popToViewController:self animated:YES];
  
}

- (void)beaconSearchManagerBLEUnsupported:(OMNBeaconSearchManager *)beaconSearchManager {
  
  [self requestQRCode];
  
}

- (void)beaconSearchManagerDidRequestTurnBLEOn:(OMNBeaconSearchManager *)beaconSearchManager {
  OMNSearchBeaconRootVC *turnOnBluetoothVC = [[OMNSearchBeaconRootVC alloc] initWithImage:[UIImage imageNamed:@"bluetooth_icon"] title:@"Включите BLE" buttons:@[]];
  [self.navigationController pushViewController:turnOnBluetoothVC animated:YES];
  
}

- (void)beaconSearchManagerDidRequestDeviceFaceUpPosition:(OMNBeaconSearchManager *)beaconSearchManager {
  
  OMNTablePositionVC *tablePositionVC = [[OMNTablePositionVC alloc] init];
  tablePositionVC.delegate = self;
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
  
  [self.navigationController popToViewController:self animated:YES];
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
