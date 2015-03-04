//
//  OMNRestaurant+payment.h
//  omnom
//
//  Created by tea on 05.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNRestaurant.h"
#import "OMNPaymentFactory.h"

@interface OMNRestaurant (omn_payment)

- (id<OMNPaymentFactory>)paymentFactory;

@end
