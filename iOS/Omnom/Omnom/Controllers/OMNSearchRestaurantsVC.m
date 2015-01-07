//
//  OMNSearchBeaconVC.m
//  omnom
//
//  Created by tea on 21.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNSearchRestaurantsVC.h"
#import "OMNOperationManager.h"
#import "OMNAskCLPermissionsVC.h"
#import "OMNTablePositionVC.h"
#import "OMNCLPermissionsHelpVC.h"
#import "OMNCircleRootVC.h"
#import "OMNTurnOnBluetoothVC.h"
#import "UINavigationController+omn_replace.h"
#import "OMNDemoRestaurantVC.h"
#import "OMNDenyCLPermissionVC.h"
#import "OMNAnalitics.h"
#import "OMNUserInfoVC.h"
#import "UIBarButtonItem+omn_custom.h"
#import "OMNBeacon+omn_debug.h"
#import "OMNAuthorization.h"
#import "OMNRestaurantManager.h"
#import <OMNBeaconsSearchManager.h>

@interface OMNSearchRestaurantsVC ()
<OMNTablePositionVCDelegate,
OMNDemoRestaurantVCDelegate,
OMNUserInfoVCDelegate,
OMNBeaconsSearchManagerDelegate>

@end

@implementation OMNSearchRestaurantsVC {
  
  OMNBeaconsSearchManager *_beaconsSearchManager;
  UIButton *_cancelButton;
  
}

- (void)dealloc {
  
  [self stopBeaconManager];
  
}

- (instancetype)init {
  self = [super initWithParent:nil];
  if (self) {
  }
  return self;
}

- (UIBarButtonItem *)userInfoButton {
  
  return [UIBarButtonItem omn_barButtonWithImage:[UIImage imageNamed:@"user_settings_icon"] color:[UIColor blackColor] target:self action:@selector(showUserProfile)];
  
}

- (void)showUserProfile {
  
  OMNUserInfoVC *userInfoVC = [[OMNUserInfoVC alloc] initWithMediator:nil];
  userInfoVC.delegate = self;
  UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:userInfoVC];
  navigationController.delegate = self.navigationController.delegate;
  [self.navigationController presentViewController:navigationController animated:YES completion:nil];
  
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self.navigationItem setHidesBackButton:YES animated:NO];
  if (NO) {
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
  if (self.restaurants) {
    
    [self.loaderView startAnimating:self.estimateAnimationDuration];
    dispatch_async(dispatch_get_main_queue(), ^{
      
      [weakSelf didFindRestaurants:weakSelf.restaurants];
      
    });
    
  }
  else if (self.hashString) {
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
      
      [weakSelf processHash:weakSelf.hashString];
      
    });
    
  }
  else if (self.qr) {
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
      
      [weakSelf processQrCode:weakSelf.qr];
      
    });
    
  }
  else if (nil == _beaconsSearchManager) {
    
    _beaconsSearchManager = [[OMNBeaconsSearchManager alloc] init];
    _beaconsSearchManager.delegate = self;
    dispatch_async(dispatch_get_main_queue(), ^{
      
      [weakSelf startSearchingBeacons];
      
    });
    
  }
  
}

- (void)processHash:(NSString *)hash {
  
  [self.loaderView startAnimating:10.0f];
  __weak typeof(self)weakSelf = self;
  [OMNRestaurantManager decodeHash:hash withCompletion:^(NSArray *restaurants) {
    
    [weakSelf didFindRestaurants:restaurants];
    
  } failureBlock:^(OMNError *error) {
    
    [weakSelf beaconsNotFound];
    
  }];
  
}

- (void)processQrCode:(NSString *)code {
  
  [self.loaderView startAnimating:10.0f];
  __weak typeof(self)weakSelf = self;
  [OMNRestaurantManager decodeQR:code withCompletion:^(NSArray *restaurants) {
    
    [weakSelf didFindRestaurants:restaurants];
    
  } failureBlock:^(OMNError *error) {
    
    [weakSelf beaconsNotFound];
    
  }];
  
}

- (void)decodeBeacons:(NSArray *)beacons {
  
  __weak typeof(self)weakSelf = self;
  [OMNRestaurantManager decodeBeacons:beacons withCompletion:^(NSArray *restaurants) {
    
    [weakSelf didFindRestaurants:restaurants];
    
  } failureBlock:^(OMNError *error) {
    
    [weakSelf didFailOmnom:error];
    
  }];
  
}

- (void)didFindRestaurants:(NSArray *)restaurants {
  
  [self stopBeaconManager];
  __weak typeof(self)weakSelf = self;
  [self finishLoading:^{
  
    [weakSelf.delegate searchRestaurantsVC:weakSelf didFindRestaurants:restaurants];
    
  }];
  
}

