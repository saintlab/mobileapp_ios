//
//  GBeacon.m
//  beacon
//
//  Created by tea on 21.02.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNBeacon.h"
#import "NSMutableArray+OMNIndexAdditions.h"
#import "OMNBeaconSessionInfo.h"

//NSTimeInterval const kTimeToDeleteMarkSec = 4 * 60 * 60;
NSTimeInterval const kTimeToDeleteMarkSec = 1 * 60;

__unused static NSTimeInterval const kGTimeToFindMarkSeconds = 2.0;
__unused static NSTimeInterval const kGTimeToLoseMarkSeconds = 5.0;

static NSUInteger const kMaxBeaconCount = 7;
static NSUInteger const kBeaconDesiredTimesAccuracy = 2;

const NSInteger kBoardingRSSI = -68;
const NSInteger kNearestDeltaRSSI = 10;

@implementation OMNBeacon {
  NSMutableArray *_beaconSessionInfo;
  dispatch_semaphore_t _updateBeaconLock;
  NSDate *_firstImmediateDate;

}

- (instancetype)init {
  self = [super init];
  if (self) {

    _updateBeaconLock = dispatch_semaphore_create(1);
    _beaconSessionInfo = [NSMutableArray arrayWithCapacity:kMaxBeaconCount];
    
  }
  return self;
}

- (void)updateWithBeacon:(OMNBeacon *)beacon {
  
  dispatch_semaphore_wait(_updateBeaconLock, DISPATCH_TIME_FOREVER);
  
  OMNBeaconSessionInfo *sessionInfo = [[OMNBeaconSessionInfo alloc] initWithBeacon:beacon];
  [_beaconSessionInfo addObject:sessionInfo];

  if (nil == _firstImmediateDate &&
      (CLProximityImmediate == sessionInfo.proximity ||
       CLProximityNear == sessionInfo.proximity)) {
    _firstImmediateDate = [NSDate date];
  }
  
  if (_beaconSessionInfo.count > kMaxBeaconCount) {
    [_beaconSessionInfo omn_removeFirstObject];
  }
  
  self.accuracy = beacon.accuracy;
  self.proximity = beacon.proximity;
  self.rssi = beacon.rssi;
  
  dispatch_semaphore_signal(_updateBeaconLock);
  
}

- (BOOL)atTheTable {
  
  __block NSInteger atTheTableTimes = 0;
  
  [_beaconSessionInfo enumerateObjectsUsingBlock:^(OMNBeaconSessionInfo *sessionInfo, NSUInteger idx, BOOL *stop) {
    
    if (CLProximityImmediate == sessionInfo.proximity ||
        CLProximityNear == sessionInfo.proximity) {
      atTheTableTimes++;
    }
    
  }];
  
  return (atTheTableTimes >= kBeaconDesiredTimesAccuracy);
  
}

- (BOOL)nearTheTable {
  return (self.rssi > kBoardingRSSI);
}

- (double)totalRSSI {
  
  if (_beaconSessionInfo.count == 0) {
    return -1000;
  }
  
  __block double totalRSSI = 0;
  [_beaconSessionInfo enumerateObjectsUsingBlock:^(OMNBeaconSessionInfo *sessionInfo, NSUInteger idx, BOOL *stop) {
    totalRSSI += sessionInfo.rssi;
  }];
  
  return totalRSSI / _beaconSessionInfo.count;
  
}

- (void)removeFromTable {
  _firstImmediateDate = nil;
  [_beaconSessionInfo removeAllObjects];
}

- (BOOL)locatedNearMark {
  return (CLProximityImmediate == self.proximity);
}

- (void)newIterationBegin {
  
  if (self.atTheTable) {
    [_beaconSessionInfo omn_removeFirstObject];
  }

}

- (NSString *)key {
  return [NSString stringWithFormat:@"%@+%@+%@",self.UUIDString,self.major,self.minor];
}

- (NSDictionary *)JSONObject {
  
  NSString *uid = [NSString stringWithFormat:@"%@+%@+%@", self.UUIDString, self.major, self.minor];
  return @{
           @"uuid" : uid,
           };
  
}

- (NSTimeInterval)atTheTableTime {
  
  NSTimeInterval atTheTableTime = 0.0;
  
  OMNBeaconSessionInfo *lastSessionInfo = [_beaconSessionInfo lastObject];
  
  if (lastSessionInfo &&
      _firstImmediateDate) {
    atTheTableTime = [lastSessionInfo.timeStamp timeIntervalSinceDate:_firstImmediateDate];
  }
  
  return atTheTableTime;
  
}

- (BOOL)closeToBeacon:(OMNBeacon *)beacon {
  return (self.rssi > beacon.rssi - kNearestDeltaRSSI);
}

- (NSString *)description {
  NSMutableString *debugString = [NSMutableString string];
  
  [_beaconSessionInfo enumerateObjectsUsingBlock:^(OMNBeaconSessionInfo *sessionInfo, NSUInteger idx, BOOL *stop) {
    [debugString appendFormat:@"%ld,", (long)sessionInfo.proximity];
  }];
  
  return [NSString stringWithFormat:@"%@, %ld, %d %f, {%@}", self.key, (long)self.rssi, self.atTheTable, self.atTheTableTime, debugString];
}

@end
