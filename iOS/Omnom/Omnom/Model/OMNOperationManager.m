//
//  OMNOperationManager.m
//  restaurants
//
//  Created by tea on 05.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNOperationManager.h"
#import "AFHTTPResponseSerializer+omn_headers.h"

static OMNOperationManager *_operationManager = nil;

@implementation OMNOperationManager

+ (void)setupWithURL:(NSString *)url {
  _operationManager = [[OMNOperationManager alloc] initWithBaseURL:[NSURL URLWithString:url]];
}

+ (instancetype)sharedManager {
  return _operationManager;
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
