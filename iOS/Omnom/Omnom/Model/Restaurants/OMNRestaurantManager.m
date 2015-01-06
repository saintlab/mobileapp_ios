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
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopWaiterCall) name:OMNSocketIOWaiterCallDoneNotification object:[OMNSocketManager manager]];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderDidChange:) name:OMNSocketIOOrderDidChangeNotification object:[OMNSocketManager manager]];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderDidChange:) name:OMNSocketIOOrderDidPayNotification object:[OMNSocketManager manager]];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderDidClose:) name:OMNSocketIOOrderDidCloseNotification object:[OMNSocketManager manager]];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderDidCreate:) name:OMNSocketIOOrderDidCreateNotification object:[OMNSocketManager manager]];
    
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
  
  [[OMNOperationManager sharedManager] POST:@"/v2/decode/ibeacons/omnom" parameters:@{@"beacons" : jsonBeacons} success:^(AFHTTPRequestOperation *operation, id responseObject) {

    NSArray *restaurants = [responseObject[@"restaurants"] omn_restaurants];
    completionBlock(restaurants);
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    failureBlock([error omn_internetError]);
    
  }];
  
}

+ (void)demoRestaurantWithCompletion:(OMNRestaurantsBlock)completionBlock failureBlock:(void(^)(OMNError *error))failureBlock {
  
  [[OMNOperationManager sharedManager] POST:@"/v2/decode/demo" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    NSArray *restaurants = [responseObject[@"restaurants"] omn_restaurants];
    completionBlock(restaurants);
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    failureBlock([error omn_internetError]);
    
  }];
  
}

+ (void)decodeQR:(NSString *)qrCode withCompletion:(OMNRestaurantsBlock)completionBlock failureBlock:(void (^)(OMNError *))failureBlock {
  
  NSDictionary *parameters =
  @{
    @"qr": qrCode
    };
  
  [[OMNOperationManager sharedManager] PUT:@"/v2/decode/qr" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    NSArray *restaurants = [responseObject[@"restaurants"] omn_restaurants];
    completionBlock(restaurants);
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    failureBlock([error omn_internetError]);
    
  }];
  
}

+ (void)decodeHash:(NSString *)hash withCompletion:(OMNRestaurantsBlock)completionBlock failureBlock:(void (^)(OMNError *))failureBlock {
  
  NSDictionary *parameters =
  @{
    @"hash": hash
    };
  
  [[OMNOperationManager sharedManager] PUT:@"/v2/decode/hash" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    NSArray *restaurants = [responseObject[@"restaurants"] omn_restaurants];
    completionBlock(restaurants);
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    failureBlock([error omn_internetError]);
    
  }];
  
}


@end
