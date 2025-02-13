//
//  OMNSearchBeaconVC.m
//  omnom
//
//  Created by tea on 21.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNSearchRestaurantsVC.h"
#import "OMNAskCLPermissionsVC.h"
#import "UINavigationController+omn_replace.h"
#import "OMNAnalitics.h"
#import "OMNBeacon+omn_debug.h"
#import "OMNAuthorization.h"
#import "UIImage+omn_helper.h"
#import <OMNStyler.h>
#import "OMNLaunchHandler.h"
#import "OMNNavigationController.h"
#import "OMNConstants.h"
#import <OMNMailRuAcquiring.h>
#import <OMNBeaconBackgroundManager.h>
#import "OMNNearestBeaconSearchManager.h"

@implementation OMNSearchRestaurantsVC {
  
  BOOL _searching;
  
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

- (void)startSearchingRestaurants {
  
  [self stopSearching];
  [self.loaderView stop];
  _searching = YES;
  
  @weakify(self)
  [self.navigationController omn_popToViewController:self animated:YES completion:^{
    
    @strongify(self)
    [self checkUserToken];
    
  }];
  
}

- (PMKPromise *)checkCLAuthorizationStatus {
  
  CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
  if (kCLAuthorizationStatusNotDetermined == status) {
    return [OMNAskCLPermissionsVC askPermission:self];
  }

  return [PMKPromise new:^(PMKFulfiller fulfill, PMKRejecter reject) {
    fulfill(@(kCLAuthorizationStatusAuthorizedAlways == status));
  }];
  
}

- (void)updateSettingsWithConfig:(OMNConfig *)config {
  
  [OMNMailRuAcquiring setupWithParametrs:config.mailRuConfig];
  
  [[OMNAnalitics analitics] setupWithToken:config.mixpanelToken
                                debugToken:config.mixpanelDebugToken
                             configuration:[OMNConstants mobileConfiguration]
                                  base_url:[OMNConstants baseUrlString]
                           serverTimestamp:config.serverTimestamp];
  
  [[OMNAuthorization authorization] registerForRemoteNotificationsIfPossible];
  [[OMNAuthorization authorization] checkAuthenticationToken];
  
  [[OMNBeaconBackgroundManager manager] setDidEnterBeaconsRegionBlock:^{
    
    [OMNNearestBeaconSearchManager findAndProcessNearestBeacons];
    
  }];
 
  
}

- (void)checkUserToken {

  [self resetAnimation];

  OMNLaunch *launch = [OMNLaunchHandler sharedHandler].launch;
  [OMNConstants setupWithLaunch:launch].then(^(OMNConfig *config) {
    
    [self updateSettingsWithConfig:config];
    return [self checkCLAuthorizationStatus];
    
  }).then(^(NSNumber *stauts) {
    
    return [launch getRestaurants];
    
  }).then(^(NSArray *restaurants) {
    
    [self didFindRestaurants:restaurants];
    
  }).catch(^(OMNError *error) {
    
    [self didFailOmnom:error];
    
  });
  
}

- (void)stopSearching {
  _searching = NO;
}

- (void)didFindRestaurants:(NSArray *)restaurants {
  
  [self stopSearching];
  @weakify(self)
  [self finishLoading:^{
  
    @strongify(self)
    [self.delegate searchRestaurantsVC:self didFindRestaurants:restaurants];
    
  }];
  
}

- (void)didFailOmnom:(OMNError *)error {
  
  @weakify(self)
  [self finishLoadingWithError:error retryBlock:^{
    
    @strongify(self)
    [self startSearchingRestaurants];
    
  } cancelBlock:^{
    
    @strongify(self)
    [self cancelTap];
    
  }];
  
}

- (void)beaconsNotFound {
  [self didFindRestaurants:@[]];
}

- (void)cancelTap {
  
  [self stopSearching];
  [self.delegate searchRestaurantsVCDidCancel:self];
  
}

- (void)resetAnimation {
  
  [self.loaderView startAnimating:self.estimateAnimationDuration];
  self.label.text = @"";
  [self.circleButton setImage:self.circleIcon forState:UIControlStateNormal];

}

- (void)handleInternetError:(OMNError *)error {

  OMNCircleRootVC *noInternetVC = [[OMNCircleRootVC alloc] initWithParent:self];
  
  NSString *text = error.localizedDescription;
  NSString *actionText = kOMN_REPEAT_NO_INTERNET_BUTTON_TITLE;
  
  switch (error.code) {
    case kOMNErrorCodeTimedOut: {
      
      text = kOMN_ERROR_NO_OMNOM_SERVER_CONNECTION;
      actionText = kOMN_REPEAT_NO_OMNOM_SERVER_BUTTON_TITLE;
      
    } break;
    case kOMNErrorCodeNotConnectedToInternet: {
      
      text = kOMN_ERROR_NO_INTERNET_CONNECTION;
      
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

@end
