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
#import "OMNError.h"

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
      
      [[OMNAnalitics analitics] logDebugEvent:@"ERROR_QR_DECODE" jsonRequest:parameters responseOperation:operation];
      failureBlock([OMNError omnomErrorFromCode:kOMNErrorCodeQrDecode]);
      
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

- (void)decodeBeacon:(OMNBeacon *)beacon success:(OMNVisitorBlock)success failure:(void (^)(OMNError *error))failure; {

  OMNVisitor *visitor = [self cachedVisitorForKey:beacon.key];
  if (visitor) {
    success(visitor);
    return;
  }

  [self decodeBeacons:@[beacon] success:^(NSArray *decodeBeacons) {
    
    success([decodeBeacons firstObject]);
    
  } failure:failure];
}

- (void)demoVisitor:(OMNVisitorBlock)completionBlock failure:(void (^)(OMNError *error))failureBlock {
  
  __weak typeof(self)weakSelf = self;
  NSString *path = @"/ibeacons/demo";
  [[OMNOperationManager sharedManager] GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    if ([responseObject isKindOfClass:[NSArray class]]) {
      
      NSArray *visitors = [responseObject omn_visitors];
      OMNVisitor *visitor = [visitors firstObject];
      if (visitor) {
        
        [weakSelf addVisitors:@[visitor]];
        completionBlock(visitor);
        
      }
      else {
        
        [[OMNAnalitics analitics] logDebugEvent:@"ERROR_DEMO_BEACON" jsonRequest:path responseOperation:operation];
        failureBlock([OMNError omnomErrorFromCode:kOMNErrorCodeUnknoun]);
        
      }
      
    }
    else {
      
      [[OMNAnalitics analitics] logDebugEvent:@"ERROR_DEMO_BEACON" jsonRequest:path jsonResponse:responseObject];
      failureBlock([OMNError omnomErrorFromCode:kOMNErrorCodeUnknoun]);
      
    }
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    [[OMNAnalitics analitics] logDebugEvent:@"ERROR_DEMO_BEACON" jsonRequest:path responseOperation:operation];
    failureBlock([error omn_internetError]);
    
  }];
  
}

- (void)decodeBeacons:(NSArray *)beacons success:(OMNVisitorsBlock)success failure:(void (^)(OMNError *error))failure {
  
  NSMutableArray *jsonBeacons = [NSMutableArray arrayWithCapacity:beacons.count];
  [beacons enumerateObjectsUsingBlock:^(OMNBeacon *beacon, NSUInteger idx, BOOL *stop) {
    
    [jsonBeacons addObject:[beacon JSONObject]];
    
  }];
  
  if (![NSJSONSerialization isValidJSONObject:jsonBeacons]) {
    failure([OMNError omnomErrorFromCode:kOMNErrorCodeUnknoun]);
    return;
  }
  
  __weak typeof(self)weakSelf = self;
  [[OMNOperationManager sharedManager] PUT:@"ibeacons/decode" parameters:jsonBeacons success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    if ([responseObject isKindOfClass:[NSArray class]]) {
      
      NSLog(@"ibeacons/decode>%lu", (unsigned long)beacons.count);
      NSArray *visitors = [responseObject omn_visitors];
      
      if (0 == visitors.count) {
        [[OMNAnalitics analitics] logDebugEvent:@"ERROR_BEACON_DECODE" jsonRequest:jsonBeacons jsonResponse:responseObject];
      }
      
      [weakSelf addVisitors:visitors];
      success(visitors);
      
    }
    else {
      
      [[OMNAnalitics analitics] logDebugEvent:@"ERROR_BEACON_DECODE" jsonRequest:jsonBeacons responseOperation:operation];
      failure([OMNError omnomErrorFromCode:kOMNErrorCodeUnknoun]);
      
    }
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    [[OMNAnalitics analitics] logDebugEvent:@"ERROR_BEACON_DECODE" jsonRequest:jsonBeacons responseOperation:operation];
    failure([error omn_internetError]);
    
  }];
  
}

- (void)handleBackgroundBeacon:(OMNBeacon *)beacon completion:(dispatch_block_t)completion {
  
  if (nil == beacon) {
    completion();
    return;
  }
  
  [self decodeBeacon:beacon success:^(OMNVisitor *visitor) {
    
    if (visitor) {
      
      [visitor showGreetingPush];
      [[OMNAnalitics analitics] logEnterRestaurant:visitor foreground:NO];
      
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

@end
