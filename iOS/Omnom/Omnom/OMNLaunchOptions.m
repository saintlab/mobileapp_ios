//
//  OMNLaunchOptions.m
//  omnom
//
//  Created by tea on 08.12.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNLaunchOptions.h"
#import "NSURL+omn_query.h"

@implementation OMNLaunchOptions {
  
  NSDictionary *_launchOptions;
  NSDictionary *_launchQuery;
}

- (instancetype)initWithLaunchOptions:(NSDictionary *)launchOptions {
  self = [super init];
  if (self) {
    
    _launchOptions = launchOptions;
    _launchQuery = [launchOptions[UIApplicationLaunchOptionsURLKey] omn_query];
    
  }
  return self;
}

- (NSString *)customConfigName {
  
  NSString *launchConfigName = (_launchQuery[@"omnom_config"]) ? (_launchQuery[@"omnom_config"]) : (@"config_prod");
  return launchConfigName;
  
}

@end
