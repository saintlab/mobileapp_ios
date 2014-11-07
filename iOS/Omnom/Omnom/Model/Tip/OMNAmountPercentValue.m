//
//  OMNAmountPercentValue.m
//  omnom
//
//  Created by tea on 03.09.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNAmountPercentValue.h"

@implementation OMNAmountPercentValue

- (long long)totalAmount {
  return self.amount*(1.0L + self.percent/100.0L);
}

@end
