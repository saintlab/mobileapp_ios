//
//  OMNQRLaunch.m
//  omnom
//
//  Created by tea on 17.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNQRLaunch.h"
#import "OMNRestaurantManager.h"

@implementation OMNQRLaunch

- (instancetype)initWithQR:(NSString *)qr config:(NSString *)config {
  self = [super init];
  if (self) {
    
    self.qr = qr;
    self.config = config;
    
  }
  return self;
}

- (NSString *)customConfigName {
  return (self.config) ?: ([super customConfigName]);
}

- (PMKPromise *)getRestaurants {
  return [OMNRestaurantManager decodeQR:self.qr];
}

@end
