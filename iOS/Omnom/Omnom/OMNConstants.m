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

NSString * const kPushSoundName = @"new_guest.caf";

//#define kEstimoteBeaconUUIDString @"B9407F30-F5F8-466E-AFF9-25556B57FE6D"
//#define kRadBeaconUSBUUIDString  @"2F234454-CF6D-4A0F-ADF2-F4911BA9FFA6"
//old
//#define kRedBearBeaconUUIDString @"E2C56DB5-DFFB-48D2-B060-D0F5A71096EE"
//#define kRedBearBeaconUUIDString @"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"

static NSDictionary *_defaultConfig = nil;
static NSDictionary *_customConfig = nil;

@implementation OMNConstants

+ (void)loadConfigWithCompletion:(dispatch_block_t)completionBlock {
  
  NSString *path = @"/mobile/config";
  [[OMNOperationManager sharedManager] GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    [self updateConfig:responseObject];
    if (completionBlock) {
      completionBlock();
    }
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

    [[OMNAnalitics analitics] logDebugEvent:@"ERROR_CONFIG" jsonRequest:path responseOperation:operation];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(30.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      [self loadConfigWithCompletion:completionBlock];
    });
    
  }];
  
}

+ (void)updateConfig:(NSDictionary *)config {
  
  NSDictionary *mailRuConfig = config[@"mail_ru"];
  [OMNMailRuAcquiring setConfig:mailRuConfig];
  __unused NSDictionary *tokensConfig = config[@"tokens"];
  
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

+ (NSString *)mixpanelToken {
  return [self stringForKey:@"MixpanelToken"];
}
+ (NSString *)mixpanelDebugToken {
  return [self stringForKey:@"MixpanelTokenDebug"];
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