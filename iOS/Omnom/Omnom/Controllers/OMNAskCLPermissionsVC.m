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
#import <OMNBeacon.h>

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
    self.backgroundImage = [UIImage imageNamed:@"wood_bg"];
    self.text = NSLocalizedString(@"Необходимо разрешение на использование службы геолокации", nil);
    
    _beaconRegion = [[[OMNBeacon beaconUUID] aciveBeaconsRegionsWithIdentifier:@"ask_permission_identifier"] firstObject];
    __weak typeof(self)weakSelf = self;
    self.buttonInfo =
    @[
      [OMNBarButtonInfo infoWithTitle:NSLocalizedString(@"Запретить", nil) image:[UIImage imageNamed:@"cancel_later_icon_small"] block:^{
        
        [weakSelf denyPermissionTap];
        
      }],
      [OMNBarButtonInfo infoWithTitle:NSLocalizedString(@"Разрешить", nil) image:[UIImage imageNamed:@"allow_icon_small"] block:^{
        
        [weakSelf askPermissionTap];
        
      }]
      ];

  }
  return self;
}

- (void)dealloc {
  
  [_permissionLocationManager stopRangingBeaconsInRegion:_beaconRegion];
  _permissionLocationManager.delegate = nil;
  _permissionLocationManager = nil;
  
}

- (void)viewDidLoad {
  [super viewDidLoad];

  [self.circleButton setImage:[UIImage imageNamed:@"allow_geolocation_icon_big"] forState:UIControlStateNormal];
  
  _permissionLocationManager = [[CLLocationManager alloc] init];
  _permissionLocationManager.pausesLocationUpdatesAutomatically = NO;
  
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

- (IBAction)askPermissionTap {
  
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

- (void)denyPermissionTap {
  
  OMNDenyCLPermissionVC *denyCLPermissionVC = [[OMNDenyCLPermissionVC alloc] initWithParent:self];
  __weak typeof(self)weakSelf = self;
  denyCLPermissionVC.buttonInfo =
  @[
    [OMNBarButtonInfo infoWithTitle:NSLocalizedString(@"REPEAT_BUTTON_TITLE", @"Повторить") image:[UIImage imageNamed:@"repeat_icon_small"] block:^{
      
      [weakSelf.navigationController popToViewController:weakSelf animated:YES];
      
    }]
    ];
  [self.navigationController pushViewController:denyCLPermissionVC animated:YES];
  
}

- (void)showDenyPermissonOffHelp {
  
  OMNCLPermissionsHelpVC *clPermissionsHelpVC = [[OMNCLPermissionsHelpVC alloc] init];
  [self.navigationController pushViewController:clPermissionsHelpVC animated:YES];
  
}

#pragma mark - UINavigationControllerDelegate

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region {
  
  [manager stopMonitoringForRegion:_beaconRegion];
  
}

@end
