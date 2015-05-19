//
//  OMNMailRuAcquiringSpec.m
//  omnom
//
//  Created by tea on 19.05.15.
//  Copyright 2015 tea. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "OMNMailRuAcquiring.h"
#import "NSString+omn_json.h"

SPEC_BEGIN(OMNMailRuAcquiringSpec)

describe(@"OMNMailRuAcquiring", ^{

  context(@"setup", ^{
    
    it(@"should check initial condition", ^{
      
      [[[OMNMailRuAcquiring acquiring] should] beNil];
      [[[OMNMailRuAcquiring acquiring].baseURL should] beNil];
      
    });
    
    it(@"should setup", ^{
    
      id response = [@"config_stub.json" omn_jsonObjectNamedForClass:self.class];
      [OMNMailRuAcquiring setupWithParametrs:response[@"mail_ru"]];
      [[[OMNMailRuAcquiring acquiring] should] beNonNil];
      [[[OMNMailRuAcquiring acquiring].baseURL should] beNonNil];
      [[@([OMNMailRuAcquiring config].isValid) should] beYes];
      
    });

    it(@"should reset", ^{
      
      [OMNMailRuAcquiring setupWithParametrs:nil];
      [[[OMNMailRuAcquiring acquiring] should] beNil];
      [[[OMNMailRuAcquiring acquiring].baseURL should] beNil];
      [[@([OMNMailRuAcquiring config].isValid) should] beNo];
      
    });
    
  });
  
});

SPEC_END
