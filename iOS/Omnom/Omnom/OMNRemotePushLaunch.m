//
//  OMNRemotePushLunch.m
//  omnom
//
//  Created by tea on 19.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNRemotePushLaunch.h"
#import "OMNRestaurantManager.h"

@implementation OMNRemotePushLaunch {
  
  NSString *_qr;
  
}

- (instancetype)initWithRemoteNotification:(NSDictionary *)info {
  
  self = [super init];
  if (![info isKindOfClass:[NSDictionary class]]) {
    return self;
  }

  if (self) {
    
    self.showTableOrders = [info[@"show_table_orders"] omn_boolValueSafe];
    self.showRecommendations = [info[@"show_recommendations"] omn_boolValueSafe];
    _qr = [info[@"qr"] omn_stringValueSafe];
    
    if ([info[@"wish"] isKindOfClass:[NSDictionary class]]) {
      self.wishID = info[@"wish"][@"id"];
    }
    
    NSString *open_url = info[@"open_url"];
    if ([open_url isKindOfClass:[NSString class]]) {
      self.openURL = [NSURL URLWithString:open_url];
    }
    
  }
  return self;
  
}

- (BOOL)shouldReload {
  
  BOOL isAppInactive = UIApplicationStateActive != [UIApplication sharedApplication].applicationState;
  return ([super shouldReload] && isAppInactive);
  
}

- (PMKPromise *)decodeRestaurants {
  
  if (0 == _qr.length) {
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
