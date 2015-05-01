//
//  OMNAskNavigationPermissionsVC.m
//  restaurants
//
//  Created by tea on 08.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNAskCLPermissionsVC.h"
#import <CoreLocation/CoreLocation.h>
#import "OMNNavigationController.h"

@interface OMNAskCLPermissionsVC ()
<CLLocationManagerDelegate>

@end

@implementation OMNAskCLPermissionsVC {
  
  CLLocationManager *_permissionLocationManager;
  PMKFulfiller _fulfiller;
  
}

- (void)dealloc {
  
  [self stop];
  _permissionLocationManager.delegate = nil;
  _permissionLocationManager = nil;
  
}

- (instancetype)initWithParent:(OMNCircleRootVC *)parent {
  self = [super initWithParent:parent];
  if (self) {
    self.backgroundImage = [UIImage imageNamed:@"wood_bg"];
    self.text = kOMN_CL_PERMISSION_DESCRIPTION_TEXT;
    
    @weakify(self)
    self.buttonInfo =
    @[
      [OMNBarButtonInfo infoWithTitle:kOMN_LATER_BUTTON_TITLE image:[UIImage imageNamed:@"cancel_later_icon_small"] block:^{
        
        @strongify(self)
        [self didReceivePermission:NO];
        
      }],
      [OMNBarButtonInfo infoWithTitle:kOMN_ALLOW_BUTTON_TITLE image:[UIImage imageNamed:@"allow_icon_small"] block:^{
        
        @strongify(self)
        [self checkPermissionStatus];
        
      }]
      ];

  }
  return self;
}

+ (PMKPromise *)askPermission:(OMNCircleRootVC *)rootVC {
  
  OMNAskCLPermissionsVC *askCLPermissionsVC = [[OMNAskCLPermissionsVC alloc] initWithParent:rootVC];
  askCLPermissionsVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
  PMKPromise *promise = [PMKPromise new:^(PMKFulfiller fulfill, PMKRejecter reject) {
    askCLPermissionsVC->_fulfiller = fulfill;
  }];
  promise.finally(^{
    [askCLPermissionsVC stop];
  });
  [rootVC presentViewController:[OMNNavigationController controllerWithRootVC:askCLPermissionsVC] animated:YES completion:nil];
  return promise;
  
}

- (void)stop {
  [_permissionLocationManager stopUpdatingLocation];
}

- (void)viewDidLoad {
  [super viewDidLoad];

  _permissionLocationManager = [[CLLocationManager alloc] init];
  _permissionLocationManager.pausesLocationUpdatesAutomatically = NO;
  _permissionLocationManager.activityType = CLActivityTypeOtherNavigation;
  _permissionLocationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
  
  [self.circleButton setImage:[UIImage imageNamed:@"allow_geolocation_icon_big"] forState:UIControlStateNormal];

}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.navigationItem setHidesBackButton:YES animated:NO];
  
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  [UIView animateWithDuration:0.3 animations:^{
    [self.view layoutIfNeeded];
  }];
  
}

- (void)didReceivePermission:(BOOL)status {
  
  [self stop];
  [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
  
    _fulfiller(@(status));
    
  }];
  
}

- (void)checkPermissionStatus {
  
  _permissionLocationManager.delegate = self;

  CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
  if (kCLAuthorizationStatusNotDetermined == status) {
    
    [self requestCLPermission];
    
  }
  else {
    
    BOOL permissionDidReceived = (kCLAuthorizationStatusAuthorizedAlways == status);
    [self didReceivePermission:permissionDidReceived];
    
  }
  
}

- (void)requestCLPermission {
  
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
  if ([_permissionLocationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
    
    [_permissionLocationManager performSelector:@selector(requestAlwaysAuthorization) withObject:nil];
    
  }
  else {
    
    [_permissionLocationManager startUpdatingLocation];
    
  }
#pragma clang diagnostic pop
  
}

#pragma mark - UINavigationControllerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
  [self checkPermissionStatus];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
  [self stop];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
  [self stop];
}

@end
