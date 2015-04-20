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

- (PMKPromise *)decodeRestaurants {
  
  @weakify(self)
  return [PMKPromise new:^(PMKFulfiller fulfill, PMKRejecter reject) {

    @strongify(self)
    [OMNRestaurantManager decodeQR:self.qr withCompletion:^(NSArray *restaurants) {
      
      fulfill(restaurants);
      
    } failureBlock:^(OMNError *error) {
      
      fulfill(nil);
      
    }];
    
  }];
  
}

@end
