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
    if (info[@"qr"]) {
      _qr = [info[@"qr"] omn_stringValueSafe];
    }
    else {
      _qr = [info[@"hash"] omn_stringValueSafe];
    }
    
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

- (PMKPromise *)getRestaurants {
  
  if ([_qr isKindOfClass:[NSString class]]) {
    
    return [OMNRestaurantManager decodeQR:_qr];
    
  }
  else {
    
    return [super getRestaurants];
    
  }
    
}

@end
