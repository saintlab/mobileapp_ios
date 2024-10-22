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

@interface OMNBeacon ()

@property (nonatomic, strong) NSMutableArray *beaconSessionInfo;

@end

@implementation OMNBeacon {
  
  dispatch_semaphore_t _updateBeaconLock;
  
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
  return _beaconUUID;
}

- (void)updateWithBeacon:(CLBeacon *)beacon {
  
  dispatch_semaphore_wait(_updateBeaconLock, DISPATCH_TIME_FOREVER);
  
  OMNBeaconSessionInfo *sessionInfo = [[OMNBeaconSessionInfo alloc] initWithBeacon:beacon];
  if (sessionInfo.rssi != 0) {
    
    [_beaconSessionInfo addObject:sessionInfo];
    
  }
  
  self.accuracy = beacon.accuracy;
  self.proximity = beacon.proximity;
  self.rssi = beacon.rssi;
  
  dispatch_semaphore_signal(_updateBeaconLock);
  
}

- (BOOL)nearTheTable {
  
  return (_beaconSessionInfo.count >= kBeaconDesiredTimesAccuracy);
  
}

- (NSString *)key {
  
  NSString *uuid = [NSString stringWithFormat:@"%@+%@+%@", self.UUIDString, self.major, self.minor];
  return uuid;
  
}

- (NSDictionary *)JSONObject {
  
  NSMutableDictionary *json =
  [@{
    @"uuid" : self.UUIDString,
    @"major" : self.major,
    @"minor" : self.minor,
    } mutableCopy];
  NSMutableArray *rssi = [NSMutableArray arrayWithCapacity:_beaconSessionInfo.count];
  [_beaconSessionInfo enumerateObjectsUsingBlock:^(OMNBeaconSessionInfo *beaconSessionInfo, NSUInteger idx, BOOL *stop) {
    
    [rssi addObject:beaconSessionInfo.JSONObject];
    
  }];
  json[@"rssi"] = rssi;
  return json;
  
}

- (NSInteger)totalRSSI {
  
  __block NSInteger totalRSSI = 0;
  [_beaconSessionInfo enumerateObjectsUsingBlock:^(OMNBeaconSessionInfo *sessionInfo, NSUInteger idx, BOOL *stop) {
    totalRSSI += sessionInfo.rssi;
  }];
  
  return totalRSSI;
}

- (NSString *)description {

  return [NSString stringWithFormat:@"%@, %ld, %d, %ld", self.key, (long)self.rssi, self.nearTheTable, self.totalRSSI];
  
}

+ (OMNBeacon *)demoBeacon {
  
  OMNBeacon *beacon = [[OMNBeacon alloc] init];
  beacon.UUIDString = @"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0";
  beacon.major = @"1";
  beacon.minor = @"1002";

  NSDate *date = [NSDate date];
  beacon.beaconSessionInfo =
  @[
    [OMNBeaconSessionInfo infoWithRSSI:-78 timeStamp:date],
    [OMNBeaconSessionInfo infoWithRSSI:-77 timeStamp:date],
    [OMNBeaconSessionInfo infoWithRSSI:-77 timeStamp:date],
    [OMNBeaconSessionInfo infoWithRSSI:-77 timeStamp:date],
    [OMNBeaconSessionInfo infoWithRSSI:-76 timeStamp:date],
    ];
  
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

+ (OMNBeacon *)stuckBeacon {
  
  OMNBeacon *beacon = [[OMNBeacon alloc] init];
  beacon.UUIDString = @"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0";
  beacon.major = @"1";
  beacon.minor = @"2";
  
  NSDate *date = [NSDate date];
  beacon.beaconSessionInfo =
  @[
    [OMNBeaconSessionInfo infoWithRSSI:-77 timeStamp:date],
    [OMNBeaconSessionInfo infoWithRSSI:-77 timeStamp:date],
    [OMNBeaconSessionInfo infoWithRSSI:-77 timeStamp:date],
    [OMNBeaconSessionInfo infoWithRSSI:-77 timeStamp:date],
    [OMNBeaconSessionInfo infoWithRSSI:-77 timeStamp:date],
    ];
  return beacon;
}



@end
