//
//  GBeaconForegroundManager.m
//  beacon
//
//  Created by tea on 03.03.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "GBeaconForegroundManager.h"
#import "OMNBeacon.h"
#import <ESTBeaconManager.h>
#import "CLBeacon+GBeaconAdditions.h"
#import "OMNConstants.h"
#import "OMNBeaconsManager.h"

static NSString * const kForegroundBeaconIdentifier = @"kForegroundBeaconIdentifier";

NSString * const GBeaconIsNearPhoneNotification = @"GBeaconIsNearPhoneNotification";
NSString * const GBeaconRemoveFromPhoneNotification = @"GBeaconRemoveFromPhoneNotification";

@interface GBeaconForegroundManager()

@property (nonatomic, assign) UIBackgroundTaskIdentifier rangingBackgroundTaskIdentifier;
@property (nonatomic, strong) NSMutableDictionary *foundForegroundBeacons;

@end


@implementation GBeaconForegroundManager
{

}

+ (instancetype)manager
{
  static id manager = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    manager = [[[self class] alloc] init];
  });
  return manager;
}

- (instancetype)init
{
  self = [super init];
  if (self) {
    
    self.foundForegroundBeacons = [[NSMutableDictionary alloc] init];

    _beaconManager = [[OMNBeaconsManager alloc] init];
    
  }
  return self;
}

- (void)startMonitoring {
  
//  [_beaconManager startMonitoring:nil];
  
}

- (void)stopMonitoring {
  
  [_beaconManager stopMonitoring];
  
}

@end
