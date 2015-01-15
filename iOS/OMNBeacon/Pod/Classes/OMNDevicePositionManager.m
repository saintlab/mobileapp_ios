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
  
  dispatch_block_t _completitionPositionBlock;
  
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

    _motionManager = [[CMMotionManager alloc] init];

  }
  return self;
}

- (void)dealloc {
  
  [self stop];
  
}

- (BOOL)running {
  
  return _motionManager.isAccelerometerActive;
  
}

- (void)getDevicePosition:(OMNDevicePositionBlock)devicePositionBlock {
  
  [self stop];
  
  _motionManager.accelerometerUpdateInterval = kAccelerometerUpdateInterval;
  
  __weak typeof(self)weakSelf = self;
  [_motionManager startAccelerometerUpdatesToQueue:[[NSOperationQueue alloc] init] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
    
    BOOL deviceFaceUp = (accelerometerData.acceleration.z < -(1.0 - kDesiredAccelerometerAccuracy));
    BOOL deviceFaceDown = (accelerometerData.acceleration.z > (1.0 - kDesiredAccelerometerAccuracy));
    
    BOOL onTable = NO;
    if (!error &&
        (deviceFaceUp || deviceFaceDown) &&
        fabsf(accelerometerData.acceleration.x) < kDesiredAccelerometerAccuracy &&
        fabsf(accelerometerData.acceleration.y) < kDesiredAccelerometerAccuracy) {
      
      onTable = YES;
      
    }
    
    [weakSelf stop];
    
    dispatch_async(dispatch_get_main_queue(), ^{
      
      devicePositionBlock(onTable);
      
    });
    
  }];
  
}

- (void)handleDeviceFaceUpPosition:(dispatch_block_t)block {

  [self stop];
  
  __block NSInteger numberOfFaceUpStillPositions = 0;

  __weak typeof(self)weakSelf = self;
  
  NSInteger numberOfDesiredStillPositions = kDesiredDurationOfStillPosition / kAccelerometerUpdateInterval;
  
  _completitionPositionBlock = [block copy];
  
  _motionManager.accelerometerUpdateInterval = kAccelerometerUpdateInterval;

  [_motionManager startAccelerometerUpdatesToQueue:[[NSOperationQueue alloc] init] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
    
    if (nil == error &&
        accelerometerData.acceleration.z < -(1.0 - kDesiredAccelerometerAccuracy) &&
        fabsf(accelerometerData.acceleration.x) < kDesiredAccelerometerAccuracy &&
        fabsf(accelerometerData.acceleration.y) < kDesiredAccelerometerAccuracy) {
      
      numberOfFaceUpStillPositions++;
      
    }
    else {
      
      numberOfFaceUpStillPositions = 0;
      
    }
    
    if (numberOfFaceUpStillPositions > numberOfDesiredStillPositions) {
      
      numberOfFaceUpStillPositions = 0;
      [weakSelf handleDeviceFaceUp];

    }
    
  }];
  
}

- (void)stop {
  
  [_motionManager stopAccelerometerUpdates];
  
}

- (void)handleDeviceFaceUp {
  
  [self stop];

  dispatch_block_t completitionPositionBlock = [_completitionPositionBlock copy];
  _completitionPositionBlock = nil;
  NSLog(@"device is face up");
  if (completitionPositionBlock) {
    
    dispatch_async(dispatch_get_main_queue(), ^{

      completitionPositionBlock();
      
    });
  }
  
}

@end
