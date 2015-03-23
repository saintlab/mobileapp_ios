//
//  OMNViewController.m
//  OMNBeacon
//
//  Created by teanet on 07/11/2014.
//  Copyright (c) 2014 teanet. All rights reserved.
//

#import "OMNViewController.h"
#import <OMNBeaconRangingManager.h>
#import <OMNBeacon.h>

@interface OMNViewController ()

@end

@implementation OMNViewController {
  
  OMNBeaconRangingManager *_beaconRangingManager;
  CLLocationManager *_cl;
  
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  
  if (kCLAuthorizationStatusNotDetermined == [CLLocationManager authorizationStatus]) {
    _cl = [[CLLocationManager alloc] init];
    [_cl requestAlwaysAuthorization];
  }
  
  id jsonData = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"config.json" ofType:nil]] options:0 error:nil];
  [OMNBeacon setBaeconUUID:[[OMNBeaconUUID alloc] initWithJsonData:jsonData[@"uuid"]]];
  _beaconRangingManager = [[OMNBeaconRangingManager alloc] initWithStatusBlock:^(CLAuthorizationStatus status) {
    
  }];
  
  [_beaconRangingManager rangeBeacons:^(NSArray *beacons) {
    
    NSLog(@"%@", beacons);
    
  } failure:^(NSError *error) {
    
  }];
  
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
