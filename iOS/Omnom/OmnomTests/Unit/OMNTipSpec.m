//
//  OMNTipSpec.m
//  omnom
//
//  Created by tea on 23.05.15.
//  Copyright 2015 tea. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "OMNTip.h"
#import "OMNOrder.h"
#import "NSString+omn_json.h"

SPEC_BEGIN(OMNTipSpec)

describe(@"OMNTip", ^{

  context(@"https://github.com/saintlab/mobileapp_ios/issues/430", ^{
    
    __block OMNOrder *_order = nil;
    __block OMNTip *_tip1 = nil;
    __block OMNTip *_tip2 = nil;
    __block OMNTip *_tip3 = nil;
    __block OMNTip *_customTip = nil;
    
    beforeAll(^{
      
      NSArray *orders = [@"orders_stub.json" omn_jsonObjectNamedForClass:self.class];
      _order = [[OMNOrder alloc] initWithJsonData:[orders firstObject]];
      
      _tip1 = [_order.tips firstObject];
      _tip2 = _order.tips[1];
      _tip3 = _order.tips[2];
      _customTip = _order.customTip;
      _customTip.percent = 15;
      
    });
    
    it(@"should check initial conditions", ^{
      
      [[_order should] beNonNil];
      [[_order.tips should] beNonNil];
      [[_tip1 should] beNonNil];
      [[_tip2 should] beNonNil];
      [[_tip3 should] beNonNil];
      [[_customTip should] beNonNil];
      
    });
    
    it(@"should check tips for 0 rub", ^{
      
      long long amount = 0ll;
      [[theValue([_tip1 amountForValue:amount]) should] equal:@(3000)];
      [[theValue([_tip2 amountForValue:amount]) should] equal:@(5000)];
      [[theValue([_tip3 amountForValue:amount]) should] equal:@(7500)];
      [[theValue([_customTip amountForValue:amount]) should] equal:@(0ll)];
      
    });
    
    it(@"should check tips for 249 rub", ^{
      
      long long amount = 24900ll;
      [[theValue([_tip1 amountForValue:amount]) should] equal:@(3000)];
      [[theValue([_tip2 amountForValue:amount]) should] equal:@(5000)];
      [[theValue([_tip3 amountForValue:amount]) should] equal:@(7500)];
      [[theValue([_customTip amountForValue:amount]) should] equal:@(amount*_customTip.percent*0.01)];
      
    });
    
    it(@"should check tips for 250 rub", ^{
      
      long long amount = 25000ll;
      [[theValue([_tip1 amountForValue:amount]) should] equal:@(4000)];
      [[theValue([_tip2 amountForValue:amount]) should] equal:@(6000)];
      [[theValue([_tip3 amountForValue:amount]) should] equal:@(9000)];
      [[theValue([_customTip amountForValue:amount]) should] equal:@(amount*_customTip.percent*0.01)];
      
    });
    
    it(@"should check tips for 399 rub", ^{
      
      long long amount = 39900ll;
      [[theValue([_tip1 amountForValue:amount]) should] equal:@(4000)];
      [[theValue([_tip2 amountForValue:amount]) should] equal:@(6000)];
      [[theValue([_tip3 amountForValue:amount]) should] equal:@(9000)];
      [[theValue([_customTip amountForValue:amount]) should] equal:@(amount*_customTip.percent*0.01)];
      
    });
    
    it(@"should check tips for 400 rub", ^{
      
      long long amount = 40000ll;
      [[theValue([_tip1 amountForValue:amount]) should] equal:@(5000)];
      [[theValue([_tip2 amountForValue:amount]) should] equal:@(7500)];
      [[theValue([_tip3 amountForValue:amount]) should] equal:@(10000)];
      [[theValue([_customTip amountForValue:amount]) should] equal:@(amount*_customTip.percent*0.01)];
      
    });
    
    
    it(@"should check tips for 599 rub", ^{

      long long amount = 59900ll;
      [[theValue([_tip1 amountForValue:amount]) should] equal:@(5000)];
      [[theValue([_tip2 amountForValue:amount]) should] equal:@(7500)];
      [[theValue([_tip3 amountForValue:amount]) should] equal:@(10000)];
      [[theValue([_customTip amountForValue:amount]) should] equal:@(amount*_customTip.percent*0.01)];
      
    });
    
    it(@"should check tips for 600 rub", ^{
      
      long long amount = 60000ll;
      [[theValue([_tip1 amountForValue:amount]) should] equal:@(amount*_tip1.percent*0.01)];
      [[theValue([_tip2 amountForValue:amount]) should] equal:@(amount*_tip2.percent*0.01)];
      [[theValue([_tip3 amountForValue:amount]) should] equal:@(amount*_tip3.percent*0.01)];
      [[theValue([_customTip amountForValue:amount]) should] equal:@(amount*_customTip.percent*0.01)];
      
    });
    
    it(@"should check tips for 2000 rub", ^{
      
      long long amount = 200000ll;
      [[theValue([_tip1 amountForValue:amount]) should] equal:@(10000)];
      [[theValue([_tip2 amountForValue:amount]) should] equal:@(20000)];
      [[theValue([_tip3 amountForValue:amount]) should] equal:@(30000)];
      [[theValue([_customTip amountForValue:amount]) should] equal:@(amount*_customTip.percent*0.01)];
      
    });
    
  });
  
});

SPEC_END
