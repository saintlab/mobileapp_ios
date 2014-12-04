//
//  OMNConstants.m
//  restaurants
//
//  Created by tea on 05.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNConstants.h"
#import "OMNOperationManager.h"
#import <OMNMailRuAcquiring.h>
#import "OMNAnalitics.h"
#import <OMNBeacon.h>

NSString * const kPushSoundName = @"new_guest.caf";

//#define kEstimoteBeaconUUIDString @"B9407F30-F5F8-466E-AFF9-25556B57FE6D"
//#define kRadBeaconUSBUUIDString  @"2F234454-CF6D-4A0F-ADF2-F4911BA9FFA6"
//old
//#define kRedBearBeaconUUIDString @"E2C56DB5-DFFB-48D2-B060-D0F5A71096EE"
//#define kRedBearBeaconUUIDString @"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"

static NSDictionary *_defaultConfig = nil;
static NSDictionary *_customConfig = nil;
static NSDictionary *_tokens = nil;

const CGFloat kOrderTableFooterHeight = 56.0f;

@implementation OMNConstants

+ (void)loadConfigWithCompletion:(dispatch_block_t)completionBlock {
  
  NSString *path = @"/mobile/config";
  AFHTTPRequestOperation *operation = [[OMNOperationManager sharedManager] GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    if (responseObject[@"tokens"]) {

      [self cacheConfig:responseObject];
      [self updateConfig:responseObject];
      if (completionBlock) {
        completionBlock();
      }

    }
    else {
    
      [self loadCachedConfig];
      NSDictionary *parametrs = nil;
      if (responseObject) {
        parametrs = @{@"responseObject" : responseObject};
      }
      [[OMNAnalitics analitics] logTargetEvent:@"ERROR_CONFIG" parametrs:parametrs];
      
    }
      
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

    [self loadCachedConfig];
    [[OMNAnalitics analitics] logTargetEvent:@"ERROR_CONFIG" parametrs:nil];
    
  }];
  
  NSMutableURLRequest *mRequest = (NSMutableURLRequest *)operation.request;
  if ([mRequest respondsToSelector:@selector(setValue:forHTTPHeaderField:)]) {
    [mRequest setValue:@"yeshackvofPigCob" forHTTPHeaderField:@"x-authentication-token"];
  }
  
}

+ (void)loadCachedConfig {
  
  NSDictionary *cachedConfig = [NSDictionary dictionaryWithContentsOfFile:[self configPath]];
  [self updateConfig:cachedConfig];
  
}

+ (NSString *)configPath {
  return [@"~/Documents/config.dat" stringByExpandingTildeInPath];
}

+ (void)cacheConfig:(NSDictionary *)config {
  
  [config writeToFile:[self configPath] atomically:YES];
  
}

+ (void)updateConfig:(NSDictionary *)config {
  
  if (nil == config) {
    return;
  }
  
  NSDictionary *mailRuConfig = config[@"mail_ru"];
  [OMNMailRuAcquiring setConfig:mailRuConfig];
  
  NSDictionary *beaconUUID = config[@"uuid"];
  if (beaconUUID) {

    [OMNBeacon setBaeconUUID:[[OMNBeaconUUID alloc] initWithJsonData:beaconUUID]];
    
  }
  
  _tokens = config[@"tokens"];
  [OMNAnalitics analitics];
  
}

+ (void)setCustomConfigName:(NSString *)name {
  
  _customConfig = [self configWithName:name];
  
}

+ (NSDictionary *)configWithName:(NSString *)name {
  return [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:name ofType:@"json"]] options:NSJSONReadingMutableContainers error:nil];
}

+ (NSDictionary *)defaultConfig {
  if (nil == _defaultConfig) {
    _defaultConfig = [self configWithName:@"config"];
  }
  return _defaultConfig;
}

+ (NSString *)stringForKey:(NSString *)key {
  if ([_customConfig objectForKey:key]) {
    return [_customConfig objectForKey:key];
  }
  else {
    return [self.defaultConfig objectForKey:key];
  }
}

+ (BOOL)boolForKey:(NSString *)key {
  return [[self stringForKey:key] boolValue];
}

+ (NSString *)baseUrlString {
  return [self stringForKey:@"baseUrlString"];
}
+ (NSString *)authorizationUrlString {
  return [self stringForKey:@"authorizationUrlString"];
}

+ (NSString *)notifierUrlString {
  return [self stringForKey:@"notifierUrlString"];
}

+ (NSString *)tokenForKey:(NSString *)key {
 
  if (NO == [key isKindOfClass:[NSString class]]) {
    return @"";
  }
  
  if (_tokens[key]) {
    return _tokens[key];
  }
  else {
    return [self stringForKey:key];
  }

}

+ (NSString *)mixpanelToken {
  return [self tokenForKey:@"MixpanelToken"];
}
+ (NSString *)mixpanelDebugToken {
  return [self tokenForKey:@"MixpanelTokenDebug"];
}
+ (NSString *)crashlyticsAPIKey {
  return [self stringForKey:@"CrashlyticsAPIKey"];
}

+ (NSString *)pushSoundName {
  return nil;
}

+ (BOOL)useStubBeacon {
  return [self boolForKey:@"UseStubBeacon"];
}
+ (BOOL)useStubBeaconDecodeData {
  return [self boolForKey:@"UseStubBeaconDecodeData"];
}
+ (BOOL)useStubOrdersData {
  return [self boolForKey:@"UseStubOrdersData"];
}
+ (BOOL)useBackgroundNotifications {
  return [self boolForKey:@"UseBackgroundNotifications"];
}

@end