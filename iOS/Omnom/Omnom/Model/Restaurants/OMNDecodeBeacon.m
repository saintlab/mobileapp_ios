//
//  OMNDecodeBeacon.m
//  restaurants
//
//  Created by tea on 14.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNDecodeBeacon.h"

@implementation OMNDecodeBeacon

- (instancetype)initWithData:(id)data {
  self = [super init];
  if (self) {
    
    _uuid = [data[@"uuid"] description];
    _tableId = [data[@"table_id"] description];
    _restaurantId = [data[@"restaurant_id"] description];
    _foundDate = [NSDate date];
    _restaurant = [[OMNRestaurant alloc] initWithData:data[@"restaurant"]];
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

- (NSString *)description {
  return [NSString stringWithFormat:@"table = %@\nrestaurant = %@", _tableId, _restaurantId];
}

@end
