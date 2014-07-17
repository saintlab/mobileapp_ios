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

@interface OMNAskNavigationPermissionsVC ()
<CLLocationManagerDelegate>

@end

@implementation OMNAskNavigationPermissionsVC {
  CLLocationManager *_locationManager;
}

- (void)dealloc {
  _locationManager.delegate = nil;
  _locationManager = nil;
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
  
  
  _locationManager = [[CLLocationManager alloc] init];
  _locationManager.delegate = self;
#ifdef __IPHONE_8_0
  [_locationManager requestAlwaysAuthorization];
#endif
  
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.navigationController.navigationItem setHidesBackButton:YES animated:animated];
  
}

- (IBAction)askPermissionTap:(id)sender {
  
  CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:kBeaconUUIDString] identifier:@"ask_permission_identifier"];
  [_locationManager requestStateForRegion:beaconRegion];
  
}

- (void)permissionGranted {
  
  [self.delegate askNavigationPermissionsVCDidGrantPermission:self];
  
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
  
  switch (status) {
    case kCLAuthorizationStatusDenied: {
      [[[UIAlertView alloc] initWithTitle:@"kCLAuthorizationStatusDenied" message:@"показать экран чтобы получить пермишен для использования геолокации" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];

    } break;
    case kCLAuthorizationStatusRestricted: {
      [[[UIAlertView alloc] initWithTitle:@"kCLAuthorizationStatusRestricted" message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    } break;
    case kCLAuthorizationStatusNotDetermined: {
    } break;
    default: {
      
      [self permissionGranted];
      
    } break;
  }
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
