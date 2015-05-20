//
//  OMNMenuProductWithRecommendationsCellItemSpec.m
//  omnom
//
//  Created by tea on 20.05.15.
//  Copyright 2015 tea. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "OMNMenuProductWithRecommendationsCellItem.h"
#import "OMNMenu.h"
#import "NSString+omn_json.h"
#import "OMNMenuProductRecommendationsDelimiterCellItem.h"

SPEC_BEGIN(OMNMenuProductWithRecommendationsCellItemSpec)

describe(@"OMNMenuProductWithRecommendationsCellItem", ^{

  __block OMNMenuProductWithRecommendationsCellItem *_item = nil;
  
  beforeAll(^{
    
    id jsondata = [@"menu_stub.json" omn_jsonObjectNamedForClass:self.class];
    OMNMenu *menu = [[OMNMenu alloc] initWithJsonData:jsondata[@"menu"]];
    
    OMNMenuProduct *product = menu.products[@"2227-in-saintlab-rkeeper-v6"];
    _item = [[OMNMenuProductWithRecommendationsCellItem alloc] initWithMenuProduct:product products:menu.products];
    
  });
  
  context(@"recommendations", ^{
    
    it(@"should have recommendation header for product with recommendations", ^{
      
      [[_item.recommendationItems should] beNonNil];
      [[_item.recommendationItems should] haveCountOf:3];
      [[_item.recommendationItems.firstObject should] beKindOfClass:[OMNMenuProductRecommendationsDelimiterCellItem class]];
      [[_item.recommendationItems[1] should] beKindOfClass:[OMNMenuProductCellItem class]];
      
    });
    
  });
  
});

SPEC_END
