//
//  OMNRestaurantManager.m
//  omnom
//
//  Created by tea on 29.12.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNRestaurantManager.h"
#import "OMNOperationManager.h"
#import "OMNAnalitics.h"
#import "OMNRestaurant+omn_network.h"
#import <OMNDevicePositionManager.h>

@implementation OMNRestaurantManager

+ (instancetype)sharedManager {
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
    
  }
  return self;
}

+ (PMKPromise *)decodeBeacons:(NSArray *)beacons {
  
  NSMutableArray *jsonBeacons = [NSMutableArray arrayWithCapacity:beacons.count];
  [beacons enumerateObjectsUsingBlock:^(OMNBeacon *beacon, NSUInteger idx, BOOL *stop) {
    
    [jsonBeacons addObject:[beacon JSONObject]];
    
  }];
  
  return [PMKPromise new:^(PMKFulfiller fulfill, PMKRejecter reject) {
    
    if (![NSJSONSerialization isValidJSONObject:jsonBeacons]) {
      reject([OMNError omnomErrorFromCode:kOMNErrorCodeUnknoun]);
      return;
    }
    
    NSDictionary *parameters = @{@"beacons" : jsonBeacons};
    
    [[OMNOperationManager sharedManager] POST:@"/v2/decode/ibeacons/omnom" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
      
      [[OMNAnalitics analitics] logDebugEvent:@"BEACON_DECODE_RESPONSE" jsonRequest:parameters jsonResponse:responseObject];
      NSArray *restaurants = [responseObject[@"restaurants"] omn_restaurants];
      fulfill(restaurants);
      
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      
      [[OMNAnalitics analitics] logDebugEvent:@"ERROR_DECODE_BEACON" jsonRequest:parameters responseOperation:operation];
      reject([operation omn_internetError]);
      
    }];

  }];
  
}

+ (void)demoRestaurantWithCompletion:(OMNRestaurantsBlock)completionBlock failureBlock:(void(^)(OMNError *error))failureBlock {
  
  NSString *path = @"/v2/decode/demo";
  [[OMNOperationManager sharedManager] POST:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    NSArray *restaurants = [responseObject[@"restaurants"] omn_restaurants];
    completionBlock(restaurants);
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    [[OMNAnalitics analitics] logDebugEvent:@"ERROR_DEMO_BEACON" jsonRequest:path responseOperation:operation];
    failureBlock([operation omn_internetError]);
    
  }];
  
}

+ (PMKPromise *)decodeQR:(NSString *)qr {
  
  if (![qr isKindOfClass:[NSString class]]) {
    return nil;
  }
  
  NSDictionary *parameters =
  @{
    @"qr": qr
    };
  
  return [PMKPromise new:^(PMKFulfiller fulfill, PMKRejecter reject) {
    
    [[OMNOperationManager sharedManager] POST:@"/v2/decode/qr" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
      
      [[OMNAnalitics analitics] logDebugEvent:@"DECODE_QR_V2_RESPONSE" jsonRequest:parameters responseOperation:operation];
      NSArray *restaurants = [responseObject[@"restaurants"] omn_restaurants];
      fulfill(restaurants);
      
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      
      [[OMNAnalitics analitics] logDebugEvent:@"ERROR_DECODE_QR_V2" jsonRequest:parameters responseOperation:operation];
      reject([operation omn_internetError]);
      
    }];

  }];
  
}

+ (void)decodeHash:(NSString *)hash withCompletion:(OMNRestaurantsBlock)completionBlock failureBlock:(void (^)(OMNError *))failureBlock {
  
  NSDictionary *parameters =
  @{
    @"hash": hash
    };
  
  [[OMNOperationManager sharedManager] POST:@"/v2/decode/hash" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    [[OMNAnalitics analitics] logDebugEvent:@"DECODE_HASH_V2_RESPONSE" jsonRequest:parameters responseOperation:operation];

    NSArray *restaurants = [responseObject[@"restaurants"] omn_restaurants];
    completionBlock(restaurants);
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    [[OMNAnalitics analitics] logDebugEvent:@"ERROR_DECODE_HASH_V2" jsonRequest:parameters responseOperation:operation];
    failureBlock([operation omn_internetError]);
    
  }];
  
}

+ (PMKPromise *)processBackgroundBeacons:(NSArray *)beacons {

  if (!beacons.count) {
    return nil;
  }

  return [OMNRestaurantManager decodeBeacons:beacons].then(^id(NSArray *restaurants) {
    
    if (1 == restaurants.count) {
      
      OMNRestaurant *restaurant = [restaurants firstObject];
      return [restaurant foundInBackground];
      
    }
    else {
      
      return nil;
      
    }
    
  });
  
}


@end
