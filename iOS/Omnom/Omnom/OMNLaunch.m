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

#if (APP_STORE || OMN_TEST)
  
  return kOMNConfigNameProd;
  
#else

  return kOMNConfigNameProd;
  
#endif
}

- (BOOL)shouldReload {
  if (self.wishID || self.openURL) {
    return NO;
  }
  else {
    return YES;
  }
}

- (BOOL)applicationStartedBackground {
  return NO;
}

- (PMKPromise *)getRestaurants {
  
  return [PMKPromise new:^(PMKFulfiller fulfill, PMKRejecter reject) {
    fulfill(nil);
  }];
  
}

@end