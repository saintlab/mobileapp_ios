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

static OMNBeaconUUID *_beaconUUID = nil;

__unused static NSTimeInterval const kGTimeToFindMarkSeconds = 2.0;
__unused static NSTimeInterval const kGTimeToLoseMarkSeconds = 5.0;

static NSUInteger const kMaxBeaconCount = 7;
static NSUInteger const kBeaconDesiredTimesAccuracy = 2;

const NSInteger kBoardingRSSI = -70;
const NSInteger kMaxRSSI = -80;
const NSInteger kNearestDeltaRSSI = 10;

@implementation OMNBeacon {
  NSMutableArray *_beaconSessionInfo;
  dispatch_semaphore_t _updateBeaconLock;
  NSDate *_firstImmediateDate;
  
}

- (instancetype)initWithJsonData:(id)jsonData {
  self = [self init];
  if (self) {
    self.UUIDString = jsonData[@"uuid"];
    self.major = jsonData[@"major"];
    self.minor = jsonData[@"minor"];
  }
  return self;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    
    _updateBeaconLock = dispatch_semaphore_create(1);
    _beaconSessionInfo = [NSMutableArray arrayWithCapacity:kMaxBeaconCount];
    
  }
  return self;
}

+ (void)setBaeconUUID:(OMNBeaconUUID *)beaconUUID {
  _beaconUUID = beaconUUID;
}

+ (OMNBeaconUUID *)beaconUUID {
  
  if (nil == _beaconUUID) {
    NSDictionary *beaconInfo = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"OMNBeaconUUID" ofType:@"plist"]];
    _beaconUUID = [[OMNBeaconUUID alloc] initWithJsonData:beaconInfo];
  }
  
  return _beaconUUID;
  
}

- (void)updateWithBeacon:(CLBeacon *)beacon {
  
  dispatch_semaphore_wait(_updateBeaconLock, DISPATCH_TIME_FOREVER);
  
  OMNBeaconSessionInfo *sessionInfo = [[OMNBeaconSessionInfo alloc] initWithBeacon:beacon];
  if (sessionInfo.rssi > kMaxRSSI &&
      sessionInfo.rssi != 0) {
    [_beaconSessionInfo addObject:sessionInfo];
  }
  
  self.accuracy = beacon.accuracy;
  self.proximity = beacon.proximity;
  self.rssi = beacon.rssi;
  
  dispatch_semaphore_signal(_updateBeaconLock);
  
}

- (double)averageRSSI {
  
  if (_beaconSessionInfo.count < 2) {
    return -100;
  }
  
  __block double totalRSSI = 0;
  [_beaconSessionInfo enumerateObjectsUsingBlock:^(OMNBeaconSessionInfo *sessionInfo, NSUInteger idx, BOOL *stop) {
    
    totalRSSI += sessionInfo.rssi;
    
  }];
  return totalRSSI/_beaconSessionInfo.count;

}

- (BOOL)atTheTable {
  
  __block NSInteger totalRSSI = 0;
  [_beaconSessionInfo enumerateObjectsUsingBlock:^(OMNBeaconSessionInfo *sessionInfo, NSUInteger idx, BOOL *stop) {
    
    if (sessionInfo.rssi > kBoardingRSSI) {
      totalRSSI += (sessionInfo.rssi - kBoardingRSSI);
    }
    
  }];
  
  NSLog(@"atTheTableTimes>%d totalRSSI>%d, %@", _beaconSessionInfo.count, totalRSSI, self.key);
  
  return (_beaconSessionInfo.count >= kBeaconDesiredTimesAccuracy &&
          totalRSSI > 0);
  
}

- (BOOL)nearTheTable {
  return (self.rssi > kBoardingRSSI);
}

- (void)removeFromTable {
  _firstImmediateDate = nil;
  [_beaconSessionInfo removeAllObjects];
}

- (void)newIterationBegin {
  
  if (self.atTheTable) {
    [_beaconSessionInfo omn_removeFirstObject];
  }
  
}

- (NSString *)key {
  NSString *uuid = [NSString stringWithFormat:@"%@+%@+%@", self.UUIDString, self.major, self.minor];
  return uuid;
}

- (NSDictionary *)JSONObject {
  
  return @{
           @"uuid" : self.UUIDString,
           @"major" : self.major,
           @"minor" : self.minor,
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

+ (OMNBeacon *)demoBeacon {
  OMNBeacon *beacon = [[OMNBeacon alloc] init];
  beacon.UUIDString = @"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0";
//  beacon.major = @"1";
//  beacon.minor = @"1";

//  iico
  beacon.major = @"1";
  beacon.minor = @"VIP";

//  mexico
//  beacon.major = @"100";
//  beacon.minor = @"3007";
  
//  a-cafe
//  beacon.major = @"A";
//  beacon.minor = @"1";
  
  return beacon;
}
@end
