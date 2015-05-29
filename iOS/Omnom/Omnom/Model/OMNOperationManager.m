//
//  OMNOperationManager.m
//  restaurants
//
//  Created by tea on 05.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNOperationManager.h"

static OMNOperationManager *_operationManager = nil;
static NSString *_operationManagerAuthenticationToken = nil;
#import "AFHTTPRequestOperationManager+omn_token.h"

@implementation OMNOperationManager

+ (void)setupWithURL:(NSString *)url headers:(NSDictionary *)headers {

  if (url) {
    _operationManager = [[OMNOperationManager alloc] initWithBaseURL:[NSURL URLWithString:url] headers:headers];
  }
  else {
    _operationManager = nil;
  }
  
}

+ (instancetype)sharedManager {
  return _operationManager;
}

- (instancetype)initWithBaseURL:(NSURL *)url headers:(NSDictionary *)headers {
  self = [super initWithBaseURL:url];
  if (self) {
    
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    [headers enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
      
      [self.requestSerializer setValue:obj forHTTPHeaderField:key];
      
    }];
    [self updateAuthenticationToken];
    
    [self.requestSerializer willChangeValueForKey:NSStringFromSelector(@selector(timeoutInterval))];
    self.requestSerializer.timeoutInterval = 10.0;
    [self.requestSerializer didChangeValueForKey:NSStringFromSelector(@selector(timeoutInterval))];

  }
  return self;
}

+ (void)setAuthenticationToken:(NSString *)token {
  
  _operationManagerAuthenticationToken = token;
  [_operationManager updateAuthenticationToken];
  
}

- (void)updateAuthenticationToken {
  [_operationManager omn_setAuthenticationToken:_operationManagerAuthenticationToken];
}

@end
