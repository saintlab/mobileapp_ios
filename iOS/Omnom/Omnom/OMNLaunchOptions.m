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
  
  NSDictionary *_launchOptions;
  NSDictionary *_launchQuery;

}

- (instancetype)initWithLocanNotification:(UILocalNotification *)localNotification {
  self = [super init];
  if (self) {
    
    _restaurants = [localNotification omn_restaurants];
    
  }
  return self;
}

- (instancetype)initWithLaunchOptions:(NSDictionary *)launchOptions {
  self = [super init];
  if (self) {
    
    _launchOptions = launchOptions;
    _launchQuery = [launchOptions[UIApplicationLaunchOptionsURLKey] omn_query];
    
  }
  return self;
}

- (instancetype)initWithURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
  self = [super init];
  if (self) {
    
    _launchQuery = [url omn_query];
    
  }
  return self;
}

- (BOOL)applicationWasOpenedByBeacon {
  
  BOOL applicationWasOpenedByBeacon = (_launchOptions[UIApplicationLaunchOptionsLocationKey] != nil);
  return applicationWasOpenedByBeacon;
  
}

- (NSString *)customConfigName {
  
  NSString *launchConfigName = (_launchQuery[@"omnom_config"]) ? (_launchQuery[@"omnom_config"]) : (@"config_prod");
  return launchConfigName;
  
}

- (NSString *)qr {
#warning @"qr-code-for-2-saintlab-iiko";
//  return @"qr-code-for-2-saintlab-iiko";
//  @"qr-code-for-1-ruby-bar-nsk-at-lenina-9";
//  @"qr-code-for-3-travelerscoffee-nsk-at-karla-marksa-7";
//  @"http://omnom.menu/qr/58428fff2c68200b7a6111644d544832";
//  @"qr-code-for-2-saintlab-iiko";
//  @"qr-code-3-at-saintlab-iiko";
//  @"http://omnom.menu/qr/special-and-vip";
//  return @"http://m.2gis.ru/os/";
  return _launchQuery[@"qr"];
  
}

- (NSString *)hashString {
  
//  return @"hash-QWERTY-restaurant-B";
  return _launchQuery[@"hash"];
  
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