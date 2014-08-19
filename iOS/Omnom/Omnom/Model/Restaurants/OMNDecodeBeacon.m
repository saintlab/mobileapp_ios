//
//  OMNDecodeBeacon.m
//  restaurants
//
//  Created by tea on 14.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNDecodeBeacon.h"

@implementation OMNDecodeBeacon {
  id _decodeBeaconData;
}

- (instancetype)initWithJsonData:(id)data {
  self = [super init];
  if (self) {
#warning _demo
//    _demo = YES;
    _decodeBeaconData = data;
    _uuid = [data[@"uuid"] description];
    _table_id = [data[@"table_id"] description];
    _restaurantId = [data[@"restaurant_id"] description];
    _foundDate = [NSDate date];
    _restaurant = [[OMNRestaurant alloc] initWithJsonData:data[@"restaurant"]];
  }
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  _decodeBeaconData = [aDecoder decodeObjectForKey:@"decodeBeaconData"];
  self = [self initWithJsonData:_decodeBeaconData];
  return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
  [aCoder encodeObject:_decodeBeaconData forKey:@"decodeBeaconData"];
}

- (BOOL)readyForPush {
  
  return ([[NSDate date] timeIntervalSinceDate:self.foundDate] > 4*60*60);
  
}

- (NSString *)description {
  return [NSString stringWithFormat:@"table = %@\nrestaurant = %@", _table_id, _restaurantId];
}

@end
