//
//  OMNDecodeBeaconManager.m
//  restaurants
//
//  Created by tea on 10.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNVisitorManager.h"
#import "OMNOperationManager.h"

NSString * const OMNDecodeBeaconManagerNotificationLaunchKey = @"OMNDecodeBeaconManagerNotificationLaunchKey";

@implementation OMNVisitorManager {
  NSMutableDictionary *_visitors;
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
      _visitors = [NSKeyedUnarchiver unarchiveObjectWithFile:[self path]];
    }
    @catch (NSException *exception) {
    }
    
    if (nil == _visitors) {
      _visitors = [NSMutableDictionary dictionary];
    }
    
  }
  return self;
}

- (void)save {
  [NSKeyedArchiver archiveRootObject:_visitors toFile:[self path]];
}

- (NSString *)path {
  
  NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
  NSString *storedBeaconsPath = [documentsDirectory stringByAppendingPathComponent:@"visitors.dat"];
  return storedBeaconsPath;
  
}

- (void)addVisitors:(NSArray *)visitors {
  
  [visitors enumerateObjectsUsingBlock:^(OMNVisitor *visitor, NSUInteger idx, BOOL *stop) {
    
    if (visitor.id) {
      _visitors[visitor.id] = visitor;
    }
    
  }];
  [self save];
  
}

- (void)decodeQRCode:(NSString *)qrCode success:(OMNVisitorBlock)successBlock failure:(void (^)(NSError *error))failureBlock {
  
  if (0 == qrCode.length) {
    failureBlock(nil);
    return;
  }
  
  NSDictionary *parameters =
  @{
    @"qr": qrCode
    };
  
  [[OMNOperationManager sharedManager] PUT:@"/qr/decode" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    NSLog(@"\nqr/decode>\n%@", responseObject);
    if (responseObject[@"restaurant"]) {
      OMNVisitor *visitor = [[OMNVisitor alloc] initWithJsonData:responseObject];
      successBlock(visitor);
    }
    else {
      failureBlock(nil);
    }
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    NSLog(@"\nqr/decode>\n%@", operation.responseString);
    failureBlock(nil);
    
  }];
  
}

- (void)decodeBeacon:(OMNBeacon *)beacon success:(OMNVisitorBlock)success failure:(void (^)(NSError *error))failure; {
  
  [self decodeBeacons:@[beacon] success:^(NSArray *decodeBeacons) {
    
    success([decodeBeacons firstObject]);
    
  } failure:failure];
}

- (void)decodeBeacons:(NSArray *)beacons success:(OMNVisitorsBlock)success failure:(void (^)(NSError *error))failure {
  
  if ([OMNConstants useStubBeaconDecodeData]) {
    
    id responseObject = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ibeaconsdecode" ofType:@"json"]] options:0 error:nil];
    NSArray *visitors = [responseObject omn_visitors];
    [self addVisitors:visitors];
    success(visitors);
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
      
      NSLog(@"ibeacons/decode>%@", responseObject);
      failure(nil);
      
    }
    else {
      
      NSLog(@"ibeacons/decode>%lu", (unsigned long)beacons.count);
      NSArray *visitors = [responseObject omn_visitors];
      [weakSelf addVisitors:visitors];
      success(visitors);
      
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
  
  [self decodeBeacon:beacon success:^(OMNVisitor *visitor) {
    
    if (visitor) {
      
      [weakSelf showLocalPushForVisitor:visitor];
      
      [visitor newGuestWithCompletion:^{
        completion();
      } failure:^(NSError *error) {
        completion();
      }];
      
    }
    else {
      completion();
    }

    
  } failure:^(NSError *error) {
    
    completion();
    
  }];
  
}

- (BOOL)readyForPush:(OMNVisitor *)visitor {
  
  if (UIApplicationStateActive == [UIApplication sharedApplication].applicationState) {
    return NO;
  }
  
#warning readyForPush
  return YES;
  BOOL readyForPush = NO;
  OMNVisitor *savedVisitor = _visitors[visitor.id];
  if (nil == savedVisitor ||
      savedVisitor.readyForPush) {
    readyForPush = YES;
    _visitors[visitor.id] = visitor;
    [self save];
  }
  
  return readyForPush;
  
}

- (void)showLocalPushForVisitor:(OMNVisitor *)visitor {
  
  if ([self readyForPush:visitor]) {
    
    OMNPushText *at_entrance = visitor.restaurant.mobile_texts.at_entrance;
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    
    localNotification.alertBody = at_entrance.greeting;
    localNotification.alertAction = at_entrance.open_action;
    localNotification.soundName = kPushSoundName;
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    if ([localNotification respondsToSelector:@selector(category)]) {
      [localNotification performSelector:@selector(setCategory:) withObject:@"incomingCall"];
    }
#pragma clang diagnostic pop

    localNotification.userInfo =
    @{
      OMNDecodeBeaconManagerNotificationLaunchKey : [NSKeyedArchiver archivedDataWithRootObject:visitor],
      };
    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
    
  }
  
}


@end
