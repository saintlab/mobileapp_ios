//
//  OMNDecodeBeaconManager.m
//  restaurants
//
//  Created by tea on 10.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNVisitorManager.h"
#import "OMNOperationManager.h"
#import "OMNAnalitics.h"
#import "OMNUtils.h"

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
    
    if (responseObject[@"restaurant"]) {
      OMNVisitor *visitor = [[OMNVisitor alloc] initWithJsonData:responseObject];
      successBlock(visitor);
    }
    else {
      [[OMNAnalitics analitics] logDebugEvent:@"ERROR_QR_DECODE" jsonRequest:parameters jsonResponse:responseObject];
      failureBlock([OMNUtils errorFromCode:OMNErrorQrDecode]);
    }
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    [[OMNAnalitics analitics] logDebugEvent:@"ERROR_QR_DECODE" jsonRequest:parameters responseOperation:operation];
    failureBlock([error omn_internetError]);
    
  }];
  
}

- (OMNVisitor *)cachedVisitorForKey:(NSString *)key {

  if (0 == key.length) {
    return nil;
  }
  
  OMNVisitor *cachedVisitor = _visitors[key];
  if (cachedVisitor.expired) {
    [_visitors removeObjectForKey:key];
    [self save];
    cachedVisitor = nil;
  }
  
  return cachedVisitor;
}

- (void)decodeBeacon:(OMNBeacon *)beacon success:(OMNVisitorBlock)success failure:(void (^)(NSError *error))failure; {

  OMNVisitor *visitor = [self cachedVisitorForKey:beacon.key];
  if (visitor) {
    success(visitor);
    return;
  }

  [self decodeBeacons:@[beacon] success:^(NSArray *decodeBeacons) {
    
    success([decodeBeacons firstObject]);
    
  } failure:failure];
}

- (void)demoVisitor:(OMNVisitorBlock)completionBlock failure:(void (^)(NSError *error))failureBlock {
  
  __weak typeof(self)weakSelf = self;
  NSString *path = @"ibeacons/demo";
  [[OMNOperationManager sharedManager] GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
      
      [[OMNAnalitics analitics] logDebugEvent:@"ERROR_DEMO_BEACON" jsonRequest:path jsonResponse:responseObject];
      failureBlock(nil);
      
    }
    else {
      
      NSArray *visitors = [responseObject omn_visitors];
      OMNVisitor *visitor = [visitors firstObject];
      if (visitor) {
        [weakSelf addVisitors:@[visitor]];
        completionBlock(visitor);
      }
      else {
        [[OMNAnalitics analitics] logDebugEvent:@"ERROR_DEMO_BEACON" jsonRequest:path responseOperation:operation];
      }
      
    }
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    [[OMNAnalitics analitics] logDebugEvent:@"ERROR_DEMO_BEACON" jsonRequest:path responseOperation:operation];
    failureBlock(nil);
    
  }];
  
}

- (void)decodeBeacons:(NSArray *)beacons success:(OMNVisitorsBlock)success failure:(void (^)(NSError *error))failure {
  
  if ([OMNConstants useStubBeaconDecodeData]) {
    
    id responseObject = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ibeaconsdecode" ofType:@"json"]] options:0 error:nil];
    NSArray *visitors = [responseObject omn_visitors];
    [self addVisitors:visitors];
    success(visitors);
    return;
  }
  
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
    
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
      
      [[OMNAnalitics analitics] logDebugEvent:@"ERROR_BEACON_DECODE" jsonRequest:jsonBeacons jsonResponse:responseObject];
      failure(nil);
      
    }
    else {
      
      NSLog(@"ibeacons/decode>%lu", (unsigned long)beacons.count);
      NSArray *visitors = [responseObject omn_visitors];
      
      if (0 == visitors.count) {
        [[OMNAnalitics analitics] logDebugEvent:@"ERROR_BEACON_DECODE" jsonRequest:jsonBeacons jsonResponse:responseObject];
      }
      
      [weakSelf addVisitors:visitors];
      success(visitors);
      
    }
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    [[OMNAnalitics analitics] logDebugEvent:@"ERROR_BEACON_DECODE" jsonRequest:jsonBeacons responseOperation:operation];
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
  
  if (NO == [OMNConstants useBackgroundNotifications]) {
    return NO;
  }
  
  if (nil == visitor.id) {
    return NO;
  }
  
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
    [[OMNAnalitics analitics] logDebugEvent:@"push_sent" parametrs:@{@"text" : (at_entrance.greeting ? (at_entrance.greeting) : (@""))}];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
//    if ([localNotification respondsToSelector:@selector(category)]) {
//      [localNotification performSelector:@selector(setCategory:) withObject:@"incomingCall"];
//    }
#pragma clang diagnostic pop

    localNotification.userInfo =
    @{
      OMNDecodeBeaconManagerNotificationLaunchKey : [NSKeyedArchiver archivedDataWithRootObject:visitor],
      };
    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
    
  }
  
}


@end
