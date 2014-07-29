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
#import "OMNCircleRootVC.h"
#import "OMNDecodeBeaconManager.h"
#import "OMNScanQRCodeVC.h"
#import "UIImage+omn_helper.h"

@interface OMNSearchBeaconVC ()
<OMNBeaconSearchManagerDelegate,
OMNTablePositionVCDelegate,
OMNScanQRCodeVCDelegate>

@end

@implementation OMNSearchBeaconVC {
  OMNBeaconSearchManager *_beaconSearchManager;
  OMNSearchBeaconVCBlock _didFindBlock;
  dispatch_block_t _cancelBlock;

}

- (void)dealloc {
  [self stopBeaconManager:NO];
}

- (instancetype)initWithBlock:(OMNSearchBeaconVCBlock)block cancelBlock:(dispatch_block_t)cancelBlock {
  self = [super initWithTitle:nil buttons:nil];
  if (self) {
    
    _estimateSearchDuration = 10.0;
    _didFindBlock = block;
    _cancelBlock = cancelBlock;
    
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.backgroundView.image = _backgroundImage;

  [self.navigationItem setHidesBackButton:YES animated:NO];
  if (_cancelBlock) {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Отмена", nil) style:UIBarButtonItemStylePlain target:self action:@selector(cancelTap)];
    UIButton *button = [[UIButton alloc] init];
    [button setImage:[UIImage imageNamed:@"cross_icon_white"] forState:UIControlStateNormal];
    [button sizeToFit];
    [button addTarget:self action:@selector(cancelTap) forControlEvents:UIControlEventTouchUpInside];
    button.center = CGPointMake(CGRectGetWidth(self.view.frame)/2.0f, 50.0f);
    [self.view addSubview:button];

  }
  
  _loaderView = [[OMNLoaderView alloc] initWithInnerFrame:self.circleButton.frame];
  [self.view addSubview:_loaderView];
  
}

- (void)showHelperButtons {
  UIButton *add = [[UIButton alloc] init];
  [add setTitle:NSLocalizedString(@"qr code", nil) forState:UIControlStateNormal];
  [add sizeToFit];
  add.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
  add.center = CGPointMake(50, 30);
  [add setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
  [add addTarget:self action:@selector(requestQRCode) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:add];
  
  UIButton *add1 = [[UIButton alloc] init];
  [add1 setTitle:NSLocalizedString(@"stub beacon", nil) forState:UIControlStateNormal];
  [add1 sizeToFit];
  add1.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
  [add1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
  add1.center = CGPointMake(50, 60);
  [add1 addTarget:self action:@selector(useStubBeacon) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:add1];
  
  add1 = [[UIButton alloc] init];
  [add1 setTitle:NSLocalizedString(@"startSearchingBeacon", nil) forState:UIControlStateNormal];
  [add1 sizeToFit];
  add1.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
  [add1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
  add1.center = CGPointMake(50, 90);
  [add1 addTarget:self action:@selector(startSearchingBeacon) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:add1];
  
  add1 = [[UIButton alloc] init];
  [add1 setTitle:NSLocalizedString(@"didFailOmnom", nil) forState:UIControlStateNormal];
  [add1 sizeToFit];
  add1.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
  [add1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
  add1.center = CGPointMake(50, 120);
  [add1 addTarget:self action:@selector(didFailOmnom) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:add1];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.navigationController setNavigationBarHidden:YES animated:animated];

}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  if (nil == _beaconSearchManager) {
    
    _beaconSearchManager = [[OMNBeaconSearchManager alloc] init];
    _beaconSearchManager.delegate = self;
    dispatch_async(dispatch_get_main_queue(), ^{
      [self startSearchingBeacon];
    });
    
  }
  
}

- (void)setLogo:(UIImage *)logo withColor:(UIColor *)color completion:(dispatch_block_t)completionBlock {
  
  UIImage *coloredCircleImage = [[UIImage imageNamed:@"circle_bg"] omn_tintWithColor:color];
  UIImageView *circleIV = [[UIImageView alloc] initWithFrame:self.circleButton.bounds];
  circleIV.contentMode = UIViewContentModeCenter;
  circleIV.alpha = 0.0f;
  circleIV.image = coloredCircleImage;
  [self.circleButton addSubview:circleIV];
  
  UIImageView *currentLogoIV = [[UIImageView alloc] initWithFrame:self.circleButton.bounds];
  currentLogoIV.contentMode = UIViewContentModeCenter;
  currentLogoIV.image = [self.circleButton imageForState:UIControlStateNormal];
  [self.circleButton addSubview:currentLogoIV];
  [self.circleButton setImage:nil forState:UIControlStateNormal];
  
  UIImageView *nextLogoIV = [[UIImageView alloc] initWithFrame:self.circleButton.bounds];
  nextLogoIV.contentMode = UIViewContentModeCenter;
  nextLogoIV.image = logo;
  nextLogoIV.alpha = 0.0f;
  [self.circleButton addSubview:nextLogoIV];
  
  NSTimeInterval duration = 0.5;
  
  [UIView animateWithDuration:duration animations:^{

    currentLogoIV.alpha = 0.0f;
    nextLogoIV.alpha = 1.0f;
    
  } completion:^(BOOL finished) {
    
    [self.circleButton setImage:logo forState:UIControlStateNormal];
    [currentLogoIV removeFromSuperview];
    
    [UIView animateWithDuration:duration animations:^{
      
      circleIV.alpha = 1.0f;
      
    } completion:^(BOOL finished) {
      
      [self.circleButton setBackgroundImage:coloredCircleImage forState:UIControlStateNormal];
      [circleIV removeFromSuperview];
      [nextLogoIV removeFromSuperview];
      if (completionBlock) {
        completionBlock();
      }
    }];
    
  }];
  
}

- (void)finishLoading:(dispatch_block_t)complitionBlock {
  [_loaderView completeAnimation:complitionBlock];
}

- (void)useStubBeacon {
#warning useStubBeacon
  OMNDecodeBeacon *decodeBeacon = [[OMNDecodeBeacon alloc] init];
  decodeBeacon.uuid = @"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0+1+1";
  decodeBeacon.tableId = @"table-1-at-riba-ris";
  decodeBeacon.restaurantId = @"riba-ris";
  _didFindBlock(self, decodeBeacon);
  
}

- (void)decodeBeacon:(OMNBeacon *)beacon {
  __weak typeof(self)weakSelf = self;
  [[OMNDecodeBeaconManager manager] decodeBeacons:@[beacon] success:^(NSArray *decodeBeacons) {
    
    [weakSelf didFindBeacon:[decodeBeacons firstObject]];
    
  } failure:^(NSError *error) {
    
    [weakSelf didFailOmnom];
    
  }];
}

- (void)didFindBeacon:(OMNDecodeBeacon *)decodeBeacon {
  
  [self stopBeaconManager:YES];
  _didFindBlock(self, decodeBeacon);
  
}

- (void)cancelTap {
  _cancelBlock();
}

- (void)startSearchingBeacon {
  
  [_loaderView startAnimating:_estimateSearchDuration];
  self.label.text = @"";
  [self.circleButton setImage:self.circleIcon forState:UIControlStateNormal];
  _beaconSearchManager.delegate = self;
  [_beaconSearchManager startSearching];
  
}

- (void)stopBeaconManager:(BOOL)didFind {
  [_beaconSearchManager stop:didFind];
  _beaconSearchManager.delegate = nil;
}

- (void)requestQRCode {

  OMNCircleRootVC *scanQRCodeInfoVC = [[OMNCircleRootVC alloc] initWithTitle:NSLocalizedString(@"Отсканируйте QR-код", nil) buttons:@[NSLocalizedString(@"Сканировать", nil)]];
  scanQRCodeInfoVC.circleBackground = [self.circleButton backgroundImageForState:UIControlStateNormal];
  scanQRCodeInfoVC.circleIcon = [UIImage imageNamed:@"scan_qr_icon"];
  
  scanQRCodeInfoVC.actionBlock = ^{
    
    OMNScanQRCodeVC *scanQRCodeVC = [[OMNScanQRCodeVC alloc] init];
    scanQRCodeVC.delegate = self;
    [self.navigationController pushViewController:scanQRCodeVC animated:YES];
    
  };
  [self.navigationController pushViewController:scanQRCodeInfoVC animated:YES];
  
}

#pragma mark - OMNScanQRCodeVCDelegate

- (void)scanQRCodeVC:(OMNScanQRCodeVC *)scanQRCodeVC didScanCode:(NSString *)code {
  
#warning scanQRCodeVC logic
  [scanQRCodeVC stopScanning];
  [self useStubBeacon];
  
}

- (void)scanQRCodeVCDidCancel:(OMNScanQRCodeVC *)scanQRCodeVC {
  
  [scanQRCodeVC stopScanning];
  [self.navigationController popToViewController:self animated:YES];
  
}

- (void)didFailOmnom {
  
  OMNCircleRootVC *turnOnBluetoothVC = [[OMNCircleRootVC alloc] initWithTitle:NSLocalizedString(@"Нет связи с заведением.\nОфициант в помощь", nil) buttons:@[NSLocalizedString(@"Проверить еще", nil)]];
  turnOnBluetoothVC.circleIcon = [UIImage imageNamed:@"no_omnom_connection_icon"];
  turnOnBluetoothVC.circleBackground = [self.circleButton backgroundImageForState:UIControlStateNormal];
  turnOnBluetoothVC.actionBlock = ^{

    [self startSearchingBeacon];
    
  };
  [self.navigationController pushViewController:turnOnBluetoothVC animated:YES];
  
}

#pragma mark - OMNBeaconSearchManagerDelegate

- (void)beaconSearchManager:(OMNBeaconSearchManager *)beaconSearchManager didFindBeacon:(OMNBeacon *)beacon {
  
  [self decodeBeacon:beacon];
  
}

- (void)beaconSearchManagerDidStop:(OMNBeaconSearchManager *)beaconSearchManager found:(BOOL)foundBeacon {
  
  if (NO == foundBeacon) {
    [_loaderView stop];
  }
  
}

- (void)beaconSearchManager:(OMNBeaconSearchManager *)beaconSearchManager didChangeState:(OMNSearchManagerState)state {
 
  switch (state) {
    case kSearchManagerInternetFound: {
      
      [_loaderView setProgress:0.2];
      
    } break;
    case kSearchManagerStartSearchingBeacons: {
      
      [_loaderView setProgress:0.6];
      NSLog(@"Определение вашего столика");
      
      //in case there ask permission state
      [self.navigationController popToViewController:self animated:YES];
      
    } break;
    case kSearchManagerNotFoundBeacons: {
      
      OMNCircleRootVC *turnOnBluetoothVC = [[OMNCircleRootVC alloc] initWithTitle:NSLocalizedString(@"Omnom не видит не одного стола", nil) buttons:@[NSLocalizedString(@"Проверить еще", nil)]];
      turnOnBluetoothVC.circleBackground = [self.circleButton backgroundImageForState:UIControlStateNormal];
      turnOnBluetoothVC.circleIcon = [UIImage imageNamed:@"not_found_beacon_icon"];
      turnOnBluetoothVC.actionBlock = ^{
        [self.navigationController popToViewController:self animated:YES];
        [self startSearchingBeacon];
      };
      [self.navigationController pushViewController:turnOnBluetoothVC animated:YES];
      
    } break;
      
    case kSearchManagerRequestTurnBLEOn: {
      
      NSLog(@"Включите BLE");
      OMNCircleRootVC *turnOnBluetoothVC = [[OMNCircleRootVC alloc] initWithTitle:NSLocalizedString(@"Включите BLE", nil) buttons:@[]];
      turnOnBluetoothVC.circleBackground = [self.circleButton backgroundImageForState:UIControlStateNormal];
      turnOnBluetoothVC.circleIcon = [UIImage imageNamed:@"bluetooth_icon"];
      [self.navigationController pushViewController:turnOnBluetoothVC animated:YES];
      
    } break;
    case kSearchManagerBLEUnsupported: {
      
      [self requestQRCode];
      
    } break;
    case kSearchManagerBLEDidOn: {
      
      [_loaderView setProgress:0.2];
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
      
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        OMNAskNavigationPermissionsVC *askNavigationPermissionsVC = [[OMNAskNavigationPermissionsVC alloc] init];
        [self.navigationController pushViewController:askNavigationPermissionsVC animated:YES];
        
      });
      
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
  
  OMNCircleRootVC *noInternetVC = [[OMNCircleRootVC alloc] initWithTitle:text buttons:@[NSLocalizedString(@"Проверить еще", nil)]];
  __weak typeof(self)weakSelf = self;
  noInternetVC.circleBackground = [self.circleButton backgroundImageForState:UIControlStateNormal];
  noInternetVC.circleIcon = [UIImage imageNamed:@"no_internet_icon"];
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
  
  OMNTablePositionVC *tablePositionVC = [[OMNTablePositionVC alloc] initWithTitle:NSLocalizedString(@"Положите телефон в центр стола", nil) buttons:@[]];
  tablePositionVC.circleBackground = [self.circleButton backgroundImageForState:UIControlStateNormal];
  tablePositionVC.circleIcon = [UIImage imageNamed:@"place_device_on_table_icon"];
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
