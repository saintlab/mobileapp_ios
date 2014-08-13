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
    OMNDecodeBeacon *decodeBeacon = [[OMNDecodeBeacon alloc] initWithData:nil];
    decodeBeacon.uuid = @"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0+1+1";
    decodeBeacon.tableId = @"table-1-at-riba-ris";
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

- (void)handleBackgroundBeacon:(OMNBeacon *)beacon completion:(dispatch_block_t)completion {
  
  if (nil == beacon) {
    completion();
    return;
  }
  
  __weak typeof(self)weakSelf = self;
  [self decodeBeacons:@[beacon] success:^(NSArray *decodeBeacons) {
    
    OMNDecodeBeacon *decodeBeacon = decodeBeacons.firstObject;
    
    if (decodeBeacon) {
      [weakSelf showLocalPushWithBeacon:decodeBeacon];
    }
    completion();
    
  } failure:^(NSError *error) {
    
    completion();
    
  }];
  
}

- (BOOL)readyForPush:(OMNDecodeBeacon *)decodeBeacon {
#warning push
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
    if ([localNotification respondsToSelector:@selector(category)]) {
      [localNotification performSelector:@selector(setCategory:) withObject:@"incomingCall"];
    }
    localNotification.userInfo =
    @{
      OMNDecodeBeaconManagerNotificationLaunchKey : [NSKeyedArchiver archivedDataWithRootObject:decodeBeacon],
      };
    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
    
  }
  
}


@end
