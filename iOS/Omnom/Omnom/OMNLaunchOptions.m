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
    
#warning run with custom qr codes
    //  searchRestaurantVC.qr = @"qr-code-for-1-ruby-bar-nsk-at-lenina-9";
    //  searchRestaurantVC.qr = @"qr-code-for-3-travelerscoffee-nsk-at-karla-marksa-7";
    //  searchRestaurantVC.qr = @"http://omnom.menu/qr/58428fff2c68200b7a6111644d544832";
    //  searchRestaurantVC.qr = @"qr-code-for-2-saintlab-iiko";
    //  searchRestaurantVC.qr = @"qr-code-3-at-saintlab-iiko";
    //  searchRestaurantVC.qr = @"http://omnom.menu/qr/special-and-vip";
    //  searchRestaurantVC.qr = @"http://m.2gis.ru/os/";
    
    //  searchRestaurantVC.hashString = @"hash-QWERTY-restaurant-B";
    
    //  NSData *decodeBeaconData = self.info[OMNVisitorNotificationLaunchKey];
    //  if (decodeBeaconData) {
    //    OMNVisitor *visitor = [NSKeyedUnarchiver unarchiveObjectWithData:decodeBeaconData];
    //    searchRestaurantVC.visitor = visitor;
    //  }
    
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
  
//  return @"qr-code-for-2-saintlab-iiko";
#warning - (NSString *)qr
  return _launchQuery[@"qr"];
  
}

- (NSString *)hashString {
  
  return _launchQuery[@"hash"];
  
}

- (NSArray *)restaurants {
  
  return nil;
  
}

@end