- (void)cancelTap {
  
  [self stopBeaconManager];
  [self.delegate searchRestaurantsVCDidCancel:self];
  
}

- (void)demoModeTap {
  
  OMNDemoRestaurantVC *demoRestaurantVC = [[OMNDemoRestaurantVC alloc] initWithParent:self];
  demoRestaurantVC.delegate = self;
  [self.navigationController pushViewController:demoRestaurantVC animated:YES];
  
}

- (void)startSearchingBeacons {
  
  [self.loaderView stop];
  _beaconsSearchManager.delegate = nil;
  [_beaconsSearchManager stop];
  
  __weak typeof(self)weakSelf = self;
  [self.navigationController omn_popToViewController:self animated:YES completion:^{
    
    [weakSelf checkUserToken];
    
  }];
  
}

- (void)checkUserToken {
  
  [self.loaderView startAnimating:self.estimateAnimationDuration];
  self.label.text = @"";
  [self.circleButton setImage:self.circleIcon forState:UIControlStateNormal];

  __weak typeof(self)weakSelf = self;
  [[OMNAuthorization authorisation] checkUserWithBlock:^(OMNUser *user) {
    
    if (user) {
      
      [weakSelf startBeaconSearchManager];
      
    }
    else {
      
      [weakSelf cancelTap];
      
    }
    
  } failure:^(OMNError *error) {
    
    [weakSelf handleInternetError:error];
    
  }];
  
}

- (void)startBeaconSearchManager {
  
  [self.loaderView setProgress:0.1];
  _beaconsSearchManager.delegate = self;
  [_beaconsSearchManager startSearching];
  
}

- (void)stopBeaconManager {
  
  _beaconsSearchManager.delegate = nil;
  [_beaconsSearchManager stop];
  
}

- (void)handleInternetError:(OMNError *)error {

  switch (error.code) {
    case kOMNErrorCodeTimedOut: {
      
      [[OMNAnalitics analitics] logDebugEvent:@"no_server_connection" parametrs:nil];
      [self showNoInternetErrorWithText:NSLocalizedString(@"ERROR_NO_OMNOM_SERVER_CONNECTION", @"Помехи на линии.")
                             actionText:NSLocalizedString(@"REPEAT_NO_OMNOM_SERVER_BUTTON_TITLE", @"Давайте ещё раз.")];

    } break;
    case kOMNErrorCodeNotConnectedToInternet: {
      
      [self showNoInternetErrorWithText:NSLocalizedString(@"ERROR_NO_INTERNET_CONNECTION", @"Вы видите интернет? Мы нет.")
                             actionText:NSLocalizedString(@"REPEAT_NO_INTERNET_BUTTON_TITLE", @"Попробуйте ещё раз")];

    } break;
  }

  
}

- (void)didFailOmnom:(OMNError *)error {
  
  [[OMNAnalitics analitics] logTargetEvent:@"no_table" parametrs:nil];

  __weak typeof(self)weakSelf = self;
  [self showRetryMessageWithError:error retryBlock:^{
    
    [weakSelf startSearchingBeacons];
    
  } cancelBlock:^{
    
    [weakSelf beaconsNotFound];
    
  }];
  
}

#pragma mark - OMNBeaconsSearchManagerDelegate

- (void)beaconSearchManager:(OMNBeaconsSearchManager *)beaconsSearchManager didFindBeacons:(NSArray *)beacons {
  
  NSDictionary *debugData = [OMNBeacon debugDataFromBeacons:beacons];
  [[OMNAnalitics analitics] logDebugEvent:@"DID_FIND_BEACONS" parametrs:debugData];
  [beaconsSearchManager stop];
  [self decodeBeacons:beacons];
  
}

- (void)beaconSearchManagerDidFail:(OMNBeaconsSearchManager *)beaconsSearchManager {
  
  [self.loaderView stop];
  
}

- (void)beaconSearchManager:(OMNBeaconsSearchManager *)beaconsSearchManager didChangeState:(OMNSearchManagerState)state {
  
  switch (state) {
    case kSearchManagerStartSearchingBeacons: {
      
      [self.loaderView setProgress:0.3];
      
    } break;
    case kSearchManagerNotFoundBeacons: {
      
      [self beaconsNotFound];
      
    } break;
    case kSearchManagerRequestReload: {
      
      [self startSearchingBeacons];
      
    } break;
  }
  
}

