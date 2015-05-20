//
//  OMNAuthorizationManager.m
//  restaurants
//
//  Created by tea on 03.06.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNAuthorizationManager.h"

static OMNAuthorizationManager *_authorizationManager = nil;

@implementation OMNAuthorizationManager

+ (void)setupWithURL:(NSString *)url headers:(NSDictionary *)headers {
  _authorizationManager = [[OMNAuthorizationManager alloc] initWithBaseURL:[NSURL URLWithString:url] headers:headers];
}

+ (instancetype)sharedManager {
  return _authorizationManager;
}

- (instancetype)initWithBaseURL:(NSURL *)url headers:(NSDictionary *)headers {
  self = [super initWithBaseURL:url];
  if (self) {
    
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    [headers enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
      
      [self.requestSerializer setValue:obj forHTTPHeaderField:key];
      
    }];
    
    [self.requestSerializer willChangeValueForKey:NSStringFromSelector(@selector(timeoutInterval))];
    self.requestSerializer.timeoutInterval = 10.0;
    [self.requestSerializer didChangeValueForKey:NSStringFromSelector(@selector(timeoutInterval))];
    
  }
  return self;
}

@end
