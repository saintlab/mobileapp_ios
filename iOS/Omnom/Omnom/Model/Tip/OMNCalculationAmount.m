//
//  GCalculationAmount.m
//  seocialtest
//
//  Created by tea on 20.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNCalculationAmount.h"
#import "OMNTipButton.h"

@implementation OMNCalculationAmount {
  OMNOrder *_order;
}

- (instancetype)initWithOrder:(OMNOrder *)order {
  self = [super init];
  if (self) {
    
    _order = order;
    
  }
  return self;
}












@end
