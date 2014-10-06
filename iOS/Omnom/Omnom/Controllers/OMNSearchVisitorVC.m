//
//  OMNSearchBeaconVC.m
//  omnom
//
//  Created by tea on 21.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNSearchVisitorVC.h"
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
#import "OMNAnalitics.h"
#import "OMNUserInfoVC.h"

@interface OMNSearchVisitorVC ()
<OMNBeaconSearchManagerDelegate,
OMNTablePositionVCDelegate,
OMNScanQRCodeVCDelegate,
OMNDemoRestaurantVCDelegate,
OMNUserInfoVCDelegate>

@end

@implementation OMNSearchVisitorVC {
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

- (UIBarButtonItem *)userInfoButton {
  
  UIBarButtonItem *userInfoButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"user_settings_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(showUserProfile)];
  return userInfoButton;
  
}

- (void)showUserProfile {
  
  OMNUserInfoVC *userInfoVC = [[OMNUserInfoVC alloc] initWithVisitor:self.visitor];
  userInfoVC.delegate = self;
  UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:userInfoVC];
  [self.navigationController presentViewController:navigationController animated:YES completion:nil];
  
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self.navigationItem setHidesBackButton:YES animated:NO];
  if (_cancelBlock) {
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
  _cancelButton.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  _cancelButton.hidden = YES;
}

- (void)finishLoading:(dispatch_block_t)completionBlock {
  
  [UIView animateWithDuration:0.3 animations:^{
    _cancelButton.alpha = 0.0f;
  } completion:^(BOOL finished) {
    _cancelButton.hidden = YES;
    _cancelButton.alpha = 1.0f;
  }];
  
  [super finishLoading:completionBlock];
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
  else if (self.qr) {
    
    dispatch_async(dispatch_get_main_queue(), ^{
      [weakSelf scanQRCodeVC:nil didScanCode:weakSelf.qr];
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
  [self stopBeaconManager:YES];
  if (_cancelBlock) {
    _cancelBlock();
  }
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
  scanQRCodeVC.navigationItem.rightBarButtonItem = [self userInfoButton];
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
      
      [weakSelf didFindVisitor:visitor];
      
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
  
  [[OMNAnalitics analitics] logEvent:@"no_table" parametrs:nil];

  __weak typeof(self)weakSelf = self;
  [self showRetryMessageWithBlock:^{
    
    [weakSelf startSearchingBeacon];
    
  }];
  
}

#pragma mark - OMNBeaconSearchManagerDelegate

- (void)beaconSearchManager:(OMNBeaconSearchManager *)beaconSearchManager didFindBeacons:(NSArray *)beacons {
  
  if (1 == beacons.count) {
    OMNBeacon *beacon = [beacons firstObject];
    [self decodeBeacon:beacon];
  }
  else {
    
    NSMutableDictionary *beaconsRSSIData = [NSMutableDictionary dictionaryWithCapacity:beacons.count];
    [beacons enumerateObjectsUsingBlock:^(OMNBeacon *beacon, NSUInteger idx, BOOL *stop) {
      
      beaconsRSSIData[beacon.key] = @(beacon.averageRSSI);
      
    }];
    
    [[OMNAnalitics analitics] logEvent:@"low_signal" parametrs:@{@"beacons" : beaconsRSSIData}];
    [self determineFaceUpPosition];
    
  }
  
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
      
      [[OMNAnalitics analitics] logEvent:@"bluetooth_turned_off" parametrs:nil];
      OMNTurnOnBluetoothVC *turnOnBluetoothVC = [[OMNTurnOnBluetoothVC alloc] initWithParent:self];
      [self.navigationController pushViewController:turnOnBluetoothVC animated:YES];
      
    } break;
    case kSearchManagerBLEUnsupported: {
      
      [self requestQRCode];
      
    } break;
    case kSearchManagerBLEDidOn: {
      
      [self.loaderView setProgress:0.2];
      
    } break;
      
    case kSearchManagerRequestCoreLocationRestrictedPermission: {
      
      NSLog(@"kSearchManagerRequestCoreLocationRestrictedPermission");
      [[OMNAnalitics analitics] logEvent:@"no_geolocation_permission" parametrs:nil];
      OMNCLPermissionsHelpVC *navigationPermissionsHelpVC = [[OMNCLPermissionsHelpVC alloc] init];
      [self.navigationController pushViewController:navigationPermissionsHelpVC animated:YES];
      
    } break;
    case kSearchManagerRequestCoreLocationDeniedPermission: {
      
      NSLog(@"kSearchManagerRequestCoreLocationDeniedPermission");
      [[OMNAnalitics analitics] logEvent:@"no_geolocation_permission" parametrs:nil];
      __weak typeof(self)weakSelf = self;
      [self showDenyLocationPermissionDescriptionWithBlock:^{

        OMNCLPermissionsHelpVC *navigationPermissionsHelpVC = [[OMNCLPermissionsHelpVC alloc] init];
        [weakSelf.navigationController pushViewController:navigationPermissionsHelpVC animated:YES];
        
      }];
      
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
      
      [[OMNAnalitics analitics] logEvent:@"no_server_connection" parametrs:nil];
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
  notFoundBeaconVC.navigationItem.rightBarButtonItem = [self userInfoButton];

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
  __weak typeof(self)weakSelf = self;
  tablePositionVC.buttonInfo =
  @[
    [OMNBarButtonInfo infoWithTitle:NSLocalizedString(@"Повторить", nil) image:[UIImage imageNamed:@"repeat_icon_small"] block:^{
      [weakSelf startSearchingBeacon];
    }]
    ];
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

#pragma mark - OMNUserInfoVCDelegate

- (void)userInfoVCDidFinish:(OMNUserInfoVC *)userInfoVC {
  
  [self.navigationController dismissViewControllerAnimated:YES completion:nil];
  
}

@end
