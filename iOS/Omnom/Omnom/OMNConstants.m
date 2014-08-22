//
//  OMNConstants.m
//  restaurants
//
//  Created by tea on 05.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#define USE_STAND 1

#if USE_STAND

NSString * const kBaseUrlString = @"http://omnom.stand.saintlab.com";
NSString * const kAuthorizationUrlString = @"http://wicket.stand.saintlab.com";

#else

NSString * const kBaseUrlString = @"http://omnom.laaaab.com";
NSString * const kAuthorizationUrlString = @"http://wicket.laaaab.com";

#endif

NSString * const CardIOAppToken = @"9a0e0afb32e642a09e1fd55093d317f5";
NSString * const kTestFlightAppToken = @"8a483dd7-f2bf-4488-a442-5f993e97a768";
NSString * const kFlurryApiKey = @"K5R4NK5S2B7WZY4WGR57";
NSString * const kMixpanelToken = @"e9386a1100754e8f62565a1b8cda8d8c";

//NSString * const kPushSoundName = @"omnom.caf";
NSString * const kPushSoundName = @"Hello.wav";

#define kEstimoteBeaconUUIDString @"B9407F30-F5F8-466E-AFF9-25556B57FE6D"
#define kRadBeaconUSBUUIDString  @"2F234454-CF6D-4A0F-ADF2-F4911BA9FFA6"

//old
//#define kRedBearBeaconUUIDString @"E2C56DB5-DFFB-48D2-B060-D0F5A71096EE"
#define kRedBearBeaconUUIDString @"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"

NSString * const kBeaconUUIDString = kRedBearBeaconUUIDString;

NSString * const kRestaurantLogoUrl = @"https://www.dropbox.com/s/85hs2o8u6dnonv2/loader-icon%402x.png?dl=1";
NSString * const kRestaurantBGUrl = @"https://www.dropbox.com/s/9lt4ljhcvqajxjs/bg_pic%402x.png?dl=1";
