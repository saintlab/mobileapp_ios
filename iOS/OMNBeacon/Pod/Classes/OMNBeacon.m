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
//NSTimeInterval const kTimeToDeleteMarkSec = 1 * 60;

static OMNBeaconUUID *_beaconUUID = nil;

static NSUInteger const kMaxBeaconCount = 7;
static NSUInteger const kBeaconDesiredTimesAccuracy = 5;

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
  if (sessionInfo.rssi != 0) {
    if (kBeaconDesiredTimesAccuracy == _beaconSessionInfo.count) {
      [_beaconSessionInfo removeObjectAtIndex:0];
    }
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
  
  return (_beaconSessionInfo.count >= kBeaconDesiredTimesAccuracy);
  
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

- (NSInteger)totalRSSI {
  
  __block NSInteger totalRSSI = 0;
  [_beaconSessionInfo enumerateObjectsUsingBlock:^(OMNBeaconSessionInfo *sessionInfo, NSUInteger idx, BOOL *stop) {
    totalRSSI += sessionInfo.rssi;
  }];
  
  return totalRSSI;
}

- (NSString *)description {

  return [NSString stringWithFormat:@"%@, %ld, %d %f, %ld", self.key, (long)self.rssi, self.atTheTable, self.atTheTableTime, self.totalRSSI];
  
}

+ (OMNBeacon *)demoBeacon {
  OMNBeacon *beacon = [[OMNBeacon alloc] init];
  beacon.UUIDString = @"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0";
  beacon.major = @"1";
  beacon.minor = @"4";
  beacon.minor = @"1002";

//  b
//  beacon.major = @"B";
//  beacon.minor = @"VIP";
  
//  iico
//  beacon.major = @"A";
//  beacon.minor = @"VIP";

//table-9-at-shashlikoff
//  beacon.UUIDString = @"F93C1AF8-FFB2-488A-A952-A250DB61DEC4";
//  beacon.major = @"101";
//  beacon.minor = @"9";
  
  return beacon;
}
@end
