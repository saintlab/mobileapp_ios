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
#import "OMNAskCLPermissionsVC.h"
#import "OMNTablePositionVC.h"
#import "OMNCLPermissionsHelpVC.h"
#import "OMNCircleRootVC.h"
#import "OMNDecodeBeaconManager.h"
#import "OMNScanQRCodeVC.h"
#import "OMNTurnOnBluetoothVC.h"
#import "UINavigationController+omn_replace.h"
#import "OMNDemoRestaurantVC.h"

@interface OMNSearchBeaconVC ()
<OMNBeaconSearchManagerDelegate,
OMNTablePositionVCDelegate,
OMNScanQRCodeVCDelegate,
OMNDemoRestaurantVCDelegate>

@end

@implementation OMNSearchBeaconVC {
  OMNBeaconSearchManager *_beaconSearchManager;
  OMNSearchBeaconVCBlock _didFindBlock;
  dispatch_block_t _cancelBlock;
  UIButton *_cancelButton;
}

- (void)dealloc {
  [self stopBeaconManager:NO];
}

- (instancetype)initWithParent:(OMNCircleRootVC *)parent completion:(OMNSearchBeaconVCBlock)completionBlock cancelBlock:(dispatch_block_t)cancelBlock {
  self = [super initWithParent:parent];
  if (self) {
    
    _didFindBlock = completionBlock;
    _cancelBlock = cancelBlock;
    
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self.navigationItem setHidesBackButton:YES animated:NO];
  if (_cancelBlock) {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Отмена", nil) style:UIBarButtonItemStylePlain target:self action:@selector(cancelTap)];
    _cancelButton = [[UIButton alloc] init];
    [_cancelButton setImage:[UIImage imageNamed:@"cross_icon_white"] forState:UIControlStateNormal];
    [_cancelButton sizeToFit];
    [_cancelButton addTarget:self action:@selector(cancelTap) forControlEvents:UIControlEventTouchUpInside];
    _cancelButton.center = CGPointMake(CGRectGetWidth(self.view.frame)/2.0f, 50.0f);
    [self.view addSubview:_cancelButton];
  }
  
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.navigationController setNavigationBarHidden:YES animated:animated];
  _cancelButton.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  _cancelButton.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  __weak typeof(self)weakSelf = self;
  if (self.uuid) {
    
    [self.loaderView startAnimating:self.estimateAnimationDuration];
    dispatch_async(dispatch_get_main_queue(), ^{
      [weakSelf decodeUUID:weakSelf.uuid];
    });
    
  }
  else if (nil == _beaconSearchManager) {
    
    _beaconSearchManager = [[OMNBeaconSearchManager alloc] init];
    _beaconSearchManager.delegate = self;
    dispatch_async(dispatch_get_main_queue(), ^{
      [weakSelf startSearchingBeacon];
    });
    
  }
  
}

