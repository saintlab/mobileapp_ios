//
//  OMNDecodeBeaconManager.m
//  restaurants
//
//  Created by tea on 10.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNDecodeBeaconManager.h"
#import "OMNOperationManager.h"

@implementation OMNDecodeBeaconManager {
  NSMutableDictionary *_decodedBeacons;
}

+ (instancetype)manager {
  static id manager = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    manager = [[[self class] alloc] init];
  });
  return manager;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    
    @try {
      _decodedBeacons = [NSKeyedUnarchiver unarchiveObjectWithFile:[self path]];
    }
    @catch (NSException *exception) {
    }

    if (nil == _decodedBeacons) {
      _decodedBeacons = [NSMutableDictionary dictionary];
    }

  }
  return self;
}

- (void)save {
  [NSKeyedArchiver archiveRootObject:_decodedBeacons toFile:[self path]];
}

- (NSString *)path {
  
  NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
  NSString *storedBeaconsPath = [documentsDirectory stringByAppendingPathComponent:@"decodedBeacons.dat"];
  return storedBeaconsPath;
  
}

- (void)addDecodedBecons:(NSArray *)decodedBecons {
  
  [decodedBecons enumerateObjectsUsingBlock:^(OMNDecodeBeacon *decodedBeacon, NSUInteger idx, BOOL *stop) {
    
    if (decodedBeacon.uuid) {
      _decodedBeacons[decodedBeacon.uuid] = decodedBeacon;
    }
    
  }];
  [self save];
  
}

- (void)decodeBeacons:(NSArray *)beacons success:(OMNBeaconsBlock)success failure:(OMNErrorBlock)failure {
#warning bd
//  OMNBeacon *beacon = [beacons firstObject];
//  
//  if (beacon.key) {
//    
//    OMNDecodeBeacon *decodeBeacon = _decodedBeacons[beacon.key];
//    
//    if (decodeBeacon) {
//      success(@[decodeBeacon]);
//      return;
//    }
//    
//  }
  
  NSMutableArray *jsonBeacons = [NSMutableArray arrayWithCapacity:beacons.count];
  [beacons enumerateObjectsUsingBlock:^(OMNBeacon *beacon, NSUInteger idx, BOOL *stop) {
    
    [jsonBeacons addObject:[beacon JSONObject]];
    
  }];
  
  if (![NSJSONSerialization isValidJSONObject:jsonBeacons]) {
    failure(nil);
    return;
  }
  
  __weak typeof(self)weakSelf = self;
  [[OMNOperationManager sharedManager] PUT:@"ibeacons/decode" parameters:jsonBeacons success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    NSLog(@"decodeBeaconsresponse>%@", responseObject);
    if ([responseObject isKindOfClass:[NSDictionary class]] &&
        responseObject[@"errors"]) {
      
      failure(nil);
      
    }
    else {

      NSArray *beacons = responseObject;
      NSMutableArray *decodedBeacons = [NSMutableArray arrayWithCapacity:beacons.count];
      [beacons enumerateObjectsUsingBlock:^(id beaconData, NSUInteger idx, BOOL *stop) {
        
        OMNDecodeBeacon *beacon = [[OMNDecodeBeacon alloc] initWithData:beaconData];
        [decodedBeacons addObject:beacon];
        
      }];
      
      [weakSelf addDecodedBecons:decodedBeacons];
      
      success([decodedBeacons copy]);
      
    }
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    failure(error);
    
  }];
  
}



@end
