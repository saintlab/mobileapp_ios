//
//  OMNLaunchHandler.m
//  omnom
//
//  Created by tea on 10.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNLaunchHandler.h"

@implementation OMNLaunchHandler

+ (instancetype)sharedHandler {
  static id manager = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    manager = [[[self class] alloc] init];
  });
  return manager;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    
  }
  return self;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
  
  OMNLaunchOptions *lo = [[OMNLaunchOptions alloc] initWithURL:url sourceApplication:sourceApplication annotation:annotation];
  [self.delegate launchHandler:self didReceiveLaunchOptions:lo];
  
  return YES;
  
}

@end
