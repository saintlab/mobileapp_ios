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

@implementation OMNRestaurantManager {
  
  NSMutableDictionary *_tablePushEvents;
  
}

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

+ (void)decodeBeacons:(NSArray *)beacons withCompletion:(OMNRestaurantsBlock)completionBlock failureBlock:(void(^)(OMNError *error))failureBlock {
  
  NSMutableArray *jsonBeacons = [NSMutableArray arrayWithCapacity:beacons.count];
  [beacons enumerateObjectsUsingBlock:^(OMNBeacon *beacon, NSUInteger idx, BOOL *stop) {
    
    [jsonBeacons addObject:[beacon JSONObject]];
    
  }];
  
  if (![NSJSONSerialization isValidJSONObject:jsonBeacons]) {
    failureBlock([OMNError omnomErrorFromCode:kOMNErrorCodeUnknoun]);
    return;
  }

  NSDictionary *parameters = @{@"beacons" : jsonBeacons};
  
  [[OMNOperationManager sharedManager] POST:@"/v2/decode/ibeacons/omnom" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
  
    [[OMNAnalitics analitics] logDebugEvent:@"BEACON_DECODE_RESPONSE" jsonRequest:parameters jsonResponse:responseObject];
    NSArray *restaurants = [responseObject[@"restaurants"] omn_restaurants];
    completionBlock(restaurants);
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    [[OMNAnalitics analitics] logDebugEvent:@"ERROR_BEACON_DECODE" jsonRequest:parameters responseOperation:operation];
    failureBlock([error omn_internetError]);
    
  }];
  
}

+ (void)demoRestaurantWithCompletion:(OMNRestaurantsBlock)completionBlock failureBlock:(void(^)(OMNError *error))failureBlock {
  
  NSString *path = @"/v2/decode/demo";
  [[OMNOperationManager sharedManager] POST:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    NSArray *restaurants = [responseObject[@"restaurants"] omn_restaurants];
    completionBlock(restaurants);
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    [[OMNAnalitics analitics] logDebugEvent:@"ERROR_DEMO_BEACON" jsonRequest:path responseOperation:operation];
    failureBlock([error omn_internetError]);
    
  }];
  
}

+ (void)decodeQR:(NSString *)qrCode withCompletion:(OMNRestaurantsBlock)completionBlock failureBlock:(void (^)(OMNError *))failureBlock {
  
  NSDictionary *parameters =
  @{
    @"qr": qrCode
    };
  
  [[OMNOperationManager sharedManager] POST:@"/v2/decode/qr" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    NSArray *restaurants = [responseObject[@"restaurants"] omn_restaurants];
    completionBlock(restaurants);
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    [[OMNAnalitics analitics] logDebugEvent:@"ERROR_QR_DECODE" jsonRequest:parameters responseOperation:operation];
    failureBlock([error omn_internetError]);
    
  }];
  
}

+ (void)decodeHash:(NSString *)hash withCompletion:(OMNRestaurantsBlock)completionBlock failureBlock:(void (^)(OMNError *))failureBlock {
  
  NSDictionary *parameters =
  @{
    @"hash": hash
    };
  
  [[OMNOperationManager sharedManager] POST:@"/v2/decode/hash" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    NSArray *restaurants = [responseObject[@"restaurants"] omn_restaurants];
    completionBlock(restaurants);
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    failureBlock([error omn_internetError]);
    
  }];
  
}

- (void)handleBackgroundDecodedRestaurant:(OMNRestaurant *)restaurant withCompletion:(dispatch_block_t)completionBlock {
  
  if (restaurant.hasTable) {
    
    [[OMNDevicePositionManager sharedManager] getDevicePosition:^(BOOL onTable) {
      
      if (onTable) {
        
        [restaurant handleAtTheTableEventWithCompletion:completionBlock];
        
      }
      else {
        
        [restaurant handleEnterEventWithCompletion:completionBlock];
        
      }
      
    }];
    
  }
  else {
    
    [restaurant handleEnterEventWithCompletion:completionBlock];
    
  }
  
}

- (void)handleBackgroundBeacons:(NSArray *)beacons withCompletion:(dispatch_block_t)completionBlock {

  if (!beacons.count) {
    completionBlock();
    return;
  }
  
  __weak typeof(self)weakSelf = self;
  [OMNRestaurantManager decodeBeacons:beacons withCompletion:^(NSArray *restaurants) {
    
    if (1 == restaurants.count) {
      
      OMNRestaurant *restaurant = [restaurants firstObject];
      [weakSelf handleBackgroundDecodedRestaurant:restaurant withCompletion:completionBlock];
      
    }
    else {
      
      completionBlock();
      
    }
    
  } failureBlock:^(OMNError *error) {

    completionBlock();
    
  }];
  
}

@end
