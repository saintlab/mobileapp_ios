//
//  OMNConstants.m
//  restaurants
//
//  Created by tea on 05.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNConstants.h"

#define USE_STAND 0

#if USE_STAND

NSString * const kBaseUrlString = @"http://omnom.stand.saintlab.com";
NSString * const kAuthorizationUrlString = @"http://wicket.stand.saintlab.com";

#else

NSString * const kBaseUrlString = @"http://omnom.laaaab.com";
NSString * const kAuthorizationUrlString = @"http://wicket.laaaab.com";

#endif

NSString * const CardIOAppToken = @"9a0e0afb32e642a09e1fd55093d317f5";
NSString * const kFlurryApiKey = @"K5R4NK5S2B7WZY4WGR57";
NSString * const kMixpanelToken = @"e9386a1100754e8f62565a1b8cda8d8c";

NSString * const kPushSoundName = @"new_guest.caf";

#define kEstimoteBeaconUUIDString @"B9407F30-F5F8-466E-AFF9-25556B57FE6D"
#define kRadBeaconUSBUUIDString  @"2F234454-CF6D-4A0F-ADF2-F4911BA9FFA6"

//old
//#define kRedBearBeaconUUIDString @"E2C56DB5-DFFB-48D2-B060-D0F5A71096EE"
#define kRedBearBeaconUUIDString @"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"

NSString * const kBeaconUUIDString = kRedBearBeaconUUIDString;

static NSDictionary *_defaultConfig = nil;
static NSDictionary *_customConfig = nil;

@implementation OMNConstants

+ (void)setCustomConfigName:(NSString *)name {
  _customConfig = [self configWithName:name];
}

+ (NSDictionary *)configWithName:(NSString *)name {
  return [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:name ofType:@"json"]] options:NSJSONReadingMutableContainers error:nil];
}

+ (NSDictionary *)defaultConfig {
  if (nil == _defaultConfig) {
    _defaultConfig = [self configWithName:@"constants"];
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
+ (NSString *)beaconUUIDString {
  return [self stringForKey:@"beaconUUID"];
}

+ (NSString *)cardIOAppToken {
  return [self stringForKey:@"CardIOAppToken"];
}
+ (NSString *)mixpanelToken {
  return [self stringForKey:@"MixpanelToken"];
}

+ (NSString *)pushSoundName {
  return [self stringForKey:@"beaconUUID"];
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

@end