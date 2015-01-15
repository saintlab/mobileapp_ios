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
#import "OMNCLPermissionsHelpVC.h"
#import "OMNCircleRootVC.h"
#import "OMNTurnOnBluetoothVC.h"
#import "UINavigationController+omn_replace.h"
#import "OMNDenyCLPermissionVC.h"
#import "OMNAnalitics.h"
#import "UIBarButtonItem+omn_custom.h"
#import "OMNBeacon+omn_debug.h"
#import "OMNAuthorization.h"
#import "OMNRestaurantManager.h"
#import <OMNBeaconsSearchManager.h>
#import "UIImage+omn_helper.h"
#import <OMNStyler.h>
#import "OMNLaunchHandler.h"

@interface OMNSearchRestaurantsVC ()
<OMNBeaconsSearchManagerDelegate>

@property (nonatomic, strong) OMNSearchRestaurantMediator *searchRestaurantMediator;

@end

@implementation OMNSearchRestaurantsVC {
  
  OMNBeaconsSearchManager *_beaconsSearchManager;
  UIButton *_cancelButton;
  
}

- (void)dealloc {
  
  [self stopBeaconManager];
  
}

- (instancetype)initWithMediator:(OMNSearchRestaurantMediator *)searchRestaurantMediator {
  self = [super initWithParent:nil];
  if (self) {
    
    _searchRestaurantMediator = searchRestaurantMediator;
    
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  UIImage *circleBackground = [[UIImage imageNamed:@"circle_bg"] omn_tintWithColor:colorWithHexString(@"d0021b")];
  self.circleBackground = circleBackground;
  self.circleIcon = [UIImage imageNamed:@"logo_icon"];
  self.backgroundImage = [UIImage imageNamed:@"wood_bg"];
  
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
  OMNLaunchOptions *launchOptions = [OMNLaunchHandler sharedHandler].launchOptions;
  if (launchOptions.restaurants) {
    
    [self.loaderView startAnimating:self.estimateAnimationDuration];
    dispatch_async(dispatch_get_main_queue(), ^{
      
      [weakSelf didFindRestaurants:launchOptions.restaurants];
      
    });
    
  }
  else if (launchOptions.hashString) {
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
      
      [weakSelf processHash:launchOptions.hashString];
      
    });
    
  }
  else if (launchOptions.qr) {
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
      
      [weakSelf processQrCode:launchOptions.qr];
      
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

- (void)didFailOmnom:(OMNError *)error {
  
  __weak typeof(self)weakSelf = self;
  [self showRetryMessageWithError:error retryBlock:^{
    
    [weakSelf startSearchingBeacons];
    
  } cancelBlock:^{
    
    [weakSelf beaconsNotFound];
    
  }];
  
}

- (void)didFindRestaurants:(NSArray *)restaurants {
  
  [self stopBeaconManager];
  __weak typeof(self)weakSelf = self;
  [self finishLoading:^{
  
    [weakSelf.searchRestaurantMediator showRestaurants:restaurants];
    
  }];
  
}

- (void)cancelTap {
  
  [self stopBeaconManager];
  [self.delegate searchRestaurantsVCDidCancel:self];
  
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

  OMNCircleRootVC *noInternetVC = [[OMNCircleRootVC alloc] initWithParent:self];
  
  NSString *text = error.localizedDescription;
  NSString *actionText = NSLocalizedString(@"REPEAT_NO_INTERNET_BUTTON_TITLE", @"Попробуйте ещё раз");
  
  switch (error.code) {
    case kOMNErrorCodeTimedOut: {
      
      text = NSLocalizedString(@"ERROR_NO_OMNOM_SERVER_CONNECTION", @"Помехи на линии.");
      actionText = NSLocalizedString(@"REPEAT_NO_OMNOM_SERVER_BUTTON_TITLE", @"Давайте ещё раз.");
      
    } break;
    case kOMNErrorCodeNotConnectedToInternet: {
      
      text = NSLocalizedString(@"ERROR_NO_INTERNET_CONNECTION", @"Вы видите интернет? Мы нет.");
      
    } break;
  }
  
  noInternetVC.text = text;
  noInternetVC.faded = YES;
  noInternetVC.circleIcon = error.circleImage;
  __weak typeof(self)weakSelf = self;
  noInternetVC.buttonInfo =
  @[
    [OMNBarButtonInfo infoWithTitle:actionText image:[UIImage imageNamed:@"repeat_icon_small"] block:^{
      
      [weakSelf startSearchingBeacons];
      
    }]
    ];
  
  [self.navigationController pushViewController:noInternetVC animated:YES];
  
}

#pragma mark - OMNBeaconsSearchManagerDelegate

- (void)beaconSearchManager:(OMNBeaconsSearchManager *)beaconsSearchManager didFindBeacons:(NSArray *)beacons {
  
  NSDictionary *debugData = [OMNBeacon debugDataFromBeacons:beacons];
  [[OMNAnalitics analitics] logDebugEvent:@"DID_FIND_BEACONS" parametrs:@{@"beacons" : debugData}];
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
  
  switch (clState) {
    case kCLSearchManagerRequestRestrictedPermission:
    case kCLSearchManagerRequestDeniedPermission: {
      
      [[OMNAnalitics analitics] logDebugEvent:@"no_geolocation_permission" parametrs:nil];
      [self showDenyLocationPermissionDescription];
      
    } break;
    case kCLSearchManagerRequestPermission: {
      
      __weak typeof(self)weakSelf = self;
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        OMNAskCLPermissionsVC *askNavigationPermissionsVC = [[OMNAskCLPermissionsVC alloc] initWithParent:weakSelf];
        [weakSelf.navigationController pushViewController:askNavigationPermissionsVC animated:YES];
        
      });
      
    } break;
  }
  
}

- (void)showDenyLocationPermissionDescription {
  
  OMNDenyCLPermissionVC *denyCLPermissionVC = [[OMNDenyCLPermissionVC alloc] initWithParent:self];
  __weak typeof(self)weakSelf = self;
  denyCLPermissionVC.buttonInfo =
  @[
    [OMNBarButtonInfo infoWithTitle:NSLocalizedString(@"Включить", nil) image:nil block:^{
      
      OMNCLPermissionsHelpVC *navigationPermissionsHelpVC = [[OMNCLPermissionsHelpVC alloc] init];
      [weakSelf.navigationController pushViewController:navigationPermissionsHelpVC animated:YES];
      
    }]
    ];
  [self.navigationController pushViewController:denyCLPermissionVC animated:YES];
  
}

- (void)beaconsNotFound {
  
  [self didFindRestaurants:@[]];
  
}

@end