- (void)beaconSearchManager:(OMNBeaconsSearchManager *)beaconsSearchManager didDetermineBLEState:(OMNBLESearchManagerState)bleState {
  
  switch (bleState) {
    case kBLESearchManagerBLEDidOn: {
      
      [self.loaderView setProgress:0.25];
      
    } break;
    case kBLESearchManagerBLEUnsupported: {
      
      [self beaconsNotFound];
      
    } break;
    case kBLESearchManagerRequestTurnBLEOn: {
      
      [[OMNAnalitics analitics] logTargetEvent:@"bluetooth_turned_off" parametrs:nil];
      OMNTurnOnBluetoothVC *turnOnBluetoothVC = [[OMNTurnOnBluetoothVC alloc] initWithParent:self];
      [self.navigationController pushViewController:turnOnBluetoothVC animated:YES];
      
    } break;
  }
  
}

- (void)beaconSearchManager:(OMNBeaconsSearchManager *)beaconsSearchManager didDetermineCLState:(OMNCLSearchManagerState)clState {
  
  __weak typeof(self)weakSelf = self;
  switch (clState) {
    case kCLSearchManagerRequestRestrictedPermission:
    case kCLSearchManagerRequestDeniedPermission: {
      
      [[OMNAnalitics analitics] logDebugEvent:@"no_geolocation_permission" parametrs:nil];
      [self showDenyLocationPermissionDescriptionWithBlock:^{
        
        OMNCLPermissionsHelpVC *navigationPermissionsHelpVC = [[OMNCLPermissionsHelpVC alloc] init];
        [weakSelf.navigationController pushViewController:navigationPermissionsHelpVC animated:YES];
        
      }];
      
    } break;
    case kCLSearchManagerRequestPermission: {
      
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        OMNAskCLPermissionsVC *askNavigationPermissionsVC = [[OMNAskCLPermissionsVC alloc] initWithParent:weakSelf];
        [weakSelf.navigationController pushViewController:askNavigationPermissionsVC animated:YES];
        
      });
      
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

- (void)showNoInternetErrorWithText:(NSString *)text actionText:(NSString *)actionText {
  
  OMNCircleRootVC *noInternetVC = [[OMNCircleRootVC alloc] initWithParent:self];
  noInternetVC.text = text;
  noInternetVC.faded = YES;
  noInternetVC.circleIcon = [UIImage imageNamed:@"unlinked_icon_big"];
  __weak typeof(self)weakSelf = self;
  noInternetVC.buttonInfo =
  @[
    [OMNBarButtonInfo infoWithTitle:actionText image:[UIImage imageNamed:@"repeat_icon_small"] block:^{
      
      [weakSelf startSearchingBeacons];
      
    }]
    ];

  [self.navigationController pushViewController:noInternetVC animated:YES];
  
}

- (void)beaconsNotFound {
  
  [self didFindRestaurants:@[]];
  
}

- (void)determineFaceUpPosition {
  
  OMNTablePositionVC *tablePositionVC = [[OMNTablePositionVC alloc] initWithParent:self];
  tablePositionVC.text = NSLocalizedString(@"Слабый сигнал.\nПоложите телефон\nв центр стола,\nпожалуйста.", nil);
  tablePositionVC.circleIcon = [UIImage imageNamed:@"weak_signal_table_icon_big"];
  tablePositionVC.tablePositionDelegate = self;
  __weak typeof(self)weakSelf = self;
  tablePositionVC.buttonInfo =
  @[
    [OMNBarButtonInfo infoWithTitle:NSLocalizedString(@"REPEAT_BUTTON_TITLE", @"Повторить") image:[UIImage imageNamed:@"repeat_icon_small"] block:^{
      [weakSelf startSearchingBeacons];
    }]
    ];
  [self.navigationController pushViewController:tablePositionVC animated:YES];
  
}

#pragma mark - OMNTablePositionVCDelegate

- (void)tablePositionVCDidPlaceOnTable:(OMNTablePositionVC *)tablePositionVC {
  
  [self startSearchingBeacons];
  
}

- (void)tablePositionVCDidCancel:(OMNTablePositionVC *)tablePositionVC {
  
  [self startSearchingBeacons];
  
}

#pragma mark - OMNDemoRestaurantVCDelegate

- (void)demoRestaurantVCDidFail:(OMNDemoRestaurantVC *)demoRestaurantVC withError:(OMNError *)error {
  
  [self didFailOmnom:error];
  
}

- (void)demoRestaurantVCDidFinish:(OMNDemoRestaurantVC *)demoRestaurantVC {
  
  [self startSearchingBeacons];

}

#pragma mark - OMNUserInfoVCDelegate

- (void)userInfoVCDidFinish:(OMNUserInfoVC *)userInfoVC {
  
  [self.navigationController dismissViewControllerAnimated:YES completion:nil];
  
}

@end
