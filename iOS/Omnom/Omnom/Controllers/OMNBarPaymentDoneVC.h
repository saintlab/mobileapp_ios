//
//  OMNBarSuccessVC.h
//  omnom
//
//  Created by tea on 10.03.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OMNScrollContentVC.h"
#import "OMNWish.h"

@interface OMNBarPaymentDoneVC : OMNScrollContentVC

- (instancetype)initWithWish:(OMNWish *)wish paymentOrdersURL:(NSURL *)paymentOrdersURL;

@end
