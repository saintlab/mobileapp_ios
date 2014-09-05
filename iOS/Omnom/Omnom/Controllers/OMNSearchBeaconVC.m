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
#import "OMNVisitorManager.h"
#import "OMNScanQRCodeVC.h"
#import "OMNTurnOnBluetoothVC.h"
#import "UINavigationController+omn_replace.h"
#import "OMNDemoRestaurantVC.h"
#import "OMNDenyCLPermissionVC.h"

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
    _cancelButton.center = CGPointMake(CGRectGetWidth(self.view.frame)/2.0f, 42.0f);
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
  if (self.visitor) {
    
    [self.loaderView startAnimating:self.estimateAnimationDuration];
    dispatch_async(dispatch_get_main_queue(), ^{
      [weakSelf didFindVisitor:weakSelf.visitor];
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

- (void)decodeBeacon:(OMNBeacon *)beacon {
  __weak typeof(self)weakSelf = self;
  [[OMNVisitorManager manager] decodeBeacon:beacon success:^(OMNVisitor *visitor) {
    
    [weakSelf didFindVisitor:visitor];
    
  } failure:^(NSError *error) {
    
    [weakSelf didFailOmnom];
    
  }];
}

- (void)didFindVisitor:(OMNVisitor *)visitor {
  
  [self stopBeaconManager:YES];
  if (visitor) {
    _didFindBlock(self, visitor);
  }
  else {
    [self beaconsNotFound];
  }
  
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
  
  [self.loaderView stop];
  
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
  
  OMNScanQRCodeVC *scanQRCodeVC = [[OMNScanQRCodeVC alloc] init];
  scanQRCodeVC.backgroundImage = self.backgroundImage;
  __weak typeof(self)weakSelf = self;
  scanQRCodeVC.buttonInfo =
  @[
    [OMNBarButtonInfo infoWithTitle:nil image:nil block:nil],
    [OMNBarButtonInfo infoWithTitle:NSLocalizedString(@"Демо-режим", nil) image:[UIImage imageNamed:@"demo_mode_icon_small"] block:^{
      [weakSelf demoModeTap];
    }]
    ];
  scanQRCodeVC.delegate = self;
  [self.navigationController pushViewController:scanQRCodeVC animated:YES];
  
}

#pragma mark - OMNScanQRCodeVCDelegate

- (void)scanQRCodeVC:(OMNScanQRCodeVC *)scanQRCodeVC didScanCode:(NSString *)code {

  [scanQRCodeVC stopScanning];
  __weak typeof(self)weakSelf = self;
  [self.loaderView startAnimating:10.0f];
  [self.navigationController omn_popToViewController:self animated:YES completion:^{
    
    [[OMNVisitorManager manager] decodeQRCode:code success:^(OMNVisitor *visitor) {
      
      [weakSelf finishLoading:^{
        [weakSelf didFindVisitor:visitor];
      }];
      
    } failure:^(NSError *error) {
      [weakSelf didFailQRCode];
    }];
    
  }];
  
}

- (void)didFailQRCode {
  
  OMNCircleRootVC *didFailOmnomVC = [[OMNCircleRootVC alloc] initWithParent:self];
  didFailOmnomVC.faded = YES;
  didFailOmnomVC.text = NSLocalizedString(@"Неверный QR-код,\nнайдите Omnom", nil);
  didFailOmnomVC.circleIcon = [UIImage imageNamed:@"unlinked_icon_big"];
  __weak typeof(self)weakSelf = self;
  didFailOmnomVC.buttonInfo =
  @[
    [OMNBarButtonInfo infoWithTitle:NSLocalizedString(@"Проверить еще", nil) image:[UIImage imageNamed:@"repeat_icon_small"] block:^{
      [weakSelf startSearchingBeacon];
    }]
    ];
  [self.navigationController pushViewController:didFailOmnomVC animated:YES];
  
}

- (void)scanQRCodeVCDidCancel:(OMNScanQRCodeVC *)scanQRCodeVC {
  
  [scanQRCodeVC stopScanning];
  [self.navigationController omn_popToViewController:self animated:YES completion:^{
    
  }];
  
}

- (void)didFailOmnom {
  
  OMNCircleRootVC *didFailOmnomVC = [[OMNCircleRootVC alloc] initWithParent:self];
  didFailOmnomVC.faded = YES;
  didFailOmnomVC.text = NSLocalizedString(@"Нет связи с заведением.\nОфициант в помощь", nil);
  didFailOmnomVC.circleIcon = [UIImage imageNamed:@"unlinked_icon_big"];
  
  __weak typeof(self)weakSelf = self;
  didFailOmnomVC.buttonInfo =
  @[
    [OMNBarButtonInfo infoWithTitle:NSLocalizedString(@"Проверить еще", nil) image:[UIImage imageNamed:@"repeat_icon_small"] block:^{
      
      [weakSelf startSearchingBeacon];
      
    }]
    ];

  [self.navigationController pushViewController:didFailOmnomVC animated:YES];
  
}

#pragma mark - OMNBeaconSearchManagerDelegate

- (void)beaconSearchManager:(OMNBeaconSearchManager *)beaconSearchManager didFindBeacon:(OMNBeacon *)beacon {
  
  [self decodeBeacon:beacon];
  
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
      
      [self beaconsNotFound];
      
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
//      [self.navigationController popToViewController:self animated:YES];
      
    } break;
      
    case kSearchManagerRequestCoreLocationRestrictedPermission: {
      
      NSLog(@"kSearchManagerRequestCoreLocationRestrictedPermission");
      OMNCLPermissionsHelpVC *navigationPermissionsHelpVC = [[OMNCLPermissionsHelpVC alloc] init];
      [self.navigationController pushViewController:navigationPermissionsHelpVC animated:YES];
      
    } break;
    case kSearchManagerRequestCoreLocationDeniedPermission: {
      
      NSLog(@"kSearchManagerRequestCoreLocationDeniedPermission");
      __weak typeof(self)weakSelf = self;
      [self showDenyLocationPermissionDescriptionWithBlock:^{

        OMNCLPermissionsHelpVC *navigationPermissionsHelpVC = [[OMNCLPermissionsHelpVC alloc] init];
        [weakSelf.navigationController pushViewController:navigationPermissionsHelpVC animated:YES];
        
      }];
      
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

- (void)showDenyLocationPermissionDescriptionWithBlock:(dispatch_block_t)block {
  
  OMNDenyCLPermissionVC *denyCLPermissionVC = [[OMNDenyCLPermissionVC alloc] initWithParent:self];
  denyCLPermissionVC.buttonInfo =
  @[
    [OMNBarButtonInfo infoWithTitle:NSLocalizedString(@"Включить", nil) image:nil block:block]
    ];
  [self.navigationController pushViewController:denyCLPermissionVC animated:YES];
  
}

- (void)showNoInternetErrorWithText:(NSString *)text {
  
  OMNCircleRootVC *noInternetVC = [[OMNCircleRootVC alloc] initWithParent:self];
  noInternetVC.text = text;
  noInternetVC.faded = YES;
  noInternetVC.circleIcon = [UIImage imageNamed:@"unlinked_icon_big"];
  __weak typeof(self)weakSelf = self;
  noInternetVC.buttonInfo =
  @[
    [OMNBarButtonInfo infoWithTitle:NSLocalizedString(@"Проверить еще", nil) image:[UIImage imageNamed:@"repeat_icon_small"] block:^{
      
      [[OMNOperationManager sharedManager] getReachableState:^(OMNReachableState reachableState) {
        
        if (kOMNReachableStateIsReachable == reachableState) {
          
          [weakSelf startSearchingBeacon];
          
        }
        
      }];
      
    }]
    ];

  [self.navigationController pushViewController:noInternetVC animated:YES];
  
}

- (void)beaconsNotFound {
  
  OMNCircleRootVC *notFoundBeaconVC = [[OMNCircleRootVC alloc] initWithParent:self];
  notFoundBeaconVC.faded = YES;
  notFoundBeaconVC.text = NSLocalizedString(@"Телефон в центре стола?\nЗаведение подключено\nк Omnom?", nil);
  notFoundBeaconVC.circleIcon = [UIImage imageNamed:@"weak_signal_table_icon_big"];
  __weak typeof(self)weakSelf = self;
  notFoundBeaconVC.buttonInfo =
  @[
    [OMNBarButtonInfo infoWithTitle:NSLocalizedString(@"Повторить", nil) image:[UIImage imageNamed:@"repeat_icon_small"] block:^{
      [weakSelf startSearchingBeacon];
    }],
    [OMNBarButtonInfo infoWithTitle:NSLocalizedString(@"Демо-режим", nil) image:[UIImage imageNamed:@"demo_mode_icon_small"] block:^{
      [weakSelf demoModeTap];
    }]
    ];
  [self.navigationController pushViewController:notFoundBeaconVC animated:YES];
  
}

- (void)determineFaceUpPosition {
  
  OMNTablePositionVC *tablePositionVC = [[OMNTablePositionVC alloc] initWithParent:self];
  tablePositionVC.text = NSLocalizedString(@"Слабый сигнал.\nПоложите телефон\nв центр стола,\nпожалуйста.", nil);
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
  
  [self didFailOmnom];
  
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
