//
//  OMNMenuProductDetailsSpec.m
//  omnom
//
//  Created by tea on 01.05.15.
//  Copyright 2015 tea. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "OMNMenuProductDetails.h"


SPEC_BEGIN(OMNMenuProductDetailsSpec)

describe(@"OMNMenuProductDetails", ^{

  context(@"creation", ^{
    
    it(@"should handle wrong data", ^{
      
      id data =
      @{
        @"weight" : [NSNull null],
        @"volume" : [NSNull null],
        @"persons" : [NSNull null],
        @"cooking_time" : [NSNull null],
        @"energy_100" : [NSNull null],
        @"energy_total" : [NSNull null],
        @"protein_100" : [NSNull null],
        @"protein_total" : [NSNull null],
        @"carbohydrate_100" : [NSNull null],
        @"carbohydrate_total" : [NSNull null],
        @"ingredients" : [NSNull null],
        };

      OMNMenuProductDetails *details = [[OMNMenuProductDetails alloc] initWithJsonData:data];
      
      [[details.weighVolumeText should] beKindOfClass:[NSString class]];
      [[details.displayFullText should] beKindOfClass:[NSString class]];
      [[details.compositionText should] beKindOfClass:[NSString class]];
      
    });
    
  });
    
});

SPEC_END
