//
//  OMNAuthorizationManager.m
//  restaurants
//
//  Created by tea on 03.06.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNAuthorizationManager.h"
#import "OMNConstants.h"

@implementation OMNAuthorizationManager

+ (instancetype)sharedManager {
  static id manager = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    manager = [[[self class] alloc] initWithBaseURL:[NSURL URLWithString:[OMNConstants authorizationUrlString]]];
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
    self.requestSerializer.timeoutInterval = 15.0;

  }
  return self;
}

@end
