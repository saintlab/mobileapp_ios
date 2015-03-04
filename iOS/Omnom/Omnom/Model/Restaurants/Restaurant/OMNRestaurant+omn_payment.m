//
//  OMNRestaurant+payment.m
//  omnom
//
//  Created by tea on 05.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNRestaurant+omn_payment.h"

#import "OMNTestPaymentFactory.h"
#import "OMNMailRuPaymentFactory.h"

@implementation OMNRestaurant (omn_payment)

- (id<OMNPaymentFactory>)paymentFactory {
  
  id<OMNPaymentFactory>paymentFactory = nil;
  if (self.is_demo) {
    
    paymentFactory = [[OMNTestPaymentFactory alloc] init];
    
  }
  else {
    
    paymentFactory = [[OMNMailRuPaymentFactory alloc] init];
    
  }
  
  return paymentFactory;
  
}

@end
