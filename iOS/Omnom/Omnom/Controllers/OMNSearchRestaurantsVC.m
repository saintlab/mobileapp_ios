//
//  OMNSearchBeaconVC.m
//  omnom
//
//  Created by tea on 21.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNSearchRestaurantsVC.h"
#import "OMNAskCLPermissionsVC.h"
#import "OMNCLPermissionsHelpVC.h"
#import "OMNTurnOnBluetoothVC.h"
#import "UINavigationController+omn_replace.h"
#import "OMNDenyCLPermissionVC.h"
#import "OMNAnalitics.h"
#import "OMNBeacon+omn_debug.h"
#import "OMNAuthorization.h"
#import "OMNRestaurantManager.h"
#import <OMNBeaconsSearchManager.h>
#import "UIImage+omn_helper.h"
#import <OMNStyler.h>
#import "OMNLaunchHandler.h"

@interface OMNSearchRestaurantsVC ()
<OMNBeaconsSearchManagerDelegate>

@end

@implementation OMNSearchRestaurantsVC {
  
  OMNBeaconsSearchManager *_beaconsSearchManager;
  BOOL _searching;
  
}

- (void)dealloc {
  [self stopBeaconSearchManager];
}

- (instancetype)init {
  self = [super initWithParent:nil];
  if (self) {
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  UIImage *circleBackground = [[UIImage imageNamed:@"circle_bg"] omn_tintWithColor:[OMNStyler redColor]];
  self.circleBackground = circleBackground;
  self.circleIcon = [UIImage imageNamed:@"logo_icon"];
  self.backgroundImage = [UIImage imageNamed:@"wood_bg"];
  [self.navigationItem setHidesBackButton:YES animated:NO];
  
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  if (!_searching) {
    @weakify(self)
    dispatch_async(dispatch_get_main_queue(), ^{
      
      @strongify(self)
      [self startSearchingRestaurants];
      
    });
  }
  
}

- (void)processHash:(NSString *)hash {
  
  @weakify(self)
  [OMNRestaurantManager decodeHash:hash withCompletion:^(NSArray *restaurants) {
    
    @strongify(self)
    [self didFindRestaurants:restaurants];
    
  } failureBlock:^(OMNError *error) {
    
    @strongify(self)
    [self beaconsNotFound];
    
  }];
  
}

- (void)processQrCode:(NSString *)code {
  
  @weakify(self)
  [OMNRestaurantManager decodeQR:code withCompletion:^(NSArray *restaurants) {
    
    @strongify(self)
    [self didFindRestaurants:restaurants];
    
  } failureBlock:^(OMNError *error) {
    
    @strongify(self)
    [self beaconsNotFound];
    
  }];
  
}

- (void)decodeBeacons:(NSArray *)beacons {
  
  @weakify(self)
  [OMNRestaurantManager decodeBeacons:beacons withCompletion:^(NSArray *restaurants) {
    
    @strongify(self)
    [self didFindRestaurants:restaurants];
    
  } failureBlock:^(OMNError *error) {
    
    @strongify(self)
    [self didFailOmnom:error];
    
  }];
  
}

- (void)didFailOmnom:(OMNError *)error {
  
  @weakify(self)
  [self showRetryMessageWithError:error retryBlock:^{
    
    @strongify(self)
    [self startSearchingRestaurants];
    
  } cancelBlock:^{
    
    @strongify(self)
    [self beaconsNotFound];
    
  }];
  
}

- (void)didFindRestaurants:(NSArray *)restaurants {
  
  [self stopBeaconSearchManager];
  @weakify(self)
  [self finishLoading:^{
  
    @strongify(self)
    [self.delegate searchRestaurantsVC:self didFindRestaurants:restaurants];
    
  }];
  
}

- (void)cancelTap {
  
  [self stopBeaconSearchManager];
  [self.delegate searchRestaurantsVCDidCancel:self];
  
}

- (void)startSearchingRestaurants {
  
  [self stopBeaconSearchManager];
  [self.loaderView stop];
  _searching = YES;
  
  @weakify(self)
  [self.navigationController omn_popToViewController:self animated:YES completion:^{
    
    @strongify(self)
    [self checkUserToken];
    
  }];
  
}

- (void)checkUserToken {
  
  [self.loaderView startAnimating:self.estimateAnimationDuration];
  self.label.text = @"";
  [self.circleButton setImage:self.circleIcon forState:UIControlStateNormal];

  @weakify(self)
  [[OMNAuthorization authorisation] checkUserWithBlock:^(OMNUser *user) {
    
    @strongify(self)
    if (user) {
      
      [self checkLaunchOptions];
      
    }
    else {
      
      [self cancelTap];
      
    }
    
  } failure:^(OMNError *error) {
    
    @strongify(self)
    [self handleInternetError:error];
    
  }];
  
}

- (void)checkLaunchOptions {
  
  @weakify(self)
  OMNLaunchOptions *launchOptions = [OMNLaunchHandler sharedHandler].launchOptions;
  dispatch_async(dispatch_get_main_queue(), ^{
    
    @strongify(self)
    if (launchOptions.restaurants) {
      
      [self didFindRestaurants:launchOptions.restaurants];
      
    }
    else if (launchOptions.hashString) {
      
      [self processHash:launchOptions.hashString];
      
    }
    else if (launchOptions.qr) {
      
      [self processQrCode:launchOptions.qr];
      
    }
    else  {
      
      [self startBeaconSearchManager];
      
    }
    
  });
  
}

- (void)startBeaconSearchManager {
  
  [self.loaderView setProgress:0.1];
  if (!_beaconsSearchManager) {
    _beaconsSearchManager = [[OMNBeaconsSearchManager alloc] init];
  }
  _beaconsSearchManager.delegate = self;
  [_beaconsSearchManager startSearching];
  
}

- (void)stopBeaconSearchManager {
  
  _searching = NO;
  _beaconsSearchManager.delegate = nil;
  [_beaconsSearchManager stop];
  _beaconsSearchManager = nil;
  
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
  @weakify(self)
  noInternetVC.buttonInfo =
  @[
    [OMNBarButtonInfo infoWithTitle:actionText image:[UIImage imageNamed:@"repeat_icon_small"] block:^{
      
      @strongify(self)
      [self startSearchingRestaurants];
      
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
      
      [self startSearchingRestaurants];
      
    } break;
  }
  
}

- (void)beaconSearchManager:(OMNBeaconsSearchManager *)beaconsSearchManager didDetermineBLEState:(OMNBLESearchManagerState)bleState {
  
  switch (bleState) {
    case kBLESearchManagerBLEDidOn: {
      
      [self.loaderView setProgress:0.25];
      
    } break;
    default: {
      
      [self beaconsNotFound];
      
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
      
      @weakify(self)
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        @strongify(self)
        OMNAskCLPermissionsVC *askNavigationPermissionsVC = [[OMNAskCLPermissionsVC alloc] initWithParent:self];
        [self.navigationController pushViewController:askNavigationPermissionsVC animated:YES];
        
      });
      
    } break;
  }
  
}

- (void)showDenyLocationPermissionDescription {
  
  OMNDenyCLPermissionVC *denyCLPermissionVC = [[OMNDenyCLPermissionVC alloc] initWithParent:self];
  @weakify(self)
  denyCLPermissionVC.buttonInfo =
  @[
    [OMNBarButtonInfo infoWithTitle:NSLocalizedString(@"Включить", nil) image:nil block:^{
      
      @strongify(self)
      OMNCLPermissionsHelpVC *navigationPermissionsHelpVC = [[OMNCLPermissionsHelpVC alloc] init];
      [self.navigationController pushViewController:navigationPermissionsHelpVC animated:YES];
      
    }]
    ];
  [self.navigationController pushViewController:denyCLPermissionVC animated:YES];
  
}

- (void)beaconsNotFound {
  
  [self didFindRestaurants:@[]];
  
}

@end
