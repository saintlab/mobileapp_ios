//
//  OMNConstants.m
//  restaurants
//
//  Created by tea on 05.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNConstants.h"
#import "OMNOperationManager.h"
#import <OMNBeacon.h>
#import <SSKeychain.h>
#import "OMNAuthorization.h"
#import "OMNLaunch.h"
#import "OMNLineNumberLogFormatter.h"
#import <UIDevice-Hardware.h>
#import "AFHTTPRequestOperationManager+omn_token.h"

NSString * const kPushSoundName = @"new_guest.caf";
NSString * const OMNFacebookPageUrlString = @"https://www.facebook.com/omnom.menu/";
NSString * const OMNFacebookAppUrlString = @"fb://profile/1548920272002383";
NSString * const kOMNStaticTokenString = @"uv5zoaRsh9uff1yiSh8Dub4oc0hum3";


//#define kEstimoteBeaconUUIDString @"B9407F30-F5F8-466E-AFF9-25556B57FE6D"
//#define kRadBeaconUSBUUIDString  @"2F234454-CF6D-4A0F-ADF2-F4911BA9FFA6"
//old
//#define kRedBearBeaconUUIDString @"E2C56DB5-DFFB-48D2-B060-D0F5A71096EE"
//#define kRedBearBeaconUUIDString @"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"

static NSDictionary *_defaultConfig = nil;
static NSDictionary *_customConfig = nil;
static OMNConfig *_config = nil;

@implementation OMNConstants

+ (PMKPromise *)setupWithLaunch:(OMNLaunch *)launchOptions {
  
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{

    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    [[DDTTYLogger sharedInstance] setLogFormatter:[OMNLineNumberLogFormatter new]];

    [SSKeychain setAccessibilityType:kSecAttrAccessibleAlwaysThisDeviceOnly];

  });
  
  _customConfig = [self configWithName:launchOptions.customConfigName];
  
  //initialize saved token
  [[OMNAuthorization authorization] loadCachedUser];

  [self setupNetworkManagers];
  
  return [self loadRemoteConfig];
  
}

+ (void)setupNetworkManagers {
  [OMNOperationManager setupWithURL:[self baseUrlString] headers:[self httpHeadersFields]];
}

+ (NSDictionary *)httpHeadersFields {
  
  NSDictionary *httpHeadersFields =
  @{
    @"x-mobile-configuration" : [OMNConstants mobileConfiguration],
    @"x-mobile-device-id" : [OMNConstants installID],
    @"x-current-app-build" : CURRENT_BUILD,
    @"x-current-app-version" : CURRENT_VERSION,
    @"x-mobile-vendor" : @"Apple",
    @"x-mobile-platform" : @"iOS",
    @"x-mobile-os-version" : [[UIDevice currentDevice] systemVersion],
    @"x-mobile-model": [[UIDevice currentDevice] modelName],
    };
  return httpHeadersFields;
  
}

+ (NSString *)installID {
  
  NSString *appName = [NSBundle bundleForClass:self.class].infoDictionary[@"CFBundleName"];
  //Check if we have UUID already
  NSString *retrieveuuid = [SSKeychain passwordForService:appName account:@"constants"];
  if (nil == retrieveuuid) {
    
    //Create new key for this app/device
    CFUUIDRef newUniqueId = CFUUIDCreate(kCFAllocatorDefault);
    retrieveuuid = (__bridge_transfer NSString*)CFUUIDCreateString(kCFAllocatorDefault, newUniqueId);
    CFRelease(newUniqueId);
    
    //Save key to Keychain
    [SSKeychain setPassword:retrieveuuid forService:appName account:@"constants"];
  }
  
  return retrieveuuid;
  
}

+ (PMKPromise *)loadRemoteConfig {
  
  NSString *path = @"/mobile/config";
  return [PMKPromise new:^(PMKFulfiller fulfill, PMKRejecter reject) {
    
    if (![OMNOperationManager sharedManager]) {
      reject([OMNError omnomErrorFromRequest:path response:nil]);
      return;
    }
    
    NSMutableURLRequest *request = [[OMNOperationManager sharedManager].requestSerializer requestWithMethod:@"GET" URLString:[[NSURL URLWithString:path relativeToURL:[OMNOperationManager sharedManager].baseURL] absoluteString] parameters:nil error:nil];
    //https://github.com/saintlab/mobileapp_ios/issues/548
    [request setValue:kOMNStaticTokenString forHTTPHeaderField:kAuthenticationTokenKey];
    
    id operation = [[OMNOperationManager sharedManager] HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
      
      if (responseObject[@"tokens"]) {
        
        OMNConfig *config = [[OMNConfig alloc] initWithJsonData:responseObject];
        config.serverTimestamp = [operation.response.allHeaderFields[@"X-Server-Time"] doubleValue];
        [self setConfig:config];
        fulfill(config);
        
      }
      else {
        
        reject([OMNError omnomErrorFromRequest:path response:responseObject]);
        
      }
      
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      
      reject([operation omn_internetError]);
      
    }];
    [[OMNOperationManager sharedManager].operationQueue addOperation:operation];
    
  }];
  
}

+ (void)setConfig:(OMNConfig *)config {
  
  _config = config;
  [OMNBeacon setBaeconUUID:[[OMNBeaconUUID alloc] initWithJsonData:config.beaconUUID]];
  
}

+ (NSDictionary *)configWithName:(NSString *)name {
  
  NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:[NSString stringWithFormat:@"%@.json", name] ofType:nil];
  if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
    return [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path] options:NSJSONReadingMutableContainers error:nil];
  }
  else {
    return nil;
  }

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

+ (NSString *)baseUrlString {
  return [self stringForKey:@"baseUrlString"];
}

+ (NSString *)mixpanelToken {
  return _config.mixpanelToken;
}
+ (NSString *)mixpanelDebugToken {
  return _config.mixpanelDebugToken;
}
+ (BOOL)disableOnEntrancePush {
  return _config.disableOnEntrancePush;
}
+ (NSString *)mobileConfiguration {
  NSString *mobileConfiguration = @"debug";
#ifdef APP_STORE
  mobileConfiguration = @"appstore";
#elif defined (LUNCH_2GIS)
  mobileConfiguration = @"lunch2gis";
#elif defined (LUNCH_2GIS_SUNCITY)
  mobileConfiguration = @"lunch2gisSuncity";
#elif defined (AD_HOC)
  mobileConfiguration = @"ad-hoc";
#else
  mobileConfiguration = @"debug";
#endif
  return mobileConfiguration;
}

@end