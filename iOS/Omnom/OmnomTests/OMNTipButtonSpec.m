//
//  OMNTipButtonSpec.m
//  omnom
//
//  Created by tea on 23.05.15.
//  Copyright 2015 tea. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "OMNTipButton.h"
#import "OMNOrder+tipButton.h"
#import "NSString+omn_json.h"

SPEC_BEGIN(OMNTipButtonSpec)

describe(@"OMNTipButton", ^{

  context(@"https://github.com/saintlab/mobileapp_ios/issues/666", ^{
  
    __block OMNOrder *_order = nil;
    __block OMNTipButton *_tipButton1 = nil;
    __block OMNTipButton *_tipButton2 = nil;
    __block OMNTipButton *_tipButton3 = nil;
    __block OMNTipButton *_tipButton4 = nil;
    
    beforeAll(^{
      
      NSArray *orders = [@"orders_stub.json" omn_jsonObjectNamedForClass:self.class];
      _order = [[OMNOrder alloc] initWithJsonData:[orders firstObject]];
      
      _tipButton1 = [[OMNTipButton alloc] init];
      _tipButton1.tip = _order.tips[0];

      _tipButton2 = [[OMNTipButton alloc] init];
      _tipButton2.tip = _order.tips[1];

      _tipButton3 = [[OMNTipButton alloc] init];
      _tipButton3.tip = _order.tips[2];

      _tipButton4 = [[OMNTipButton alloc] init];
      _tipButton4.tip = _order.tips[3];

    });
    
    it(@"should check initial conditions", ^{
      
      [[_tipButton1 should] beNonNil];
      [[_tipButton2 should] beNonNil];
      [[_tipButton3 should] beNonNil];
      [[_tipButton4 should] beNonNil];
      [[_order should] beNonNil];
      [[_order.tips should] beNonNil];
      
    });
    
    it(@"should configure tip button for 0 rub", ^{
      
      _order.enteredAmount = 0ll;
      [_order configureTipButton:_tipButton1];
      [_order configureTipButton:_tipButton2];
      [_order configureTipButton:_tipButton3];
      [_order configureTipButton:_tipButton4];
      
      [[[_tipButton1 titleForState:UIControlStateNormal] should] equal:@"30"];
      [[[_tipButton1 titleForState:UIControlStateSelected] should] containString:@"30"];
      
      [[[_tipButton2 titleForState:UIControlStateNormal] should] equal:@"50"];
      [[[_tipButton2 titleForState:UIControlStateSelected] should] containString:@"50"];
      
      [[[_tipButton3 titleForState:UIControlStateNormal] should] equal:@"75"];
      [[[_tipButton3 titleForState:UIControlStateSelected] should] containString:@"75"];
      
      [[[_tipButton4 titleForState:UIControlStateNormal] should] equal:@"Другой"];
      [[[_tipButton4 titleForState:UIControlStateSelected] should] containString:@"10%"];
      
    });
    
    it(@"should configure tip button for 599 rub", ^{
      
      _order.enteredAmount = 59900ll;
      [_order configureTipButton:_tipButton1];
      [_order configureTipButton:_tipButton2];
      [_order configureTipButton:_tipButton3];
      [_order configureTipButton:_tipButton4];
      
      [[[_tipButton1 titleForState:UIControlStateNormal] should] equal:@"50"];
      [[[_tipButton1 titleForState:UIControlStateSelected] should] containString:@"50"];
      
      [[[_tipButton2 titleForState:UIControlStateNormal] should] equal:@"75"];
      [[[_tipButton2 titleForState:UIControlStateSelected] should] containString:@"75"];
      
      [[[_tipButton3 titleForState:UIControlStateNormal] should] equal:@"100"];
      [[[_tipButton3 titleForState:UIControlStateSelected] should] containString:@"100"];
      
      [[[_tipButton4 titleForState:UIControlStateNormal] should] equal:@"Другой"];
      [[[_tipButton4 titleForState:UIControlStateSelected] should] containString:@"10%"];

    });

    it(@"should configure tip button for 600 rub", ^{
      
      _order.enteredAmount = 60000ll;
      [_order configureTipButton:_tipButton1];
      [_order configureTipButton:_tipButton2];
      [_order configureTipButton:_tipButton3];
      [_order configureTipButton:_tipButton4];
      
      [[[_tipButton1 titleForState:UIControlStateNormal] should] equal:@"5%"];
      [[[_tipButton1 titleForState:UIControlStateSelected] should] containString:@"5%"];
      
      [[[_tipButton2 titleForState:UIControlStateNormal] should] equal:@"10%"];
      [[[_tipButton2 titleForState:UIControlStateSelected] should] containString:@"10%"];
      
      [[[_tipButton3 titleForState:UIControlStateNormal] should] equal:@"15%"];
      [[[_tipButton3 titleForState:UIControlStateSelected] should] containString:@"15%"];
      
      [[[_tipButton4 titleForState:UIControlStateNormal] should] equal:@"Другой"];
      [[[_tipButton4 titleForState:UIControlStateSelected] should] containString:@"10%"];
      
    });
    
  });
  
});

SPEC_END
