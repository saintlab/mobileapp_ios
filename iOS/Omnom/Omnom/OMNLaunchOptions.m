//
//  OMNLaunchOptions.m
//  omnom
//
//  Created by tea on 08.12.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNLaunchOptions.h"
#import "NSURL+omn_query.h"

@interface UILocalNotification (omn_restaurants)

- (NSArray *)omn_restaurants;

@end

@implementation OMNLaunchOptions {
  
  NSDictionary *_launchQuery;

}

- (instancetype)init {
  self = [super init];
  if (self) {
    
    _customConfigName = @"config_prod";
    _applicationWasOpenedByBeacon = NO;
    
#warning _customConfig
//    _customConfigName = @"config_laaaab";

    //  return @"qr-code-for-2-saintlab-iiko";
    //  @"qr-code-for-1-ruby-bar-nsk-at-lenina-9";
    //  @"qr-code-for-3-travelerscoffee-nsk-at-karla-marksa-7";
    //  @"http://omnom.menu/qr/58428fff2c68200b7a6111644d544832";
    //  @"qr-code-for-2-saintlab-iiko";
    //  @"qr-code-3-at-saintlab-iiko";
    //  @"http://omnom.menu/qr/special-and-vip";
    //  return @"http://m.2gis.ru/os/";
    //  _hashString = @"hash-QWERTY-restaurant-B";
    
    
  }
  return self;
}

- (instancetype)initWithRemoteNotification:(NSDictionary *)info {
  
  self = [self init];
  if (self) {
    
    _showTableOrders = [info[@"show_table_orders"] boolValue];
    if (info[@"hash"]) {
      _hashString = info[@"hash"];
    }
    else if (info[@"qr"]) {
      _qr = info[@"qr"];
    }

  }
  return self;
  
}

- (instancetype)initWithLocanNotification:(UILocalNotification *)localNotification {
  self = [self init];
  if (self) {
    
    _restaurants = [localNotification omn_restaurants];
    
  }
  return self;
}

- (instancetype)initWithLaunchOptions:(NSDictionary *)launchOptions {
  self = [self initWithURL:launchOptions[UIApplicationLaunchOptionsURLKey] sourceApplication:nil annotation:nil];
  if (self) {
    
    _applicationWasOpenedByBeacon = (launchOptions[UIApplicationLaunchOptionsLocationKey] != nil);
    
  }
  return self;
}

- (instancetype)initWithURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
  self = [self init];
  if (self) {
    
    NSDictionary *urlQuery = [url omn_query];
    if (urlQuery[@"qr"]) {
      _qr = urlQuery[@"qr"];
    }
    
    if (urlQuery[@"hash"]) {
      _hashString = urlQuery[@"hash"];
    }
    
    if (urlQuery[@"omnom_config"]) {
      _customConfigName = urlQuery[@"omnom_config"];
    }
    
  }
  return self;
}

@end

@implementation UILocalNotification (omn_restaurants)

- (NSArray *)omn_restaurants {
  
  NSArray *restaurants = nil;
  NSData *restaurantData = self.userInfo[OMNRestaurantNotificationLaunchKey];
  if (restaurantData) {
    
    OMNRestaurant *restaurant = [NSKeyedUnarchiver unarchiveObjectWithData:restaurantData];
    if (restaurant) {
      
      restaurants = @[restaurant];
      
    }
  }

  return restaurants;
  
}

@end