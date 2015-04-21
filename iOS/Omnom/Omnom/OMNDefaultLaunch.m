//
//  OMNDefaultLaunch.m
//  omnom
//
//  Created by tea on 17.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNDefaultLaunch.h"
#import <OMNBeaconsSearchManager.h>
#import "OMNRestaurantManager.h"
#import "OMNBeacon+omn_debug.h"
#import "OMNAnalitics.h"

@interface OMNDefaultLaunch ()

@property (nonatomic, strong, readonly) OMNBeaconsSearchManager *beaconsSearchManager;

@end

@implementation OMNDefaultLaunch

- (void)dealloc {
  [self.beaconsSearchManager stop];
}

- (instancetype)init {
  self = [super init];
  if (self) {
    
    _beaconsSearchManager = [[OMNBeaconsSearchManager alloc] init];
    
  }
  return self;
}

- (PMKPromise *)decodeRestaurants {
  
  return [self searchBeacons].then(^(NSArray *beacons) {
    
    return [self decodeBeacons:beacons];
    
  });
  
}

- (PMKPromise *)searchBeacons {
  
  return [PMKPromise new:^(PMKFulfiller fulfill, PMKRejecter reject) {
    
    [self.beaconsSearchManager startSearchingWithCompletion:^(NSArray *beacons) {
      
      fulfill(beacons);
      
    }];
    
  }];
  
}

- (PMKPromise *)decodeBeacons:(NSArray *)beacons {
  
  return [PMKPromise new:^(PMKFulfiller fulfill, PMKRejecter reject) {
    
    if (!beacons) {
      fulfill(@[]);
      return;
    }
    
    NSDictionary *debugData = [OMNBeacon debugDataFromBeacons:beacons];
    [[OMNAnalitics analitics] logDebugEvent:@"DID_FIND_BEACONS" parametrs:@{@"beacons" : debugData}];
    
    [OMNRestaurantManager decodeBeacons:beacons withCompletion:^(NSArray *restaurants) {
      
      fulfill(restaurants);
      
    } failureBlock:^(OMNError *error) {
      
      fulfill(@[]);
      
    }];
    
  }];
  
}

@end
