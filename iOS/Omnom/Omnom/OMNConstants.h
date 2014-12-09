//
//  OMNConstants.h
//  restaurants
//
//  Created by tea on 05.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

extern NSString * const kPushSoundName;

#define FuturaOSFOmnomMedium(__FONTSIZE__) ([UIFont fontWithName:@"Futura-OSF-Omnom-Medium" size:__FONTSIZE__])
#define FuturaOSFOmnomRegular(__FONTSIZE__) ([UIFont fontWithName:@"Futura-OSF-Omnom-Regular" size:__FONTSIZE__])
#define FuturaLSFOmnomLERegular(__FONTSIZE__) ([UIFont fontWithName:@"Futura-LSF-Omnom-LE-Regular" size:__FONTSIZE__])

#define CURRENT_VERSION ([[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"])
#define CURRENT_BUILD ([[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey])

enum {
  
  OMNErrorUnknoun = -1,
  OMNErrorDefault = 0,
  OMNErrorNoSuchUser = 101,

  OMNErrorTimedOut = NSURLErrorTimedOut,
  OMNErrorNotConnectedToInternet = NSURLErrorNotConnectedToInternet,
  
  OMNErrorOrderClosed = 300,
  OMNErrorPaymentError,
  OMNErrorQrDecode,
  
};

extern const CGFloat kOrderTableFooterHeight;

@interface OMNConstants : NSObject

+ (void)setupWithLaunchOptions:(NSDictionary *)launchOptions completion:(dispatch_block_t)completionBlock;
+ (NSString *)stringForKey:(NSString *)key;
+ (BOOL)boolForKey:(NSString *)key;

+ (NSString *)baseUrlString;
+ (NSString *)authorizationUrlString;
+ (NSString *)notifierUrlString;

+ (NSString *)mixpanelToken;
+ (NSString *)mixpanelDebugToken;
+ (NSString *)crashlyticsAPIKey;

+ (NSString *)pushSoundName;

+ (BOOL)useStubBeacon;
+ (BOOL)useStubBeaconDecodeData;
+ (BOOL)useStubOrdersData;

@end
