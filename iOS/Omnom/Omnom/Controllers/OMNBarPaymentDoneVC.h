//
//  OMNBarSuccessVC.h
//  omnom
//
//  Created by tea on 10.03.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OMNPaymentDoneVC.h"
#import "OMNWish.h"

@interface OMNBarPaymentDoneVC : OMNPaymentDoneVC

- (instancetype)initWithWish:(OMNWish *)wish paymentOrdersURL:(NSURL *)paymentOrdersURL;

@end
