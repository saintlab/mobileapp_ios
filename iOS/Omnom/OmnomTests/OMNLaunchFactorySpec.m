//
//  OMNLaunchFactorySpec.m
//  omnom
//
//  Created by tea on 30.04.15.
//  Copyright 2015 tea. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "OMNLaunchFactory.h"
#import "OMNDefaultLaunch.h"
#import "OMNQRLaunch.h"

SPEC_BEGIN(OMNLaunchFactorySpec)

describe(@"OMNLaunchFactory", ^{

  context(@"creation", ^{
    
    it(@"should create default launch", ^{
      
      OMNLaunch *launch = [OMNLaunchFactory launchWithLaunchOptions:nil];
      [[launch should] beKindOfClass:[OMNDefaultLaunch class]];
      
    });
    
    it(@"chould create launch with url with qr", ^{
      
      NSDictionary *info =
      @{
        UIApplicationLaunchOptionsURLKey : [NSURL URLWithString:@"omnom://app?qr=qr-code-for-2-saintlab-iiko-dev&omnom_config=config_staging"],
        };
      OMNLaunch *launch = [OMNLaunchFactory launchWithLaunchOptions:info];
      [[launch should] beKindOfClass:[OMNQRLaunch class]];
      [[launch.customConfigName should] equal:@"config_staging"];
      
    });

    it(@"chould create launch with url", ^{
      
      NSDictionary *info =
      @{
        UIApplicationLaunchOptionsURLKey : [NSURL URLWithString:@"omnom://app?omnom_config=config_staging"],
        };
      OMNLaunch *launch = [OMNLaunchFactory launchWithLaunchOptions:info];
      [[launch should] beKindOfClass:[OMNDefaultLaunch class]];
      [[launch.customConfigName should] equal:@"config_staging"];
      
    });

  });
  
});

SPEC_END
