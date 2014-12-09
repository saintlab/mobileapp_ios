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
#import "OMNAuthorisation.h"

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
    
    [[[OMNAuthorisation authorisation].token should] beNonNil];
    
    __block NSNumber *isConfigLoaded = nil;
    [OMNConstants setupWithLaunchOptions:nil completion:^{
      
      isConfigLoaded = @(YES);
      
    }];
    [[expectFutureValue(isConfigLoaded) shouldEventuallyBeforeTimingOutAfter(10.0)] equal:@(YES)];
    
    NSDictionary *config = [OMNMailRuAcquiring config];
    [[config should] beNonNil];
    [[@([OMNMailRuAcquiring isValidConfig:config]) should] equal:@(YES)];
    
  });
  
});

SPEC_END