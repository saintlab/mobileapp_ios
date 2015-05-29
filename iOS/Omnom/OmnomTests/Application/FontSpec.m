//
//  FontSpec.m
//  omnom
//
//  Created by tea on 29.05.15.
//  Copyright 2015 tea. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import <OMNStyler.h>
#import "OMNUtils.h"

SPEC_BEGIN(FontSpec)

describe(@"Font", ^{

  context(@"creation", ^{
    
    it(@"should create FuturaLSFOmnomLERegular font", ^{
      [[FuturaLSFOmnomLERegular(15) should] beNonNil];
    });
    
    it(@"should create FuturaOSFOmnomMedium font", ^{
      [[FuturaOSFOmnomMedium(15) should] beNonNil];
    });
    
    it(@"should create FuturaOSFOmnomRegular font", ^{
      [[FuturaOSFOmnomRegular(15) should] beNonNil];
    });
    
  });
  
  context(@"utils", ^{
    
    it(@"should create text attributes with nil font", ^{
      [[[OMNUtils textAttributesWithFont:nil textColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter] should] haveCountOf:2];
    });
    
    it(@"should create text attributes with nil color", ^{
      [[[OMNUtils textAttributesWithFont:[UIFont systemFontOfSize:5] textColor:nil textAlignment:NSTextAlignmentCenter] should] haveCountOf:2];
    });
    
    it(@"should create text attributes with nil color and font", ^{
      [[[OMNUtils textAttributesWithFont:nil textColor:nil textAlignment:NSTextAlignmentCenter] should] haveCountOf:1];
    });
    
    it(@"should create text attributes with color and font", ^{
      [[[OMNUtils textAttributesWithFont:FuturaOSFOmnomMedium(13.0) textColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter] should] haveCountOf:3];
    });
    
   });
  
  
});

SPEC_END
