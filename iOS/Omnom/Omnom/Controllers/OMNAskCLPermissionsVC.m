//
//  OMNAskNavigationPermissionsVC.m
//  restaurants
//
//  Created by tea on 08.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNAskCLPermissionsVC.h"
#import <CoreLocation/CoreLocation.h>
#import "OMNDenyCLPermissionVC.h"
#import "OMNCLPermissionsHelpVC.h"
#import <OMNBeacon.h>

@interface OMNAskCLPermissionsVC ()
<CLLocationManagerDelegate>

@end

@implementation OMNAskCLPermissionsVC {
  
  CLLocationManager *_permissionLocationManager;
  
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
      [OMNBarButtonInfo infoWithTitle:kOMN_FORBID_BUTTON_TITLE image:[UIImage imageNamed:@"cancel_later_icon_small"] block:^{
        
        @strongify(self)
        [self denyPermissionTap];
        
      }],
      [OMNBarButtonInfo infoWithTitle:kOMN_ALLOW_BUTTON_TITLE image:[UIImage imageNamed:@"allow_icon_small"] block:^{
        
        @strongify(self)
        [self askPermissionTap];
        
      }]
      ];

  }
  return self;
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

- (void)didReceivePermission {
  
  [self stop];
  self.didReceivePermissionBlock();
  
}

- (IBAction)askPermissionTap {
  
  _permissionLocationManager.delegate = self;

  switch ([CLLocationManager authorizationStatus]) {
    case kCLAuthorizationStatusAuthorizedAlways:
    case kCLAuthorizationStatusAuthorizedWhenInUse: {
      
      [self didReceivePermission];
      
    } break;
    case kCLAuthorizationStatusNotDetermined: {
      
      [self requestCLPermission];
      
    } break;
    case kCLAuthorizationStatusDenied:
    case kCLAuthorizationStatusRestricted:
    default: {
      
      [self showDenyPermissonOffHelp];
      
    } break;
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

- (void)denyPermissionTap {
  
  OMNDenyCLPermissionVC *denyCLPermissionVC = [[OMNDenyCLPermissionVC alloc] initWithParent:self];
  @weakify(self)
  denyCLPermissionVC.buttonInfo =
  @[
    [OMNBarButtonInfo infoWithTitle:kOMN_REPEAT_BUTTON_TITLE image:[UIImage imageNamed:@"repeat_icon_small"] block:^{
      
      @strongify(self)
      [self.navigationController popToViewController:self animated:YES];
      
    }]
    ];
  [self.navigationController pushViewController:denyCLPermissionVC animated:YES];
  
}

- (void)showDenyPermissonOffHelp {
  
  OMNCLPermissionsHelpVC *clPermissionsHelpVC = [[OMNCLPermissionsHelpVC alloc] init];
  [self.navigationController pushViewController:clPermissionsHelpVC animated:YES];
  
}

#pragma mark - UINavigationControllerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
  [self askPermissionTap];  
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
  [self stop];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
  [self stop];
}

@end
