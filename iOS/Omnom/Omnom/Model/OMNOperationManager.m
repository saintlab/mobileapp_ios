//
//  OMNOperationManager.m
//  restaurants
//
//  Created by tea on 05.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNOperationManager.h"
#import "OMNConstants.h"
#import <UIDevice-Reachability.h>

@implementation OMNOperationManager {
}

+ (instancetype)sharedManager {
  static id manager = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    manager = [[[self class] alloc] initWithBaseURL:[NSURL URLWithString:[OMNConstants baseUrlString]]];
  });
  return manager;
}

- (instancetype)initWithBaseURL:(NSURL *)url {
  self = [super initWithBaseURL:url];
  if (self) {
    
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    [self.requestSerializer setValue:CURRENT_BUILD forHTTPHeaderField:@"current-app-build"];
    [self.requestSerializer setValue:CURRENT_VERSION forHTTPHeaderField:@"current-app-version"];
    [self.requestSerializer setValue:CURRENT_BUILD forHTTPHeaderField:@"x-current-app-build"];
    [self.requestSerializer setValue:CURRENT_VERSION forHTTPHeaderField:@"x-current-app-version"];
    self.requestSerializer.timeoutInterval = 10.0;

  }
  return self;
}

- (OMNReachableState)reachableState {
  
  OMNReachableState reachableState = kOMNReachableStateNoInternet;
  if ([[UIDevice currentDevice] networkAvailable]) {
    
    reachableState = kOMNReachableStateIsReachable;
    
  }
  else {
    
    reachableState = kOMNReachableStateNoInternet;
    
  }

  return reachableState;
  
}

@end
