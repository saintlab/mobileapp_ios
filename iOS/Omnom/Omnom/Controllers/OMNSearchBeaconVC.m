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
#import "OMNDecodeBeaconManager.h"

@interface OMNSearchBeaconVC ()
<OMNBeaconSearchManagerDelegate,
OMNTablePositionVCDelegate>

@end

@implementation OMNSearchBeaconVC {
  OMNBeaconSearchManager *_beaconSearchManager;
  OMNSearchBeaconVCBlock _didFindBlock;
  dispatch_block_t _cancelBlock;
  UIProgressView *_progress;
}

- (void)dealloc {
  [self stopBeaconManager];
}

- (instancetype)initWithBlock:(OMNSearchBeaconVCBlock)block cancelBlock:(dispatch_block_t)cancelBlock {
  self = [super initWithImage:nil title:nil buttons:nil];
  if (self) {
    _didFindBlock = block;
    _cancelBlock = cancelBlock;
    
    _beaconSearchManager = [[OMNBeaconSearchManager alloc] init];
    _beaconSearchManager.delegate = self;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self.navigationItem setHidesBackButton:YES animated:NO];
  if (_cancelBlock) {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Отмена", nil) style:UIBarButtonItemStylePlain target:self action:@selector(cancelTap)];
  }
  
  _progress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
  _progress.center = CGPointMake(CGRectGetMidX(self.view.frame), 50.0f);
  [self.view addSubview:_progress];
  
  
  [self startSearchingBeacon];
}

- (void)cancelTap {
  _cancelBlock();
}

- (void)startSearchingBeacon {
  
  NSLog(@"Подключение...");
  [_progress setProgress:0.0f animated:YES];
  self.label.text = NSLocalizedString(@"Подключение...", nil);
  [self.circleButton setImage:nil forState:UIControlStateNormal];

  [_beaconSearchManager startSearching];
}

- (void)stopBeaconManager {
  [_beaconSearchManager stop];
  _beaconSearchManager.delegate = nil;
  _beaconSearchManager = nil;
}

- (void)requestQRCode {
  NSLog(@"requestQRCode");
}

- (void)didFailOmnom {
  
  OMNSearchBeaconRootVC *turnOnBluetoothVC = [[OMNSearchBeaconRootVC alloc] initWithImage:[UIImage imageNamed:@"no_omnom_connection_icon"] title:NSLocalizedString(@"Нет связи с заведением.\nОфициант в помощь", nil) buttons:@[NSLocalizedString(@"Проверить еще", nil)]];
  turnOnBluetoothVC.actionBlock = ^{
    [self.navigationController popToViewController:self animated:YES];
    [self startSearchingBeacon];
  };
  [self.navigationController pushViewController:turnOnBluetoothVC animated:YES];
  
}

#pragma mark - OMNBeaconSearchManagerDelegate

- (void)beaconSearchManager:(OMNBeaconSearchManager *)beaconSearchManager didFindBeacon:(OMNBeacon *)beacon {
  
  NSLog(@"didFindBeacon>>%@", beacon);
  [_progress setProgress:0.5f animated:YES];
  
  __weak typeof(self)weakSelf = self;
  [[OMNDecodeBeaconManager manager] decodeBeacons:@[beacon] success:^(NSArray *decodeBeacons) {
    
    [weakSelf didFindBeacon:[decodeBeacons firstObject]];
    
  } failure:^(NSError *error) {
    
    [weakSelf didFailOmnom];
    
  }];
  
}

- (void)didFindBeacon:(OMNDecodeBeacon *)decodeBeacon {

  [self stopBeaconManager];
  [_progress setProgress:0.75f];
  _didFindBlock(decodeBeacon);
}

