//
//  OMNAuthorizationManager.m
//  restaurants
//
//  Created by tea on 03.06.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNAuthorizationManager.h"
#import "OMNConstants.h"
#import "AFHTTPResponseSerializer+omn_headers.h"

@implementation OMNAuthorizationManager

+ (instancetype)sharedManager {
  static id manager = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    manager = [[self alloc] initWithBaseURL:[NSURL URLWithString:[OMNConstants authorizationUrlString]]];
  });
  return manager;
}

- (instancetype)initWithBaseURL:(NSURL *)url {
  self = [super initWithBaseURL:url];
  if (self) {
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    self.requestSerializer.timeoutInterval = 10.0;
    [self.requestSerializer omn_addCustomHeaders];
    
  }
  return self;
}

@end
