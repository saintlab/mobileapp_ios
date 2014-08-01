//
//  OMNAskNavigationPermissionsVC.m
//  restaurants
//
//  Created by tea on 08.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNAskNavigationPermissionsVC.h"
#import <CoreLocation/CoreLocation.h>
#import "OMNConstants.h"
#import "OMNDenyCLPermissionVC.h"
#import "OMNNavigationPermissionsHelpVC.h"

@interface OMNAskNavigationPermissionsVC ()
<OMNDenyCLPermissionVCDelegate,
CLLocationManagerDelegate>

@end

@implementation OMNAskNavigationPermissionsVC {
  CLLocationManager *_permissionLocationManager;
  CLBeaconRegion *_beaconRegion;
}

- (instancetype)init {
  self = [super initWithNibName:@"OMNAskNavigationPermissionsVC" bundle:nil];
  if (self) {
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

  _permissionLocationManager = [[CLLocationManager alloc] init];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
  if ([_permissionLocationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
    [_permissionLocationManager performSelector:@selector(requestAlwaysAuthorization) withObject:nil];
  }
#pragma clang diagnostic pop
  
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.navigationController.navigationItem setHidesBackButton:YES animated:animated];
  
}

- (IBAction)askPermissionTap:(id)sender {
  
  [_permissionLocationManager startRangingBeaconsInRegion:_beaconRegion];
  _permissionLocationManager.delegate = self;
  
}

- (IBAction)denyPermissionTap:(id)sender {
  
  OMNDenyCLPermissionVC *denyCLPermissionVC = [[OMNDenyCLPermissionVC alloc] init];
  denyCLPermissionVC.delegate = self;
  [self.navigationController pushViewController:denyCLPermissionVC animated:YES];
  
}

- (void)showDenyPermissonOffHelp {
  
  OMNNavigationPermissionsHelpVC *navigationPermissionsHelpVC = [[OMNNavigationPermissionsHelpVC alloc] init];
  [self.navigationController pushViewController:navigationPermissionsHelpVC animated:YES];
  
}
#pragma mark - OMNDenyCLPermissionVCDelegate

- (void)denyCLPermissionVCDidAskPermission:(OMNDenyCLPermissionVC *)denyCLPermissionVC {
  [self.navigationController popToViewController:self animated:YES];
}

#pragma mark - UINavigationControllerDelegate

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region {
  [manager stopMonitoringForRegion:_beaconRegion];
}

@end
