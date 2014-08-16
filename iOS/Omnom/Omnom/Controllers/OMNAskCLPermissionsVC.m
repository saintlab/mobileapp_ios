//
//  OMNAskNavigationPermissionsVC.m
//  restaurants
//
//  Created by tea on 08.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNAskCLPermissionsVC.h"
#import <CoreLocation/CoreLocation.h>
#import "OMNConstants.h"
#import "OMNDenyCLPermissionVC.h"
#import "OMNCLPermissionsHelpVC.h"
#import "OMNToolbarButton.h"

@interface OMNAskCLPermissionsVC ()
<CLLocationManagerDelegate>

@end

@implementation OMNAskCLPermissionsVC {
  CLLocationManager *_permissionLocationManager;
  CLBeaconRegion *_beaconRegion;
}

- (instancetype)initWithParent:(OMNCircleRootVC *)parent {
  self = [super initWithParent:parent];
  if (self) {
    self.text = NSLocalizedString(@"Необходимо разрешение на использование службы геолокации", nil);
    _beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:kBeaconUUIDString] identifier:@"ask_permission_identifier"];
  }
  return self;
}

- (void)dealloc {
  
  [_permissionLocationManager stopMonitoringForRegion:_beaconRegion];
  _permissionLocationManager.delegate = nil;
  _permissionLocationManager = nil;
  
}

- (void)viewDidLoad {
  [super viewDidLoad];

  [self.circleButton setImage:[UIImage imageNamed:@"allow_geolocation_icon_big"] forState:UIControlStateNormal];
  
  _permissionLocationManager = [[CLLocationManager alloc] init];
  _permissionLocationManager.pausesLocationUpdatesAutomatically = NO;
  [self addActionsBoard];
  
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.navigationController.navigationItem setHidesBackButton:YES animated:animated];
  
}

- (void)addActionsBoard {
  [self addBottomButtons];
  
  UIButton *leftButton = [[OMNToolbarButton alloc] init];
  [leftButton setImage:[UIImage imageNamed:@"cancel_later_icon_small"] forState:UIControlStateNormal];
  [leftButton addTarget:self action:@selector(denyPermissionTap:) forControlEvents:UIControlEventTouchUpInside];
  [leftButton setTitle:NSLocalizedString(@"Запретить", nil) forState:UIControlStateNormal];
  [leftButton sizeToFit];
  
  UIButton *rightButton = [[OMNToolbarButton alloc] init];
  [rightButton setImage:[UIImage imageNamed:@"allow_icon_small"] forState:UIControlStateNormal];
  [rightButton addTarget:self action:@selector(askPermissionTap:) forControlEvents:UIControlEventTouchUpInside];
  [rightButton setTitle:NSLocalizedString(@"Разрешить", nil) forState:UIControlStateNormal];
  [rightButton sizeToFit];
  
  self.bottomToolbar.items =
  @[
    [[UIBarButtonItem alloc] initWithCustomView:leftButton],
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
    [[UIBarButtonItem alloc] initWithCustomView:rightButton],
    ];

}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  self.bottomViewConstraint.constant = 0.0f;
  [UIView animateWithDuration:0.3 animations:^{
    [self.view layoutIfNeeded];
  }];
  
}

- (IBAction)askPermissionTap:(id)sender {
  
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
  if ([_permissionLocationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
    [_permissionLocationManager performSelector:@selector(requestAlwaysAuthorization) withObject:nil];
  }
  else {
    [_permissionLocationManager startRangingBeaconsInRegion:_beaconRegion];
    _permissionLocationManager.delegate = self;
  }
#pragma clang diagnostic pop
  
  
}

- (IBAction)denyPermissionTap:(id)sender {
  
  OMNDenyCLPermissionVC *denyCLPermissionVC = [[OMNDenyCLPermissionVC alloc] initWithParent:self];
  __weak typeof(self)weakSelf = self;
  denyCLPermissionVC.actionBlock = ^{
    [weakSelf.navigationController popToViewController:weakSelf animated:YES];
  };
  [self.navigationController pushViewController:denyCLPermissionVC animated:YES];
  
}

- (void)showDenyPermissonOffHelp {
  
  OMNCLPermissionsHelpVC *navigationPermissionsHelpVC = [[OMNCLPermissionsHelpVC alloc] init];
  [self.navigationController pushViewController:navigationPermissionsHelpVC animated:YES];
  
}

#pragma mark - UINavigationControllerDelegate

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region {
  [manager stopMonitoringForRegion:_beaconRegion];
}

@end
