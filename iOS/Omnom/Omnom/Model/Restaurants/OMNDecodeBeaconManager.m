//
//  OMNDecodeBeaconManager.m
//  restaurants
//
//  Created by tea on 10.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNDecodeBeaconManager.h"
#import "OMNOperationManager.h"

NSString * const OMNDecodeBeaconManagerNotificationLaunchKey = @"OMNDecodeBeaconManagerNotificationLaunchKey";

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

- (void)decodeBeacons:(NSArray *)beacons success:(OMNBeaconsBlock)success failure:(void (^)(NSError *error))failure {
  
  if (kUseStubBeaconDecodeData) {
    OMNDecodeBeacon *decodeBeacon = [[OMNDecodeBeacon alloc] initWithJsonData:nil];
    decodeBeacon.uuid = @"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0+1+1";
    decodeBeacon.table_id = @"table-1-at-riba-ris";
    decodeBeacon.restaurantId = @"riba-ris";
    success(@[decodeBeacon]);
    return;
  }
  
#warning chache
  /*
  OMNBeacon *beacon = [beacons firstObject];
  if (beacon.key) {
  
    OMNDecodeBeacon *decodeBeacon = _decodedBeacons[beacon.key];
  
    if (decodeBeacon) {
      success(@[decodeBeacon]);
      return;
    }
  
  }
  */
  
  __weak typeof(self)weakSelf = self;
  [[OMNOperationManager sharedManager] PUT:@"ibeacons/decode" parameters:beacons success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    if ([responseObject isKindOfClass:[NSDictionary class]] &&
        responseObject[@"errors"]) {
      
      NSLog(@"ibeacons/decode>%@", responseObject);
      failure(nil);
      
    }
    else {
      
      NSArray *beacons = responseObject;
      NSMutableArray *decodedBeacons = [NSMutableArray arrayWithCapacity:beacons.count];
      [beacons enumerateObjectsUsingBlock:^(id beaconData, NSUInteger idx, BOOL *stop) {
        
        OMNDecodeBeacon *beacon = [[OMNDecodeBeacon alloc] initWithJsonData:beaconData];
        [decodedBeacons addObject:beacon];
        
      }];
      
      [weakSelf addDecodedBecons:decodedBeacons];
      
      success([decodedBeacons copy]);
      
    }
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    NSLog(@"ibeacons/decode>%@", operation.responseString);
    failure(error);
    
  }];
  
}

- (void)handleBackgroundBeacon:(OMNBeacon *)beacon completion:(dispatch_block_t)completion {
  
  if (nil == beacon) {
    completion();
    return;
  }
  
  __weak typeof(self)weakSelf = self;
  NSDictionary *uuid = @{@"uuid" : [beacon uuid]};
  [self decodeBeacons:@[uuid] success:^(NSArray *decodeBeacons) {
    
    OMNDecodeBeacon *decodeBeacon = decodeBeacons.firstObject;
    
    if (decodeBeacon) {
      
      [decodeBeacon.restaurant newGuestForTableID:decodeBeacon.table_id completion:^{
        completion();
      } failure:^(NSError *error) {
        completion();
      }];
      [weakSelf showLocalPushWithBeacon:decodeBeacon];
    }
    else {
      completion();
    }
    
  } failure:^(NSError *error) {
    
    completion();
    
  }];
  
}

- (BOOL)readyForPush:(OMNDecodeBeacon *)decodeBeacon {
#warning readyForPush
  return YES;
  BOOL readyForPush = NO;
  OMNDecodeBeacon *savedBeacon = _decodedBeacons[decodeBeacon.uuid];
  if (nil == savedBeacon ||
      savedBeacon.readyForPush) {
    readyForPush = YES;
    _decodedBeacons[decodeBeacon.uuid] = decodeBeacon;
    [self save];
  }
  
  return readyForPush;
  
}

- (void)showLocalPushWithBeacon:(OMNDecodeBeacon *)decodeBeacon {
  
  if ([self readyForPush:decodeBeacon]) {
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.alertBody = decodeBeacon.restaurantId;
    localNotification.alertAction = NSLocalizedString(@"Запустить", nil);
    localNotification.soundName = kPushSoundName;
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    if ([localNotification respondsToSelector:@selector(category)]) {
      [localNotification performSelector:@selector(setCategory:) withObject:@"incomingCall"];
    }
#pragma clang diagnostic pop

    localNotification.userInfo =
    @{
      OMNDecodeBeaconManagerNotificationLaunchKey : [NSKeyedArchiver archivedDataWithRootObject:decodeBeacon],
      };
    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
    
  }
  
}


@end