- (void)beaconSearchManager:(OMNBeaconSearchManager *)beaconSearchManager didChangeState:(OMNSearchManagerState)state {
 
  switch (state) {
    case kSearchManagerStartSearchingBeacons: {
      
      NSLog(@"Определение вашего столика");
      [_progress setProgress:0.25f animated:YES];
      self.label.text = NSLocalizedString(@"Определение вашего столика", nil);
      [self.circleButton setImage:nil forState:UIControlStateNormal];
      //in case there ask permission state
      [self.navigationController popToViewController:self animated:YES];
      
    } break;
    case kSearchManagerNotFoundBeacons: {
      
      OMNSearchBeaconRootVC *turnOnBluetoothVC = [[OMNSearchBeaconRootVC alloc] initWithImage:[UIImage imageNamed:@"not_found_beacon_icon"] title:NSLocalizedString(@"Omnom не видит не одного стола", nil) buttons:@[NSLocalizedString(@"Проверить еще", nil)]];
      turnOnBluetoothVC.actionBlock = ^{
        [self.navigationController popToViewController:self animated:YES];
        [self startSearchingBeacon];
      };
      [self.navigationController pushViewController:turnOnBluetoothVC animated:YES];
      
    } break;
      
    case kSearchManagerRequestTurnBLEOn: {
      
      NSLog(@"Включите BLE");
      self.label.text = NSLocalizedString(@"Включите BLE", nil);
      [self.circleButton setImage:[UIImage imageNamed:@"bluetooth_icon"] forState:UIControlStateNormal];
      
    } break;
    case kSearchManagerBLEUnsupported: {
      
      [self requestQRCode];
      
    } break;
    case kSearchManagerBLEDidOn: {
      
      //dismiss turn BLE on controller
      [self.navigationController popToViewController:self animated:YES];
      
    } break;
      
    case kSearchManagerRequestCoreLocationRestrictedPermission: {
      
      NSLog(@"kSearchManagerRequestCoreLocationRestrictedPermission");
      OMNNavigationPermissionsHelpVC *navigationPermissionsHelpVC = [[OMNNavigationPermissionsHelpVC alloc] init];
      [self.navigationController pushViewController:navigationPermissionsHelpVC animated:YES];
      
    } break;
    case kSearchManagerRequestCoreLocationDeniedPermission: {
      
      NSLog(@"kSearchManagerRequestCoreLocationDeniedPermission");
      OMNNavigationPermissionsHelpVC *navigationPermissionsHelpVC = [[OMNNavigationPermissionsHelpVC alloc] init];
      [self.navigationController pushViewController:navigationPermissionsHelpVC animated:YES];
      
    } break;
    case kSearchManagerRequestDeviceFaceUpPosition: {
      
      NSLog(@"determineFaceUpPOsition");
      [self determineFaceUpPOsition];
      
    } break;
    case kSearchManagerRequestLocationManagerPermission: {
      
      OMNAskNavigationPermissionsVC *askNavigationPermissionsVC = [[OMNAskNavigationPermissionsVC alloc] init];
      [self.navigationController pushViewController:askNavigationPermissionsVC animated:YES];
      
    } break;
      
    case kSearchManagerInternetUnavaliable: {
      
      [self showNoInternetErrorWithText:NSLocalizedString(@"Нет соединения с интернетом.", nil)];
      
    } break;
    case kSearchManagerOmnomServerUnavaliable: {
      
      [self showNoInternetErrorWithText:NSLocalizedString(@"нет доступа к серверам omnom.", nil)];
      
    } break;
  }
  
}

- (void)showNoInternetErrorWithText:(NSString *)text {
  
  OMNSearchBeaconRootVC *noInternetVC = [[OMNSearchBeaconRootVC alloc] initWithImage:[UIImage imageNamed:@"no_internet_icon"] title:text buttons:@[NSLocalizedString(@"Проверить еще", nil)]];
  __weak typeof(self)weakSelf = self;
  noInternetVC.actionBlock = ^{
    
    [[OMNOperationManager sharedManager] getReachableState:^(OMNReachableState reachableState) {
      
      if (kOMNReachableStateIsReachable == reachableState) {
        [weakSelf.navigationController popToViewController:weakSelf animated:YES];
        [weakSelf startSearchingBeacon];
      }
      
    }];

  };
  [self.navigationController pushViewController:noInternetVC animated:YES];
  
}

- (void)determineFaceUpPOsition {
  
  OMNTablePositionVC *tablePositionVC = [[OMNTablePositionVC alloc] initWithImage:[UIImage imageNamed:@"place_device_on_table_icon"] title:NSLocalizedString(@"Положите телефон в центр стола", nil) buttons:@[]];
  tablePositionVC.tablePositionDelegate = self;
  [self.navigationController pushViewController:tablePositionVC animated:YES];
  
}

#pragma mark - OMNTablePositionVCDelegate

- (void)tablePositionVCDidPlaceOnTable:(OMNTablePositionVC *)tablePositionVC {
  
  [self.navigationController popToViewController:self animated:YES];
  [self startSearchingBeacon];
  
}

- (void)tablePositionVCDidCancel:(OMNTablePositionVC *)tablePositionVC {
  
  [self.navigationController popToViewController:self animated:YES];
  [self startSearchingBeacon];
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

@end
