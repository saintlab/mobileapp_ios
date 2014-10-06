//
//  OMNBeaconUUID.m
//  Pods
//
//  Created by tea on 12.09.14.
//
//

#import "OMNBeaconUUID.h"
#import <CoreLocation/CoreLocation.h>

@interface NSArray (omn_regions)

- (NSArray *)omn_regionsWithIdentifier:(NSString *)identifier;

@end

@implementation OMNBeaconUUID {
  id _jsonData;
  NSArray *_activeUUIDs;
  NSArray *_deprecatedUUIDs;
}

- (instancetype)initWithJsonData:(id)jsonData {
  self = [super init];
  if (self) {
    _jsonData = jsonData;
    NSArray *active = jsonData[@"active"];
    NSMutableArray *activeUUIDs = [NSMutableArray arrayWithCapacity:active.count];
    [active enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
      NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:obj];
      [activeUUIDs addObject:uuid];
    }];
    _activeUUIDs = activeUUIDs;
    
    NSArray *deprecated = jsonData[@"deprecated"];
    NSMutableArray *deprecatedUUIDs = [NSMutableArray arrayWithCapacity:deprecated.count];
    [deprecated enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
      NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:obj];
      [deprecatedUUIDs addObject:uuid];
    }];
    _deprecatedUUIDs = deprecatedUUIDs;
    
  }
  return self;
}

- (NSArray *)aciveBeaconsRegionsWithIdentifier:(NSString *)identifier {
  
  return [_activeUUIDs omn_regionsWithIdentifier:identifier];
}

- (NSArray *)deprecatedBeaconsRegionsWithIdentifier:(NSString *)identifier {
  
  return [_deprecatedUUIDs omn_regionsWithIdentifier:identifier];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  
  id jsonData = [aDecoder decodeObjectForKey:@"jsonData"];
  self = [self initWithJsonData:jsonData];
  if (self) {
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
  [aCoder encodeObject:_jsonData forKey:@"jsonData"];
}

@end

@implementation NSArray (omn_regions)

- (NSArray *)omn_regionsWithIdentifier:(NSString *)identifier {
  
  NSMutableArray *regions = [NSMutableArray array];
  [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    
    if ([obj isKindOfClass:[NSUUID class]]) {
      NSString *indexedIdentifier = [NSString stringWithFormat:@"%@-%d", identifier, idx];
      CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:obj identifier:indexedIdentifier];
      beaconRegion.notifyOnEntry = YES;
      beaconRegion.notifyOnExit = YES;
      [regions addObject:beaconRegion];
    }
    
  }];
  return regions;
  
}

@end
