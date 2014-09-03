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

SPEC_BEGIN(OMNConfigTests)

describe(@"check initial state", ^{
  
  it(@"should check urls", ^{
    
    [[[OMNConstants baseUrlString] should] beNonNil];
    [[[OMNConstants authorizationUrlString] should] beNonNil];
    
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