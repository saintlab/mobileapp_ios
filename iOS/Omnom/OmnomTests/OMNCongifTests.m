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
    
    NSString *mailRuConfig = [OMNConstants mailRuConfig];
    [[mailRuConfig should] beNonNil];
    
    BOOL isConfigSet = [OMNMailRuAcquiring setConfig:mailRuConfig];
    [[@(isConfigSet) should] equal:@(YES)];
    
    [[[[OMNMailRuAcquiring acquiring] certificateData] should] beNonNil];
    
  });
  
});

SPEC_END