//
//  OMNDecodeBeacon.m
//  restaurants
//
//  Created by tea on 14.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNDecodeBeacon.h"
#import "GDefaultClient.h"

@implementation OMNDecodeBeacon


- (instancetype)initWithData:(id)data {
  self = [super init];
  if (self) {
    
    self.major = @([data[@"major"] integerValue]);
    self.minor = @([data[@"minor"] integerValue]);

//    _table = [[OMNTable alloc] initWithData:data];
//    _restaurant = [[OMNRestaurant alloc] init];
//    _restaurant.ID = data[@"restaurantId"];
//    _restaurant.title = data[@"restaurantId"];
    
    _tableId = data[@"tableId"];
    _restaurantId = data[@"restaurantId"];
    
  }
  return self;
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
  
  NSError *error = nil;
  NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonBeacons options:0 error:&error];
  
  if (error) {
    failure(error);
    return;
  }
  
  [[GDefaultClient sharedClient] PUT:@"ibeacons/decode" parameters:nil body:jsonData success:^(NSURLSessionDataTask *task, id responseObject) {
    
    NSLog(@"decodeBeaconsresponse>%@", responseObject);
    
    NSArray *beacons = responseObject;
    NSMutableArray *decodeBeacons = [NSMutableArray arrayWithCapacity:beacons.count];
    [beacons enumerateObjectsUsingBlock:^(id beaconData, NSUInteger idx, BOOL *stop) {
      
      OMNDecodeBeacon *beacon = [[OMNDecodeBeacon alloc] initWithData:beaconData];
      [decodeBeacons addObject:beacon];
      
    }];
    
    success([decodeBeacons copy]);
    
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    
    failure(error);
    
  }];
  
}

- (NSString *)description {
  return [NSString stringWithFormat:@"table = %@\nrestaurant = %@", _tableId, _restaurantId];
}

@end
