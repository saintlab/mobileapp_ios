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
<OMNDenyCLPermissionVCDelegate>

@end

@implementation OMNAskNavigationPermissionsVC {
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
//  
//  _locationManager = [[CLLocationManager alloc] init];
//  _locationManager.delegate = self;
//#ifdef __IPHONE_8_0
//  [_locationManager requestAlwaysAuthorization];
//#endif
  
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.navigationController.navigationItem setHidesBackButton:YES animated:animated];
  
}

- (IBAction)askPermissionTap:(id)sender {
  
#warning 123
//  CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:kBeaconUUIDString] identifier:@"ask_permission_identifier"];
//  [_locationManager requestStateForRegion:beaconRegion];
  
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

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
