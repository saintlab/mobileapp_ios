//
//  OMNLocationManager.m
//  omnom
//
//  Created by tea on 28.11.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNLocationManager.h"

@interface OMNLocationManager ()
<CLLocationManagerDelegate>

@end

@implementation OMNLocationManager {

  CLLocationManager *_locationManager;
  CLGeocoder *_geocoder;
  OMNLocationBlock _locationBlock;
  
}

+ (instancetype)sharedManager {
  static id manager = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    manager = [[[self class] alloc] init];
  });
  return manager;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.activityType = CLActivityTypeOtherNavigation;
    _locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    _locationManager.pausesLocationUpdatesAutomatically = NO;
    
  }
  return self;
}

- (void)getLocation:(OMNLocationBlock)block {

  _locationBlock = [block copy];
  [self startUpdatingLocationIfNeeded];
  
}

- (void)startUpdatingLocationIfNeeded {
  
  CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
  BOOL permissionGranted = (kCLAuthorizationStatusAuthorizedAlways == authorizationStatus || kCLAuthorizationStatusAuthorizedWhenInUse == authorizationStatus);
  
  if (_locationBlock &&
      permissionGranted) {
    
    [_locationManager startUpdatingLocation];
    
  }
  else {
    
    [self notFoundCoordinate];
    
  }
  
}

- (void)notFoundCoordinate {
  
  [self didFindCoordinate:CLLocationCoordinate2DMake(0.0, 0.0)];
  
}

- (void)didFindCoordinate:(CLLocationCoordinate2D)coordinate {
  
  [_locationManager stopUpdatingLocation];
  if (_locationBlock) {
    
    _locationBlock(coordinate);
    _locationBlock = nil;

  }
  
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
  
  CLLocation *location = [locations lastObject];
  if (location) {
    
    [self didFindCoordinate:location.coordinate];
    
  }
  
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
  
  [self startUpdatingLocationIfNeeded];
  
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
  
  [self notFoundCoordinate];
  
}

@end
