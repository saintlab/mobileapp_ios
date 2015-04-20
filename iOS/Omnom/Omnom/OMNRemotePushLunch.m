//
//  OMNRemotePushLunch.m
//  omnom
//
//  Created by tea on 19.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNRemotePushLunch.h"
#import "OMNRestaurantManager.h"

@implementation OMNRemotePushLunch {
  
  NSString *_qr;
  
}

- (instancetype)initWithRemoteNotification:(NSDictionary *)info {
  
  self = [self init];
  if (self) {
    
    self.showTableOrders = [info[@"show_table_orders"] boolValue];
    self.showRecommendations = [info[@"show_recommendations"] boolValue];
    _qr = info[@"qr"];
    
  }
  return self;
  
}

- (PMKPromise *)decodeRestaurants {
  
  if (!_qr) {
    return [super decodeRestaurants];
  }
  
  NSString *qr = _qr;
  return [PMKPromise new:^(PMKFulfiller fulfill, PMKRejecter reject) {
    
    [OMNRestaurantManager decodeQR:qr withCompletion:^(NSArray *restaurants) {
      
      fulfill(restaurants);
      
    } failureBlock:^(OMNError *error) {
      
      fulfill(nil);
      
    }];
    
  }];
  
}

@end
