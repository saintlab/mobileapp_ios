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
    
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    self.requestSerializer = [AFJSONRequestSerializer serializer];
  }
  return self;
}

- (BOOL)isReachable {
  return _reachabilityManager.isReachable;
}

@end
