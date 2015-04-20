//
//  OMNLaunchOptions.m
//  omnom
//
//  Created by tea on 08.12.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNLaunch.h"

@implementation OMNLaunch

- (NSString *)customConfigName {
  return @"config_prod";
}

- (BOOL)applicationStartedBackground {
  return NO;
}

- (PMKPromise *)decodeRestaurants {
  
  return [PMKPromise new:^(PMKFulfiller fulfill, PMKRejecter reject) {
    fulfill(nil);
  }];
  
}

@end