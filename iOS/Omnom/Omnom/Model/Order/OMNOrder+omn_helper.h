//
//  OMNOrder+omn_helper.h
//  omnom
//
//  Created by tea on 25.05.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNOrder.h"
#import <PromiseKit.h>

@interface OMNOrder (omn_helper)

- (PMKPromise *)checkPaymentValue;

@end
