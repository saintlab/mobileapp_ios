//
//  OMNCongifTests.m
//  omnom
//
//  Created by tea on 03.09.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Kiwi.h>
#import "OMNConstants.h"
#import <OMNMailRuAcquiring.h>
#import <OMNBeacon.h>
#import "OMNAuthorization.h"
#import "OMNLaunch.h"

SPEC_BEGIN(OMNConfigTests)

describe(@"check initial state", ^{
  
  __block OMNBeaconUUID *_beaconUUID = nil;
  beforeAll(^{
    
    _beaconUUID = [OMNBeacon beaconUUID];
  });
  
  it(@"should check urls", ^{
    
    [[[OMNConstants baseUrlString] should] beNonNil];
    [[[OMNConstants authorizationUrlString] should] beNonNil];
    
  });
  
  it(@"should check beacon unique id", ^{
    
    [[_beaconUUID should] beNonNil];
    
    NSArray *regions = [_beaconUUID aciveBeaconsRegionsWithIdentifier:@"id"];
    NSMutableArray *identifiers = [NSMutableArray array];
    [regions enumerateObjectsUsingBlock:^(CLBeaconRegion *region, NSUInteger idx, BOOL *stop) {
      
      BOOL contains = [identifiers containsObject:region.identifier];
      [[@(contains) should] equal:@(NO)];
      [identifiers addObject:region.identifier];
      
    }];
    
  });
  
  it(@"should check mail.ru config", ^{
    
    [[[OMNAuthorization authorization].token should] beNonNil];
    
    __block NSNumber *isConfigLoaded = nil;
    OMNLaunch *launch = [[OMNLaunch alloc] init];
    [OMNConstants setupWithLaunch:launch completion:^{
      
      isConfigLoaded = @(YES);
      
    }];
    [[expectFutureValue(isConfigLoaded) shouldEventuallyBeforeTimingOutAfter(10.0)] equal:@(YES)];
    
    OMNMailRuConfig *config = [OMNMailRuAcquiring config];
    [[config should] beNonNil];
    [[@(config.isValid) should] equal:@(YES)];
    
  });
  
});

SPEC_END