//
//  OMNBeaconSessionInfo.m
//  beacon
//
//  Created by tea on 10.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNBeaconSessionInfo.h"

@implementation OMNBeaconSessionInfo

- (instancetype)initWithBeacon:(CLBeacon *)beacon {
  self = [super init];
  if (self) {
    self.proximity = beacon.proximity;
    self.rssi = beacon.rssi;
    self.timeStamp = [NSDate date];
  }
  return self;
}

+ (instancetype)infoWithRSSI:(NSInteger)RSSI timeStamp:(NSDate *)timeStamp {
  
  OMNBeaconSessionInfo *beaconSessionInfo = [[OMNBeaconSessionInfo alloc] init];
  beaconSessionInfo.rssi = RSSI;
  beaconSessionInfo.timeStamp = timeStamp;
  return beaconSessionInfo;
  
}

- (NSDictionary *)JSONObject {
  
  return
  @{
    @"value" : @(self.rssi),
    @"time" : [self timeStampString],
    };
  
}

- (NSString *)timeStampString {
  
  static NSDateFormatter *dateFormatter = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    
    dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter setLocale:locale];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
  });
  
  if (self.timeStamp) {
    
    return [dateFormatter stringFromDate:self.timeStamp];
    
  }
  else {
    
    return @"";
    
  }
  
}

@end
