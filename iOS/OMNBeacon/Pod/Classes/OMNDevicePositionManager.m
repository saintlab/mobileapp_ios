//
//  OMNDeviceLocationManager.m
//  beacon
//
//  Created by tea on 15.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNDevicePositionManager.h"
#import <CoreMotion/CoreMotion.h>

static double const kDesiredDurationOfStillPosition = 1.0;
static double const kAccelerometerUpdateInterval = 0.5;
static double const kDesiredAccelerometerAccuracy = 0.08;

@implementation OMNDevicePositionManager {
  
  CMMotionManager *_motionManager;
  PMKFulfiller fulfiller;   // void (^)(id)
  PMKRejecter rejecter;     // void (^)(NSError *)
  
}

- (void)dealloc {
  [self stop];
}

+ (PMKPromise *)getAccelerometerData {
  
  OMNDevicePositionManager *manager = [[OMNDevicePositionManager alloc] init];
  PMKPromise *promise = [PMKPromise new:^(PMKFulfiller fulfill, PMKRejecter reject) {
    manager->fulfiller = fulfill;
    manager->rejecter = reject;
  }];
  promise.finally(^{
    [manager stop];
  });
  [manager startAccelerometerUpdates];
  // NOTE: we don’t return the promise returned by finally.
  // This way we don’t risk premature deallocation of the manager.
  return promise;
  
}

+ (PMKPromise *)onTable {
  
  return [self getAccelerometerData].then(^(CMAccelerometerData *accelerometerData) {
    
    return [PMKPromise new:^(PMKFulfiller fulfill, PMKRejecter reject) {
      
      BOOL deviceFaceUp = (accelerometerData.acceleration.z < -(1.0 - kDesiredAccelerometerAccuracy));
      BOOL deviceFaceDown = (accelerometerData.acceleration.z > (1.0 - kDesiredAccelerometerAccuracy));
      if ((deviceFaceUp || deviceFaceDown) &&
          fabsf(accelerometerData.acceleration.x) < kDesiredAccelerometerAccuracy &&
          fabsf(accelerometerData.acceleration.y) < kDesiredAccelerometerAccuracy) {
        
        fulfill(nil);
        
      }
      else {
        reject(nil);
      }

    }];
    
  });
  
}

- (void)startAccelerometerUpdates {
  
  _motionManager = [[CMMotionManager alloc] init];
  _motionManager.accelerometerUpdateInterval = kAccelerometerUpdateInterval;
  
  __weak typeof(self)weakSelf = self;
  [_motionManager startAccelerometerUpdatesToQueue:[[NSOperationQueue alloc] init] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {

    if (error) {
      rejecter(error);
    }
    else {
      fulfiller(accelerometerData);
    }
    
  }];
  
}

- (void)stop {
  
  [_motionManager stopAccelerometerUpdates];
  _motionManager = nil;
  
}

@end
