//
//  OMNAuthorizationManager.m
//  restaurants
//
//  Created by tea on 03.06.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNAuthorizationManager.h"
#import "AFHTTPResponseSerializer+omn_headers.h"

static OMNAuthorizationManager *_authorizationManager = nil;

@implementation OMNAuthorizationManager

+ (void)setupWithURL:(NSString *)url {
  _authorizationManager = [[OMNAuthorizationManager alloc] initWithBaseURL:[NSURL URLWithString:url]];
}

+ (instancetype)sharedManager {
  return _authorizationManager;
}

- (instancetype)initWithBaseURL:(NSURL *)url {
  self = [super initWithBaseURL:url];
  if (self) {
    
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    [self.requestSerializer omn_addCustomHeaders];
    
  }
  return self;
}

@end
