//
//  OMNOrderTansactionInfo.m
//  omnom
//
//  Created by tea on 14.11.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNOrderTansactionInfo.h"
#import "OMNAnalitics.h"

@implementation OMNOrderTansactionInfo

- (instancetype)initWithOrder:(OMNOrder *)order {
  self = [super init];
  if (self) {
    
    _order_id = [(order.id) ? (order.id) : (@"") copy];
    _restaurant_id = [(order.restaurant_id) ? (order.restaurant_id) : (@"") copy];
    _table_id = (order.table_id) ? ([order.table_id copy]) : @"";
    _bill_amount = order.enteredAmount;
    _tips_amount = order.tipAmount;
    _total_amount = order.enteredAmountWithTips;
    
    if (_bill_amount) {
      
      _tips_percent = (double)_tips_amount/_bill_amount;
      
    }
    else {
      
      _tips_percent = 0.0;
      
    }
    
    _tips_way = stringFromTipType(order.tipType);
    _split = stringFromSplitType(order.splitType);
    
  }
  return self;
}



@end
