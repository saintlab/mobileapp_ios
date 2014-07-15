//
//  OMNOrderVCDelegate.h
//  restaurants
//
//  Created by tea on 23.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNOrder.h"

@protocol OMNOrderVCDelegate <NSObject>

- (void)orderDidPay:(OMNOrder *)order;

@end