- (void)decodeUUID:(NSString *)uuid {
  __weak typeof(self)weakSelf = self;
  [[OMNDecodeBeaconManager manager] decodeBeacons:@[@{@"uuid" : uuid}] success:^(NSArray *decodeBeacons) {
    
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

- (void)demoModeTap {
  
  OMNDemoRestaurantVC *demoRestaurantVC = [[OMNDemoRestaurantVC alloc] initWithParent:self];
  demoRestaurantVC.delegate = self;
  [self.navigationController pushViewController:demoRestaurantVC animated:YES];
  
}

- (void)startSearchingBeacon {
  
  [self.navigationController omn_popToViewController:self animated:YES completion:^{
    
    [self.loaderView startAnimating:self.estimateAnimationDuration];
    self.label.text = @"";
    [self.circleButton setImage:self.circleIcon forState:UIControlStateNormal];
    _beaconSearchManager.delegate = self;
    [_beaconSearchManager startSearching];

  }];
  
}

- (void)stopBeaconManager:(BOOL)didFind {
  [_beaconSearchManager stop:didFind];
  _beaconSearchManager.delegate = nil;
}

- (void)requestQRCode {
  
  OMNCircleRootVC *scanQRCodeInfoVC = [[OMNCircleRootVC alloc] initWithParent:self];
  scanQRCodeInfoVC.faded = YES;
  scanQRCodeInfoVC.text = NSLocalizedString(@"Отсканируйте QR-код", nil);
  scanQRCodeInfoVC.circleIcon = [UIImage imageNamed:@"scan_qr_icon"];
  scanQRCodeInfoVC.buttonInfo =
  @[
    @{
      @"title" : NSLocalizedString(@"Сканировать", nil),
      @"block" : ^{
        OMNScanQRCodeVC *scanQRCodeVC = [[OMNScanQRCodeVC alloc] init];
        scanQRCodeVC.delegate = self;
        [self.navigationController pushViewController:scanQRCodeVC animated:YES];
      },
      }
    ];

  [self.navigationController pushViewController:scanQRCodeInfoVC animated:YES];
  
}

#pragma mark - OMNScanQRCodeVCDelegate

- (void)scanQRCodeVC:(OMNScanQRCodeVC *)scanQRCodeVC didScanCode:(NSString *)code {
  
#warning scanQRCodeVC
  [scanQRCodeVC stopScanning];
  [self.navigationController popToViewController:self animated:YES];
  
}

- (void)scanQRCodeVCDidCancel:(OMNScanQRCodeVC *)scanQRCodeVC {
  
  [scanQRCodeVC stopScanning];
  [self.navigationController popToViewController:self animated:YES];
  
}

- (void)didFailOmnom {
  
  OMNCircleRootVC *didFailOmnomVC = [[OMNCircleRootVC alloc] initWithParent:self];
  didFailOmnomVC.faded = YES;
  didFailOmnomVC.text = NSLocalizedString(@"Нет связи с заведением.\nОфициант в помощь", nil);
  didFailOmnomVC.circleIcon = [UIImage imageNamed:@"unlinked_icon_big"];
  
  __weak typeof(self)weakSelf = self;
  didFailOmnomVC.buttonInfo =
  @[
    @{
      @"title" : NSLocalizedString(@"Проверить еще", nil),
      @"image" : [UIImage imageNamed:@"repeat_icon_small"],
      @"block" : ^{
        [weakSelf startSearchingBeacon];
      },
      }
    ];

  [self.navigationController pushViewController:didFailOmnomVC animated:YES];
  
}

#pragma mark - OMNBeaconSearchManagerDelegate

- (void)beaconSearchManager:(OMNBeaconSearchManager *)beaconSearchManager didFindUUID:(NSString *)uuid {
  
  [self decodeUUID:uuid];
  
}

- (void)beaconSearchManagerDidStop:(OMNBeaconSearchManager *)beaconSearchManager found:(BOOL)foundBeacon {
  
  if (NO == foundBeacon) {
    [self.loaderView stop];
  }
  
}

- (void)beaconSearchManager:(OMNBeaconSearchManager *)beaconSearchManager didChangeState:(OMNSearchManagerState)state {
  
  switch (state) {
    case kSearchManagerInternetFound: {
      
      [self.loaderView setProgress:0.2];
      
    } break;
    case kSearchManagerStartSearchingBeacons: {
      
      NSLog(@"Определение вашего столика");
      [self.loaderView setProgress:0.5f];
      
    } break;
    case kSearchManagerNotFoundBeacons: {
      
      OMNCircleRootVC *notFoundBeaconVC = [[OMNCircleRootVC alloc] initWithParent:self];
      notFoundBeaconVC.faded = YES;
      notFoundBeaconVC.text = NSLocalizedString(@"Столик не найден. Возможно, вы вне заведения", nil);
      notFoundBeaconVC.circleIcon = [UIImage imageNamed:@"sad_table_icon_big"];
      __weak typeof(self)weakSelf = self;
      notFoundBeaconVC.buttonInfo =
      @[
        @{
          @"title" : NSLocalizedString(@"Повторить", nil),
          @"image" : [UIImage imageNamed:@"repeat_icon_small"],
          @"block" : ^{
            [weakSelf startSearchingBeacon];
          },
          },
        @{
          @"title" : NSLocalizedString(@"Демо-режим", nil),
          @"image" : [UIImage imageNamed:@"demo_mode_icon_small"],
          @"block" : ^{
            [weakSelf demoModeTap];
          },
          }
        ];
      [self.navigationController pushViewController:notFoundBeaconVC animated:YES];
      
    } break;
      
    case kSearchManagerRequestTurnBLEOn: {
      
      OMNTurnOnBluetoothVC *turnOnBluetoothVC = [[OMNTurnOnBluetoothVC alloc] initWithParent:self];
      [self.navigationController pushViewController:turnOnBluetoothVC animated:YES];
      
    } break;
    case kSearchManagerBLEUnsupported: {
      
      [self requestQRCode];
      
    } break;
    case kSearchManagerBLEDidOn: {
      
      [self.loaderView setProgress:0.2];
      //dismiss turn BLE on controller
      [self.navigationController popToViewController:self animated:YES];
      
    } break;
      
    case kSearchManagerRequestCoreLocationRestrictedPermission: {
      
      NSLog(@"kSearchManagerRequestCoreLocationRestrictedPermission");
      OMNCLPermissionsHelpVC *navigationPermissionsHelpVC = [[OMNCLPermissionsHelpVC alloc] init];
      [self.navigationController pushViewController:navigationPermissionsHelpVC animated:YES];
      
    } break;
    case kSearchManagerRequestCoreLocationDeniedPermission: {
      
      NSLog(@"kSearchManagerRequestCoreLocationDeniedPermission");
      OMNCLPermissionsHelpVC *navigationPermissionsHelpVC = [[OMNCLPermissionsHelpVC alloc] init];
      [self.navigationController pushViewController:navigationPermissionsHelpVC animated:YES];
      
    } break;
    case kSearchManagerRequestDeviceFaceUpPosition: {
      
      NSLog(@"determineFaceUpPosition");
      [self determineFaceUpPosition];
      
    } break;
    case kSearchManagerRequestLocationManagerPermission: {
      
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        OMNAskCLPermissionsVC *askNavigationPermissionsVC = [[OMNAskCLPermissionsVC alloc] initWithParent:self];
        [self.navigationController pushViewController:askNavigationPermissionsVC animated:YES];
        
      });
      
    } break;
      
    case kSearchManagerInternetUnavaliable: {
      
      [self showNoInternetErrorWithText:NSLocalizedString(@"Нет соединения с интернетом.", nil)];
      
    } break;
    case kSearchManagerOmnomServerUnavaliable: {
      
      [self showNoInternetErrorWithText:NSLocalizedString(@"нет доступа к серверам omnom.", nil)];
      
    } break;
    case kSearchManagerRequestReload: {
      
      [self startSearchingBeacon];
      
    } break;
  }
  
}

- (void)showNoInternetErrorWithText:(NSString *)text {
  
  OMNCircleRootVC *noInternetVC = [[OMNCircleRootVC alloc] initWithParent:self];
  noInternetVC.text = text;
  noInternetVC.faded = YES;
  noInternetVC.circleIcon = [UIImage imageNamed:@"unlinked_icon_big"];
  __weak typeof(self)weakSelf = self;
  noInternetVC.buttonInfo =
  @[
    @{
      @"title" : NSLocalizedString(@"Проверить еще", nil),
      @"image" : [UIImage imageNamed:@"repeat_icon_small"],
      @"block" : ^{
        
        [[OMNOperationManager sharedManager] getReachableState:^(OMNReachableState reachableState) {
          
          if (kOMNReachableStateIsReachable == reachableState) {
            
            [weakSelf startSearchingBeacon];
            
          }
          
        }];
        
      },
      }
    ];

  [self.navigationController pushViewController:noInternetVC animated:YES];
  
}

- (void)determineFaceUpPosition {
  
  OMNTablePositionVC *tablePositionVC = [[OMNTablePositionVC alloc] initWithParent:self];
  tablePositionVC.text = NSLocalizedString(@"Слабый сигнал. Положите телефон в центр стола, пожалуйста.", nil);
  tablePositionVC.circleIcon = [UIImage imageNamed:@"weak_signal_table_icon_big"];
  tablePositionVC.tablePositionDelegate = self;
  [self.navigationController pushViewController:tablePositionVC animated:YES];
  
}

#pragma mark - OMNTablePositionVCDelegate

- (void)tablePositionVCDidPlaceOnTable:(OMNTablePositionVC *)tablePositionVC {
  
  [self startSearchingBeacon];
  
}

- (void)tablePositionVCDidCancel:(OMNTablePositionVC *)tablePositionVC {
  
  [self startSearchingBeacon];
  
}

#pragma mark - OMNDemoRestaurantVCDelegate

- (void)demoRestaurantVCDidFail:(OMNDemoRestaurantVC *)demoRestaurantVC {
  __weak typeof(self)weakSelf = self;
  [self.navigationController omn_popToViewController:self animated:YES completion:^{
    
    [weakSelf didFailOmnom];
    
  }];
  
}

- (void)demoRestaurantVCDidFinish:(OMNDemoRestaurantVC *)demoRestaurantVC {
  __weak typeof(self)weakSelf = self;
  [self.navigationController omn_popToViewController:self animated:YES completion:^{
    
    [weakSelf startSearchingBeacon];
    
  }];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

@end
