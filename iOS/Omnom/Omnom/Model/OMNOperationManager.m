//
//  OMNOperationManager.m
//  restaurants
//
//  Created by tea on 05.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNOperationManager.h"
#import "OMNConstants.h"

@implementation OMNOperationManager {
  AFNetworkReachabilityManager *_omnomReachabilityManager;
  AFNetworkReachabilityManager *_internetReachabilityManager;
}

+ (instancetype)sharedManager {
  static id manager = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    manager = [[[self class] alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrlString]];
  });
  return manager;
}

- (instancetype)initWithBaseURL:(NSURL *)url {
  self = [super initWithBaseURL:url];
  if (self) {
    
    _omnomReachabilityManager = [AFNetworkReachabilityManager managerForDomain:url.host];
    [_omnomReachabilityManager startMonitoring];
    __unused BOOL or = _omnomReachabilityManager.isReachable;
    
    _internetReachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [_internetReachabilityManager startMonitoring];
    __unused BOOL ir = _internetReachabilityManager.isReachable;
    
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    self.requestSerializer = [AFJSONRequestSerializer serializer];
  }
  return self;
}

- (void)getReachableState:(void(^)(OMNReachableState reachableState))isReachableBlock {

  if (AFNetworkReachabilityStatusUnknown == _omnomReachabilityManager.networkReachabilityStatus) {
    
    __weak typeof(_omnomReachabilityManager)weakManager = _omnomReachabilityManager;
    __weak typeof(self)weakSelf = self;
    [_omnomReachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
      
      [weakManager setReachabilityStatusChangeBlock:nil];
      
      if (weakManager.isReachable) {
        isReachableBlock(kOMNReachableStateIsReachable);
      }
      else {
        [weakSelf getInternetReachableState:isReachableBlock];
      }
      
    }];
    
  }
  else if (_omnomReachabilityManager.isReachable) {
    
    isReachableBlock(kOMNReachableStateIsReachable);
    
  }
  else {
    
    [self getInternetReachableState:isReachableBlock];
    
  }
  
}

- (void)getInternetReachableState:(void(^)(OMNReachableState reachableState))isReachableBlock {

  if(AFNetworkReachabilityStatusUnknown == _internetReachabilityManager.networkReachabilityStatus) {
    
    __weak typeof(_internetReachabilityManager)weakManager = _internetReachabilityManager;
    __weak typeof(self)weakSelf = self;
    [_internetReachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
      
      [weakManager setReachabilityStatusChangeBlock:nil];
      [weakSelf updateInternetReachableState:isReachableBlock];
      
    }];
    
  }
  else {
    
    [self updateInternetReachableState:isReachableBlock];
    
  }
  
}

- (void)updateInternetReachableState:(void(^)(OMNReachableState reachableState))isReachableBlock {
  
  if (_internetReachabilityManager.isReachable &&
      !_omnomReachabilityManager.isReachable) {
    isReachableBlock(kOMNReachableStateNoOmnom);
  }
  else {
    isReachableBlock(kOMNReachableStateNoInternet);
  }
  
}

- (void)cardsWithCompletion:(void(^)(NSArray *cards))completionBlock failure:(void(^)(NSError *error))failureBlock {
  
  NSAssert(completionBlock != nil, @"completionBlock is nil");
  NSAssert(failureBlock != nil, @"complitionBlock is nil");
  
  NSString *path = [NSString stringWithFormat:@"/cards"];
  [self GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id response) {
    
    if (response[@"cards"]) {
      completionBlock(response[@"cards"]);
    }
    else {
      failureBlock(nil);
    }
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    failureBlock(error);
    
  }];
}

@end
