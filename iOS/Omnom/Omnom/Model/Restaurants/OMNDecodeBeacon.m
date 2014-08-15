//
//  OMNDecodeBeacon.m
//  restaurants
//
//  Created by tea on 14.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNDecodeBeacon.h"

@implementation OMNDecodeBeacon {
  id _restaurantData;
}

- (instancetype)initWithData:(id)data {
  self = [super init];
  if (self) {
    _uuid = [data[@"uuid"] description];
    _table_id = [data[@"table_id"] description];
    _restaurantId = [data[@"restaurant_id"] description];
    _foundDate = [NSDate date];
    _restaurantData = data[@"restaurant"];
    _restaurant = [[OMNRestaurant alloc] initWithData:_restaurantData];
  }
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  self = [super init];
  if (self) {
    self.uuid = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(uuid))];
    self.table_id = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(tableId))];
    self.restaurantId = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(restaurantId))];
    self.foundDate = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(foundDate))];
    _restaurantData = [aDecoder decodeObjectForKey:@"restaurantData"];
    self.restaurant = [[OMNRestaurant alloc] initWithData:_restaurantData];
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
  [aCoder encodeObject:self.uuid forKey:NSStringFromSelector(@selector(uuid))];
  [aCoder encodeObject:self.table_id forKey:NSStringFromSelector(@selector(tableId))];
  [aCoder encodeObject:self.restaurantId forKey:NSStringFromSelector(@selector(restaurantId))];
  [aCoder encodeObject:self.foundDate forKey:NSStringFromSelector(@selector(foundDate))];
  [aCoder encodeObject:_restaurantData forKey:@"restaurantData"];
}

- (BOOL)readyForPush {
  
  return ([[NSDate date] timeIntervalSinceDate:self.foundDate] > 4*60*60);
  
}

- (NSString *)description {
  return [NSString stringWithFormat:@"table = %@\nrestaurant = %@", _table_id, _restaurantId];
}

@end
