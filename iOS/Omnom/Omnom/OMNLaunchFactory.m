//
//  OMNLaunchFactory.m
//  omnom
//
//  Created by tea on 17.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNLaunchFactory.h"
#import "NSURL+omn_query.h"
#import "OMNQRLaunch.h"
#import "OMNBackgroundLaunch.h"
#import "OMNDefaultLaunch.h"
#import "OMNRemotePushLunch.h"
#import "OMNTravelersLaunch.h"

@implementation OMNLaunchFactory

+ (OMNLaunch *)launchWithURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {

  NSDictionary *urlQuery = [url omn_query];
  NSString *customConfigName = urlQuery[@"omnom_config"];
  if (urlQuery[@"qr"]) {
    return [[OMNQRLaunch alloc] initWithQR:urlQuery[@"qr"] config:customConfigName];
  }
  else {
    return [[OMNDefaultLaunch alloc] init];
  }

}

+ (OMNLaunch *)launchWithLaunchOptions:(NSDictionary *)launchOptions {
  
#if OMN_TEST
  return [[OMNLaunch alloc] init];
#elif LUNCH_2GIS
  return [[OMNQRLaunch alloc] initWithQR:@"qr-code-for-0-lunch2gis" config:nil];
#elif LUNCH_2GIS_SUNCITY
  return [[OMNQRLaunch alloc] initWithQR:@"qr-code-for-0-lunch2gis-sun-city" config:@"config_staging"];
#elif OMN_TRAVELERS
  return [[OMNTravelersLaunch alloc] init];
#elif TARGET_IPHONE_SIMULATOR

  NSString *customConfigName = @"config_prod";
  NSString *qr = @"";
  
//  staging
//  customConfigName = @"config_staging";
//  qr = @"http://omnom.menu/zr9b"; //saintlab-iiko-dev
//  qr =  @"qr-code-for-2-saintlab-iiko-dev"; //staging
//  
//  prod
//  qr = @"qr-code-for-4-ruby-bar-nsk-at-lenina-9"; //rubi
//  qr = @"qr-code-for-0-harats-tomsk";
//  qr = @"qr-code-for-0-lunch2gis";
//  qr = @"http://omnom.menu/qr-hash-for-table-5-at-saintlab-rkeeper-v6";
//  qr = @"qr-code-for-1-riba-ris-nsk-at-aura";
//  qr = @"qr-code-for-2-saintlab-iiko";
//  qr = @"http://omnom.menu/qr/d5495734ed5491655234e528d50972e9"; //бирман
//  qr = @"http://omnom.menu/qr/8eab9af3006a4fb0cd0bd92836e90130"; //мехико
//  qr = @"qr-code-for-1-ruby-bar-nsk-at-lenina-9"; //руби
//  qr = @"qr-code-for-3-travelerscoffee-nsk-at-karla-marksa-7"; //тревелерз
//  qr = @"http://omnom.menu/qr/special-and-vip"; //b-cafe
  qr =  @"http://m.2gis.ru/os/";
//
//  laaaab
//  customConfigName = @"config_laaaab";
  
  return [[OMNQRLaunch alloc] initWithQR:qr config:customConfigName];

  
#else
  
  if (launchOptions[UIApplicationLaunchOptionsURLKey]) {
    return [self launchWithURL:launchOptions[UIApplicationLaunchOptionsURLKey] sourceApplication:nil annotation:nil];
  }
  else if (launchOptions[UIApplicationLaunchOptionsLocationKey]) {
    return [[OMNBackgroundLaunch alloc] init];
  }
  else {
    return [[OMNDefaultLaunch alloc] init];
  }
  
#endif
  
}

+ (OMNLaunch *)launchWithLocalNotification:(UILocalNotification *)notification {
  return [[OMNDefaultLaunch alloc] init];
}

+ (OMNLaunch *)launchWithRemoteNotification:(NSDictionary *)notification {
  return [[OMNRemotePushLunch alloc] initWithRemoteNotification:notification];
}

@end
