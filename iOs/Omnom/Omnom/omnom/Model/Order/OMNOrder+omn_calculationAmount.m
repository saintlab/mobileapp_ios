//
//  OMNOrder+omn_calculationAmount.m
//  restaurants
//
//  Created by tea on 06.06.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNOrder+omn_calculationAmount.h"

@implementation OMNOrder (omn_calculationAmount)

- (OMNCalculationAmount *)omn_calculationAmount {
  
  return [[OMNCalculationAmount alloc] initWithTips:self.tips tipsThreshold:self.tipsThreshold total:self.total];
  
}

@end
