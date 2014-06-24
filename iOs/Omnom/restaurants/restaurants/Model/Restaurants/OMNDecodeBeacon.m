//
//  OMNDecodeBeacon.m
//  restaurants
//
//  Created by tea on 14.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNDecodeBeacon.h"
#import "OMNOperationManager.h"

@implementation OMNDecodeBeacon


- (instancetype)initWithData:(id)data {
  self = [super init];
  if (self) {
    
    _uuid = [data[@"uuid"] description];
    _tableId = [data[@"tableId"] description];
    _restaurantId = [data[@"restaurantId"] description];
    _foundDate = [NSDate date];
    
  }
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  self = [super init];
  if (self) {
    self.uuid = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(uuid))];
    self.tableId = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(tableId))];
    self.restaurantId = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(restaurantId))];
    self.foundDate = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(foundDate))];
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
  [aCoder encodeObject:self.uuid forKey:NSStringFromSelector(@selector(uuid))];
  [aCoder encodeObject:self.tableId forKey:NSStringFromSelector(@selector(tableId))];
  [aCoder encodeObject:self.restaurantId forKey:NSStringFromSelector(@selector(restaurantId))];
  [aCoder encodeObject:self.foundDate forKey:NSStringFromSelector(@selector(foundDate))];
}

- (BOOL)readyForPush {
  
  return ([[NSDate date] timeIntervalSinceDate:self.foundDate] > 4*60*60);
  
}

+ (void)decodeBeacons:(NSArray *)beacons success:(OMNBeaconsBlock)success failure:(OMNErrorBlock)failure {
  
  NSMutableArray *jsonBeacons = [NSMutableArray arrayWithCapacity:beacons.count];
  [beacons enumerateObjectsUsingBlock:^(OMNBeacon *beacon, NSUInteger idx, BOOL *stop) {
    
    [jsonBeacons addObject:[beacon JSONObject]];
    
  }];
  
  if (![NSJSONSerialization isValidJSONObject:jsonBeacons]) {
    failure(nil);
    return;
  }
  
  [[OMNOperationManager sharedManager] PUT:@"ibeacons/decode" parameters:jsonBeacons success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    NSLog(@"decodeBeaconsresponse>%@", responseObject);
    
    NSArray *beacons = responseObject;
    NSMutableArray *decodeBeacons = [NSMutableArray arrayWithCapacity:beacons.count];
    [beacons enumerateObjectsUsingBlock:^(id beaconData, NSUInteger idx, BOOL *stop) {
      
      OMNDecodeBeacon *beacon = [[OMNDecodeBeacon alloc] initWithData:beaconData];
      [decodeBeacons addObject:beacon];
      
    }];
    
    success([decodeBeacons copy]);
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
  
    failure(error);
    
  }];
  
}

- (NSString *)description {
  return [NSString stringWithFormat:@"table = %@\nrestaurant = %@", _tableId, _restaurantId];
}

@end
