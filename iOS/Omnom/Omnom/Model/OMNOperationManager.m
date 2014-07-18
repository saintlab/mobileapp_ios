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
  AFNetworkReachabilityManager *_reachabilityManager;

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
    
    _reachabilityManager = [AFNetworkReachabilityManager managerForDomain:url.host];
    [_reachabilityManager startMonitoring];
    __unused BOOL isReachable = _reachabilityManager.isReachable;
    
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    self.requestSerializer = [AFJSONRequestSerializer serializer];
  }
  return self;
}

- (void)getReachableState:(void(^)(BOOL isReachable))isReachableBlock {

  if (AFNetworkReachabilityStatusUnknown == _reachabilityManager.networkReachabilityStatus) {
    
    __weak typeof(_reachabilityManager)weakManager = _reachabilityManager;
    [_reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
      
      isReachableBlock(weakManager.isReachable);
      
    }];
    
  }
  else {
    isReachableBlock(_reachabilityManager.isReachable);
  }
  
}

- (BOOL)isReachable {
  NSLog(@"%d", _reachabilityManager.networkReachabilityStatus);
  return _reachabilityManager.isReachable;
}

@end
