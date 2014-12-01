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
    
  }
  return self;
}

- (void)getLocation:(OMNLocationBlock)block {
  
  CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
  if (kCLAuthorizationStatusAuthorizedAlways == authorizationStatus ||
      kCLAuthorizationStatusAuthorizedWhenInUse == authorizationStatus) {
    
    _locationBlock = [block copy];
    [self startUpdatingLocation];
    
  }
  
}

- (void)startUpdatingLocation {
  
  if (nil == _locationManager) {
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
  }
  
  _locationManager.activityType = CLActivityTypeOtherNavigation;
  _locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
  _locationManager.pausesLocationUpdatesAutomatically = NO;
  [_locationManager startUpdatingLocation];
  
}

- (void)stopUpdatingLocation {

  _locationManager.delegate = nil;
  [_locationManager stopUpdatingLocation];
  _locationManager = nil;
  
}

- (void)didFindLocation:(CLLocation *)location {
  
  [self stopUpdatingLocation];
  _locationBlock(location.coordinate);
  _locationBlock = nil;
  
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
  
  [self didFindLocation:[locations lastObject]];
  
}

@end